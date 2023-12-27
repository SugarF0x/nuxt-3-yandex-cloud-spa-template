import { Driver, getCredentialsFromEnv, Session, TypedData, TypedValues } from "ydb-sdk"

export default async function <T = unknown>(callback: (session: Session) => Promise<T>) {
  const driver = new Driver({
    endpoint: process.env.YDB_ENDPOINT,
    database: process.env.YDB_DATABASE,
    authService: getCredentialsFromEnv()
  })

  if (!await driver.ready(10000)) throw new Error('Establishing YDB connection timed out')

  const result = await driver.tableClient.withSession(callback)

  await driver.destroy()

  return result
}

export async function ydbGet<T>(session: Session, query: string, params: Record<string, TypedValues | undefined>): Promise<T[]> {
  const { resultSets } = await session.executeQuery(query , filterOptionalQueryParams(params))
  return TypedData.createNativeObjects(resultSets[0]) as T[]
}

export async function ydbPost(session: Session, query: string, params: Record<string, TypedValues | undefined>): Promise<void> {
  await session.executeQuery(query , filterOptionalQueryParams(params))
  return
}
