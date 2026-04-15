# Plan: BC-Native POS Module (Cash Sales)

## Status: ✅ IMPLEMENTED

## TL;DR
Build a lightweight Point-of-Sale module directly in Business Central to bypass LS Central sync issues. Uses Sales Invoice posting for real-time inventory, supports cash payments only initially, with keyboard wedge barcode scanning. Single location with multiple cashpoints. Future-ready for ECR/Payment Terminal integration.

---

## Implementation Summary

### Phase 1: Enums & Tables ✅
- 4 Enums: POSTransactionStatus, POSPaymentMethod, POSShiftStatus, POSBusinessSection
- 8 Tables: POS Setup, Terminal, Shift, Transaction Header/Line, Payment Entry, Archive, Role Center Cue

### Phase 2: Codeunits ✅
- POS Transaction Mgt. (50640) - Cart operations, item lookup, payment processing
- POS Posting (50641) - Sales Invoice creation and posting
- POS Shift Mgt. (50642) - Shift lifecycle management

### Phase 3: Checkout UI ✅
- 10 Pages: Checkout, Cart Subform, Payment Dialog, Shift Management, Transaction List/Card, etc.

### Phase 4: Cashier Role Center ✅
- Profile: POS Cashier
- Role Center with shift info, quick actions, transaction cues

### Phase 5: Manager Role Center ✅
- Profile: POS Manager
- Section-specific activity cues (Hypermart, Restaurant, Bar, Laundromat)
- Overall summary and administration access

### Phase 6: Reports ✅
- POS Transaction Report (50650)
- POS Shift Report (50651)
- POS Sales by Section Report (50652)

---

## Object ID Allocation (50600-50699 reserved for POS)

### Enums (50680-50683)
| ID | Object Name | Purpose |
|----|-------------|---------|
| 50680 | POS Transaction Status | Open, Paid, Posted, Voided |
| 50681 | POS Payment Method | Cash, Card, Voucher, Mobile Money, Bank Transfer |
| 50682 | POS Shift Status | Open, Closed, Suspended |
| 50683 | POS Business Section | Hypermart, Restaurant, Bar, Laundromat |

### Tables (50600-50607)
| ID | Object Name | Purpose |
|----|-------------|---------|
| 50600 | POS Setup | Global POS configuration |
| 50601 | POS Terminal | Terminal/cashpoint registration |
| 50602 | POS Shift | Shift management |
| 50603 | POS Transaction Header | Current cart/transaction |
| 50604 | POS Transaction Line | Cart line items |
| 50605 | POS Payment Entry | Payment records |
| 50606 | POS Transaction Archive | Posted transactions |
| 50607 | POS Role Center Cue | Section-specific cues |

### Codeunits (50640-50642)
| ID | Object Name | Purpose |
|----|-------------|---------|
| 50640 | POS Transaction Mgt. | Cart operations, payment processing |
| 50641 | POS Posting | Create & post Sales Invoice |
| 50642 | POS Shift Mgt. | Open/close shifts |

### Pages (50620-50641)
| ID | Object Name | PageType | Purpose |
|----|-------------|----------|---------|
| 50620 | POS Setup | Card | Configure POS settings |
| 50621 | POS Terminal List | List | Manage terminals |
| 50622 | POS Terminal Card | Card | Terminal configuration |
| 50623 | POS Checkout | Card | **Main checkout screen** |
| 50624 | POS Cart Subform | ListPart | Cart line items |
| 50625 | POS Payment Dialog | StandardDialog | Payment entry |
| 50626 | POS Shift Management | Card | Shift open/close |
| 50627 | POS Void Reason Dialog | StandardDialog | Void reason entry |
| 50628 | POS Shift FactBox | CardPart | Shift info display |
| 50629 | POS Float Entry | StandardDialog | Opening float entry |
| 50630 | POS Transaction List | List | Transaction history |
| 50631 | POS Transaction Card | Card | Transaction details |
| 50632 | POS Payment Subform | ListPart | Payment entries |
| 50633 | POS Cashier Role Center | RoleCenter | Cashier home |
| 50634 | POS Cashier Activities | CardPart | Cashier cues |
| 50635 | POS Manager Role Center | RoleCenter | Manager home |
| 50636 | POS Manager Activities | CardPart | Manager summary |
| 50638 | POS Hypermart Activities | CardPart | Hypermart cues |
| 50639 | POS Restaurant Activities | CardPart | Restaurant cues |
| 50640 | POS Bar Activities | CardPart | Bar cues |
| 50641 | POS Laundromat Activities | CardPart | Laundromat cues |

