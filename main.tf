provider "google" {
  credentials = file("credentials.json")
  project     = "desafio-infra"
  region      = "us-west1"
}

// Terraform plugin for creating random ids
resource "random_id" "instance_id" {
  byte_length = 8
}

resource "google_compute_instance" "gitlab" {
  name         = "gitlab-${random_id.instance_id.hex}"
  machine_type = "n2-standard-2"
  zone         = "us-west1-a"

  metadata = {
    ssh-keys = "gabriel_panho:${file("~/.ssh/id_rsa.pub")}"
  }

  boot_disk {
    initialize_params {
      image = "centos-cloud/centos-7"
    }
  }

  metadata_startup_script = "yum update -y && yum install python3 -y; sed -i 's/enforcing/permissive/g' /etc/selinux/config && reboot"

  network_interface {
    network = "default"

    access_config {} // Grant an external ip address
  }
}

resource "google_compute_disk" "storage_gitlab" {
  name = "gitlab-disk"
  type = "pd-balanced"
  zone = "us-west1-a"
  size = 25
}

resource "google_compute_attached_disk" "att_gitlab_disk" {
  device_name = "gitlab_storage"
  disk        = google_compute_disk.storage_gitlab.id
  instance    = google_compute_instance.gitlab.id
  mode        = "READ_WRITE"
}

output "ip" {
  value = google_compute_instance.gitlab.network_interface.0.access_config.0.nat_ip
}