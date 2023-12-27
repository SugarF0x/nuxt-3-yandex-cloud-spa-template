if [ -f "./env/.env.keys" ]
then
  exit 0
fi

ACCESS_KEY=$(aws --profile yandex configure get aws_access_key_id)
SECRET_KEY=$(aws --profile yandex configure get aws_secret_access_key)

echo "

ACCESS_KEY=$ACCESS_KEY
SECRET_KEY=$SECRET_KEY

" >| ./env/.env.keys
