terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"
}

variable "YC_ZONE" { type = string }
variable "TOKEN" { type = string }
variable "ACCESS_KEY" { type = string }
variable "SECRET_KEY" { type = string }
variable "DNS_ZONE_ID" { type = string }
variable "S3_BUCKET_ID" { type = string }
variable "SSL_CERTIFICATE_ID" { type = string }

provider "yandex" {
  zone    = var.YC_ZONE
  token   = var.TOKEN
  profile = "yandex"
}

resource "yandex_storage_bucket" "website_bucket" {
  access_key = var.ACCESS_KEY
  secret_key = var.SECRET_KEY

  bucket                = var.S3_BUCKET_ID
  acl                   = "public-read"
  default_storage_class = "DEFAULT"
  max_size              = 104857600

  website {
    index_document = "index.html"
    error_document = "error.html"
  }

  anonymous_access_flags {
    read        = true
    list        = false
    config_read = false
  }

  https {
    certificate_id = var.SSL_CERTIFICATE_ID
  }
}

resource "yandex_dns_recordset" "website_record" {
  zone_id = var.DNS_ZONE_ID
  name    = "${var.S3_BUCKET_ID}."
  type    = "ANAME"
  ttl     = 600
  data    = ["${var.S3_BUCKET_ID}.website.yandexcloud.net"]
}
