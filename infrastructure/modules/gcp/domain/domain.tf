resource "google_dns_managed_zone" "my_domain" {
  name     = "${var.project}-zone"
  dns_name = "at4nyu.net."

  timeouts {
    create = null
    delete = null
    update = null
  }
}

resource "google_dns_record_set" "api_domain" {
  name = "${var.project}.api.${google_dns_managed_zone.my_domain.dns_name}"
  type = "A"
  ttl  = 300

  managed_zone = google_dns_managed_zone.my_domain.name

  rrdatas = [var.elb_ip_tmp]
}

resource "google_compute_managed_ssl_certificate" "api_domain_ssl_cert" {
  name = "${var.project}-cert"

  managed {
    domains = ["${var.project}.api.${google_dns_managed_zone.my_domain.dns_name}"]
  }
}

output "ssl_cert_id" {
  value = google_compute_managed_ssl_certificate.api_domain_ssl_cert.id
}

output "domain_name" {
  value = google_dns_record_set.api_domain.name
}
