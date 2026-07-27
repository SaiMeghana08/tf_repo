provider "aws"{
    region="ap-south-1"
}
provider "vault" {
  address = "http://3.110.167.66:8200"
  skip_child_token = true

  auth_login {
    path = "auth/approle/login"

    parameters = {
      role_id = "7147266c-9c24-a080-0db7-5a3f9d941894"
      secret_id = "6575aa4e-331f-44a5-4c24-34f9dbcceb6d"
    }
  }
}
data "vault_kv_secret_v2" "example" {
  mount = "kv" // change it according to your mount
  name  = "secret" // change it according to your secret
}
resource "aws_instance" "my_instance" {
  ami           = "ami-01a00762f46d584a1"
  instance_type = "t3.micro"

  tags = {
    Name = "test"
    Secret = data.vault_kv_secret_v2.example.data["username"]
  }
}