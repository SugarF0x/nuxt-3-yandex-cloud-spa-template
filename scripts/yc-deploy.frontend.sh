source ./env/.env.cloud

# sync directory by size only for each rebuild updates date and forces a re-sync of seemingly unchanged files
aws --profile yandex \
  s3 --endpoint-url=https://storage.yandexcloud.net \
  sync --size-only --delete ./.output/public s3://"$S3_BUCKET_ID"

# force update index for there might be contents change despite size remaining unchanged
aws --profile yandex \
  s3 --endpoint-url=https://storage.yandexcloud.net \
  cp ./.output/public/index.html s3://"$S3_BUCKET_ID"
