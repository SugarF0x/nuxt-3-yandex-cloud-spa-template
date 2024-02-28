if [ -f "./env/.env.keys" ] && ! test $(find "./env/.env.keys" -mmin +60) && [ ! $1 == "--force" ]
then
  exit 0
fi

TOKEN=$(yc iam create-token)

cat env/.env.keys | sed 's/\(TOKEN=\)\(.*\)/\1'"$TOKEN"'/' > env/.env.keys.updated
rm env/.env.keys
mv env/.env.keys.updated env/.env.keys
