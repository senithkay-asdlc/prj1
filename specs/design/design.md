# prj1 — Expense Claims — Design

A single-page web app (`expense-webapp`) gives Employees, Managers, and Finance
role-scoped views onto one backend service (`expense-api`), which owns expense
claims end to end: submission, manager approval/rejection, and finance's export
to a payroll-ready file. Claim data and audit fields live in `expense-db`;
receipt attachments live in `receipt-storage`; status-change emails go out
through an external email provider. Every user signs in through Thunder.

## Context (C1)

```mermaid
graph TD
  Employee((Employee))
  Manager((Manager))
  Finance((Finance))
  System[prj1 — Expense Claims]
  Thunder[Thunder Identity Provider]
  Email[Email Provider]

  Employee -->|submits & tracks claims| System
  Manager -->|approves / rejects claims| System
  Finance -->|exports approved claims| System
  System -->|sign-in / tokens| Thunder
  System -->|status-change emails| Email
```

## Domain model (ER)

```mermaid
erDiagram
  EMPLOYEE {
    string id
    string name
    string email
    string role
    string managerId
  }
  EXPENSE_CLAIM {
    string id
    string employeeId
    string category
    decimal amount
    string currency
    date expenseDate
    string description
    string receiptUrl
    string status
    string rejectionReason
    datetime submittedAt
    datetime decidedAt
    datetime exportedAt
  }

  EMPLOYEE ||--o{ EXPENSE_CLAIM : "submits"
  EMPLOYEE ||--o{ EMPLOYEE : "manages"
```

`status` is one of `submitted`, `approved`, `rejected`, `exported`. A claim
moves `submitted -> approved -> exported`, or `submitted -> rejected -> submitted` (on resubmission, with a fresh `submittedAt` and cleared
`rejectionReason`). `role` is one of `employee`, `manager`, `finance`.

## Key flows

### Submit, approve, reject

```mermaid
sequenceDiagram
  actor Employee
  actor Manager
  participant WebApp as expense-webapp
  participant API as expense-api
  participant DB as expense-db
  participant Storage as receipt-storage
  participant Email as Email Provider

  Employee->>WebApp: Fill claim form (+ optional receipt)
  WebApp->>API: POST /expense-claims
  API->>Storage: store receipt (if attached)
  API->>DB: insert claim (status=submitted)
  API-->>WebApp: 201 Created

  Manager->>WebApp: Open review queue
  WebApp->>API: GET /expense-claims?status=submitted
  API->>DB: query pending claims for team
  API-->>WebApp: claim list

  Manager->>WebApp: Approve or reject (+ reason)
  WebApp->>API: POST /expense-claims/{id}/approve|reject
  API->>DB: update status (+ rejectionReason)
  API->>Email: send status-change email
  API-->>WebApp: 200 OK
```

### Export to payroll

```mermaid
sequenceDiagram
  actor Finance
  participant WebApp as expense-webapp
  participant API as expense-api
  participant DB as expense-db

  Finance->>WebApp: Open export screen
  WebApp->>API: GET /expense-claims?status=approved
  API->>DB: query approved, unexported claims
  API-->>WebApp: claim list

  Finance->>WebApp: Export selected claims
  WebApp->>API: POST /expense-claims/export
  API->>DB: mark claims status=exported, set exportedAt
  API-->>WebApp: downloadable CSV file
```