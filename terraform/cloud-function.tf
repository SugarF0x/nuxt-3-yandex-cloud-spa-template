# TODO: figure out how to pass env vars straight into here
resource "yandex_function" "cloud-function" {
  name               = var.FUNCTION_NAME
  description        = "${var.FUNCTION_NAME} api cloud function"
  user_hash          = "any_user_defined_string"
  runtime            = "nodejs18"
  entrypoint         = "index.handler"
  memory             = "128"
  execution_timeout  = "3"
  folder_id          = var.FOLDER_ID
  content {
    zip_filename = "../server/dummy.zip"
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
