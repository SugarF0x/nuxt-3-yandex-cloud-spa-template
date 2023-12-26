import { nodeResolve } from "@rollup/plugin-node-resolve"
import commonjs from '@rollup/plugin-commonjs'
import json from '@rollup/plugin-json'

export default {
  input: './.output/server/index.js',
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
