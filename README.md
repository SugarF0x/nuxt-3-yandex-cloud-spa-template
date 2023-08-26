# Nuxt 3 SPA + Yandex Cloud Template

Nuxt 3 Yandex cloud deployment template with SPA mode, serverless functions 

## Development

1. Define 3 environment variable files as displayed in the root examples: `.env.cloud`, `.env.local` and `.env.prod`
2. Setup YC IAM cli profile (needed for deployment and working with non-local YDB instance)
3. Install dependencies and run `yarn dev`

## Deployment

You can deploy to bucket, cloud functions and API Gateway individually or combined with `yarn deploy`.
You can also run `yarn bd` to build and deploy right after.
You need, however, `.env.prod` to be defined for this.

## Contributions

Any issue and/or pull request is a welcome one
