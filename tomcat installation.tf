resource "aws_instance" "example" {
 ami           = "ami-0c94855ba95b798c7" 
 instance_type = "t2.micro"

 key_name = "my-key-pair" 

 tags = {
    Name = "Tomcat Server"
 }

 provisioner "remote-exec" {
    inline = [
      "sudo yum update -y"
      "sudo yum install -y tomcat"
      "sudo systemctl start tomcat"
      "sudo systemctl enable tomcat" 
    ]
 }

 connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file("~/.ssh/my-key-pair.pem") 
    host        = self.public_ip
 }
}

output "server_ip" {
 value = aws_instance.example.public_ip
}