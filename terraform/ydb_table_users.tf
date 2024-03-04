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
