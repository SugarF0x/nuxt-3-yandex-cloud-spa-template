source ./env/.env.cloud

# inject env variables into the template
IFS=''
while read line; do eval echo \"$line\"; done < ./scripts/yc.api-gateway.yaml > ./scripts/yc.api-gateway.temp.yaml

yc serverless api-gateway update --id "$API_GATEWAY_ID" --spec=scripts/yc.api-gateway.temp.yaml

rm ./scripts/yc.api-gateway.temp.yaml
