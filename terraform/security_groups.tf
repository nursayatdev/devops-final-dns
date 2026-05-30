# Security Group for Bastion Host (Public Subnet)
resource "aws_security_group" "bastion_sg" {
  name        = "bastion-security-group"
  description = "Allows SSH access to the Bastion host from trusted administrative CIDRs"
  vpc_id      = aws_vpc.main.id

  # Inbound SSH from our trusted administrative IP range defined in variables
  ingress {
    description = "SSH administrative access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.allowed_ssh_cidr]
  }

  # Allow inbound Tinyproxy requests from the private instances within the VPC
  ingress {
    description = "Allow Tinyproxy access from VPC CIDR"
    from_port   = 8888
    to_port     = 8888
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  # Allow all outbound traffic
  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "bastion-sg"
  }
}

# Security Group for Private Subnet Instances (DNS servers and hosts)
resource "aws_security_group" "private_sg" {
  name        = "private-security-group"
  description = "Controls incoming and outgoing traffic for hosts in the private subnet"
  vpc_id      = aws_vpc.main.id

  # Allow SSH ONLY from the Bastion Host security group
  ingress {
    description     = "SSH access strictly restricted to the Bastion Host"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion_sg.id]
  }

  # Allow inbound DNS TCP query traffic from the VPC CIDR (never exposed to public internet)
  ingress {
    description = "DNS TCP queries from within VPC"
    from_port   = 53
    to_port     = 53
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  # Allow inbound DNS UDP query traffic from the VPC CIDR (never exposed to public internet)
  ingress {
    description = "DNS UDP queries from within VPC"
    from_port   = 53
    to_port     = 53
    protocol    = "udp"
    cidr_blocks = [var.vpc_cidr]
  }

  # Allow all outbound traffic so private servers can download packages (bind9, dnsutils) via NAT Gateway
  egress {
    description = "Allow outbound updates and external internet access"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "private-instances-sg"
  }
}
