variable "YC_ZONE" { type = string }
variable "TOKEN" { type = string }
variable "ACCESS_KEY" { type = string }
variable "SECRET_KEY" { type = string }
variable "DNS_ZONE_ID" { type = string }
variable "S3_BUCKET_ID" { type = string }
variable "SSL_CERTIFICATE_ID" { type = string }
variable "SERVICE_ACCOUNT_ID" { type = string }
variable "FUNCTION_NAME" { type = string }

terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"
}

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

resource "yandex_function" "cloud-function" {
  name               = var.FUNCTION_NAME
  description        = "${var.S3_BUCKET_ID} api cloud function"
  user_hash          = "any_user_defined_string"
  runtime            = "nodejs16"
  entrypoint         = "index.handler"
  memory             = "128"
  execution_timeout  = "3"
  service_account_id = var.SERVICE_ACCOUNT_ID
}

resource "yandex_api_gateway" "api-gateway" {
  depends_on = [
    yandex_function.cloud-function
  ]

  name = var.S3_BUCKET_ID
  description = "${var.S3_BUCKET_ID} API gateway"

  spec = <<-EOT
openapi: "3.0.0"
info:
  version: 1.0.0
  title: Test API
servers:
  - url: https://${var.S3_BUCKET_ID}
paths:
  /:
    get:
      x-yc-apigateway-integration:
        type: object_storage
        bucket: ${var.S3_BUCKET_ID}
        object: index.html
  /{file+}:
    get:
      x-yc-apigateway-integration:
        type: object_storage
        bucket: ${var.S3_BUCKET_ID}
        object: '{file}'
        error_object: index.html
      parameters:
        - explode: false
          in: path
          name: file
          required: true
          schema:
            type: string
          style: simple
  /api/{slug+}:
    x-yc-apigateway-any-method:
      parameters:
        - name: slug
          in: path
      x-yc-apigateway-integration:
        type: cloud_functions
        payload_format_version: '1.0'
        function_id: ${yandex_function.cloud-function.id}
        service_account_id: ${var.SERVICE_ACCOUNT_ID}
EOT
}
