
 resource "aws_instance" "Jumpbox" {
    ami                         = "ami-0ff30663ed13c2290"
    instance_type               = "t2.micro"
    subnet_id                   = aws_subnet.pubsub.id
    vpc_security_group_ids      = [aws_security_group.allow_all.id]
    key_name                    = "Laptopkey"
    associate_public_ip_address = true
}
