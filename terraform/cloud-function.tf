resource "yandex_function" "cloud-function" {
  depends_on = [
    yandex_lockbox_secret_version.secrets_version
  ]

  service_account_id = var.SERVICE_ACCOUNT_ID
  name               = var.FUNCTION_NAME
  description        = "${var.FUNCTION_NAME} api cloud function"
  user_hash          = "any_user_defined_string"
  runtime            = "nodejs18"
  entrypoint         = "index.handler"
  memory             = "128"
  execution_timeout  = "3"
  folder_id          = var.FOLDER_ID
  environment        = fileexists("../env/.env.rollup") ? { for tuple in regexall("(.*)=(.*)", file("../env/.env.rollup")) : tuple[0] => tuple[1] } : null

  content {
    zip_filename = fileexists("../.output/temp/server.zip") ? "../.output/temp/server.zip" : "../server/dummy.zip"
  }

  dynamic "secrets" {
    for_each = yandex_lockbox_secret_version.secrets_version.entries
    # keys are there as defined in resource, WebStorm argues they are not :shrug:
    content {
      environment_variable = secrets.value.key
      key                  = secrets.value.key
      id                   = yandex_lockbox_secret_version.secrets_version.secret_id
      version_id           = yandex_lockbox_secret_version.secrets_version.id
    }
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
