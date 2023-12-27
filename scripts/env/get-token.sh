if [ -f "./env/.env.token" ] && ! test $(find "./env/.env.token" -mmin +60)
then
  exit 0
fi

TOKEN=$(yc iam create-token)

echo "

TOKEN=$TOKEN

" >| ./env/.env.token
