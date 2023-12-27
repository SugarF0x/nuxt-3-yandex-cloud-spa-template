import { H3Event } from "h3"
import type { ZodObject } from "zod"
import { z } from "zod"

export async function getBodyPayload<T extends ZodObject<any>>(event: H3Event, schema: T): Promise<z.infer<T>> {
  const body = await readBody(event)
  const zod = schema.safeParse(body)
  if (!zod.success) throw createError({ statusCode: 400 })
  return zod.data
}

export function getQueryPayload<T extends ZodObject<any>>(event: H3Event, schema: T): z.infer<T> {
  const query = getQuery(event)
  const zod = schema.safeParse(query)
  if (!zod.success) throw createError({ statusCode: 400 })
  return zod.data
}
