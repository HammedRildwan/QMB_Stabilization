# Month-End Closing Process - User Guide

## Overview

The Month-End Closing module provides a structured, checklist-based approach to closing accounting periods. It ensures consistency, tracks progress, and provides an audit trail for compliance.

---

## Getting Started

### Prerequisites
- Finance & Admin Manager role assigned
- Access to the QMB Stab. Finance Admin RC Role Center
- Accounting periods must be set up in the system

### Accessing the Module

From the Role Center, you can access Month-End Closing through:
- **Navigation Menu** → Month-End Closing section
- **Actions** → Start Month-End Closing (quick access)

---

## Initial Setup (One-Time)

### Step 1: Create Checklist Templates

Before your first month-end closing, you need to set up the checklist templates:

1. Navigate to **Month-End Closing** → **Checklist Templates**
2. Click **Create Default Templates** to populate standard tasks
3. Review and customize the templates as needed:
   - Modify descriptions to match your specific processes
   - Adjust sequence numbers to change task order
   - Set responsible users for each task type
   - Enable/disable auto-validation where appropriate
   - Mark blocking tasks that must complete before others can start

### Template Fields Explained

| Field | Description |
|-------|-------------|
| **Code** | Unique identifier for the task |
| **Description** | What needs to be done |
| **Category** | Grouping (Pre-Closing, Bank Reconciliation, Reporting, etc.) |
| **Sequence No.** | Order in which tasks appear |
| **Auto-Validate** | System automatically checks if task is complete |
| **Validation Type** | What the system checks (e.g., No Open Expenses) |
| **Blocking** | Subsequent tasks wait until this completes |
| **Related Page/Report** | Quick link to relevant page or report |
| **Active** | Include this task in new closings |

---

## Monthly Closing Process

### Step 1: Create New Month-End Closing

1. Go to **Month-End Closing** → **Month-End Closings** → **New**
   - Or use the quick action: **Start Month-End Closing**
2. Select the **Accounting Period** to close
3. The system automatically populates:
   - Period Start Date
   - Period End Date
   - Fiscal Year
4. Click **Initialize Checklist** to create tasks from templates

> **Note:** The status changes from "Open" to "In Progress" after initialization.

### Step 2: Run Auto-Validations

Before starting manual work, let the system check what's already complete:

1. Click **Run Auto-Validations**
2. The system checks all tasks marked for auto-validation:
   - ✅ Tasks that pass are marked **Completed**
   - ❌ Tasks that fail show the issue in **Validation Result**
3. Review the Task Summary FactBox for progress overview

### Auto-Validation Types

| Validation Type | What It Checks |
|-----------------|----------------|
| No Open Expenses | No expense requests with status Open or Pending Approval for the period |
| No Open Requisitions | No store requisitions with status Open or Pending Approval for the period |
| No Pending Approvals | No open approval entries for the period |
| Bank Reconciled | No unposted bank reconciliations for the period |
| No Unposted Journals | No general journal lines with amounts |
| Inventory Adjusted | No unposted item journal lines |
| Trial Balance Balanced | G/L debits equal credits |

### Step 3: Work Through Tasks

For each task in the checklist:

1. Select the task row
2. Click **Start Task** to mark it "In Progress"
3. Use **Open Related Page** or **Run Related Report** to access relevant functionality
4. Perform the required work
5. Click **View Instructions** if you need guidance
6. When done, click **Complete Task**

#### Task Status Flow

```
Pending → In Progress → Completed
                    ↘ Skipped (non-blocking only)
```

#### Handling Blocked Tasks

If a task shows status **Blocked**:
- A previous blocking task is not yet complete
- Complete the blocking task first
- The blocked task will automatically become **Pending**

#### Skipping Tasks

Non-blocking tasks can be skipped if not applicable:
1. Select the task
2. Click **Skip Task**
3. Add a note explaining why (in the Notes field)

> **Important:** Blocking tasks cannot be skipped.

### Step 4: Track Progress

Monitor your progress using:

- **Progress Group** on the card:
  - Total Tasks
  - Completed Tasks
  - Blocked Tasks
  - Completion %

- **Task Summary FactBox**:
  - Overall progress
  - Remaining tasks by category

### Step 5: Complete the Closing

When all tasks are complete:

1. Review the checklist to ensure nothing is missed
2. Add any final comments in the Comments field
3. Click **Complete Closing**

The system validates:
- All required tasks are completed or skipped
- No tasks are pending or blocked

After completion:
- Status changes to **Completed**
- Completed Date and Completed By are recorded
- The closing is locked for editing

---

## Post-Closing Operations

### Viewing Historical Closings

