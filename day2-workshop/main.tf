/* 
provision 1 server

s-1vcpu-2gb 

in singapore
*/

terraform {
  required_version = "> 1.7.0"
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "2.5.1"
    }
  }
}

provider "digitalocean" {
  token = var.do_token
}

provider "local" {
  # Configuration options
}

data "digitalocean_ssh_key" "arun-ssh-pub" {
  name = var.ssh_pub_key
}


resource "digitalocean_droplet" "practice-vm-2" {
  name     = "practice-vm-2"
  image    = var.image
  region   = var.region
  size     = var.size
  ssh_keys = [data.digitalocean_ssh_key.arun-ssh-pub.id]

  connection {
    type     = "ssh"
    user     = "root"
    private_key = file("${var.ssh_private_key_file}/id_rsa")
    host     = "${digitalocean_droplet.droplet-1.ipv4_address}"
  }
}

resource "local_file" "inventory" {
  filename = "inventory.yaml"
  content = <<EOT
  all:
    vars:
      ansible_user: root
      ansible_connection: ssh
      ansible_ssh_private_key_file: ${var.ssh_private_key_file}id_rsa
      codeserver_password: ${var.code_server_password}
      codeserver_domain: code-server.${digitalocean_droplet.droplet-1.ipv4_address}.nip.io
    hosts:
      ${digitalocean_droplet.droplet-1.name}:
        ansible_host: ${digitalocean_droplet.droplet-1.ipv4_address}
  EOT
  file_permission = "0444"
}
