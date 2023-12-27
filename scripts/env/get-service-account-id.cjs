const { readFileSync, writeFileSync } = require('node:fs')
const { relative } = require('node:path')

const id = JSON.parse(readFileSync(relative(__dirname, ".yc/key.json"), 'utf-8')).service_account_id
writeFileSync("./env/.env.service-account", `SERVICE_ACCOUNT_ID=${id}`)
