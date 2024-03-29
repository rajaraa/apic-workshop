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
  backend "s3" {
    skip_credentials_validation = true
    skip_region_validation      = true
    skip_metadata_api_check     = true
    skip_requesting_account_id  = true
    skip_s3_checksum = true
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

data "digitalocean_image" "mydroplet_nginx" {
  name = "mydroplet_snapshot"
}

resource "digitalocean_droplet" "practice-vm-3" {
  name     = "practice-vm-3"
  image    = data.digitalocean_image.mydroplet_nginx.image
  region   = var.region
  size     = var.size
  ssh_keys = [data.digitalocean_ssh_key.arun-ssh-pub-pub.id]

  connection {
    type     = "ssh"
    user     = "root"
    private_key = file("${var.ssh_private_key_file}/id_rsa")
    host     = "${digitalocean_droplet.droplet-1.ipv4_address}"
  }

  provisioner remote-exec {
    inline = [
      "sed -i 's/CODESERVER_DOMAIN/code-server.${digitalocean_droplet.droplet-1.ipv4_address}.nip.io/' /etc/nginx/sites-available/code-server.conf",
      "sed -i 's/CODESERVER_PASSWORD/${var.CODESERVER_PASSWORD}/' /etc/systemd/system/code-server.service",
      "systemctl daemon-reload",
      "systemctl restart code-server.service",
      "systemctl restart nginx"
    ]
  }

}
