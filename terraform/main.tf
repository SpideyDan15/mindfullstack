provider "aws" {
  region     = var.aws_region
  access_key = var.access_key
  secret_key = var.secret_key
}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

data "aws_acm_certificate" "issued" {
  domain   = "mindfullstack.com"
  statuses = ["ISSUED"]
}

# EC2 instance
resource "aws_instance" "front_end" {
  ami           = "ami-093467ec28ae4fe03"  # Change to your desired AMI ID
  instance_type = "t2.nano"
  key_name      = var.key_pair_name

  tags = {
    Name = "front-end-instance"
  }

  # ... other instance configuration ...

  user_data = <<-EOF
              #!/bin/bash
              sudo yum update -y
              sudo amazon-linux-extras install docker -y
              sudo service docker start
              sudo usermod -a -G docker ec2-user
              sudo docker run -d -p 8080:8080 your-nodejs-docker-image
              EOF
}

# ALB
resource "aws_lb" "front_end" {
  name               = "front-end-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb.id]
  subnets            = data.aws_subnets.default.ids #["subnet-xxxxxxxxxxxxxxxxx", "subnet-yyyyyyyyyyyyyyyyy"]  # Change to your subnet IDs

  enable_deletion_protection = false

  enable_http2 = true
}

# ALB Listener for HTTP
resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.front_end.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"
    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

# ALB Listener for HTTPS
resource "aws_lb_listener" "https_listener" {
  load_balancer_arn = aws_lb.front_end.arn
  port              = 443
  protocol          = "HTTPS"

  ssl_policy = "ELBSecurityPolicy-2016-08"
  certificate_arn = data.aws_acm_certificate.issued.arn #"arn:aws:acm:us-west-2:437030661393:certificate/1497b9ae-4104-47ed-8aa0-0a5e5d0699a9"  # Change to your SSL certificate ARN

  default_action {
    target_group_arn = aws_lb_target_group.front_end.arn
    type             = "forward"
  }
}

# ALB Target Group
resource "aws_lb_target_group" "front_end" {
  name     = "front-end-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.default.id #vpc_id   = "vpc-xxxxxxxxxxxxxxxxx"  # Change to your VPC ID

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

# EC2 instance as target
resource "aws_lb_target_group_attachment" "front_end" {
  target_group_arn = aws_lb_target_group.front_end.arn
  target_id        = aws_instance.front_end.id
}

# Route 53 record
resource "aws_route53_record" "website_domain_record" {
  zone_id = var.route53_zone_id
  name    = var.domain_name
  type    = "A"

  alias {
    name                   = aws_lb.front_end.dns_name
    zone_id                = aws_lb.front_end.zone_id
    evaluate_target_health = false
  }
}

# Security Group for ALB
resource "aws_security_group" "lb" {
  name        = "front-end-lb-sg"
  description = "Allow traffic to ALB"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
