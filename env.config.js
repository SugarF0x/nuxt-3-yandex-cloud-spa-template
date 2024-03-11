import { config } from 'dotenv'
import { readFileSync, existsSync } from 'node:fs'

function prepare() {
  // TODO(template): possibly figure out a different handler for linux only local db instance
  if (!existsSync('./terraform/.terraform.lock.hcl')) throw new Error('TF lock does not exist. Run `yarn terraform init` first')
  if (!existsSync('./terraform/terraform.tfstate')) throw new Error('TF state does not exist. Run `yarn terraform apply` first')

  const { database_path, ydb_api_endpoint } = JSON.parse(readFileSync("./terraform/terraform.tfstate", 'utf-8')).resources.find(e => e.type === 'yandex_ydb_database_serverless').instances[0].attributes

  process.env.YDB_ENDPOINT = `grpcs://${ydb_api_endpoint}`
  process.env.YDB_DATABASE = database_path

  const ENV_FILES = [
    'local',
    'keys',
    'cloud'
  ]

  for (const file of ENV_FILES) config({ path: `./env/.env.${file}` })

  process.env.YDB_ACCESS_TOKEN_CREDENTIALS = process.env.TOKEN

  if (process.env.NODE_ENV === 'production') {
    process.env.AUTH_ORIGIN = `https://${process.env.S3_BUCKET_ID}`
    process.env.NEXTAUTH_URL = `https://${process.env.S3_BUCKET_ID}`
  } else {
    process.env.AUTH_ORIGIN = 'http://localhost:3000'
    process.env.NEXTAUTH_URL = 'http://localhost:3000'
  }
}

if (existsSync('./.nuxt')) prepare()
