import "next-auth"
import "next-auth/jwt"

type User = {
  username: string
}

// TODO: figure this out since this is obviously not working as intended

declare module "next-auth" {
  export type User = User
  export interface Session {
    user: User
  }
}

declare module "next-auth/jwt" {
  export interface JWT {
    user: User
  }
}

declare global {
  namespace inspector {
    interface Session {
      user: User
    }
  }
}
