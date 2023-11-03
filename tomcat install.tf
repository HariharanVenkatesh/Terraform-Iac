resource "aws_instance" "example" {
 ami           = "ami-0c94855ba95b798c7" # Amazon Linux 2 AMI (HVM), which already has Java installed
 instance_type = "t2.micro"

 key_name = "my-key-pair" # Replace with your actual key pair name

 tags = {
    Name = "Tomcat Server"
 }

 provisioner "remote-exec" {
    inline = [
      "sudo yum update -y", # Update the server to the latest packages
      "sudo yum install -y tomcat", # Install Tomcat
      "sudo systemctl start tomcat", # Start the Tomcat service
      "sudo systemctl enable tomcat" # Enable the Tomcat service to start on boot
    ]
 }

 connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file("~/.ssh/my-key-pair.pem") # Replace with the actual path to your private key file
    host        = self.public_ip
 }
}

output "server_ip" {
 value = aws_instance.example.public_ip
}