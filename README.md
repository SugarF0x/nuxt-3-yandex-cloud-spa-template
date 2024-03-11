# Nuxt 3 SPA + Yandex Cloud Template

Nuxt 3 Yandex cloud deployment template in SPA mode, serverless functions and YDB instance.
I use it myself for my own side projects but any feedback to improve the template is appreciated

## Development

1. Define 3 environment variable files as displayed in the `/env` examples
2. Install dependencies `yarn` 
3. Run `yarn terraform apply`
4. Run dev `yarn dev`

This will create your stack you defined in `/env`. Consider it production, 
though I would recommend having different sets of `.env` files for actual production and development

## Deployment

Running `yarn terraform apply` creates: 

* Bucket: set to a web-site host with SSL certificated defined in `.env` attached
* Cloud function: empty function that will be updated on deploy
* API Gateway: forward every path of `/api/*` to the server; the rest - to the bucket (SSL included)
* DNS Record: forward every specified bucket id request to API gateway
* Managed YDB: instande with an empty read-to-use users table

To deploy run `yarn bd` to build and deploy both front-end and back-end, or run these separately:

```bash
yarn build
yarn deploy
# or separately
yarn deploy:frontend
yarn deploy:backend
```

## Contributions

Any contribution is welcome 
