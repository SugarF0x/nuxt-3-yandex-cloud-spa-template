import { H3Event } from "h3"
import type { ZodObject } from "zod"
import { z } from "zod"

export async function getBodyPayload<T extends ZodObject<any>>(event: H3Event, schema: T): Promise<z.infer<T>> {
  const body = await readBody(event)
  if (!schema.safeParse(body).success) throw createError({ statusCode: 400 })
  return body as z.infer<T>
}

export function getQueryPayload<T extends ZodObject<any>>(event: H3Event, schema: T): z.infer<T> {
  const query = getQuery(event)
  if (!schema.safeParse(query).success) throw createError({ statusCode: 400 })
  return query as z.infer<T>
}
