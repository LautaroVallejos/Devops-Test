# AMI data
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

# EC2 instance
resource "aws_instance" "web_server" {
  ami           = data.aws_ami.ubuntu.id
  key_name      = var.key_name
  instance_type = "t2.micro"

  iam_instance_profile = aws_iam_instance_profile.ec2_role.name
  subnet_id = aws_subnet.server_subnet.id
  vpc_security_group_ids = ["${aws_security_group.firewall.id}"]

  tags = {
    Name = "nginx-server"
  }

  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "ubuntu"
    private_key = file(var.key_name)
  }

  # NGINX Installation
  provisioner "remote-exec" {
    inline = [
      "sudo apt -y update",
      "sudo apt -y install nginx",
      "sudo systemctl start nginx"
    ]
  }

}

# Key Pair SSH Connection
resource "aws_key_pair" "secret_key" {
  key_name   = var.key_name
  public_key = file(var.public_key)
}

# Outputs
output "public_dns" {
  value = aws_instance.web_server.*.public_dns
}
output "public_ip" {
  value = aws_instance.web_server.*.public_ip
}
