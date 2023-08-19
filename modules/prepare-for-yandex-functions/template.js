import { handler } from "./index.mjs"

async function wrapper(event, context) {
  if (event.body && event.isBase64Encoded) event.body = atob(event.body)
  if (context?.token?.access_token) process.env.YDB_ACCESS_TOKEN_CREDENTIALS = context.token.access_token

  const response = await handler(event, context)

  if (response.headers['set-cookie']) {
    response.multiValueHeaders ??= {}
    response.multiValueHeaders['set-cookie'] = response.headers['set-cookie'].split(/(.*?),(.*?)($|,(?! ))/).filter(Boolean)
    delete response.headers['set-cookie']
  }

  return response
}

export { wrapper as handler }
