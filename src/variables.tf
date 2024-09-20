###cloud vars
variable "token" {
  type        = string
  description = "OAuth-token; https://cloud.yandex.ru/docs/iam/concepts/authorization/oauth-token"
}

variable "cloud_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/cloud/get-id"
}

variable "folder_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/folder/get-id"
}

variable "default_zone" {
  type        = string
  default     = "ru-central1-a"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}
variable "default_cidr" {
  type        = list(string)
  default     = ["10.0.1.0/24"]
  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
}

variable "vpc_name" {
  type        = string
  default     = "develop"
  description = "VPC network&subnet name"
}

variable "family" {
  type        = string
  default     = "ubuntu-2004-lts"
  description = "OS name"
}

variable "yandex_compute_instance" {
  type = object({
    count         = number
    platform_id   = string
    cores         = number
    memory        = number
    core_fraction = number
  })
  default = {
    count         = 2
    platform_id   = "standard-v1"
    cores         = 2
    memory        = 1
    core_fraction = 5
  }

}

variable "preemptible" {
  type        = bool
  default     = true
  description = "Прерывание"
}

variable "nat" {
  type        = bool
  default     = true
  description = "Включить NAT"
}

variable "metadata" {
  type = object({
    serial-port-enable = number
    ssh-keys           = string
  })
  default = {
    serial-port-enable = 1
    ssh-keys           = "~/.ssh/id_rsa.pub"
  }

}


