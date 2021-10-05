locals {
  ports = ["22", "80", "443", "2049"]
}
resource "aws_security_group" "sg-dynamic" {
  # this security group belongs to the dd_vpc
  vpc_id      = aws_vpc.dd_vpc.id
  name        = "dynamic-sg"
  description = "dynamic-sg"
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  dynamic "ingress" {
    for_each = local.ports
    content {
      description = "allow port ${ingress.key}"
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
}
