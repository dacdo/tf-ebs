# Get latest AMI ID for Redhat OS
data "aws_ami" "redhat" {
  most_recent = true
  owners      = ["675714608849"]

}
