provider "aws"{
    region="ap-south-1"
}
variable "ami"{
    description="ami_value"
}
variable "instance_type"{
    description="instance_type"
    type=map(string)
    default={
        "dev"="t3.micro"
        "prod"="t3.small"
    }
}
module "ec2_instance"{
    source="./modules/ec2-instances"
    ami=var.ami
    instance_type=lookup(var.instance_type,terraform.workspace,"t2.micro")
}