provider "aws"{
    region="ap-south-1"
}
variable "vars"{
    description="Value for var"
    default="10.0.0.0/16"
}
resource "aws_vpc" "main" {
  cidr_block = var.vars
}
resource "aws_subnet" "subnet" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.0.0/24"
   map_public_ip_on_launch = true
  tags = {
    Name = "subnet"
  }
}
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "gw"
  }
}
resource "aws_route_table" "test" {
  vpc_id = aws_vpc.main.id

  # since this is exactly the route AWS will create, the route will be adopted
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
}
resource "aws_route_table_association" "rta1" {
  subnet_id      = aws_subnet.subnet.id
  route_table_id = aws_route_table.test.id
}
resource "aws_security_group" "my_sg" {
  name        = "instance-sg"
  description = "Allow SSH traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress{
    from_port=0
    to_port=0
    protocol=-1
    cidr_blocks=["0.0.0.0/0"]
  }
  tags = {
    Name = "Web-sg"
  }
}

resource "aws_instance" "ec2"{
     ami= "ami-01a00762f46d584a1"
  instance_type = "t3.micro"
  subnet_id     = aws_subnet.subnet.id
  key_name      = "jenkins-instance"
  # Attach the security group here using its ID
  vpc_security_group_ids = [aws_security_group.my_sg.id]
  connection {
    type        = "ssh"
    user        = "ubuntu" # Use "ubuntu" if your AMI is Ubuntu
    private_key = file("${path.module}/jenkins-instance.pem") # Path to your local private key file
    host        = self.public_ip # Tells Terraform to use the instance's public IP
    timeout     = "5m"
  }
provisioner "file" {
    source      = "app.py"  # Replace with the path to your local file
    destination = "/home/ubuntu/app.py"  # Replace with the path on the remote instance
  }
provisioner "remote-exec" {
  inline = [
    "sudo apt update -y",
    "sudo apt install -y python3-pip python3-venv",
    "cd /home/ubuntu",
    "python3 -m venv venv",
    "/home/ubuntu/venv/bin/pip install flask",
    "nohup /home/ubuntu/venv/bin/python /home/ubuntu/app.py > /home/ubuntu/app.log 2>&1 &",
    "sleep 5",
    "cat /home/ubuntu/app.log"
  ]
}
}