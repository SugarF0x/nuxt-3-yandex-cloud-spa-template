import { TypedValues } from "ydb-sdk"
import { omitBy } from "lodash-es"

export default function (params: Record<string, TypedValues | undefined>): Record<string, TypedValues> {
  return omitBy(params, param => !param) as Record<string, TypedValues>
}
