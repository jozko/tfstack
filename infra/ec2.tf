/*
Create a keypair and an EC2 instance
*/

resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQD3F6tyPEFEzV0LX3X8BsXdMsQz1x2cEikKDEY0aIj41qgxMCP/iteneqXSIFZBp5vizPvaoIR3Um9xK7PGoW8giupGn+EPuxIA4cDM4vzOqOkiMPhz5XK0whEjkVzTo4+S0puvDZuwIsdiW9mxhJc7tgBNL0cYlWSYVkz4G/fslNfRPW5mYAM49f4fhtxPb5ok4Q2Lg9dPKVHO/Bgeu5woMc7RY0p1ej6D4CKFE6lymSDJpW0YHX/wqE9+cfEauh7xZcG0q9t2ta6F6fmX0agvpFyZo8aFbXeUBr7osSCJNgvavWbM/06niWrOvYX2xwWdhXmXSrbX8ZbabVohBK41 email@example.com"
}

resource "aws_instance" "bastion" {
  ami           = "ami-03cf127a"
  key_name      = aws_key_pair.deployer.key_name
  instance_type = "t2.micro"
  vpc_security_group_ids = [
    aws_security_group.allow_http.id
  ]
  associate_public_ip_address = true
  subnet_id                   = aws_subnet.localstack_vpc_subnet.id

  root_block_device {
    delete_on_termination = true
    volume_size           = 100
  }

  tags = {
    Stage = "local"
    Name  = "bastion-local"
  }
}