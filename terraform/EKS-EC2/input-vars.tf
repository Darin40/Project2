variable "ami" {
  description = "amazon image"
  default     = "ami-00bb6a80f01f03502"
}
variable "instance_type" {
  description = "instance type"
  default     = "t2.micro"
}
variable "key_name" {
  description = "key pair"
  default     = "docker"
}