### Reports (50650-50652)
| ID | Object Name | Purpose |
|----|-------------|---------|
| 50650 | POS Transaction Report | Transaction receipt/details |
| 50651 | POS Shift Report | End of day shift summary |
| 50652 | POS Sales by Section Report | Sales by business section |

### Profiles
| Name | Role Center |
|------|-------------|
| POS Cashier | POS Cashier Role Center |
| POS Manager | POS Manager Role Center |
| ID | Object Name | Purpose |
|----|-------------|---------|
| 50660 | POS Receipt | Thermal receipt format |
| 50661 | POS Shift Summary | End-of-shift report (X/Z report) |
| 50662 | POS Daily Sales | Daily sales summary by section |
| 50663 | POS Section Comparison | Sales comparison across Hypermart/Restaurant/Bar/Laundromat |
| 50664 | POS Variance Report | Cash variance by shift/terminal |

### Enums (50680-50684)
| ID | Object Name | Values |
|----|-------------|--------|
| 50680 | POS Transaction Status | Open, Paid, Posted, Voided |
| 50681 | POS Payment Method | Cash, Card (future), Voucher (future) |
| 50682 | POS Shift Status | Open, Closed, Suspended |
| 50683 | POS Business Section | Hypermart, Restaurant, Bar, Laundromat |

### Profiles
| Name | Caption | RoleCenter |
|------|---------|------------|
| QMBSTAB-CASHIER | QMB Stabilization Cashier | POS Cashier Role Center (50628) |
| QMBSTAB-POSMGR | QMB Stabilization POS Manager | POS Manager Role Center (50630) |

---

## BC Standard Integration

### Pricing Integration (Sales Price Table)
The POS module leverages BC's standard pricing engine:

```
Pricing Lookup Hierarchy:
1. Sales Price (table 7002) - Customer Price Group specific
2. Sales Line Discount (table 7004) - Line-level discounts
3. Item."Unit Price" - Fallback default

Configuration:
- POS Setup → Default Customer Price Group (e.g., "RETAIL", "RESTAURANT")
- POS Terminal → Override Customer Price Group per section
- Customer record → Assigned Customer Price Group

GetUnitPrice(ItemNo, CustomerPriceGroup, UOM, Qty) → Decimal
  → Use Sales Price codeunit (7000) for standard lookup
  → Respects: Starting/Ending Dates, Minimum Qty, Currency
```

**Setup Requirements:**
- Create Customer Price Groups: HYPERMART, RESTAURANT, BAR, LAUNDROMAT
- Assign Items to price lists per group
- Create "Cash Customer" records per section with appropriate price group

### Inventory Integration (Standard BC Controls)
The POS module respects all standard BC inventory settings:

```
Item Card Settings Used:
- Item."Costing Method" (FIFO, LIFO, Average, Standard, Specific)
- Item."Item Tracking Code" (Lot, Serial, Expiration)
- Item."Reorder Point" / "Reorder Quantity"
- Item."Negative Adj." (blocked/allowed)
- Item."Stockout Warning" (enabled/disabled)

Inventory Setup Settings Respected:
- "Location Mandatory"
- "Expected Cost Posting to G/L"
- "Automatic Cost Posting"
- "Average Cost Calc. Type"

Location Card Settings:
- "Bin Mandatory"
- "Require Pick" / "Require Shipment"
- "Use As In-Transit"

POS Behavior:
- CheckInventoryAvailable(ItemNo, LocationCode, Qty) → Boolean
  → Uses Item."Inventory" - Reserved - On Sales Order
  → Respects Inventory Setup."Prevent Negative Inventory"
  → Shows warning if below Reorder Point
```

**Setup Requirements:**
- Configure Inventory Setup for real-time costing
- Set Location Code per POS Terminal
- Configure Item Cards with appropriate tracking and costing

---

## Table Designs

