// TODO: make ydb instance optional (1. might not need it; 2. allow sharing pre existing ones based on directory prefix)

resource "yandex_ydb_database_serverless" "ydb" {
  name      = var.YDB_NAME
  folder_id = var.FOLDER_ID

  deletion_protection = false
}
