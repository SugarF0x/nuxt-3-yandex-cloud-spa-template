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
