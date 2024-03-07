rm -rf ./.output/server/node_modules

# rollup server node modules to bypass YC CF dependency installation step
NODE_ENV=production rollup -c scripts/rollup.config.js

source ./env/.env.cloud

(cd ./.output/temp/server-to-zip && zip -r -X "../server.zip" .)

yc serverless function version create \
  --function-name="$FUNCTION_NAME" \
  --runtime nodejs18 \
  --entrypoint index.handler \
  --memory 128m \
  --execution-timeout 3s \
  --source-path ./.output/temp/server.zip \
  --environment=`paste -s -d, env/.env.rollup` \
  --service-account-id="$SERVICE_ACCOUNT_ID"

rm -rf ./.output/temp

