provider "aws" {
 region = "us-west-2"
}

resource "aws_security_group" "allow_all" {
 name        = "allow_all"
 description = "Allow all inbound traffic"

 ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
 }

 egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
 }
}

resource "aws_lb" "example" {
 name               = "example"
 internal           = false
 load_balancer_type = "application"
 security_groups    = [aws_security_group.allow_all.id]

 subnets            = ["subnet-12345678", "subnet-abcdefgh"]
}

resource "aws_lb_target_group" "example" {
 name     = "example"
 port     = 80
 protocol = "HTTP"
 vpc_id   = "vpc-12345678"
}

resource "aws_lb_listener" "example" {
 load_balancer_arn = aws_lb.example.arn
 port              = "80"
 protocol          = "HTTP"

 default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.example.arn
 }
}