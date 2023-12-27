source ./env/.env.token
source ./env/.env.keys
source ./env/.env.service-account
source ./env/.env.cloud

echo "

TF_VAR_TOKEN=$TOKEN
TF_VAR_ACCESS_KEY=$ACCESS_KEY
TF_VAR_SECRET_KEY=$SECRET_KEY
TF_VAR_SERVICE_ACCOUNT_ID=$SERVICE_ACCOUNT_ID

TF_VAR_YC_ZONE=$YC_ZONE
TF_VAR_S3_BUCKET_ID=$S3_BUCKET_ID
TF_VAR_SSL_CERTIFICATE_ID=$SSL_CERTIFICATE_ID
TF_VAR_DNS_ZONE_ID=$DNS_ZONE_ID

" >| ./env/.env.terraform
