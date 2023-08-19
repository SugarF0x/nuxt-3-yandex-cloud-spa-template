import { Driver, getCredentialsFromEnv, Session } from 'ydb-sdk'

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
