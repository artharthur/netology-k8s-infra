resource "random_password" "garage_ct_root" {
  length           = 20
  special          = true
  override_special = "_-"
}

resource "proxmox_virtual_environment_container" "garage" {
  node_name     = var.target_node
  vm_id         = 150
  description   = "Garage S3 backend for Terraform state"
  tags          = ["terraform", "garage", "bootstrap"]
  unprivileged  = true
  start_on_boot = true
  started       = true
  timeout_create = 120

  cpu {
    cores = 1
  }

  memory {
    dedicated = 512
    swap      = 512
  }

  disk {
    datastore_id = var.lxc_datastore
    size         = 8
  }

  operating_system {
    template_file_id = var.lxc_template
    type             = "debian"
  }

  initialization {
    hostname = "garage"

    dns {
      servers = ["192.168.1.1", "1.1.1.1"]
    }

    ip_config {
      ipv4 {
        address = var.garage_ip
        gateway = var.garage_gateway
      }
    }

    user_account {
      keys     = [trimspace(file(pathexpand(var.ssh_public_key_path)))]
      password = random_password.garage_ct_root.result
    }
  }

  network_interface {
    name   = "eth0"
    bridge = "vmbr0"
  }
}

output "garage_container_ip" {
  value = split("/", var.garage_ip)[0]
}
