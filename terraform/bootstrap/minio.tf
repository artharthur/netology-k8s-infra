resource "random_password" "minio_ct_root" {
  length           = 20
  special          = true
  override_special = "_-"
}

resource "proxmox_virtual_environment_container" "minio" {
  node_name     = var.target_node
  vm_id         = 150
  description   = "MinIO S3 backend for Terraform state (managed by Terraform)"
  tags          = ["terraform", "minio", "bootstrap"]
  unprivileged  = true
  start_on_boot = true
  started       = true

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
    hostname = "minio"

    dns {
      servers = ["192.168.1.1", "1.1.1.1"]
    }

    ip_config {
      ipv4 {
        address = var.minio_ip
        gateway = var.minio_gateway
      }
    }

    user_account {
      keys     = [trimspace(file(var.ssh_public_key_path))]
      password = random_password.minio_ct_root.result
    }
  }

  network_interface {
    name   = "eth0"
    bridge = "vmbr0"
  }
}

output "minio_container_ip" {
  description = "IP контейнера MinIO"
  value       = split("/", var.minio_ip)[0]
}
