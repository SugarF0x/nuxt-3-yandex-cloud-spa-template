export interface UserTableRow {
  username: string
  created_at: Date
  hash: string
  iterations: number
  salt: string
}
