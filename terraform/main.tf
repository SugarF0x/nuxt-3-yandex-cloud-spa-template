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
