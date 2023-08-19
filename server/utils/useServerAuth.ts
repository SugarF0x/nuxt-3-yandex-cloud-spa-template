import { H3Event } from "h3"
import { getServerSession } from "#auth"

export default async function (event: H3Event) {
  const session = await getServerSession(event)
  if (!session) throw createError({ statusCode: 401, message: "Unauthorized" })

  return session
}
