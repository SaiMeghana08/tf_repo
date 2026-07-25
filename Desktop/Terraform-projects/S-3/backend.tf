terraform {
  backend "s3" {
    bucket         = "meghanaa-s3-demo-bucket" # change this
    key            = "megha/terraform.tfstate"
    region         = "ap-south-1"
    encrypt        = true
    dynamodb_table = "terraform-lock"
  }
}