### Table 50600: POS Setup
```
Fields:
- Primary Key (Code[10])
- Default Location Code (Code[10]) → Location table
- Cash Payment Account (Code[20]) → G/L Account
- Sales Invoice Nos. (Code[20]) → No. Series (use existing Sales series)
- Receipt Nos. (Code[20]) → No. Series for POS receipts
- Require Shift Open (Boolean) - default TRUE
- Default Cashier Dimension (Code[20]) → Dimension Value
- Business Section Dimension (Code[20]) → Dimension - for section tracking

// Section-Specific Defaults (Customer + Price Group per section)
- Hypermart Customer No. (Code[20]) → Customer
- Hypermart Customer Price Group (Code[10]) → Customer Price Group
- Restaurant Customer No. (Code[20]) → Customer
- Restaurant Customer Price Group (Code[10]) → Customer Price Group
- Bar Customer No. (Code[20]) → Customer
- Bar Customer Price Group (Code[10]) → Customer Price Group
- Laundromat Customer No. (Code[20]) → Customer
- Laundromat Customer Price Group (Code[10]) → Customer Price Group
```

### Table 50601: POS Terminal
```
Fields:
- Terminal ID (Code[10]) - PK
- Name (Text[50])
- Location Code (Code[10]) → Location
- Business Section (Enum "POS Business Section") - Hypermart/Restaurant/Bar/Laundromat
- Customer Price Group (Code[10]) → Customer Price Group - section-specific pricing
- Default Customer No. (Code[20]) → Customer - section's cash customer
- Active (Boolean)
- Current Shift No. (Code[20]) → POS Shift (active shift)
- Assigned User ID (Code[50]) → User Setup
- Receipt Printer Name (Text[100]) - for future
- Last Transaction No. (Code[20])
- Dimension 1 Code (Code[20]) → Dimension Value - auto-set from Business Section
```

### Table 50602: POS Shift
```
Fields:
- Shift No. (Code[20]) - PK
- Terminal ID (Code[10]) → POS Terminal
- User ID (Code[50])
- Opening DateTime (DateTime)
- Closing DateTime (DateTime)
- Opening Float (Decimal)
- Expected Cash (Decimal) - calculated
- Declared Cash (Decimal) - user input at close
- Variance (Decimal) - Expected - Declared
- Status (Enum "POS Shift Status")
- Total Sales (Decimal) - FlowField sum
- Transaction Count (Integer) - FlowField count
```

### Table 50603: POS Transaction Header
```
Fields:
- Transaction No. (Code[20]) - PK, No. Series
- Terminal ID (Code[10]) → POS Terminal
- Shift No. (Code[20]) → POS Shift
- Customer No. (Code[20]) → Customer
- Customer Name (Text[100])
- Transaction Date (Date)
- Transaction Time (Time)
- Status (Enum "POS Transaction Status")
- Subtotal (Decimal) - FlowField sum of lines
- Discount Amount (Decimal)
- Total Amount (Decimal) - Subtotal - Discount
- Paid Amount (Decimal) - FlowField sum of payments
- Change Amount (Decimal) - Paid - Total
- Salesperson Code (Code[20])
- Location Code (Code[10])
- Posted Invoice No. (Code[20]) - link to Sales Invoice
- Void Reason (Text[250])
```

### Table 50604: POS Transaction Line
```
Fields:
- Transaction No. (Code[20]) - PK part 1
- Line No. (Integer) - PK part 2
- Item No. (Code[20]) → Item
- Barcode (Code[50]) - scanned input
- Description (Text[100])
- Quantity (Decimal) - default 1
- Unit of Measure Code (Code[10])
- Unit Price (Decimal) - from Item.Unit Price
- Discount % (Decimal)
- Discount Amount (Decimal)
- Line Amount (Decimal) - Qty * Price - Discount
- Location Code (Code[10])
- Variant Code (Code[10])
```

### Table 50605: POS Payment Entry
```
Fields:
- Entry No. (Integer) - PK, AutoIncrement
- Transaction No. (Code[20]) → POS Transaction Header
- Payment Method (Enum "POS Payment Method")
- Amount (Decimal)
- Tendered Amount (Decimal) - what customer gave
- Change Amount (Decimal)
- Reference No. (Code[50]) - for card/voucher (future)
- Payment DateTime (DateTime)
```

---

## Page Designs

