provider "google" {
  project = var.project_id
  region  = "southamerica-east1"
}

resource "google_compute_instance" "kafka_instance" {
  count = var.broker_count
  name  = "kafka-instance-${count.index}"

  machine_type = "e2-standard-2"
  zone         = "southamerica-east1-a"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-12"
    }
  }

  network_interface {
    access_config {

    }
    subnetwork = "default"
  }

  scheduling {
    preemptible        = true
    provisioning_model = "SPOT"
    automatic_restart  = false
  }

  metadata = {
    "enable-oslogin" = "TRUE"
  }
}

locals {
  ips = { for instance in google_compute_instance.kafka_instance : instance.name => {
    external_ip = instance.network_interface[0].access_config[0].nat_ip,
    internal_ip = instance.network_interface[0].network_ip
    }
  }
}

output "ip-addresses" {
  value = local.ips
}
