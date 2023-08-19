import { defineNuxtModule } from "@nuxt/kit"
import { rmSync, existsSync, copyFileSync } from "fs"

export default defineNuxtModule({
  hooks: {
    'close': (nuxt) => {
      if (process.env.NODE_ENV !== 'production') return
      if (!existsSync('./.output/server/node_modules')) return

      rmSync('./.output/server/node_modules', { recursive: true, force: true })
      rmSync('./.output/server/package.json')

      copyFileSync('./modules/prepare-for-yandex-functions/template.js', './.output/server/index.js')
    }
  }
})
