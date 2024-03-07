import { NuxtAuthHandler } from "#auth"
import CredentialsProvider from 'next-auth/providers/credentials'
import { User, Session } from "next-auth"
import { JWT } from "next-auth/jwt"
import { TypedData, TypedValues } from "ydb-sdk"
import { PersistedPassword, verifyPassword } from "~/server/utils/passwordManagement"
import { z } from "zod"

// @ts-expect-error You need to use .default here for it to work during SSR. May be fixed via Vite at some point
const Provider = CredentialsProvider.default ?? CredentialsProvider

export default NuxtAuthHandler({
  secret: process.env.AUTH_SECRET ?? 'fallback-dev-secret',
  providers: [
    Provider({
      name: 'Credentials',
      credentials: {
        username: { label: 'Username', type: 'text' },
        password: { label: 'Password', type: 'password' }
      },
      async authorize(credentials: Record<string, unknown>): Promise<User | null> {
        const payload = validateCredentials(credentials)
        if (!payload) return null
        const { username, password } = payload

        const persistedPassword = await useYDBSession(async (session) => {
          const { resultSets } = await session.executeQuery(`
            DECLARE $username AS Utf8;

            SELECT * FROM users WHERE username = $username LIMIT 1;
          `, {
            "$username": TypedValues.utf8(username)
          })

          return TypedData.createNativeObjects(resultSets[0])[0] as unknown as PersistedPassword
        })

        if (!persistedPassword || !(await verifyPassword(persistedPassword, password))) return null

        return { username: credentials.username }
      }
    })
  ],
  callbacks: {
    async jwt({ token, user }: { token: JWT, user: User }){
      if (user) token.user = user
      return token
    },
    async session({ token, session }): Promise<Session> {
      return { ...session, user: token.user }
    }
  },
  pages: {
    signIn: '/login'
  }
})

function validateCredentials(credentials: Record<string, unknown>) {
  const CredentialsSchema = z.object({
    username: z.string().min(1),
    password: z.string().min(1),
  })

  if (!CredentialsSchema.safeParse(credentials).success) return null
  return credentials as z.infer<typeof CredentialsSchema>
}
