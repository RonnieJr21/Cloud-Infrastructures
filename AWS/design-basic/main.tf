terraform {
  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "~> 3.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region     = "us-east-1"
  access_key = ""
  secret_key = ""
}

# Configure basic ubuntu instance
resource "aws_instance" "ubuntu" {
  ami = "ami-053b0d53c279acc90"
  instance_type = "t2.micro"

}
