provider "aws" {
 region = "us-west-2"
}

resource "aws_instance" "jenkins" {
 ami           = "ami-0c94855ba95b798c7"
 instance_type = "t2.micro"

 tags = {
    Name = "Jenkins"
 }

 user_data = <<-EOF
              #!/bin/bash
              sudo apt-get update
              sudo apt-get install -y openjdk-8-jdk
              wget -q -O - https://pkg.jenkins.io/debian/jenkins.io.key | sudo apt-key add -
              sudo sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
              sudo apt-get update
              sudo apt-get install -y jenkins
              sudo systemctl start jenkins
              sudo systemctl enable jenkins
              EOF
}

resource "aws_security_group" "jenkins" {
 name        = "jenkins_sg"
 description = "Jenkins security group"

 ingress {
    from_port   = 8080
    to_port     = 8080
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

resource "aws_security_group_rule" "jenkins_http" {
 security_group_id = aws_security_group.jenkins.id

 type        = "ingress"
 from_port   = 80
 to_port     = 80
 protocol    = "tcp"
 cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "jen