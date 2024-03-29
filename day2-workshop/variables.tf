variable "do_token" {}

variable "ssh_pub_key" {
  type = string
}

variable "image" {
  type    = string
  default = "ubuntu-20-04-x64"
}

variable "region" {
  type    = string
  default = "sgp1"
}

variable "size" {
  type    = string
  default = "s-1vcpu-2gb"
}

variable "ssh_private_key_file" {
  type = string
}

variable "code_server_password" {
  
}
