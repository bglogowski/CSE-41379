
resource "aws_vpc" "cse41379" {
 cidr_block = var.vpc_cidr

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

resource "aws_eip" "jenkins_ip" {
  instance = "${aws_instance.jenkins_server.id}"

  tags = {
    Name = "CSE-41379 Jenkins server elastic IP"
  }

}

resource "aws_eip" "executor_ip" {
  instance = "${aws_instance.jenkins_executor.id}"

  tags = {
    Name = "CSE-41379 Jenkins Executor elastic IP"
  }

}

resource "aws_eip" "sonarqube_ip" {
  instance = "${aws_instance.sonarqube_server.id}"
  
  tags = {
    Name = "CSE-41379 Sonar Qube server elastic IP"
  } 
    
}