### Page 50623: POS Checkout (Main Screen)
```
PageType = Card
SourceTable = "POS Transaction Header"
Caption = 'Checkout'

Layout:
┌─────────────────────────────────────────────────────┐
│ [Barcode Entry Field] [+Qty] [Search Items]         │  ← Quick entry area
├─────────────────────────────────────────────────────┤
│ CART LINES (Subform 50624)                          │
│ ┌───────┬────────────┬─────┬────────┬─────────────┐ │
│ │ Item  │ Description│ Qty │ Price  │ Line Amount │ │
│ ├───────┼────────────┼─────┼────────┼─────────────┤ │
│ │ ...   │ ...        │ ... │ ...    │ ...         │ │
│ └───────┴────────────┴─────┴────────┴─────────────┘ │
├─────────────────────────────────────────────────────┤
│ Subtotal: XXX.XX    Discount: XXX.XX                │
│ ══════════════════════════════════════════════════  │
│ TOTAL: XXX.XX                                       │
├─────────────────────────────────────────────────────┤
│ [VOID LINE] [VOID TRANS] [HOLD] │ [PAY CASH] [POST] │  ← Actions
└─────────────────────────────────────────────────────┘

Key Features:
- Barcode field with OnValidate → lookup Item by Barcode or Item No.
- Auto-add line with Qty=1 on barcode scan
- F-key shortcuts: F2=New Trans, F5=Search, F8=Void Line, F12=Pay
- Real-time total calculation
- Status-based editability (locked after Posted)
```

### Page 50624: POS Cart Subform
```
PageType = ListPart
SourceTable = "POS Transaction Line"

Columns:
- Item No. (editable for manual entry)
- Description (non-editable)
- Quantity (editable, +/- buttons)
- Unit Price (editable for price override)
- Discount % (editable)
- Line Amount (non-editable, calculated)

Actions:
- Increment Qty
- Decrement Qty
- Remove Line
```

### Page 50628: POS Cashier Role Center
```
PageType = RoleCenter
Layout:
├── Headlines Part (shift status, sales today)
├── Activities Part (50629) - Section-specific based on Terminal assignment
│   ├── Cue: Open Transactions (my terminal)
│   ├── Cue: Today's Sales Total (my section)
│   ├── Cue: Transaction Count (my shift)
│   └── Cue: Shift Status
├── Actions:
│   ├── New Sale (opens 50623)
│   ├── Open Shift
│   ├── Close Shift
│   ├── View History
│   └── Item Lookup
```

### Page 50630: POS Manager Role Center
```
PageType = RoleCenter
Layout:
├── Headlines Part (total sales, alerts)
├── Section Cue Groups:
│   ├── Hypermart Cues (50632)
│   │   ├── Today's Sales
│   │   ├── Open Transactions
│   │   ├── Active Terminals
│   │   └── Pending Shifts
│   ├── Restaurant Cues (50633)
│   │   ├── Today's Sales
│   │   ├── Open Transactions
│   │   ├── Active Terminals
│   │   └── Average Ticket Size
│   ├── Bar Cues (50634)
│   │   ├── Today's Sales
│   │   ├── Open Transactions
│   │   ├── Active Terminals
│   │   └── Peak Hour Sales
│   └── Laundromat Cues (50635)
│       ├── Today's Sales
│       ├── Open Transactions
│       ├── Active Terminals
│       └── Machine Utilization (future)
├── Section Sales FactBox (50636) - Real-time comparison chart
├── Actions:
│   ├── View All Transactions
│   ├── Shift Oversight
│   ├── Terminal Management
│   ├── Daily Sales Report
│   ├── Variance Report
│   └── POS Setup
```

### Table 50607: POS Role Center Cue (Section-Specific FlowFields)
```
Fields:
- Primary Key (Code[10])
- Business Section Filter (Enum "POS Business Section") - FlowFilter

// Hypermart Cues
- Hypermart Today Sales (Decimal) - FlowField sum where Section = Hypermart
- Hypermart Open Trans (Integer) - FlowField count
- Hypermart Active Terminals (Integer) - FlowField count

// Restaurant Cues  
- Restaurant Today Sales (Decimal)
- Restaurant Open Trans (Integer)
- Restaurant Active Terminals (Integer)
- Restaurant Avg Ticket (Decimal) - calculated

// Bar Cues
- Bar Today Sales (Decimal)
- Bar Open Trans (Integer)
- Bar Active Terminals (Integer)

// Laundromat Cues
- Laundromat Today Sales (Decimal)
- Laundromat Open Trans (Integer)
- Laundromat Active Terminals (Integer)

// Totals
- Total Today Sales (Decimal)
- Total Open Trans (Integer)
- Total Active Shifts (Integer)
- Date Filter (Date) - FlowFilter
```

---

## Codeunit Procedures

