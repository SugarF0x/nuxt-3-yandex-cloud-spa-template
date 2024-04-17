rm -rf ./.output/server/node_modules

# rollup server node modules to bypass YC CF dependency installation step
NODE_ENV=production rollup -c scripts/rollup.config.js

(cd ./.output/temp/server-to-zip && zip -r -X "../server.zip" .)
yarn terraform apply -auto-approve -target=yandex_function.cloud-function

rm -rf ./.output/temp

