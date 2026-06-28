variable "proxmox_endpoint" {
  type = string
}

variable "proxmox_ssh_password" {
  type      = string
  sensitive = true
}

variable "proxmox_insecure" {
  type    = bool
  default = true
}

variable "target_node" {
  type    = string
  default = "homelab"
}

variable "lxc_template" {
  type    = string
  default = "local:vztmpl/debian-12-standard_12.12-1_amd64.tar.zst"
}

variable "lxc_datastore" {
  type    = string
  default = "local-lvm"
}

variable "ssh_public_key_path" {
  type    = string
  default = "~/.ssh/id_rsa.pub"
}

variable "project_pool" {
  type    = string
  default = "shclopro-25"
}

# Описание нод k3s: id, имя, зона (бридж), IP, шлюз, ресурсы
variable "k3s_nodes" {
  type = map(object({
    vm_id    = number
    hostname = string
    bridge   = string
    ip       = string
    gateway  = string
    cores    = number
    memory   = number
  }))
  default = {
    server = {
      vm_id    = 210
      hostname = "k3s-server"
      bridge   = "vmbr10"
      ip       = "10.10.1.10/24"
      gateway  = "10.10.1.1"
      cores    = 2
      memory   = 2048
    }
    agent1 = {
      vm_id    = 211
      hostname = "k3s-agent-1"
      bridge   = "vmbr20"
      ip       = "10.10.2.10/24"
      gateway  = "10.10.2.1"
      cores    = 1
      memory   = 1536
    }
    agent2 = {
      vm_id    = 212
      hostname = "k3s-agent-2"
      bridge   = "vmbr30"
      ip       = "10.10.3.10/24"
      gateway  = "10.10.3.1"
      cores    = 1
      memory   = 1536
    }
  }
}
