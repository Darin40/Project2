# Create a new security group
resource "aws_security_group" "jenkins_sg" {
  name        = "jenkins-security-group"
  description = "Allow HTTP and Jenkins port access"

  # Allow inbound HTTP traffic (port 80)
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Open to the world (modify as needed)
  }

  # Allow inbound Jenkins traffic (port 8080)
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Open to the world (modify as needed)
  }

  # Allow SSH access (port 22) for remote management
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Restrict to your IP for security
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create the EC2 instance with the new security group
resource "aws_instance" "darinterra_vm" {
  ami             = var.ami
  instance_type   = var.instance_type
  key_name        = var.key_name
  security_groups = [aws_security_group.jenkins_sg.name] # Use the new security group

  tags = {
    Name = "jenkins"
  }
}