variable "image_version" {
  type = string
}

variable "instance_count" {
  type = number
}

variable "container_port" {
  type    = number
  default = 3000
}

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
  default = "s-1vcpu-1gb"
}

variable "ssh_private_key_file" {
  type = string
}

variable "docker_host_ip" {
  type = string
  default = "167.71.213.52"
}
