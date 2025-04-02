resource "aws_instance" "nginx_instance_prod" {
  ami                    = "ami-0ecf75a98fe8519d7" # Amazon Linux 2023 AMI
  instance_type          = "t3.micro"
  key_name               = "dardelean"
  user_data              = filebase64("user_data.sh")
  iam_instance_profile   = aws_iam_instance_profile.ec2_instance_profile.name
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  tags = {
    Name = "Production EC2"
  }
}

resource "aws_instance" "nginx_instance_dev" {
  ami                    = "ami-0facbf2a36e11b9dd" # Amazon Linux 2023 AMI, eu-west-3
  instance_type          = "t3.micro"
  key_name               = "ami-0ecf75a98fe8519d7"
  user_data              = filebase64("user_data.sh")
  iam_instance_profile   = aws_iam_instance_profile.ec2_instance_profile.name
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  tags = {
    Name = "Development EC2"
  }
}

resource "tls_private_key" "rsa" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "TF_key" {
  key_name   = "TF_key"
  public_key = tls_private_key.rsa.public_key_openssh
}

resource "local_file" "private_key" {
  content  = tls_private_key.rsa.private_key_pem
  filename = "tfkey"
}