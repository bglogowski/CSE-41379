
#resource "aws_network_interface" "jenkins_nic" {
#  subnet_id   = aws_subnet.public_subnets[0].id
#  private_ips = ["10.0.1.10"]
#
#  tags = {
#    Name = "CSE-41379 Jenkins Primary NIC"
#  }
#}

#resource "aws_ebs_volume" "jenkins_root" {
#  availability_zone = "us-west-2a"
#  size              = 40
#
#  tags = {
#    Name = "HelloWorld"
#  }
#}

resource "aws_ebs_volume" "jenkins_disk" {
    final_snapshot       = false
    availability_zone    = "us-west-2c"
    encrypted            = false
    iops                 = 3000
    size                 = 20
    throughput           = 125
    type                 = "gp3"
    tags                 = {
        "Name" = "CSE-41379 Jenkins disk"
    }
}

resource "aws_volume_attachment" "jenkins_ebs_attachment" {
  device_name           = "/dev/xvda"
  volume_id   = aws_ebs_volume.jenkins_disk.id
  instance_id = aws_instance.jenkins_server.id
}



resource "aws_instance" "jenkins_server" {
#  ami           = data.aws_ami.jenkins_ami.id
#  ami           = "ami-075686beab831bb7f"
  ami           = "ami-05572e392e80aee89"
  instance_type = "t2.medium"

  subnet_id       = aws_subnet.public_subnets[0].id
  vpc_security_group_ids = [ "${aws_security_group.jenkins_sg.id}", "${aws_security_group.ssh_sg.id}", "${aws_security_group.http_sg.id}" ]
  key_name      = aws_key_pair.generated_key.key_name

  iam_instance_profile = aws_iam_instance_profile.jenkins_profile.name


  root_block_device {
#    volume_size = 20
#    volume_type = "gp3"
#    iops        = 3000
#    throughput  = 125
    delete_on_termination = false
    tags                 = {
        "Name" = "CSE-41379 Jenkins disk"
    }

  }


#  network_interface {
#    network_interface_id = "${aws_network_interface.jenkins_nic.id}"
#    device_index         = 0
#  }


  tags = {
    Name = "CSE-41379 Jenkins server"
  }

}



resource "aws_instance" "jenkins_executor" {
  ami           = "ami-05572e392e80aee89"
  instance_type = "t2.medium"

  subnet_id       = aws_subnet.public_subnets[0].id
  vpc_security_group_ids = [ "${aws_security_group.jenkins_sg.id}", "${aws_security_group.ssh_sg.id}", "${aws_security_group.http_sg.id}" ]
  key_name      = aws_key_pair.generated_key.key_name

  iam_instance_profile = aws_iam_instance_profile.jenkins_profile.name


  root_block_device {
    volume_size = 20
    volume_type = "gp3"
    iops        = 3000
    throughput  = 125
    delete_on_termination = true
  }


  tags = {
    Name = "CSE-41379 Jenkins Executor"
  }

}



resource "aws_instance" "sonarqube_server" {
  ami           = "ami-05572e392e80aee89"
  instance_type = "t2.medium"
 
  subnet_id       = aws_subnet.public_subnets[0].id
  vpc_security_group_ids = [ "${aws_security_group.sonarqube_sg.id}", "${aws_security_group.ssh_sg.id}" ]
  key_name      = aws_key_pair.generated_key.key_name

  iam_instance_profile = aws_iam_instance_profile.sonarqube_profile.name
 
 
  root_block_device {
    volume_size = 20
    volume_type = "gp3"
    iops        = 3000
    throughput  = 125
    delete_on_termination = true
  }


   
  tags = {
    Name = "CSE-41379 Sonar Qube server"
  }

}




resource "aws_instance" "private_executor_test" {
  count      = length(var.private_subnet_cidrs)
  ami           = "ami-05572e392e80aee89"
  instance_type = "t2.micro"

  subnet_id       = element(aws_subnet.private_subnets[*].id, count.index)
  vpc_security_group_ids = [ "${aws_security_group.jenkins_sg.id}", "${aws_security_group.ssh_sg.id}", "${aws_security_group.http_sg.id}" ]
  key_name      = aws_key_pair.generated_key.key_name

  iam_instance_profile = aws_iam_instance_profile.jenkins_profile.name


  tags = {
    Name = "CSE-41379 Jenkins Private Executor Test ${count.index + 1}"
  } 
    
} 
