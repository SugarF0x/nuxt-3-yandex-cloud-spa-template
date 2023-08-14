source ./.env.cloud

# inject env variables into the template
IFS=''
while read line; do eval echo \"$line\"; done < yc.api-gateway.yaml > yc.api-gateway.temp.yaml

yc serverless api-gateway update --id "$API_GATEWAY_ID" --spec=yc.api-gateway.temp.yaml

rm yc.api-gateway.temp.yaml
