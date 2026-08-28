// Expense Claims — three roles: Employee, Manager, Finance

screen MyClaims "Employee tracks their submitted claims and starts a new one"
  navbar "ExpenseFlow"
  sidebar "My Claims -> MyClaims | New Claim -> SubmitClaim"
  row
    heading "My Claims"
    right
    button "New claim" primary -> SubmitClaim
  tabs "All (12) | Pending (2) | Approved (7) | Rejected (3)"
  table "Category | Amount | Date | Status | Updated" -> ClaimDetail
    row "Travel | $214.50 | Aug 12 | Approved | 2d ago"
    row "Meals | $38.20 | Aug 20 | Pending | 6h ago"
    row "Supplies | $92.00 | Aug 18 | Rejected | 1d ago"

screen SubmitClaim "Employee submits a new expense claim"
  navbar "ExpenseFlow"
  sidebar "My Claims -> MyClaims | New Claim -> SubmitClaim"
  breadcrumb "My Claims / New claim"
  heading "New Expense Claim"
  row
    select "Category: Travel"
    input "Amount — e.g. 214.50"
  row
    input "Expense date"
    input "Currency: USD"
  textarea "What was this expense for?"
  input "Attach receipt (optional)"
  row
    right
    button "Cancel" -> MyClaims
    button "Submit claim" primary -> MyClaims

screen ClaimDetail "Employee reviews one claim's status and, if rejected, resubmits it"
  navbar "ExpenseFlow"
  sidebar "My Claims -> MyClaims | New Claim -> SubmitClaim"
  breadcrumb "My Claims / Supplies — $92.00"
  row
    heading "Supplies — $92.00"
    badge "Rejected" danger
  text "Submitted Aug 18 — decided Aug 19"
  split 60/40
    left
      heading "Details"
      text "Category: Supplies"
      text "Amount: $92.00 USD"
      text "Description: Replacement keyboard for shared desk"
      text "Receipt: keyboard-receipt.jpg"
    right
      card "Rejection reason"
        text "Manager · Aug 19: Missing itemized receipt — please reattach and resubmit."
      row
        right
        button "Resubmit corrected claim" primary -> SubmitClaim

screen ReviewQueue "Manager works through pending claims from their team"
  navbar "ExpenseFlow"
  sidebar "Review Queue -> ReviewQueue"
  row
    heading "Review Queue"
    right
    select "Team: All direct reports"
  row
    card "Pending | 8 | awaiting your decision"
    card "Approved this week | 14 | ready for export"
    card "Rejected this week | 2 | sent back for correction"
  table "Employee | Category | Amount | Submitted | Status" -> ClaimReview
    row "J. Alvarez | Travel | $214.50 | 2d ago | Pending"
    row "M. Diaz | Meals | $38.20 | 6h ago | Pending"
    row "R. Osei | Lodging | $310.00 | 1d ago | Pending"

screen ClaimReview "Manager approves or rejects one pending claim"
  navbar "ExpenseFlow"
  sidebar "Review Queue -> ReviewQueue"
  breadcrumb "Review Queue / Travel — $214.50"
  row
    heading "Travel — $214.50"
    badge "Pending" warning
  text "J. Alvarez — submitted 2d ago"
  split 60/40
    left
      heading "Details"
      text "Category: Travel"
      text "Amount: $214.50 USD"
      text "Description: Round-trip flight to client site"
      text "Receipt: flight-receipt.pdf"
    right
      card "Reject with a reason"
        textarea "Why is this claim being rejected?"
        button "Reject" danger
      row
        right
        button "Approve" primary -> ReviewQueue

screen ExportQueue "Finance selects approved claims and exports them to payroll"
  navbar "ExpenseFlow"
  sidebar "Export Queue -> ExportQueue | Export History -> ExportHistory"
  row
    heading "Export Queue"
    right
    button "Export selected" primary -> ExportHistory
  row
    card "Approved, unexported | 23 | across 9 employees"
    card "Total amount | $4,812.30 | ready for payroll"
  table "Employee | Category | Amount | Approved" -> ClaimDetail
    row "J. Alvarez | Travel | $214.50 | 2d ago"
    row "R. Osei | Lodging | $310.00 | 1d ago"
    row "K. Smith | Meals | $52.10 | 3d ago"

screen ExportHistory "Finance reviews past exports"
  navbar "ExpenseFlow"
  sidebar "Export Queue -> ExportQueue | Export History -> ExportHistory"
  heading "Export History"
  table "Export date | Claims | Total"
    row "Aug 26 | 23 | $4,812.30"
    row "Aug 12 | 19 | $3,905.00"

flow "Submit and track a claim"
  role "Employee"
  description "An employee submits a claim, checks its status, and resubmits if rejected"
  MyClaims
  SubmitClaim
  ClaimDetail

flow "Review team claims"
  role "Manager"
  description "A manager works the review queue and decides each pending claim"
  ReviewQueue
  ClaimReview

flow "Export to payroll"
  role "Finance"
  description "Finance exports approved claims and checks export history"
  ExportQueue
  ExportHistory
