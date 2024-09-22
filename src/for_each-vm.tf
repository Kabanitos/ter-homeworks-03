################ Variavle for DB #####################
variable "each_vm" {
  type = map(object({
    cpu         = number
    memory      = number
    disk_volume = number

  }))
  default = {
    "main" = {
      cpu         = 4
      memory      = 2
      disk_volume = 15

    },
    "replica" = {
      cpu         = 2
      memory      = 1
      disk_volume = 10
    }
  }

}

data "yandex_compute_image" "ubuntu-each" {
  family = var.family
}
resource "yandex_compute_instance" "each_vm" {
  for_each    = var.each_vm
  name        = "netologu-vm-${each.key}"
  platform_id = var.yandex_compute_instance.platform_id

  resources {
    cores         = each.value.cpu
    memory        = each.value.memory
    core_fraction = var.yandex_compute_instance.core_fraction
  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
      size     = each.value.disk_volume
    }
  }
  scheduling_policy {
    preemptible = var.preemptible
  }
  network_interface {
    subnet_id          = yandex_vpc_subnet.develop.id
    security_group_ids = [yandex_vpc_security_group.example.id]
    nat                = var.nat

  }

  metadata = {
    serial-port-enable = var.metadata.serial-port-enable
    ssh-keys           = "ubuntu:${local.ssh}"
  }
}
