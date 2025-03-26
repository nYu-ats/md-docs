resource "google_compute_network" "vpc" {
  name                    = "${var.project}-network"
  auto_create_subnetworks = false
  routing_mode            = "REGIONAL"
  mtu                     = 1460
}

resource "google_compute_subnetwork" "default" {
  name          = "${var.project}-subnetwork"
  ip_cidr_range = var.default_subnet_cidr
  network       = google_compute_network.vpc.id
  region        = var.base_region
}

resource "google_compute_subnetwork" "proxy_only_subnet" {
  name          = "${var.project}-proxy-only-subnetwork"
  ip_cidr_range = var.default_proxy_only_subnet_cidr
  network       = google_compute_network.vpc.id
  region        = var.base_region
  purpose       = "REGIONAL_MANAGED_PROXY"
  role          = "ACTIVE"

  timeouts {
    create = null
    delete = null
    update = null
  }
}