1. Go to **Month-End Closings** list
2. Filter by Status, Period, or Fiscal Year
3. Click any row to view details

### Reopening a Closing

If corrections are needed after completion:

1. Open the completed closing
2. Click **Reopen**
3. Make necessary corrections
4. Complete the closing again

> **Note:** Reopening is tracked in the audit trail.

### Quick Reports from Closing Card

Access key reports directly from the closing card:
- **Trial Balance** - Verify balances
- **Income Statement** - Review P&L
- **Balance Sheet** - Check financial position

---

## Best Practices

### Before Month-End

1. **Process all transactions** - Post all approved expenses, requisitions, and returns
2. **Complete approvals** - Clear pending approval queue
3. **Reconcile sub-ledgers** - Ensure AR, AP, and inventory are reconciled

### During Closing

1. **Follow the sequence** - Complete blocking tasks before dependent tasks
2. **Document issues** - Use Notes field for any exceptions or problems
3. **Run validations often** - Re-run auto-validations after making corrections
4. **Review validation results** - Don't ignore failed validations

### After Closing

1. **Archive reports** - Save PDF copies of key reports
2. **Review completion** - Verify all tasks show Completed or Skipped
3. **Update templates** - Add new tasks discovered during the process

---

## Troubleshooting

### "Cannot complete closing" Error

**Cause:** There are incomplete tasks.

**Solution:**
1. Check the Task Summary FactBox for pending/blocked counts
2. Filter tasks by Status to find incomplete items
3. Complete or skip remaining tasks

### Auto-Validation Keeps Failing

**Cause:** Open documents exist for the period.

**Solution:**
1. Check the Validation Result column for details
2. Click **Open Related Page** to view the open items
3. Process or void the open documents
4. Run auto-validations again

### Task is Blocked

**Cause:** A previous blocking task is incomplete.

**Solution:**
1. Look for tasks with earlier sequence numbers
2. Find tasks marked as Blocking = Yes
3. Complete those tasks first
4. The blocked task will automatically unblock

### Cannot Delete a Closing

**Cause:** Completed closings are protected.

**Solution:**
1. Reopen the closing first
2. Then delete if needed (only Open or In Progress status)

---

## Checklist Template Default Tasks

The following tasks are created by the **Create Default Templates** action:

### Pre-Closing (PRE-xxx)
- Review open documents for the period
- Process all pending expense requests *(Auto)*
- Process all pending store requisitions *(Auto)*
- Complete all pending approvals *(Auto)*

### Bank Reconciliation (BANK-xxx)
- Reconcile all bank accounts *(Auto)*
- Post bank reconciliations

### Expense Processing (EXP-xxx)
- Review expense postings to G/L

### Inventory (INV-xxx)
- Post inventory adjustments *(Auto)*
- Run inventory valuation report

### Accruals & Deferrals (ACC-xxx)
- Review and post accruals
- Review and post deferrals

### Journals (JNL-xxx)
- Post all general journal entries *(Auto)*

### Reporting (RPT-xxx)
- Print Trial Balance
- Verify Trial Balance is balanced *(Auto)*
- Print Income Statement
- Print Balance Sheet
- Review Budget vs. Actual

### Final Review (FIN-xxx)
- Finance Manager final review
- Sign-off and close period

*(Auto)* = Task has auto-validation enabled

---

## Customizing Templates

### Adding a New Task

1. Open **Checklist Templates**
2. Press Ctrl+N to insert new row
3. Enter:
   - **Code**: Unique identifier (e.g., CUSTOM-001)
   - **Description**: Clear action statement
   - **Category**: Select appropriate category
   - **Sequence No.**: Where it should appear (10, 20, 30...)
4. Set other properties as needed
5. Ensure **Active** is checked

### Disabling a Task

To exclude a task from future closings without deleting it:
1. Open the template
2. Uncheck **Active**
3. The task won't appear in new closings

### Modifying Sequence

To reorder tasks:
1. Change **Sequence No.** values
2. Use gaps (10, 20, 30) to allow future insertions

---

## Security Considerations

| Action | Recommended Permission |
|--------|----------------------|
| Create new closing | Finance Manager |
| Initialize checklist | Finance Manager |
| Complete individual tasks | Finance Team |
| Run auto-validations | Finance Team |
| Complete closing | Finance Manager |
| Reopen closing | Finance Manager |
| Modify templates | Administrator |

---

## Support

For assistance with the Month-End Closing process:
1. Review this user guide
2. Check the **Instructions** field for specific tasks
3. Contact your system administrator for template changes
4. Report issues through your IT helpdesk

---

*Document Version: 1.0*  
*Last Updated: March 2026*  
*Module: QMB Stabilization - Month-End Closing*
