terraform {
  backend "s3" {
    bucket         = "ns2312-tf-state"
    dynamodb_table = "ns2312-statelock-table"
    region         = "us-east-1"
    key            = "ns2312-cluster/terraform.tfstate"
  }
}

provider "aws" {
  region = "us-east-1"
}