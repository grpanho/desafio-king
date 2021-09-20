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

  metadata_startup_script = ""

  network_interface {
    network = "default"

    access_config {// Grant an external ip address
    
    }
  }

  output "ip" {
  value = google_compute_instance.gitlab.network_interface.0.network_ip
}
}