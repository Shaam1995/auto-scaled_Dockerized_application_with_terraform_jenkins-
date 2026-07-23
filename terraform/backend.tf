terraform {
  backend "s3" {
    bucket         = "your-global-terraform-state-bucket"
    key            = "terraform.tfstate"
    region         = "us-east-2"
    dynamodb_table = "terraform-lock-table"
  }
}