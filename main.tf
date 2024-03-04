variable "YC_ZONE" { type = string }
variable "TOKEN" { type = string }
variable "ACCESS_KEY" { type = string }
variable "SECRET_KEY" { type = string }
variable "DNS_ZONE_ID" { type = string }
variable "S3_BUCKET_ID" { type = string }
variable "SSL_CERTIFICATE_ID" { type = string }
variable "SERVICE_ACCOUNT_ID" { type = string }
variable "FOLDER_ID" { type = string }
variable "FUNCTION_NAME" { type = string }
variable "YDB_NAME" { type = string }
variable "GATEWAY_NAME" { type = string }

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

  bucket   = var.S3_BUCKET_ID
  acl      = "public-read"
  max_size = 104857600

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

# TODO: figure out how to pass env vars straight into here
resource "yandex_function" "cloud-function" {
  name               = var.FUNCTION_NAME
  description        = "${var.FUNCTION_NAME} api cloud function"
  user_hash          = "any_user_defined_string"
  runtime            = "nodejs16"
  entrypoint         = "index.handler"
  memory             = "128"
  execution_timeout  = "3"
  folder_id          = var.FOLDER_ID
  content {
    zip_filename = "./server/dummy.zip"
  }
}

resource "yandex_function_iam_binding" "function-iam" {
  depends_on = [
    yandex_function.cloud-function
  ]

  function_id = yandex_function.cloud-function.id
  role        = "serverless.functions.invoker"

  members = [
    "system:allUsers",
  ]
}

resource "yandex_ydb_database_serverless" "ydb" {
  name      = var.YDB_NAME
  folder_id = var.FOLDER_ID

  deletion_protection = false
}

resource "yandex_api_gateway" "api-gateway" {
  depends_on = [
    yandex_function.cloud-function
  ]

  folder_id = var.FOLDER_ID

  name        = var.GATEWAY_NAME
  description = "${var.GATEWAY_NAME} API gateway"

  custom_domains {
    fqdn = var.S3_BUCKET_ID
    certificate_id = var.SSL_CERTIFICATE_ID
  }

  spec = <<-EOT
openapi: 3.0.0
info:
  version: 1.0.0
  title: ${var.GATEWAY_NAME} API
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

resource "yandex_dns_recordset" "website_record" {
  depends_on = [
    yandex_api_gateway.api-gateway
  ]

  zone_id = var.DNS_ZONE_ID
  name    = "${var.S3_BUCKET_ID}."
  type    = "ANAME"
  ttl     = 600
  data    = [yandex_api_gateway.api-gateway.domain]
}

resource "yandex_ydb_table" "users" {
  depends_on = [
    yandex_ydb_database_serverless.ydb
  ]

  path = "users"
  connection_string = yandex_ydb_database_serverless.ydb.ydb_full_endpoint

  column {
    name = "username"
    type = "Utf8"
    not_null = true
  }

  column {
    name = "created_at"
    type = "Datetime"
  }

  column {
    name = "hash"
    type = "Utf8"
  }

  column {
    name = "iterations"
    type = "Uint16"
  }

  column {
    name = "salt"
    type = "Utf8"
  }

  primary_key = ["username"]
}
