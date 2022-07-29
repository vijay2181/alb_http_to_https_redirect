# AWS Provider
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region  = var.region
  profile = var.profile
}


data "aws_ami" "app_ami" {
  most_recent = true
  owners      = ["amazon"]


  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}

resource "aws_instance" "VIJAY-TERRAFORM" {
  ami                         = data.aws_ami.app_ami.id
  instance_type               = var.instance_type
  key_name                    = var.key_name
  subnet_id                   = aws_subnet.public-subnet-1.id
  vpc_security_group_ids      = [aws_security_group.vijay-sg.id,]
  associate_public_ip_address = true
  iam_instance_profile        = aws_iam_instance_profile.vijay_profile.name
  user_data                   = file("docker.sh")

  tags = {
    "Name"    = "VIJAY-TERRAFORM"
    "Backend" = "VIJAY"
    "Tenant"  = "TERRAFORM"
  }

  provisioner "file" {
    source      = "configure"
    destination = "/tmp"

  }

  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "ec2-user"
    private_key = file("/vagrant/${var.key_name}.pem")
    timeout     = "4m"
  }
}


resource "aws_lb_target_group" "vijay-target-group-http" {
  health_check {
    interval            = 30
    path                = "/index.html"
    protocol            = "HTTP"
    timeout             = 6
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  name        = "vijay-target-group-http"
  port        = 80
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = aws_vpc.vpc.id
}

resource "aws_lb_target_group_attachment" "vijay-target-group-attachment" {
  target_group_arn = aws_lb_target_group.vijay-target-group-http.arn
  target_id        = aws_instance.VIJAY-TERRAFORM.id
  port             = 4000
}

resource "aws_lb" "vijay-alb" {
  name     = "vijay-alb"
  internal = false

  security_groups = [
    aws_security_group.alb-vijay-sg.id,
  ]

  subnets = [
    aws_subnet.public-subnet-1.id,
    aws_subnet.public-subnet-2.id,
    aws_subnet.public-subnet-3.id,
  ]

  #we are giving three subnets because lb should be launched in at altest two subnets 
  tags = {
    Name = "vijay-alb"
  }

  ip_address_type    = "ipv4"
  load_balancer_type = "application"
}


resource "aws_lb_listener" "vijay-alb-listener-http" {
  depends_on = [
    aws_lb.vijay-alb,
    aws_lb_target_group.vijay-target-group-http
  ]
  load_balancer_arn = aws_lb.vijay-alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.vijay-target-group-http.arn
    type             = "forward"
  }
}


resource "aws_lb_listener" "vijay-alb-listener-https" {
  depends_on        = [aws_acm_certificate.alb-certificate]
  load_balancer_arn = aws_lb.vijay-alb.arn
  port              = 443
  protocol          = "HTTPS"
  certificate_arn   = aws_acm_certificate.alb-certificate.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.vijay-target-group-http.arn
  }
}

resource "aws_lb_listener_certificate" "test" {
  depends_on      = [aws_acm_certificate_validation.certificate-validation]
  listener_arn    = aws_lb_listener.vijay-alb-listener-https.arn
  certificate_arn = aws_acm_certificate.alb-certificate.arn
}


resource "aws_lb_listener_rule" "test" {
  listener_arn = aws_lb_listener.vijay-alb-listener-https.arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.vijay-target-group-http.arn
  }

  condition {
    host_header {
      values = [var.record]
    }
  }
}


resource "aws_lb_listener_rule" "redirect_http_to_https" {
  listener_arn = aws_lb_listener.vijay-alb-listener-http.arn

  action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }

  condition {
    host_header {
      values = [var.record]
    }
  }
}
