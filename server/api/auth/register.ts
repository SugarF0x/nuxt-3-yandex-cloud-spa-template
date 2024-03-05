import { TypedData, TypedValues } from "ydb-sdk"
import { z } from 'zod'

export default defineEventHandler(async (event) => {
  const { username, password } = await getBodyPayload(event, z.object({
    username: z.string().min(1),
    password: z.string().min(1),
  }))

  if (await doesUserAlreadyExist(username)) throw createError({ statusCode: 409 })

  await createUser(username, password)

  return true
})

async function doesUserAlreadyExist(username: string): Promise<boolean> {
  return await useYDBSession(async (session) => {
    const { resultSets } = await session.executeQuery(`
      DECLARE $username AS Utf8;
      
      SELECT COUNT(username) as count FROM users WHERE username = $username LIMIT 1;
    `, {
      "$username": TypedValues.utf8(username)
    })

    return Boolean(TypedData.createNativeObjects(resultSets[0])[0].count)
  })
}

async function createUser(username: string, password: string) {
  const { hash, salt, iterations } = await generateHashPassword(password)

  await useYDBSession(async (session) => {
    await session.executeQuery(`
      DECLARE $username AS Utf8;
      DECLARE $created_at AS Datetime;
      DECLARE $hash AS Utf8;
      DECLARE $salt AS Utf8;
      DECLARE $iterations AS Uint16;

      INSERT INTO users (username, created_at, hash, salt, iterations) 
      VALUES ($username, $created_at, $hash, $salt, $iterations);
    `, {
      "$username": TypedValues.utf8(username),
      "$created_at": TypedValues.datetime(new Date()),
      "$hash": TypedValues.utf8(hash),
      "$salt": TypedValues.utf8(salt),
      "$iterations": TypedValues.uint16(iterations),
    })
  })
}
