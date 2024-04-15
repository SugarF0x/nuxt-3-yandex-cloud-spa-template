resource "yandex_lockbox_secret" "secrets" {
  name        = var.LOCKBOX_NAME
  description = "${var.LOCKBOX_NAME} secrets"
  folder_id   = var.FOLDER_ID
}

resource "yandex_lockbox_secret_version" "secrets_version" {
  depends_on = [
    yandex_lockbox_secret.secrets
  ]

  secret_id = yandex_lockbox_secret.secrets.id

  for_each = { for tuple in regexall("(.*)=(.*)", file("../env/.env.local")) : tuple[0] => tuple[1] }

  entries {
    key        = each.key
    text_value = each.value
  }
}
