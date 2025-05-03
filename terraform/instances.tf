
#resource "aws_network_interface" "jenkins_nic" {
#  subnet_id   = aws_subnet.public_subnets[0].id
#  private_ips = ["10.0.1.10"]
#
#  tags = {
#    Name = "CSE-41379 Jenkins Primary NIC"
#  }
#}



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
    volume_size = 20
    volume_type = "gp3"
    iops        = 3000
    throughput  = 125
    delete_on_termination = true
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

