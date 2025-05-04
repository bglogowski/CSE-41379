
resource "aws_vpc" "cse41379" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

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

resource "aws_eip" "nat_gateway" {
  count    = length(var.private_subnet_cidrs)
  domain   = "vpc"

  tags = {
    "Name" = "CSE-41379 NAT Gateway Public IP ${count.index + 1}"
  }

}

resource "aws_nat_gateway" "nat_gateway" {
  count         = length(var.private_subnet_cidrs)
  allocation_id = element(aws_eip.nat_gateway[*].id, count.index)
  subnet_id     = element(aws_subnet.public_subnets[*].id, count.index)

  tags = {
    "Name" = "CSE-41379 NAT Gateway ${count.index + 1}"
  }

}

resource "aws_route_table" "nat_gateway" {
  vpc_id = aws_vpc.cse41379.id
  count         = length(var.private_subnet_cidrs)
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = element(aws_nat_gateway.nat_gateway[*].id, count.index)
  }
  tags = {
    "Name" = "CSE-41379 NAT Route Table ${count.index + 1}"
  }

}

resource "aws_route_table_association" "nat_gateway" {
 count          = length(var.private_subnet_cidrs)
 subnet_id      = element(aws_subnet.private_subnets[*].id, count.index)
 route_table_id = element(aws_route_table.nat_gateway[*].id, count.index)

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
