resource "yandex_ydb_database_serverless" "ydb" {
  name      = var.YDB_NAME
  folder_id = var.FOLDER_ID

  deletion_protection = false
}
