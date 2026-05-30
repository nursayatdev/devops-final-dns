variable "aws_region" {
  type        = string
  description = "The target AWS region for deployment"
  default     = "us-east-1"
}

variable "vpc_cidr" {
  type        = string
  description = "CIDR block for the main project VPC"
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  type        = string
  description = "CIDR block for the public subnet where the bastion resides"
  default     = "10.0.1.0/24"
}

variable "private_subnet_cidr" {
  type        = string
  description = "CIDR block for the private subnet where DNS servers and hosts reside"
  default     = "10.0.2.0/24"
}

variable "allowed_ssh_cidr" {
  type        = string
  description = "Trusted CIDR block allowed to SSH into the Bastion Host (e.g., administrator home IP)"
  default     = "0.0.0.0/0" # In production, restrict this to a specific trusted IP
}

variable "key_name" {
  type        = string
  description = "Name of the AWS Key Pair to use for EC2 instances"
  default     = "devops-key"
}

variable "ssh_public_key" {
  type        = string
  description = "The public key material to register in AWS for SSH access"
}

variable "instance_type" {
  type        = string
  description = "EC2 instance size for the project virtual machines"
  default     = "t3.micro"
}
