
resource "aws_vpc" "cse41379" {
 cidr_block = "10.0.0.0/16"

 tags = {
   Name = "CSE-41379 VPC"
 }
}


resource "aws_subnet" "public_subnets" {
 count      = length(var.public_subnet_cidrs)
 vpc_id     = aws_vpc.cse41379.id
 cidr_block = element(var.public_subnet_cidrs, count.index)

 tags = {
   Name = "CSE-41379 Public Subnet ${count.index + 1}"
 }
}

 

resource "aws_subnet" "private_subnets" {
 count      = length(var.private_subnet_cidrs)
 vpc_id     = aws_vpc.cse41379.id
 cidr_block = element(var.private_subnet_cidrs, count.index)

 tags = {
   Name = "CSE-41379 Private Subnet ${count.index + 1}"
 }
}


resource "aws_internet_gateway" "ig" {
 vpc_id = aws_vpc.cse41379.id

 tags = {
   Name = "CSE-41379 VPC IG"
 }
}


resource "aws_route_table" "wan_rt" {
 vpc_id = aws_vpc.cse41379.id

 route {
   cidr_block = "0.0.0.0/0"
   gateway_id = aws_internet_gateway.ig.id
 }

 
 tags = {
   Name = "CSE-41379 WAN Route Table"
 }
}

resource "aws_route_table_association" "public_subnet_assn" {
 count = length(var.public_subnet_cidrs)
 subnet_id      = element(aws_subnet.public_subnets[*].id, count.index)
 route_table_id = aws_route_table.wan_rt.id

}


resource "aws_security_group" "ssh_sg" {

  vpc_id = aws_vpc.cse41379.id
  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port = 22
    to_port = 22
    protocol = "tcp"
  }

  egress {
   from_port = 0
   to_port = 0
   protocol = "-1"
   cidr_blocks = ["0.0.0.0/0"]
 }

 tags = {
   Name = "CSE-41379 SSH SG"
 }

}

resource "aws_security_group" "http_sg" {

  vpc_id = aws_vpc.cse41379.id

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port = 80
    to_port = 80
    protocol = "tcp"
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
  }

  egress {
   from_port = 0
   to_port = 0
   protocol = "-1"
   cidr_blocks = ["0.0.0.0/0"]
 }

 tags = {
   Name = "CSE-41379 HTTP SG"
 }

}


resource "tls_private_key" "rsa_4096" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "generated_key" {
  key_name   = var.key_name
  public_key = tls_private_key.rsa_4096.public_key_openssh
}


resource "aws_iam_role" "jenkins_role" {
  name = "test_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF

  tags = {
      tag-key = "CSE-41379 Jenkins server role"
  }
}

resource "aws_iam_role_policy_attachment" "jenkins_attachment" {
  role       = aws_iam_role.jenkins_role.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}


resource "aws_iam_instance_profile" "jenkins_profile" {
  name = "test_profile"
  role = "${aws_iam_role.jenkins_role.name}"
}


resource "aws_security_group" "jenkins_sg" {
  vpc_id = aws_vpc.cse41379.id
}

resource "aws_instance" "jenkins_server" {
  ami           = "ami-05572e392e80aee89"
  instance_type = "t2.micro"
  subnet_id       = aws_subnet.public_subnets[0].id
  vpc_security_group_ids = [ "${aws_security_group.jenkins_sg.id}", "${aws_security_group.ssh_sg.id}", "${aws_security_group.http_sg.id}" ]
  key_name      = aws_key_pair.generated_key.key_name

  iam_instance_profile = aws_iam_instance_profile.jenkins_profile.name

  tags = {
    Name = "CSE-41379 Jenkins server"
  }

}


resource "aws_eip" "jenkins_ip" {
  instance = "${aws_instance.jenkins_server.id}"

  tags = {
    Name = "CSE-41379 Jenkins server elastic IP"
  }

}
