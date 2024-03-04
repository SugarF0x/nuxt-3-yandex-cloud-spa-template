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
