data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

# resource "aws_vpc" "server_vpc" {
#   cidr_block = "172.16.0.0/16"

#   tags = {
#     Name = "web-vpc"
#   }
# }

# resource "aws_subnet" "server_subnet" {
#   vpc_id            = aws_vpc.server_vpc.id
#   cidr_block        = "172.16.10.0/24"
#   availability_zone = "us-east-1a"

#   tags = {
#     Name = "web-subnet"
#   }
# }

# resource "aws_network_interface" "net_interface" {
#   subnet_id   = aws_subnet.server_subnet.id
#   private_ips = ["172.16.10.100"]

#   tags = {
#     Name = "primary_network_interface"
#   }
# }

resource "aws_security_group" "firewall" {
  # vpc_id = aws_vpc.server_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

resource "aws_instance" "web_server" {
  ami           = data.aws_ami.ubuntu.id
  key_name      = "./.keys/secret-key"
  # user_data     = file("install_nginx.sh")
  instance_type = "t2.micro"

  tags = {
    Name = "nginx-server"
  }

  # network_interface {
  #   network_interface_id = aws_network_interface.net_interface.id
  #   device_index         = 0
  # }

  connection {
    type        = "ssh"
    host        = self.private_ip
    user        = "ubuntu"
    private_key = file(".keys/secret-key")
  }

  # provisioner "file" {
  #   source     = "install_nginx.sh"
  #   destination = "/tmp/install_nginx.sh"
  # }

  provisioner "remote-exec" {
    inline = [
      "sudo apt update",
      "sudo apt install nginx",
      "sudo systemctl start nginx"
    ]
  }

}

resource "aws_key_pair" "secret_key" {
  key_name   = "./.keys/secret-key"
  public_key = file(".keys/secret-key.pub")
}

output "public_ip" {
  value = ["${aws_instance.web_server.*.public_ip}"]
}
