// https://nuxt.com/docs/api/configuration/nuxt-config
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
