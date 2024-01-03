# Nuxt 3 SPA + Yandex Cloud Template

Nuxt 3 Yandex cloud deployment template in SPA mode, serverless functions and YDB instance.
I use it myself for my own side projects but any feedback to improve the template is appreciated

## Development

1. Define 4 environment variable files as displayed in the `/env` examples
2. Run `yarn terraform apply`
3. Install dependencies `yarn` 
4. Run dev `yarn dev`

This will create your stack you defined in `/env`. Consider it production, 
though I would recommend having different sets of `.env` files for actual production and development

## Deployment

Running `yarn terraform apply` creates bucket and cloud function instance, yet both are at the time empty.

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
