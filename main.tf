
resource "aws_instance" "public-vm" {
  subnet_id     = aws_subnet.public-subnet.id
  instance_type = "t2.micro"
  key_name      = var.key_name
  # ami         = data.aws_ami.redhat.id
  ami = var.ami_id

  associate_public_ip_address = true
  # user_data                   = file("ebs.sh")

  user_data = <<-EOT
#! /bin/bash
mkfs -t xfs /dev/xvdb
mkdir /mxlocal
mount /dev/xvdb /mxlocal
blkid /dev/xvdb |  awk '{print $2}' > /tmp/mx_tmpb_fsfile
sed -i 's/"//' /tmp/mx_tmpb_fsfile
sed -i 's/"/ \/mxlocal  xfs     defaults        0 0 /' /tmp/mx_tmpb_fsfile
cat /tmp/mx_tmpb_fsfile >> /etc/fstab
mkfs -t xfs /dev/xvdh
mkdir /mxdata
mount /dev/xvdh /mxdata
blkid /dev/xvdh |  awk '{print $2}' > /tmp/mx_tmph_fsfile
sed -i 's/"//' /tmp/mx_tmph_fsfile
sed -i 's/"/ \/mxdata  xfs     defaults        0 0 /' /tmp/mx_tmph_fsfile
cat /tmp/mx_tmph_fsfile >> /etc/fstab
  EOT 

  vpc_security_group_ids = [aws_security_group.sg-dynamic.id]

  tags = {
    Name = "tf-public-vm"
  }

}

resource "aws_vpc" "dd_vpc" {
  cidr_block = "10.0.0.0/16"
}
resource "aws_subnet" "public-subnet" {
  vpc_id                  = aws_vpc.dd_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-west-2a"
  map_public_ip_on_launch = true
}


# internet gateway for the vpc
resource "aws_internet_gateway" "myvpc-igw" {
  vpc_id = aws_vpc.dd_vpc.id
  tags = {
    Name = "dd_vpc-igw"
  }
}
resource "aws_route_table" "public-rtb" {
  vpc_id = aws_vpc.dd_vpc.id

  tags = {
    Name = "rtb-for-public-subnet"
  }
}

# route to the my-igw
resource "aws_route" "internet_access" {
  route_table_id         = aws_route_table.public-rtb.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.myvpc-igw.id
}

resource "aws_route_table_association" "assoc-public" {
  subnet_id      = aws_subnet.public-subnet.id
  route_table_id = aws_route_table.public-rtb.id
}

resource "time_sleep" "wait_some_seconds" {
  depends_on      = [aws_instance.public-vm]
  create_duration = "20s"
}
