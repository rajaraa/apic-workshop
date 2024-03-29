source digitalocean mydroplet {
    api_token = var.DO_token
    image = var.DO_image
    size = var.DO_size
    region = var.DO_region
    snapshot_name = var.snapshot_name
    ssh_username = "root"
}

build {
    sources = [ "source.digitalocean.mydroplet" ]

    provisioner ansible {
        playbook_file = "playbook.yaml"
        extra_arguments = [
          "--extra-vars",
          "code_server_archives=${var.code_server_archive} unpacked_directory=${var.unpacked_directory}"
        ]
        ansible_ssh_extra_args = [
        "-oHostKeyAlgorithms=+ssh-rsa", "-oPubkeyAcceptedKeyTypes=+ssh-rsa"
        ]
    }
}
