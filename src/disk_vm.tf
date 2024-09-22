variable "disk" {
  type = object({
    type  = string
    count = number
    size  = number
    zone  = string
  })
  default = {
    type  = "network-hdd"
    count = 3
    size  = 1
    zone  = "ru-central1-a"
  }

}

variable "storage-vm" {
  type = object({
    name_vm       = string
    cpu           = number
    memory        = number
    core_fraction = number
  })
  default = {
    name_vm       = "storage"
    cpu           = 2
    memory        = 1
    core_fraction = 5
  }
}


resource "yandex_compute_disk" "hdd" {
  count = var.disk.count
  name  = "disk-${count.index}"
  type  = var.disk.type
  size  = var.disk.size
  zone  = var.disk.zone
}

resource "yandex_compute_instance" "storage" {
  name        = var.storage-vm.name_vm
  platform_id = var.yandex_compute_instance.platform_id

  resources {
    cores         = var.storage-vm.cpu
    memory        = var.storage-vm.memory
    core_fraction = var.storage-vm.core_fraction
  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
    }
  }



  dynamic "secondary_disk" {
    for_each = yandex_compute_disk.hdd
    content {
      disk_id = secondary_disk.value.id
    }

  }
  scheduling_policy {
    preemptible = var.preemptible
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat       = var.nat

  }

  metadata = {
    serial-port-enable = var.metadata.serial-port-enable
    ssh-keys           = "ubuntu:${local.ssh}"
  }
}
