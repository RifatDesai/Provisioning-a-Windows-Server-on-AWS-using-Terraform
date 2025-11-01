variable "aws_region" {
  type    = string
  default = "ap-south-1"   # change if needed
}

variable "key_name" {
  type    = string
  default = "my-win-key"
}

variable "instance_type" {
  type    = string
  default = "t3.micro"
}

# You must provide a valid Windows AMI id for your region.
variable "windows_ami" {
  type    = string
  default = "ami-089e0600a8bb6d176"  # set a Windows AMI id e.g. "ami-0abcd..." or pass via -var
}

variable "subnet_id" {
  type = string
  default = "subnet-0cb7bc7a3b18962cd"  # optional: put subnet if launching in VPC
}
