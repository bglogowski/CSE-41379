variable "key_name" {
  type        = string
  description = "SSH key pair name"
  default     = "cse41379"
}

variable "vpc_cidr" {
  type        = string
  description = "VPC CIDR value"
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
 type        = list(string)
 description = "Public Subnet CIDR values"
 default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
 # default     = ["10.0.1.0/22", "10.0.4.0/22", "10.0.8.0/22"]
}

 

variable "private_subnet_cidrs" {
 type        = list(string)
 description = "Private Subnet CIDR values"
 default     = ["10.0.12.0/22", "10.0.16.0/22", "10.0.20.0/22"]
}


variable "azs" {
 type        = list(string)
 description = "Availability Zones"
 default     = ["us-west-2a", "us-west-2b", "us-west-2c"]
}
