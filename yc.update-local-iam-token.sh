TOKEN=$(yc iam create-token)

cat .env.local | sed 's/\(YDB_ACCESS_TOKEN_CREDENTIALS=\)\(.*\)/\1'"$TOKEN"'/' > .env.local.updated
rm .env.local
mv .env.local.updated .env.local
