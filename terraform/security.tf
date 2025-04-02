resource "aws_security_group" "ec2_sg" {
    vpc_id = aws_default_vpc.default.id
    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["79.119.37.164/32"]
        ipv6_cidr_blocks = ["::/0"]
    }
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["79.119.37.164/32"]
        ipv6_cidr_blocks = ["::/0"]
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = -1
        cidr_blocks = ["79.119.37.164/32"]
        ipv6_cidr_blocks = ["::/0"]
    }
}