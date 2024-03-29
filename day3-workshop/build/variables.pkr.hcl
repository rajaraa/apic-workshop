variable DO_token {
    type = string
    sensitive = true
}

variable DO_image {
    default = "ubuntu-20-04-x64"
}

variable DO_region {
    default = "sgp1"
}

variable DO_size {
    default = "s-1vcpu-2gb"
}

variable code_server_archive {
    default = "https://github.com/coder/code-server/releases/download/v4.22.1/code-server-4.22.1-linux-amd64.tar.gz"
}

variable unpacked_directory {
    default = "code-server-4.22.1-linux-amd64"
}

variable snapshot_name {
  type = string
  default = "mydroplet_snapshot"
}
