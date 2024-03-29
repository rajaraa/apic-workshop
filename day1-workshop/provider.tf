terraform {
  required_version = "> 1.7.0"
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "3.0.2"
    }
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

provider "docker" {
  host = "unix:///var/run/docker.sock"
}

provider "digitalocean" {
  token = var.do_token
}

provider "local" {
  # Configuration options
}

# Pulls the image
resource "docker_image" "fortune-image" {
  name = "chukmunnlee/fortune:${var.image_version}"
}

# Create a container
resource "docker_container" "fortune-container" {
  count = var.instance_count
  name  = "fortune-container-${count.index}"
  image = docker_image.fortune-image.image_id
  ports {
    internal = var.container_port
  }
}

output "fortune_container_ports" {
  description = "Output Ports"
  value = [
    for p in docker_container.fortune-container[*].ports : "external port = ${p[0].external}"
  ]
}
