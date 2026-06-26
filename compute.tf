# 1. Get the latest official Amazon Linux 2023 AMI ID dynamically
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }
}

# 2. The Launch Template (The Server Blueprint)
resource "aws_launch_template" "web" {
  name_prefix   = "${var.project_name}-template-"
  image_id      = data.aws_ami.amazon_linux.id
  instance_type = "t2.micro" # Free tier eligible

  # Attach the inner firewall we made in Phase 2
  network_interfaces {
    associate_public_ip_address = false
    security_groups             = [aws_security_group.web.id]
  }

  # Automated User Data Script (Installs Apache Web Server on Boot)
  user_data = base64encode(<<-EOF
              #!/bin/bash
              dnf update -y
              dnf install -y httpd
              systemctl start httpd
              systemctl enable httpd
              
              # Create a custom landing page showing the server's unique ID
              TOKEN=$(curl -s -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")
              INSTANCE_ID=$(curl -s -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/instance-id)
              AZ=$(curl -s -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/placement/availability-zone)
              
              echo "<h1>Hello from the Charlotte Enterprise Cloud Pipeline!</h1>" > /var/www/html/index.html
              echo "<p><b>Instance ID:</b> $INSTANCE_ID</p>" >> /var/www/html/index.html
              echo "<p><b>Availability Zone:</b> $AZ</p>" >> /var/www/html/index.html
              EOF
  )

  lifecycle {
    create_before_destroy = true
  }
}

# 3. The Auto Scaling Group (The Automated Manager)
resource "aws_autoscaling_group" "web" {
  name_prefix         = "${var.project_name}-asg-"
  desired_capacity    = 2
  max_size            = 3
  min_size            = 1
  vpc_zone_identifier = [aws_subnet.private[0].id, aws_subnet.private[1].id] # Dropped safely in private subnets

  target_group_arns = [aws_lb_target_group.web.arn] # Link to our Phase 2 Target Group
  health_check_type = "ELB"

  launch_template {
    id      = aws_launch_template.web.id
    version = "$Latest"
  }

  lifecycle {
    create_before_destroy = true
  }

  tag {
    key                 = "Name"
    value               = "${var.project_name}-web-server"
    propagate_at_launch = true
  }
}