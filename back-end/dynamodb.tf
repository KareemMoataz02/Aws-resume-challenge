provider "aws" {
  region = var.region
}

resource "aws_dynamodb_table" "visit-counter" {
  name           = "visit-counter"
  hash_key       = "site_id"
  read_capacity  = 5
  write_capacity = 5
  billing_mode   = "PROVISIONED"

  attribute {
    name = "site_id"
    type = "S"
  }
  tags = {
    Name = "Count visits"
  }
}

resource "aws_dynamodb_table" "terraform-state" {
  name           = "terraform-state"
  billing_mode   = "PROVISIONED"
  read_capacity  = 5
  write_capacity = 5
  hash_key       = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
  tags = {
    Name = "Terraform State Lock"
  }
}


