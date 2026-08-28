# prj1 — PRD

## Problem Statement

Employees pay for business expenses out of pocket and have no consistent way to submit them for reimbursement. Managers approve spending informally over email or chat, with no record of what was approved. Finance has to manually chase approved amounts and re-key them into payroll, which is slow and error-prone.

## Solution

A shared expense-claim system where employees submit claims with the details a manager needs to judge them, managers approve or reject those claims in one place, and finance exports the approved, unexported claims as a file ready to feed into payroll — removing the manual chasing and re-keying.

## Actors

- **Employee** — submits expense claims, tracks their status, and can resubmit a corrected claim after rejection.
- **Manager** — reviews the claims submitted by their team and approves or rejects each one.
- **Finance** — views approved claims awaiting payroll, exports them to a file, and tracks which claims have already been exported.

## User Stories

1. As an Employee, I want to submit an expense claim with an amount, category, date, and description, so that my manager has what they need to decide on it.
2. As an Employee, I want to attach a receipt to my expense claim, so that my manager can verify the expense.
3. As an Employee, I want to view the status of my submitted claims, so that I know whether each one is pending, approved, or rejected.
4. As an Employee, I want to see why a claim was rejected and resubmit a corrected version, so that I can fix a mistake without starting over.
5. As a Manager, I want to see a queue of pending expense claims from my team, so that I can work through them.
6. As a Manager, I want to approve or reject a claim, so that only legitimate expenses move forward toward payroll.
7. As a Manager, I want to give a reason when I reject a claim, so that the employee understands what to fix.
8. As Finance, I want to see all approved claims that haven't been exported yet, so that I know what's ready for payroll.
9. As Finance, I want to export those approved claims to a downloadable file, so that I can load them into payroll.
10. As Finance, I want exported claims marked as exported, so that the same claim is never sent to payroll twice.

## Product Decisions

- Every user signs in via SSO through Thunder, the platform identity provider.
- Approval is single-level: a claim needs only its manager's approval before it is eligible for export — there is no separate finance sign-off step.
- Finance's export produces a downloadable file (e.g. CSV) formatted for upload into whatever payroll system the organization uses, rather than a live integration with a named payroll provider.
- The actor set is Employee, Manager, and Finance only — no separate Admin role.
- Expense claims use a fixed, predefined set of categories (e.g. Travel, Meals, Lodging, Supplies, Other) rather than free-text or per-organization configuration. *assumed*
- All claims are submitted in a single organization-wide currency; the system does not do multi-currency conversion. *assumed*
- Receipt attachment is optional on submission, not mandatory. *assumed*
- Employees and managers receive an email notification when a claim's status changes (approved or rejected). *assumed*
- An exported claim is locked from further edits or re-export; only rejected claims can be resubmitted. *assumed*

## Out of Scope

- Multi-level or multi-approver workflows (e.g. finance sign-off in addition to manager approval).
- Direct API integration with a specific payroll provider.
- Multi-currency support and currency conversion.
- Expense policy enforcement (e.g. spending limits, per-category caps) beyond simple manager approval.
- Admin-configurable categories, roles, or organizational structure.

## Open Questions

1. What fields and file format does the target payroll system expect from the export file? — deferred until a payroll system is named.

## Further Notes

None.