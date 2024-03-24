#Provisioning backend statefile
terraform {
  backend "s3" {
    bucket         = "coolfmremotestatedev2024"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "remote-terraform-state-lock"
  }
}
