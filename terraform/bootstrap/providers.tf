provider "proxmox" {
  endpoint  = var.proxmox_endpoint
  api_token = var.proxmox_api_token
  insecure  = var.proxmox_insecure

  # SSH нужен провайдеру для операций, которые API не покрывает
  # (например загрузка файлов, некоторые операции с LXC).
  ssh {
    agent = true
  }
}
