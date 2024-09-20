data "yandex_compute_image" "ubuntu" {
  family = var.family
}
resource "yandex_compute_instance" "platform" {
  count       = var.yandex_compute_instance.count
  name        = "netology-develop-platorm-${count.index + 1}"
  platform_id = var.yandex_compute_instance.platform_id
  depends_on  = [yandex_compute_instance.each_vm]

  resources {
    cores         = var.yandex_compute_instance.cores
    memory        = var.yandex_compute_instance.memory
    core_fraction = var.yandex_compute_instance.core_fraction
  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
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
    ssh-keys           = "ubuntu:${var.metadata.ssh-keys}"
  }
}
