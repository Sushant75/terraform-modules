# Variable-1: Region

variable "aws-region" {
  default = "us-east-1"
}

# Variable-2: Auto-Assign Public IP
variable "map-on-launch" {
  description = "Mapping of Public IP on Launch"
  type = bool
  default = true
}

# Variable-3: CIDR Blocks

variable "vpc-cidr" {
  description = "Variable that will provide CIDRS to VPC and Subnets."
  type = list(string)
  default = [ "10.0.0.0/16", "10.0.0.0/19", "10.0.32.0/19", "10.0.64.0/18", "10.0.128.0/18", "10.0.192.0/19", "10.0.224.0/19" ]
}

# Variable-4: Availability Zone
variable "availability_zone" {
  description = "Mapping of Availabilty Zones"
  type = map 
  default = {
    "az-1" = "us-east-1a"
    "az-2" = "us-east-1b"
  }
}