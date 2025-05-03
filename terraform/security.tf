
# SSH Key pair

resource "tls_private_key" "rsa_4096" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "generated_key" {
  key_name   = var.key_name
  public_key = tls_private_key.rsa_4096.public_key_openssh
}


# Security Groups

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

resource "aws_security_group" "jenkins_sg" {
  vpc_id = aws_vpc.cse41379.id
}

resource "aws_security_group" "sonarqube_sg" {
  vpc_id = aws_vpc.cse41379.id

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port = 9000
    to_port = 9000
    protocol = "tcp"
  }
 
  egress {
   from_port = 0
   to_port = 0
   protocol = "-1"
   cidr_blocks = ["0.0.0.0/0"]
 }  
    
 tags = {
   Name = "CSE-41379 Sonar Qube SG"
 }
  
}   


# Instance Roles

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
  name = "jenkins_profile"
  role = aws_iam_role.jenkins_role.name
}


resource "aws_iam_role" "sonarqube_role" {
  name = "sonarqube_role"

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
      tag-key = "CSE-41379 Sonar Qube server role"
  }
} 


resource "aws_iam_role_policy_attachment" "sonarqube_attachment" {
  role       = aws_iam_role.sonarqube_role.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}
 
  
resource "aws_iam_instance_profile" "sonarqube_profile" {
  name = "sonarqube_profile"
  role = aws_iam_role.sonarqube_role.name
}

