data "digitalocean_ssh_key" "macbook-pub" {
  name = var.ssh_pub_key
}

resource "local_file" "nginx_config" {
  filename = "nginx.conf"
  content = templatefile("nginx.conf.tftpl", {
    container_ports = [
      for ports in docker_container.fortune-container[*].ports: ports[0].external
    ]
    docker_host_ip = var.docker_host_ip
  })
  file_permission = "0444"
}

resource "digitalocean_droplet" "practice-vm" {
  name     = "practice-vm"
  image    = var.image
  region   = var.region
  size     = var.size
  ssh_keys = [data.digitalocean_ssh_key.macbook-pub.id]

  connection {
    type     = "ssh"
    user     = "root"
    private_key = file("${var.ssh_private_key_file}/id_rsa")
    host     = "${digitalocean_droplet.droplet-1.ipv4_address}"
  }

  provisioner remote-exec {
    inline = [
      "apt update -y",
      "apt install -y nginx",
      "systemctl enable nginx",
      "systemctl start nginx",
    ]
  }

  provisioner "file" {
    source = "nginx.conf"
    destination = "/etc/nginx/nginx.confi"
    
  }

  provisioner remote-exec {
    inline = [
      "systemctl stop nginx",
      "systemctl start nginx"
    ]
  }

}

output "ssh_pub_fingerprint" {
  value = data.digitalocean_ssh_key.macbook-pub.fingerprint
}

output "ipv4_address" {
  value = digitalocean_droplet.droplet-1.ipv4_address
}

resource "local_file" "root_at_ip" {
  filename = "root@${digitalocean_droplet.droplet-1.ipv4_address}"
  content = ""
  file_permission = "0444"
}
