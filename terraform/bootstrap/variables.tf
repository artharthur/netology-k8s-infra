variable "proxmox_endpoint" {
  description = "URL API Proxmox VE"
  type        = string
}

variable "proxmox_api_token" {
  description = "API-токен в формате 'user@realm!tokenid=secret'"
  type        = string
  sensitive   = true
}

variable "proxmox_insecure" {
  description = "Пропускать проверку TLS-сертификата (self-signed на homelab)"
  type        = bool
  default     = true
}

variable "target_node" {
  description = "Имя ноды Proxmox для размещения ресурсов"
  type        = string
  default     = "homelab"
}

variable "lxc_template" {
  description = "Шаблон LXC (volid в Proxmox storage)"
  type        = string
  default     = "local:vztmpl/debian-12-standard_12.12-1_amd64.tar.zst"
}

variable "lxc_datastore" {
  description = "Хранилище для корневого диска контейнеров"
  type        = string
  default     = "local-lvm"
}

variable "minio_ip" {
  description = "Статический IP контейнера MinIO (CIDR)"
  type        = string
  default     = "192.168.1.150/24"
}

variable "minio_gateway" {
  description = "Шлюз сети (роутер)"
  type        = string
  default     = "192.168.1.1"
}

variable "minio_root_user" {
  description = "MinIO root user (логин админа)"
  type        = string
  sensitive   = true
}

variable "minio_root_password" {
  description = "MinIO root password (мин. 8 символов)"
  type        = string
  sensitive   = true
}

variable "ssh_public_key_path" {
  description = "Путь к публичному SSH-ключу для доступа в контейнеры"
  type        = string
  default     = "~/.ssh/id_rsa.pub"
}

variable "proxmox_ssh_password" {
  description = "Root-пароль ноды Proxmox для SSH-операций, недоступных API-токену"
  type        = string
  sensitive   = true
}
