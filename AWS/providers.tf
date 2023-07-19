terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region     = "us-east-1"
  access_key = "AKIA3R4CVWRS4R5U6P2T"
  secret_key = "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"
}