### Codeunit 50640: POS Transaction Mgt.
```
Procedures:
- CreateNewTransaction(TerminalID): Code[20]
  → Creates header, assigns No. Series, returns Transaction No.
  → Sets Customer/Price Group from Terminal's Business Section
  
- AddItemByBarcode(TransNo, Barcode): Boolean
  → Lookup Item by Barcode or No., add line with Qty=1
  → If item exists in cart, increment Qty instead
  → Call GetUnitPrice for BC Sales Price lookup
  
- GetUnitPrice(ItemNo, CustomerPriceGroup, UOM, Qty, TransDate): Decimal
  → Use BC's Sales Price functions (table 7002)
  → Respects Customer Price Group, Minimum Qty, Date range
  → Fallback to Item."Unit Price" if no price found
  
- ApplyLineDiscount(var TransLine): Boolean
  → Lookup Sales Line Discount (table 7004)
  → Apply percentage or amount discount
  
- UpdateLineQuantity(TransNo, LineNo, NewQty): Boolean
  → Validate stock using CheckInventoryAvailable
  → Recalculate price for qty breaks
  
- CheckInventoryAvailable(ItemNo, LocationCode, Qty): Boolean
  → Use BC's Item Availability functions
  → Respect Inventory Setup."Prevent Negative Inventory"
  → Show Stockout Warning if Item."Stockout Warning" enabled
  
- VoidLine(TransNo, LineNo): Boolean
  → Remove line from cart
  
- VoidTransaction(TransNo, Reason): Boolean
  → Set Status=Voided, record reason
  
- CalculateTotals(var Header): Decimal
  → CalcFields on Subtotal, apply discounts, return Total
  
- ProcessPayment(TransNo, PaymentMethod, TenderedAmount): Boolean
  → Create Payment Entry, calculate change
  → If fully paid, call PostTransaction
  
- GetChange(TransNo): Decimal
  → Returns change due
```

### Codeunit 50641: POS Posting
```
Procedures:
- PostTransaction(TransNo): Boolean
  → Validate shift is open
  → Validate payment complete
  → Create Sales Invoice Header from POS Header
  → Create Sales Invoice Lines from POS Lines
  → Post Sales Invoice using SalesPost codeunit
  → Update POS Header with Posted Invoice No.
  → Set Status = Posted
  → Archive transaction
  → Return TRUE on success

- CreateSalesInvoice(POSHeader): Record "Sales Header"
  → Map: Customer, Date, Location, Salesperson, Dimensions
  
- CreateSalesInvoiceLines(POSHeader, SalesHeader)
  → For each POS Line, create Sales Line
  → Map: Item No., Qty, Unit Price, Discount, Location
```

### Codeunit 50642: POS Shift Mgt.
```
Procedures:
- OpenShift(TerminalID, OpeningFloat): Code[20]
  → Validate no open shift exists
  → Create POS Shift record
  → Update Terminal.Current Shift No.
  → Return Shift No.
  
- CloseShift(ShiftNo, DeclaredCash): Boolean
  → Calculate Expected Cash (OpeningFloat + CashSales)
  → Record Variance
  → Set Status = Closed
  → Clear Terminal.Current Shift No.
  
- ValidateShiftOpen(TerminalID): Boolean
  → Check if active shift exists
  → Used before allowing transactions
```

---

## Steps

### Phase 1: Foundation (Tables + Enums + Setup)
1. Create enums: POS Transaction Status (50680), POS Payment Method (50681), POS Shift Status (50682), **POS Business Section (50683)**
2. Create POS Setup table (50600) with section-specific Customer/Price Group fields + Setup page (50620)
3. Create POS Terminal table (50601) with Business Section field + List page (50621) + Card page (50622)
4. Create POS Shift table (50602)
5. Create POS Transaction Header table (50603) with Business Section field
6. Create POS Transaction Line table (50604)
7. Create POS Payment Entry table (50605)
8. Create POS Archived Transaction table (50606) for history
9. **Create POS Role Center Cue table (50607) with section-specific FlowFields**
10. Update Permission Set with new objects

### Phase 2: Core Transaction Logic (Codeunits) *depends on Phase 1*
11. Create POS Transaction Mgt. codeunit (50640) with **GetItemSalesPrice** using BC table 7002
12. Create POS Posting codeunit (50641) using BC standard inventory controls
13. Create POS Shift Mgt. codeunit (50642)

