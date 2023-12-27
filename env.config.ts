import { config } from 'dotenv'

const ENV_FILES = [
  process.env.NODE_ENV === 'production' ? 'prod' : 'local',
  'token',
  'cloud'
]

for (const file of ENV_FILES) config({ path: `./env/.env.${file}` })

if (process.env.NODE_ENV === 'production') {
  process.env.AUTH_ORIGIN = `https://${process.env.S3_BUCKET_ID}`
  process.env.NEXTAUTH_URL = `https://${process.env.S3_BUCKET_ID}`
} else {
  process.env.AUTH_ORIGIN = 'http://localhost:3000'
  process.env.NEXTAUTH_URL = 'http://localhost:3000'
  process.env.YDB_ACCESS_TOKEN_CREDENTIALS = process.env.TOKEN
}
