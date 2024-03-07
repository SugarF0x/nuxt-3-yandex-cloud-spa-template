import "../env.config.js"
import { writeFileSync } from "node:fs"
import { pick, compact } from "lodash-es"
import { nodeResolve } from "@rollup/plugin-node-resolve"
import commonjs from '@rollup/plugin-commonjs'
import json from '@rollup/plugin-json'

const bundledVars = Object.entries(pick(process.env, compact(`
  AUTH_SECRET
  AUTH_ORIGIN
  NEXTAUTH_URL
  YDB_SDK_PRETTY_LOGS
  YDB_ENDPOINT
  YDB_DATABASE
`.split('\n').map(e => e.trim())))).map(e => e.join('=')).join('\n')
writeFileSync('./env/.env.rollup', bundledVars)

export default {
  input: './.output/server/index.mjs',
  output: {
    dir: '.output/temp/server-to-zip',
    format: 'cjs'
  },
  plugins: [
    nodeResolve({
      preferBuiltins: true,
      exportConditions: ["node"]
    }),
    commonjs(),
    json()
  ],
}
