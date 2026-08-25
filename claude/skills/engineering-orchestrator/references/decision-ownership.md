# Decision Ownership Matrix v8

Ownership is based on **decision type**, not file extension.

| Decision | UI/UX owns | FE owns | BE owns |
|---|---:|---:|---:|
| user flow / information hierarchy | yes | no | no |
| table vs card/list | yes | no | no |
| drawer vs modal/page | yes | no | no |
| field order/grouping | yes | no | no |
| primary/secondary action hierarchy | yes | no | no |
| loading/empty/error UX behavior | yes | implements | no |
| responsive transformation | yes | implements mechanism | no |
| accessibility behavior | yes | implements semantics/focus/ARIA | no |
| theme visual semantics | yes | implements tokens/provider/persistence | no |
| copy meaning/tone | yes | implements translation bindings | no |
| feature/module/component ownership | no | yes | no |
| state/query/cache ownership | no | yes | no |
| API adapter/DTO mapping | no | yes | contract counterpart |
| i18n library/namespace/loading/formatting | no | yes | no |
| theme provider/CSS vars/hydration/storage | no | yes | no |
| controller/service/domain/repository | no | no | yes |
| exception/logging/transaction ownership | no | no | yes |

## Examples

`Mobile uses a structured list instead of the desktop 9-column table` -> UI/UX decision.

`UserMobileList lives under features/users and reuses useUsersQuery` -> FE decision.

`Delete opens a confirmation dialog and describes irreversibility` -> UI/UX decision.

`DELETE /users/:id is called through usersApi and invalidates users query` -> FE implementation decision.

A `.tsx` file may contain both concerns. The ownership still follows the decision type.
