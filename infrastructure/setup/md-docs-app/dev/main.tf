locals {
  ent        = "dev"
  project_id = "md-docs-dev"
  region     = "asia-northeast1"
}

terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.50.0"
    }
  }
  backend "gcs" {
    bucket = "md-docs-dev-terraform-bucket"
  }
}

provider "google" {
  project     = local.project_id
  region      = local.region
  credentials = file(var.credentials)
}

module "vpc" {
  source      = "../../../modules/gcp/vpc"
  base_region = "asia-northeast1"
  project     = var.project
}

module "domain" {
  source     = "../../../modules/gcp/domain"
  elb_ip_tmp = var.elb_ip_tmp
  project    = var.project
}

module "elb" {
  source               = "../../../modules/gcp/elb"
  elb_ip_tmp           = var.elb_ip_tmp
  base_region          = "asia-northeast1"
  oauth2_client_id     = var.oauth2_client_id
  oauth2_client_secret = var.oauth2_client_secret
  ssl_cert_id          = module.domain.ssl_cert_id
  project              = var.project
  domain_name          = module.domain.domain_name
}

module "cicd" {
  source  = "../../../modules/gcp/cicd"
  project = var.project
}
