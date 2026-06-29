resource "random_password" "runner_root" {
  length           = 20
  special          = true
  override_special = "_-"
}

resource "proxmox_virtual_environment_container" "runner" {
  node_name      = var.target_node
  vm_id          = var.runner_node.vm_id
  description    = "GitHub Actions self-hosted runner (managed by Terraform)"
  tags           = ["terraform", "ci", "runner"]
  pool_id        = proxmox_virtual_environment_pool.project.pool_id
  unprivileged   = true
  start_on_boot  = true
  started        = true
  timeout_create = 180

  cpu {
    cores = var.runner_node.cores
  }

  memory {
    dedicated = var.runner_node.memory
    swap      = 512
  }

  disk {
    datastore_id = var.lxc_datastore
    size         = 10
  }

  operating_system {
    template_file_id = var.lxc_template
    type             = "debian"
  }

  initialization {
    hostname = var.runner_node.hostname

    dns {
      servers = ["1.1.1.1", "8.8.8.8"]
    }

    ip_config {
      ipv4 {
        address = var.runner_node.ip
        gateway = var.runner_node.gateway
      }
    }

    user_account {
      keys     = [trimspace(file(pathexpand(var.ssh_public_key_path)))]
      password = random_password.runner_root.result
    }
  }

  network_interface {
    name   = "eth0"
    bridge = var.runner_node.bridge
  }
}

output "runner_ip" {
  value = split("/", var.runner_node.ip)[0]
}
