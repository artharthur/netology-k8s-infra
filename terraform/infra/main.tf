# ── Пароль root для контейнеров (не хардкодим) ──
resource "random_password" "ct_root" {
  for_each         = var.k3s_nodes
  length           = 20
  special          = true
  override_special = "_-"
}

# ── Проектный пул ──
resource "proxmox_virtual_environment_pool" "project" {
  pool_id = var.project_pool
  comment = "Дипломный проект k8s (managed by Terraform)"
}

# ── Ноды k3s по зонам доступности ──
resource "proxmox_virtual_environment_container" "k3s" {
  for_each = var.k3s_nodes

  node_name      = var.target_node
  vm_id          = each.value.vm_id
  description    = "k3s ${each.key} (managed by Terraform)"
  tags           = ["terraform", "k3s", each.key]
  pool_id        = proxmox_virtual_environment_pool.project.pool_id
  unprivileged   = true
  start_on_boot  = true
  started        = true
  timeout_create = 180

  cpu {
    cores = each.value.cores
  }

  memory {
    dedicated = each.value.memory
    swap      = 512
  }

  disk {
    datastore_id = var.lxc_datastore
    size         = 12
  }

  # k3s требует включённого nesting для работы контейнерного рантайма
  features {
    nesting = true
    keyctl  = true
  }

  operating_system {
    template_file_id = var.lxc_template
    type             = "debian"
  }

  initialization {
    hostname = each.value.hostname

    dns {
      servers = ["1.1.1.1", "8.8.8.8"]
    }

    ip_config {
      ipv4 {
        address = each.value.ip
        gateway = each.value.gateway
      }
    }

    user_account {
      keys     = [trimspace(file(pathexpand(var.ssh_public_key_path)))]
      password = random_password.ct_root[each.key].result
    }
  }

  network_interface {
    name   = "eth0"
    bridge = each.value.bridge
  }
}

output "k3s_nodes" {
  description = "Ноды k3s: имя → IP"
  value = {
    for k, node in var.k3s_nodes : node.hostname => split("/", node.ip)[0]
  }
}
