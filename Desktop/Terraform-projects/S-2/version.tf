provider "aws" {
  region = "ap-south-1"
}
module "ec2_instance" {
  source = "./modules"
  ami_value = "ami-01a00762f46d584a1"
  instance_type_value = "t3.micro"
  key_name_value = "jenkins-instance"
}
output "public_ip" {
  value = module.ec2_instance.public_ip
}