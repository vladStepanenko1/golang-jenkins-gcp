terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "3.75.0"
    }
  }
}

provider "google" {
  project     = var.project_id
  region      = var.region
  zone        = var.zone
  credentials = file(var.credentials-file)
}

# public ip for jenkins master
resource "google_compute_address" "jenkins_master_ip_address" {
  name = "jenkins-master-ip"
}

# network for jenkins instances
resource "google_compute_network" "jenkins_network" {
  name = "jenkins-network"
}

# firewall
resource "google_compute_firewall" "jenkins_network_firewall" {
  name    = "jenkins-network-firewall"
  network = google_compute_network.jenkins_network.name

  allow {
    protocol = "tcp"
    ports    = ["8080", "22"]
  }

  source_ranges = ["0.0.0.0/0"]
}

# jenkins master instance
resource "google_compute_instance" "jenkins_master_vm" {
  name         = "jenkins-master"
  machine_type = var.jenkins-vm-machine-type
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = var.jenkins-vm-image
    }
  }

  network_interface {
    network = google_compute_network.jenkins_network.name
    access_config {
      nat_ip = google_compute_address.jenkins_master_ip_address.address
    }
  }

  allow_stopping_for_update = true
}