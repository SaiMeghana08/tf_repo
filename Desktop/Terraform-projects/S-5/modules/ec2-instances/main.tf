provider "aws"{
    region="ap-south-1"
}
variable "ami"{
    description="ami_value"
}
variable "instance_type"{
    description="instance_type"
}
resource "aws_instance" "example"{
    ami=var.ami
    instance_type=var.instance_type
}