### Phase 3: User Interface - Transaction Pages *depends on Phase 1*
14. Create POS Cart Subform page (50624)
15. Create POS Checkout page (50623) with barcode entry and actions
16. Create POS Payment Dialog page (50625)
17. Create POS Shift Management page (50626)

### Phase 4: Cashier Role Center *depends on Phase 3*
18. Create POS Cashier Activities page (50629) - aggregated cues
19. Create POS Cashier Role Center page (50628)
20. Create Cashier Profile

### Phase 5: Manager Role Center *depends on Phase 3*
21. **Create section-specific Cue pages:**
    - POS Hypermart Cues (50632)
    - POS Restaurant Cues (50633)
    - POS Bar Cues (50634)
    - POS Laundromat Cues (50635)
22. **Create POS All Sections Overview page (50636)** - combined dashboard
23. **Create POS Manager Role Center page (50630)**
24. Create Manager Profile

### Phase 6: Reports *parallel with Phase 4-5*
25. Create POS Receipt report (50660)
26. Create POS Shift Summary report (50661)
27. Create POS Daily Sales report (50662)
28. Create POS Transaction History report (50663)
29. **Create POS Section Comparison report (50664)** - cross-section analysis

### Phase 7: Testing & Polish
30. Test end-to-end flow: Open Shift → Scan Items → Pay → Post → Close Shift
31. Test BC Sales Price integration with different Customer Price Groups
32. Test section-specific filtering on Manager cues
33. Test edge cases: void, price override, negative qty
34. Add keyboard shortcuts (F5=Checkout, F8=Payment, Esc=Cancel)
35. Performance tuning

---

## Relevant Files (Templates)

| Pattern | Source File | Use For |
|---------|-------------|---------|
| Header Table | Tables/ExpenseRequestHeader.Table.al | POS Transaction Header |
| Line Table | Tables/ExpenseRequestLine.Table.al | POS Transaction Line |
| Card + Subform | Pages/ExpenseCard.Page.al, Pages/ExpenseSubform.Page.al | POS Checkout + Cart |
| Role Center | RoleCenters/QMB_Stabilization_FinanceAdminRC.Page.al | POS Cashier RC |
| Activities | RoleCenters/QMB_Stabilization_FinanceAdminActivities.Page.al | POS Cashier Activities |
| Profile | RoleCenters/QMB_Stabilization_FinanceAdmin.Profile.al | Cashier Profile |
| Codeunit | Codeunits/MonthEndClosingMgt.Codeunit.al | POS Transaction Mgt. |
| Permission Set | PermissionSets/QMBStabAllObjects.PermissionSet.al | Add POS objects |

---

## Verification

### Manual Testing
1. Open POS Setup, configure default customer + location
2. Create POS Terminal, assign to user
3. Open Shift with float
4. New Transaction → Scan items → Verify inventory lookup
5. Pay Cash → Verify change calculation
6. Post → Verify Sales Invoice created + inventory reduced
7. Close Shift → Verify cash reconciliation

### Automated Validation
- Compile with Ctrl+Shift+B
- Run `Get-NAVAppInfo` to verify installation

---

## Decisions

- **ID Range**: 50600-50699 reserved for POS module
- **Sales Invoice vs Order**: Using Sales Invoice (direct post) for simplicity
- **Customer**: Default "Cash Customer" per POS Setup; support Customer Category for price groups
- **Barcode**: Lookup Item."Bar Code" field; fallback to Item."No."
- **Pricing**: Leverage BC Sales Price table (Customer Price Groups, Item Discounts) - NOT simple Item."Unit Price"
- **Inventory**: Use standard BC Inventory Setup + Item Card settings (costing, tracking, negative inventory, reorder)
- **Shifts**: Required before transactions (configurable)
- **Dimensions**: Business Section (Hypermart/Restaurant/Bar/Laundromat) as Dimension 1; Location as context
- **Role Centers**: Cashier RC (operational) + Manager RC (analytical) with section-specific cues

---

## Future Considerations

1. **Payment Terminals (ECR)**: Add Card payment method, integrate with payment provider API
2. **Customer Lookup**: Allow selecting customer for invoicing
3. **Discounts**: Line-level, transaction-level, promotional
4. **Returns/Refunds**: Negative lines or credit memo posting
5. **Hold/Recall**: Park transactions and retrieve later
6. **Multi-tender**: Split payments across methods
7. **Offline Mode**: Local queue with sync (complex)
8. **Touch UI**: Consider BC mobile app or Power App frontend
