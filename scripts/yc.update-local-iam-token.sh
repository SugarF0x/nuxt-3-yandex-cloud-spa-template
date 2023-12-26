TOKEN=$(yc iam create-token)

cat env/.env.local | sed 's/\(YDB_ACCESS_TOKEN_CREDENTIALS=\)\(.*\)/\1'"$TOKEN"'/' > env/.env.local.updated
rm env/.env.local
mv env/.env.local.updated env/.env.local
