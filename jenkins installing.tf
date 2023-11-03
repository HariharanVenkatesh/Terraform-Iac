provider "aws" {
 region = "us-west-2"
}

data "aws_ami" "jenkins" {
 most_recent = true
 owners      = ["amazon"]

 filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
 }
}

resource "aws_security_group" "jenkins_sg" {
 name        = "jenkins_sg"
 description = "Allow inbound traffic"

 ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
 }

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

resource "aws_instance" "jenkins_instance" {
 ami           = data.aws_ami.jenkins.id
 instance_type = "t2.micro"

 key_name               = "your-key-pair"
 vpc_security_group_ids = [aws_security_group.jenkins_sg.id]

 user_data = <<-EOF
              #!/bin/bash
              sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
              sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
              sudo yum install -y jenkins java-1.8.0-openjdk-devel
              sudo systemctl start jenkins
              sudo systemctl enable jenkins
              EOF

 tags = {
    Name = "jenkins_instance"
 }
}

output "public_ip" {
 value = aws_instance.jenkins_instance.public_ip
}