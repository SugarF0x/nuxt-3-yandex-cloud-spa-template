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
