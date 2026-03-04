// ------------------------------------------------------------------------------------------------
// Role Center Cue Table
// Shared cue table for all QMB's Specific Role Centers
// Provides FlowFields for KPIs across all the entities in this PTE
// ------------------------------------------------------------------------------------------------
table 70103 "QMB Stab. Role Center Cue"
{
    Caption = 'QMB Role Center Cue';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
            DataClassification = SystemMetadata;
        }

        // ============================================================
        // FINANCE AND ADMIN MANAGER CUES - Payment Processing i.e Expense Request Header and Line Tables and related pages
        // ============================================================
        field(10; "Open Expense Requests"; Integer)
        {
            Caption = 'Open Expense Requests';
            FieldClass = FlowField;
            CalcFormula = count("Expense Request Header" where(Status = const(" "), Posted = const(false)));
        }
        field(11; "Pending Expense Approvals"; Integer)
        {
            Caption = 'Pending Expense Approvals';
            FieldClass = FlowField;
            CalcFormula = count("Expense Request Header" where(Status = const("Pending Approval")));
        }
        field(12; "Approved Expense Requests"; Integer)
        {
            Caption = 'Approved Expense Requests';
            FieldClass = FlowField;
            CalcFormula = count("Expense Request Header" where(Status = const(Approved), Posted = const(false)));
        }
        field(13; "Rejected Expense Requests"; Integer)
        {
            Caption = 'Rejected Expense Requests';
            FieldClass = FlowField;
            CalcFormula = count("Expense Request Header" where(Status = const(Rejected)));
        }
        field(14; "Posted Expense Requests"; Integer)
        {
            Caption = 'Posted Expense Requests';
            FieldClass = FlowField;
            CalcFormula = count("Expense Request Header" where(Posted = const(true)));
        }

        // ============================================================
        // FINANCE AND ADMIN MANAGER CUES - Store Requests, Issuance and Returns Processing
        // ============================================================
        field(20; "Open Store Requisitions"; Integer)
        {
            Caption = 'Open Store Requisitions';
            FieldClass = FlowField;
            CalcFormula = count("Store Requisition Header" where(Status = const(" "), Posted = const(false)));
        }
        field(21; "Pending Store Requisitions"; Integer)
        {
            Caption = 'Pending Store Requisitions';
            FieldClass = FlowField;
            CalcFormula = count("Store Requisition Header" where(Status = const("Pending Approval")));
        }
        field(22; "Approved Store Requisitions"; Integer)
        {
            Caption = 'Approved Store Requisitions';
            FieldClass = FlowField;
            CalcFormula = count("Store Requisition Header" where(Status = const(Approved), Posted = const(false)));
        }
        field(23; "Rejected Store Requisitions"; Integer)
        {
            Caption = 'Rejected Store Requisitions';
            FieldClass = FlowField;
            CalcFormula = count("Store Requisition Header" where(Status = const(Rejected)));
        }
        field(24; "Posted Store Requisitions"; Integer)
        {
            Caption = 'Posted Store Requisitions';
            FieldClass = FlowField;
            CalcFormula = count("Store Requisition Header" where(Posted = const(true)));
        }
        field(30; "Open Store Returns"; Integer)
        {
            Caption = 'Open Store Returns';
            FieldClass = FlowField;
            CalcFormula = count("Store Return Header" where(Status = const(" "), Posted = const(false)));
        }
        field(31; "Pending Store Returns"; Integer)
        {
            Caption = 'Pending Store Returns';
            FieldClass = FlowField;
            CalcFormula = count("Store Return Header" where(Status = const("Pending Approval")));
        }
        field(32; "Approved Store Returns"; Integer)
        {
            Caption = 'Approved Store Returns';
            FieldClass = FlowField;
            CalcFormula = count("Store Return Header" where(Status = const(Approved), Posted = const(false)));
        }
        field(33; "Rejected Store Returns"; Integer)
        {
            Caption = 'Rejected Store Returns';
            FieldClass = FlowField;
            CalcFormula = count("Store Return Header" where(Status = const(Rejected)));
        }
        field(34; "Posted Store Returns"; Integer)
        {
            Caption = 'Posted Store Returns';
            FieldClass = FlowField;
            CalcFormula = count("Store Return Header" where(Posted = const(true)));
        }

        // ============================================================
        // FINANCE AND ADMIN MANAGER CUES - Budget Check Cues   
        // ============================================================
        field(40; "Total Expense Amount"; Decimal)
        {
            Caption = 'Total Expense Amount';
            FieldClass = Normal;
            Editable = false;
        }
        field(41; "Posted Expense Amount"; Decimal)
        {
            Caption = 'Posted Expense Amount';
            FieldClass = Normal;
            Editable = false;
        }

        // ============================================================
        // FINANCE AND ADMIN MANAGER CUES - Approval Workflow Cues
        // ============================================================
        field(50; "Open Approval Entries"; Integer)
        {
            Caption = 'Open Approval Entries';
            FieldClass = FlowField;
            CalcFormula = count("Document Approval Entry" where(Open = const(true)));
        }
        field(51; "Pending Approval Entries"; Integer)
        {
            Caption = 'Pending Approval Entries';
            FieldClass = FlowField;
            CalcFormula = count("Document Approval Entry" where(Status = const(Pending)));
        }
        field(52; "Approved Entries"; Integer)
        {
            Caption = 'Approved Entries';
            FieldClass = FlowField;
            CalcFormula = count("Document Approval Entry" where(Status = const(Approved)));
        }
        field(53; "Rejected Entries"; Integer)
        {
            Caption = 'Rejected Entries';
            FieldClass = FlowField;
            CalcFormula = count("Document Approval Entry" where(Status = const(Rejected)));
        }
        field(54; "My Pending Approvals"; Integer)
        {
            Caption = 'My Pending Approvals';
            FieldClass = FlowField;
            CalcFormula = count("Document Approval Entry" where(Status = const(Pending), Approver = field("User ID Filter")));
        }

        // ============================================================
        // FILTER FIELDS
        // ============================================================
        field(100; "Date Filter"; Date)
        {
            Caption = 'Date Filter';
            FieldClass = FlowFilter;
        }
        field(101; "User ID Filter"; Code[50])
        {
            Caption = 'User ID Filter';
            FieldClass = FlowFilter;
        }
    }

    keys
    {
        key(PK; "Primary Key")
        {
            Clustered = true;
        }
    }

    procedure GetOrCreate()
    begin
        Reset();
        if not Get() then begin
            Init();
            Insert();
        end;
        CalculateExpenseAmounts();
    end;

    procedure CalculateExpenseAmounts()
    var
        ExpenseHeader: Record "Expense Request Header";
        TotalApproved: Decimal;
        TotalPosted: Decimal;
    begin
        TotalApproved := 0;
        TotalPosted := 0;

        // Calculate Total Expense Amount (Approved but not Posted)
        ExpenseHeader.Reset();
        ExpenseHeader.SetRange(Status, ExpenseHeader.Status::Approved);
        ExpenseHeader.SetRange(Posted, false);
        if ExpenseHeader.FindSet() then
            repeat
                ExpenseHeader.CalcFields("Total Line Amount");
                TotalApproved += ExpenseHeader."Total Line Amount";
            until ExpenseHeader.Next() = 0;

        // Calculate Posted Expense Amount
        ExpenseHeader.Reset();
        ExpenseHeader.SetRange(Posted, true);
        if ExpenseHeader.FindSet() then
            repeat
                ExpenseHeader.CalcFields("Total Line Amount");
                TotalPosted += ExpenseHeader."Total Line Amount";
            until ExpenseHeader.Next() = 0;

        Rec."Total Expense Amount" := TotalApproved;
        Rec."Posted Expense Amount" := TotalPosted;
        if Rec.Modify() then;
    end;
}
