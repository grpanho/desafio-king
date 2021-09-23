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

  metadata_startup_script = "yum install python3 -y; yum update -y; setenforce 0"

  network_interface {
    network = "default"

    access_config {} // Grant an external ip address
  }

  tags = ["gitlab"]
}

resource "google_compute_disk" "storage_gitlab" {
  name = "gitlab-disk-${random_id.instance_id.hex}"
  type = "pd-balanced"
  zone = "us-west1-a"
  size = 25

  lifecycle {
    prevent_destroy = true
  }
}

resource "google_compute_attached_disk" "att_gitlab_disk" {
  device_name = "gitlab_storage"
  disk        = google_compute_disk.storage_gitlab.id
  instance    = google_compute_instance.gitlab.id
  mode        = "READ_WRITE"
}

resource "google_compute_firewall" "gitlab_fw" {
  name    = "allow-gitlab-access-${random_id.instance_id.hex}"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["80", "443", "22", "2222"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["gitlab"]
}

output "ip" {
  value = google_compute_instance.gitlab.network_interface.0.access_config.0.nat_ip
}

resource "null_resource" "ansible-run" {

  provisioner "local-exec" {
    command = "echo '${google_compute_instance.gitlab.network_interface.0.access_config.0.nat_ip}' > .ansible-host"
  }
}