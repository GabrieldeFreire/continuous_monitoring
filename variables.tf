
#us-east-1 regions

variable "aws_region" {
  description = "AWS region to launch servers."
  default     = "us-east-1"
}

variable "aws_availability_zone" {
  description = "AWS availabitiy zone to launch servers."
  default     = "us-east-1a"
}

variable "aws_instance_type" {
  description = "AWS Instance type"
  default     = "t2.micro"
}

# Ubuntu Server 20.04 LTS (HVM), SSD Volume Type
variable "aws_amis" {
  default = {
    us-east-1 = "ami-053b0d53c279acc90"
  }
}

variable "name" {
  description = "Infrastructure name"
  default     = "lab_monitoring"
}

variable "monitoring_server_name" {
  default     = "prometheus_grafana_server"
}

variable "database_server_name" {
  default     = "postgresql_server"
}

variable "vpc_cidr" {
  description = "VPC CIDR"
  default     = "10.0.0.0/16"
}

variable "prometheus_server_subnet_cidr1" {
  description = "Promethus Server Subnet CIDR"
  default     = "10.0.10.0/24"
}

variable "env" {
  description = "Environment"
  default     = "Prod"
}
