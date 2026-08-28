# prj1 — Security design

## Roles → permissions

A Manager sees only claims submitted by employees whose `managerId` is their
own id. Finance's view is org-wide and scoped to `status = approved`. An
Employee's view is scoped to claims they submitted themselves. No role can see
or act outside its own scope — an Employee cannot approve, a Manager cannot
export, and Finance cannot approve.

## Authentication (Thunder)

Every user signs in through Thunder via SSO. Both `expense-webapp` and
`expense-api` declare the same `user-auth` dependency (`thunder-app`), which is
what ties the SPA's sign-in to the tokens it attaches on every API call.
Scopes: `openid profile email` (default). `expense-webapp` is the only
component on the sign-in (SPA) side; `expense-api` is the only protected
backend — there is no other service to wire.

## Role resolution

`expense-api` resolves a caller's business role by looking up the Employee
record whose id matches the token's subject claim in `expense-db`; that record
carries `role` (`employee` | `manager` | `finance`) and, for approval routing,
`managerId`. A token that resolves to no Employee record is denied (401) —
there is no default role. An authenticated caller attempting an action outside
their role's row above receives 403.