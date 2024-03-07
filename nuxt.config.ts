import './env.config'

export default defineNuxtConfig({
  ssr: false,
  devtools: { enabled: true },
  typescript: { strict: true },
  experimental: { noVueServer: true },
  modules: ['@sidebase/nuxt-auth'],
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
