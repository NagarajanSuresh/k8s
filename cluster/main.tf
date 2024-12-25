module "network" {
  source   = "./network"
  region   = "us-east-1"
  prefix   = "ns2312-cluster"
  vpc_cidr = "10.0.0.0/16"
  public_subnets = [{
    az   = "us-east-1a",
    cidr = "10.0.0.0/24"
    }, {
    az   = "us-east-1b",
    cidr = "10.0.1.0/24"
  }]
  private_subnets = [{
    az   = "us-east-1a",
    cidr = "10.0.2.0/24",
    }, {
    az   = "us-east-1b",
    cidr = "10.0.3.0/24"
  }]
}