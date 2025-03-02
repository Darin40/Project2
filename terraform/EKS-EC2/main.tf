resource "aws_instance" "darinterra_vm" {
  ami             = var.ami
  instance_type   = var.instance_type
  key_name        = var.key_name
  security_groups = ["default"]
  tags = {
    Name = "ubuntu-server"
  }
}