resource "google_compute_region_network_endpoint_group" "api_neg" {
  name                  = "${var.project}-neg"
  network_endpoint_type = "SERVERLESS"
  region                = var.base_region
  cloud_run {
    service = "md-docs-api-dev"
  }
  timeouts {
    create = null
    delete = null
  }
}

resource "google_compute_region_network_endpoint_group" "frontend_neg" {
  name                  = "${var.project}-frontend-neg"
  network_endpoint_type = "SERVERLESS"
  region                = var.base_region
  cloud_run {
    service = "md-docs-frontend-dev"
  }
  timeouts {
    create = null
    delete = null
  }
}

resource "google_compute_security_policy" "api_backend_service_security_policy" {
  description = "Default security policy for: md-docs-dev-be"
  name        = "security-policy-for-backend-service-${var.project}-be"
  type        = "CLOUD_ARMOR"

  rule {
    action   = "allow"
    preview  = false
    priority = 2147483647

    match {
      versioned_expr = "SRC_IPS_V1"

      config {
        src_ip_ranges = [
          "*",
        ]
      }
    }
  }

  rule {
    action      = "throttle"
    description = "Default rate limiting rule"
    preview     = false
    priority    = 2147483646

    match {
      versioned_expr = "SRC_IPS_V1"

      config {
        src_ip_ranges = [
          "*",
        ]
      }
    }

    rate_limit_options {
      ban_duration_sec = 0
      conform_action   = "allow"
      enforce_on_key   = "IP"
      exceed_action    = "deny(403)"

      rate_limit_threshold {
        count        = 500
        interval_sec = 60
      }
    }
  }

  timeouts {}
}

resource "google_compute_backend_service" "api_backend_service" {
  name                            = "${var.project}-be"
  protocol                        = "HTTPS"
  load_balancing_scheme           = "EXTERNAL_MANAGED"
  locality_lb_policy              = "ROUND_ROBIN"
  connection_draining_timeout_sec = 0
  security_policy                 = google_compute_security_policy.api_backend_service_security_policy.id

  backend {
    group = google_compute_region_network_endpoint_group.api_neg.id
  }

  # iap設定は手動で行う必要あり
  iap {
    oauth2_client_id     = var.oauth2_client_id
    oauth2_client_secret = var.oauth2_client_secret
  }

  timeouts {}
}

resource "google_compute_backend_service" "frontend_backend_service" {
  name                            = "${var.project}-frontend-be"
  protocol                        = "HTTPS"
  load_balancing_scheme           = "EXTERNAL_MANAGED"
  locality_lb_policy              = "ROUND_ROBIN"
  connection_draining_timeout_sec = 0
  security_policy                 = google_compute_security_policy.api_backend_service_security_policy.id

  backend {
    group = google_compute_region_network_endpoint_group.frontend_neg.id
  }

  # iap設定は手動で行う必要あり
  iap {
    oauth2_client_id     = var.oauth2_client_id
    oauth2_client_secret = var.oauth2_client_secret
  }

  timeouts {}
}

resource "google_compute_url_map" "api_url_map" {
  name            = "${var.project}-lb"
  default_service = google_compute_backend_service.frontend_backend_service.id

  host_rule {
    hosts        = [var.domain_name]
    path_matcher = "${var.project}-path-matcher"
  }

  path_matcher {
    name            = "${var.project}-path-matcher"
    default_service = google_compute_backend_service.frontend_backend_service.id

    path_rule {
      paths   = ["/api/*"]
      service = google_compute_backend_service.api_backend_service.id
    }
  }
}

resource "google_compute_target_https_proxy" "api_https_proxy" {
  name             = "${var.project}-lb-target-proxy"
  url_map          = google_compute_url_map.api_url_map.id
  ssl_certificates = [var.ssl_cert_id]

  timeouts {}
}

resource "google_compute_global_forwarding_rule" "api_forwarding_rule" {
  project               = var.project
  name                  = "${var.project}-fe"
  target                = google_compute_target_https_proxy.api_https_proxy.id
  ip_address            = var.elb_ip_tmp
  ip_protocol           = "TCP"
  ip_version            = "IPV4"
  port_range            = "443-443"
  load_balancing_scheme = "EXTERNAL_MANAGED"
}
