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
