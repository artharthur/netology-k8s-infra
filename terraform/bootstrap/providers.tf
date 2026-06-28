provider "proxmox" {
  endpoint = var.proxmox_endpoint
  username = "root@pam"
  password = var.proxmox_ssh_password
  insecure = var.proxmox_insecure

  ssh {
    agent = true
  }
}
