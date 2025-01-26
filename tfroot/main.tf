terraform {
  cloud { 
    
    organization = "krlab-delete" 

    workspaces { 
      name = "mylocalcli" 
    } 
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.82.2"
    }
  }
}
provider "aws" {
  region = "us-east-1"
}
locals {
  vpc = {
    dev = {
      vpc_cidr = "192.168.0.0/16"
      subnets = {
        "us-east-1a" = "192.168.5.0/24"
        "us-east-1b" = "192.168.6.0/24"
      }
    }
    prod = {
      vpc_cidr = "172.16.0.0/16"
      subnets = {
        "us-east-1a" = "172.16.5.0/24"
        "us-east-1b" = "172.16.6.0/24"
      }
    }
  }
}
module "maindev" {
  for_each    = local.vpc
  source  = "app.terraform.io/krlab-delete/mymodulevpc/aws"
  version = "1.0.0"
  vpc_cidr    = each.value.vpc_cidr
  azs         = keys(each.value.subnets)
  subnet_cidr = values(each.value.subnets)
}

