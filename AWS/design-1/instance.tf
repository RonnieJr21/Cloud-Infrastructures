resource "aws_instance" "server" {
  ami = "ami-053b0d53c279acc90"
  instance_type = "t2.micro"


  network_interface {
    network_interface_id = aws_network_interface.server-nic.id
    device_index = 0
  }
    user_data = {
        
    }
  
  tags = {
    Name = "Web Server!"
  }
  vpc_security_group_ids = aws_security_group.vpc-subnet-public.id
}

resource "aws_network_interface" "server-nic" {
  subnet_id   = aws_subnet.vpc-public-subnet.vpc_id

  tags = {
    Name = "primary_network_interface"
  }
}
