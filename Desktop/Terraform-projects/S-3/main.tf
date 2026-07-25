provider "aws"{
    region="ap-south-1"
}
resource "aws_instance" "example"{
    ami="ami-01a00762f46d584a1"
    instance_type="t3.micro"
}
resource "aws_s3_bucket" "s3_bucket"{
    bucket="meghanaa-s3-demo-bucket"
}
resource "aws_dynamodb_table" "terraform_lock" {
  name           = "terraform-lock"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}