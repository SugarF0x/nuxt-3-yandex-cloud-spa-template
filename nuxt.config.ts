import { config } from 'dotenv'

const ENV_FILES = [
  process.env.NODE_ENV === 'production' ? 'prod' : 'local',
  'res'
]

for (const file of ENV_FILES) config({ path: `./env/.env.${file}` })

export default defineNuxtConfig({
  ssr: false,
  devtools: { enabled: true },
  typescript: { strict: true },
  experimental: { noVueServer: true },
  modules: [
    '@sidebase/nuxt-auth',
    'modules/prepare-for-yandex-functions'
  ],
  nitro: {
    prerender: {
      crawlLinks: false,
      routes: ['/']
    },
    preset: 'aws-lambda',
    rollupConfig: {
      output: { sourcemap: false }
    }
  },
  auth: {
    baseURL: process.env.AUTH_ORIGIN,
    provider: {
      addDefaultCallbackUrl: true,
      type: 'authjs'
    }
  },
})
