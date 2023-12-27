export $(grep -v '^#' ./env/.env.terraform | xargs)
