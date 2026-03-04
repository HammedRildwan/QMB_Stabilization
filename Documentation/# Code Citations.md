# Code Citations

## License: unknown
https://github.com/nadeemshirazi786/ENYOGBC14EXT-New/blob/cd36edfc35e9b163549a3e280889702a3be3d6d2/EN%20WMS/Enums/e14229227.ENWMSDocumentStatus.al

```
I'll help you implement a Month-End Closing Checklist feature to streamline and accelerate the month-end process. This will include a checklist table, page, and integration with the Role Center.

## Solution Overview

| Component | Purpose |
|-----------|---------|
| **Month-End Checklist Template** | Define reusable checklist items |
| **Month-End Closing Header** | Track each period's closing process |
| **Month-End Closing Line** | Individual tasks with status tracking |
| **Closing Checklist Page** | Manage and execute closing tasks |
| **Automation Codeunit** | Pre-validate and auto-complete tasks |

---

### 1. Month-End Checklist Template Table

````al
// filepath: c:\Users\LukmanASULAIMAN\source\repos\QMB_Stabilization\QMB_Stabilization\Tables\MonthEndChecklistTemplate.Table.al
table 60080 "Month-End Checklist Template"
{
    Caption = 'Month-End Checklist Template';
    DataClassification = CustomerContent;
    LookupPageId = "Month-End Checklist Templates";
    DrillDownPageId = "Month-End Checklist Templates";

    fields
    {
        field(1; "Code"; Code[20])
        {
            Caption = 'Code';
            NotBlank = true;
        }
        field(2; Description; Text[100])
        {
            Caption = 'Description';
        }
        field(3; "Sequence No."; Integer)
        {
            Caption = 'Sequence No.';
            MinValue = 1;
        }
        field(4; Category; Enum "Closing Task Category")
        {
            Caption = 'Category';
        }
        field(5; "Responsible Role"; Code[20])
        {
            Caption = 'Responsible Role';
            TableRelation = "User Setup"."User ID";
        }
        field(6; "Est. Duration (Minutes)"; Integer)
        {
            Caption = 'Est. Duration (Minutes)';
            MinValue = 0;
        }
        field(7; "Auto-Validate"; Boolean)
        {
            Caption = 'Auto-Validate';
            ToolTip = 'If enabled, the system will automatically check if this task is complete.';
        }
        field(8; "Validation Type"; Enum "Closing Validation Type")
        {
            Caption = 'Validation Type';
        }
        field(9; "Related Page ID"; Integer)
        {
            Caption = 'Related Page ID';
            TableRelation = AllObjWithCaption."Object ID" where("Object Type" = const(Page));
        }
        field(10; "Related Report ID"; Integer)
        {
            Caption = 'Related Report ID';
            TableRelation = AllObjWithCaption."Object ID" where("Object Type" = const(Report));
        }
        field(11; "Blocking"; Boolean)
        {
            Caption = 'Blocking';
            ToolTip = 'If enabled, subsequent tasks cannot start until this task is completed.';
        }
        field(12; "Instructions"; Text[2048])
        {
            Caption = 'Instructions';
        }
        field(13; Active; Boolean)
        {
            Caption = 'Active';
            InitValue = true;
        }
    }

    keys
    {
        key(PK; "Code")
        {
            Clustered = true;
        }
        key(Sequence; "Sequence No.")
        {
        }
        key(Category; Category, "Sequence No.")
        {
        }
    }

    trigger OnInsert()
    begin
        if "Sequence No." = 0 then
            "Sequence No." := GetNextSequenceNo();
    end;

    local procedure GetNextSequenceNo(): Integer
    var
        Template: Record "Month-End Checklist Template";
    begin
        Template.SetCurrentKey("Sequence No.");
        if Template.FindLast() then
            exit(Template."Sequence No." + 10)
        else
            exit(10);
    end;
}
````

---

### 2. Closing Task Category Enum

````al
// filepath: c:\Users\LukmanASULAIMAN\source\repos\QMB_Stabilization\QMB_Stabilization\Enums\ClosingTaskCategory.Enum.al
enum 60080 "Closing Task Category"
{
    Caption = 'Closing Task Category';
    Extensible = true;

    value(0; " ")
    {
        Caption = ' ';
    }
    value(1; "Pre-Closing")
    {
        Caption = 'Pre-Closing';
    }
    value(2; "Receivables")
    {
        Caption = 'Receivables';
    }
    value(3; "Payables")
    {
        Caption = 'Payables';
    }
    value(4; "Inventory")
    {
        Caption = 'Inventory';
    }
    value(5; "Fixed Assets")
    {
        Caption = 'Fixed Assets';
    }
    value(6; "Bank Reconciliation")
    {
        Caption = 'Bank Reconciliation';
    }
    value(7; "Expense Processing")
    {
        Caption = 'Expense Processing';
    }
    value(8; "Accruals & Deferrals")
    {
        Caption = 'Accruals & Deferrals';
    }
    value(9; "Intercompany")
    {
        Caption = 'Intercompany';
    }
    value(10; "Reporting")
    {
        Caption = 'Reporting';
    }
    value(11; "Final Review")
    {
        Caption = 'Final Review';
    }
}
````

---

### 3. Closing Validation Type Enum

````al
// filepath: c:\Users\LukmanASULAIMAN\source\repos\QMB_Stabilization\QMB_Stabilization\Enums\ClosingValidationType.Enum.al
enum 60081 "Closing Validation Type"
{
    Caption = 'Closing Validation Type';
    Extensible = true;

    value(0; "Manual")
    {
        Caption = 'Manual';
    }
    value(1; "No Open Expenses")
    {
        Caption = 'No Open Expenses';
    }
    value(2; "No Open Requisitions")
    {
        Caption = 'No Open Requisitions';
    }
    value(3; "No Pending Approvals")
    {
        Caption = 'No Pending Approvals';
    }
    value(4; "Bank Reconciled")
    {
        Caption = 'Bank Reconciled';
    }
    value(5; "No Unposted Journals")
    {
        Caption = 'No Unposted Journals';
    }
    value(6; "Inventory Adjusted")
    {
        Caption = 'Inventory Adjusted';
    }
    value(7; "Trial Balance Balanced")
    {
        Caption = 'Trial Balance Balanced';
    }
    value(8; "Budget Reviewed")
    {
        Caption = 'Budget Reviewed';
    }
}
````

---

### 4. Month-End Closing Header Table

````al
// filepath: c:\Users\LukmanASULAIMAN\source\repos\QMB_Stabilization\QMB_Stabilization\Tables\MonthEndClosingHeader.Table.al
table 60081 "Month-End Closing Header"
{
    Caption = 'Month-End Closing Header';
    DataClassification = CustomerContent;
    LookupPageId = "Month-End Closing List";
    DrillDownPageId = "Month-End Closing List";

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
        }
        field(2; "Accounting Period"; Code[10])
        {
            Caption = 'Accounting Period';
            TableRelation = "Accounting Period";

            trigger OnValidate()
            var
                AccPeriod: Record "Accounting Period";
            begin
                if AccPeriod.Get("Accounting Period") then begin
                    "Period Start Date" := AccPeriod."Starting Date";
                    "Period End Date" := CalcDate('<CM>', AccPeriod."Starting Date");
                    "Fiscal Year" := Date2DMY(AccPeriod."Starting Date", 3);
                end;
            end;
        }
        field(3; "Period Start Date"; Date)
        {
            Caption = 'Period Start Date';
            Editable = false;
        }
        field(4; "Period End Date"; Date)
        {
            Caption = 'Period End Date';
            Editable = false;
        }
        field(5; "Fiscal Year"; Integer)
        {
            Caption = 'Fiscal Year';
            Editable = false;
        }
        field(6; Status; Enum "Month-End Closing Status")
        {
            Caption = 'Status';
            Editable = false;
        }
        field(7; "Created By"; Code[50])
        {
            Caption = 'Created By';
            DataClassification = EndUserIdentifiableInformation;
            Editable = false;
        }
        field(8; "Created Date"; Date)
        {
            Caption = 'Created Date';
            Editable = false;
        }
        field(9; "Started Date"; Date)
        {
            Caption = 'Started Date';
            Editable = false;
        }
        field(10; "Completed Date"; Date)
        {
            Caption = 'Completed Date';
            Editable = false;
        }
        field(11; "Completed By"; Code[50])
        {
            Caption = 'Completed By';
            DataClassification = EndUserIdentifiableInformation;
            Editable = false;
        }
        field(12; "Total Tasks"; Integer)
        {
            Caption = 'Total Tasks';
            FieldClass = FlowField;
            CalcFormula = count("Month-End Closing Line" where("Document No." = field("No.")));
            Editable = false;
        }
        field(13; "Completed Tasks"; Integer)
        {
            Caption = 'Completed Tasks';
            FieldClass = FlowField;
            CalcFormula = count("Month-End Closing Line" where("Document No." = field("No."), Status = const(Completed)));
            Editable = false;
        }
        field(14; "Blocked Tasks"; Integer)
        {
            Caption = 'Blocked Tasks';
            FieldClass = FlowField;
            CalcFormula = count("Month-End Closing Line" where("Document No." = field("No."), Status = const(Blocked)));
            Editable = false;
        }
        field(15; "Comments"; Text[500])
        {
            Caption = 'Comments';
        }
    }

    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }
        key(Period; "Accounting Period", "Fiscal Year")
        {
        }
    }

    trigger OnInsert()
    var
        NoSeriesMgt: Codeunit NoSeriesManagement;
        CustomSetup: Record "Custom Setup";
    begin
        if "No." = '' then begin
            CustomSetup.Get();
            "No." := NoSeriesMgt.GetNextNo('MONTHEND', WorkDate(), true);
        end;
        "Created By" := CopyStr(UserId, 1, 50);
        "Created Date" := WorkDate();
        Status := Status::Open;
    end;

    trigger OnDelete()
    var
        ClosingLine: Record "Month-End Closing Line";
    begin
        if Status = Status::Completed then
            Error('Cannot delete a completed month-end closing.');

        ClosingLine.SetRange("Document No.", "No.");
        ClosingLine.DeleteAll(true);
    end;

    procedure InitializeFromTemplate()
    var
        Template: Record "Month-End Checklist Template";
        ClosingLine: Record "Month-End Closing Line";
        LineNo: Integer;
    begin
        if Status <> Status::Open then
            Error('Checklist can only be initialized when status is Open.');

        Template.SetRange(Active, true);
        Template.SetCurrentKey("Sequence No.");
        if Template.FindSet() then begin
            LineNo := 10000;
            repeat
                ClosingLine.Init();
                ClosingLine."Document No." := "No.";
                ClosingLine."Line No." := LineNo;
                ClosingLine."Task Code" := Template.Code;
                ClosingLine.Description := Template.Description;
                ClosingLine.Category := Template.Category;
                ClosingLine."Sequence No." := Template."Sequence No.";
                ClosingLine."Responsible User" := Template."Responsible Role";
                ClosingLine."Est. Duration (Minutes)" := Template."Est. Duration (Minutes)";
                ClosingLine."Auto-Validate" := Template."Auto-Validate";
                ClosingLine."Validation Type" := Template."Validation Type";
                ClosingLine."Related Page ID" := Template."Related Page ID";
                ClosingLine."Related Report ID" := Template."Related Report ID";
                ClosingLine.Blocking := Template.Blocking;
                ClosingLine.Instructions := Template.Instructions;
                ClosingLine.Status := ClosingLine.Status::Pending;
                ClosingLine.Insert(true);
                LineNo += 10000;
            until Template.Next() = 0;
        end;

        Status := Status::"In Progress";
        "Started Date" := WorkDate();
        Modify();
    end;

    procedure CompleteClosing()
    var
        ClosingLine: Record "Month-End Closing Line";
    begin
        ClosingLine.SetRange("Document No.", "No.");
        ClosingLine.SetFilter(Status, '<>%1', ClosingLine.Status::Completed);
        if not ClosingLine.IsEmpty then
            Error('Cannot complete closing. There are %1 incomplete tasks.', ClosingLine.Count);

        Status := Status::Completed;
        "Completed Date" := WorkDate();
        "Completed By" := CopyStr(UserId, 1, 50);
        Modify();
    end;

    procedure ReopenClosing()
    begin
        if Status <> Status::Completed then
            Error('Only completed closings can be reopened.');

        Status := Status::"In Progress";
        "Completed Date" := 0D;
        "Completed By" := '';
        Modify();
    end;

    procedure GetCompletionPercentage(): Decimal
    begin
        CalcFields("Total Tasks", "Completed Tasks");
        if "Total Tasks" = 0 then
            exit(0);
        exit(Round("Completed Tasks" / "Total Tasks" * 100, 0.1));
    end;
}
````

---

### 5. Month-End Closing Status Enum

````al
// filepath: c:\Users\LukmanASULAIMAN\source\repos\QMB_Stabilization\QMB_Stabilization\Enums\MonthEndClosingStatus.Enum.al
enum 60082 "Month-End Closing Status"
{
    Caption = 'Month-End Closing Status';
    Extensible = true;

    value(0; Open)
    {
        Caption = 'Open';
    }
    value(1; "In Progress")
    {
        Caption = 'In Progress';
    }
    value(2; Completed)
    {
        Caption = 'Completed';
    }
    value(3; Cancelled)
    {
        Caption = 'Cancelled';
    }
```


## License: unknown
https://github.com/nadeemshirazi786/ENYOGBC14EXT-New/blob/cd36edfc35e9b163549a3e280889702a3be3d6d2/EN%20WMS/Enums/e14229227.ENWMSDocumentStatus.al

```
I'll help you implement a Month-End Closing Checklist feature to streamline and accelerate the month-end process. This will include a checklist table, page, and integration with the Role Center.

## Solution Overview

| Component | Purpose |
|-----------|---------|
| **Month-End Checklist Template** | Define reusable checklist items |
| **Month-End Closing Header** | Track each period's closing process |
| **Month-End Closing Line** | Individual tasks with status tracking |
| **Closing Checklist Page** | Manage and execute closing tasks |
| **Automation Codeunit** | Pre-validate and auto-complete tasks |

---

### 1. Month-End Checklist Template Table

````al
// filepath: c:\Users\LukmanASULAIMAN\source\repos\QMB_Stabilization\QMB_Stabilization\Tables\MonthEndChecklistTemplate.Table.al
table 60080 "Month-End Checklist Template"
{
    Caption = 'Month-End Checklist Template';
    DataClassification = CustomerContent;
    LookupPageId = "Month-End Checklist Templates";
    DrillDownPageId = "Month-End Checklist Templates";

    fields
    {
        field(1; "Code"; Code[20])
        {
            Caption = 'Code';
            NotBlank = true;
        }
        field(2; Description; Text[100])
        {
            Caption = 'Description';
        }
        field(3; "Sequence No."; Integer)
        {
            Caption = 'Sequence No.';
            MinValue = 1;
        }
        field(4; Category; Enum "Closing Task Category")
        {
            Caption = 'Category';
        }
        field(5; "Responsible Role"; Code[20])
        {
            Caption = 'Responsible Role';
            TableRelation = "User Setup"."User ID";
        }
        field(6; "Est. Duration (Minutes)"; Integer)
        {
            Caption = 'Est. Duration (Minutes)';
            MinValue = 0;
        }
        field(7; "Auto-Validate"; Boolean)
        {
            Caption = 'Auto-Validate';
            ToolTip = 'If enabled, the system will automatically check if this task is complete.';
        }
        field(8; "Validation Type"; Enum "Closing Validation Type")
        {
            Caption = 'Validation Type';
        }
        field(9; "Related Page ID"; Integer)
        {
            Caption = 'Related Page ID';
            TableRelation = AllObjWithCaption."Object ID" where("Object Type" = const(Page));
        }
        field(10; "Related Report ID"; Integer)
        {
            Caption = 'Related Report ID';
            TableRelation = AllObjWithCaption."Object ID" where("Object Type" = const(Report));
        }
        field(11; "Blocking"; Boolean)
        {
            Caption = 'Blocking';
            ToolTip = 'If enabled, subsequent tasks cannot start until this task is completed.';
        }
        field(12; "Instructions"; Text[2048])
        {
            Caption = 'Instructions';
        }
        field(13; Active; Boolean)
        {
            Caption = 'Active';
            InitValue = true;
        }
    }

    keys
    {
        key(PK; "Code")
        {
            Clustered = true;
        }
        key(Sequence; "Sequence No.")
        {
        }
        key(Category; Category, "Sequence No.")
        {
        }
    }

    trigger OnInsert()
    begin
        if "Sequence No." = 0 then
            "Sequence No." := GetNextSequenceNo();
    end;

    local procedure GetNextSequenceNo(): Integer
    var
        Template: Record "Month-End Checklist Template";
    begin
        Template.SetCurrentKey("Sequence No.");
        if Template.FindLast() then
            exit(Template."Sequence No." + 10)
        else
            exit(10);
    end;
}
````

---

### 2. Closing Task Category Enum

````al
// filepath: c:\Users\LukmanASULAIMAN\source\repos\QMB_Stabilization\QMB_Stabilization\Enums\ClosingTaskCategory.Enum.al
enum 60080 "Closing Task Category"
{
    Caption = 'Closing Task Category';
    Extensible = true;

    value(0; " ")
    {
        Caption = ' ';
    }
    value(1; "Pre-Closing")
    {
        Caption = 'Pre-Closing';
    }
    value(2; "Receivables")
    {
        Caption = 'Receivables';
    }
    value(3; "Payables")
    {
        Caption = 'Payables';
    }
    value(4; "Inventory")
    {
        Caption = 'Inventory';
    }
    value(5; "Fixed Assets")
    {
        Caption = 'Fixed Assets';
    }
    value(6; "Bank Reconciliation")
    {
        Caption = 'Bank Reconciliation';
    }
    value(7; "Expense Processing")
    {
        Caption = 'Expense Processing';
    }
    value(8; "Accruals & Deferrals")
    {
        Caption = 'Accruals & Deferrals';
    }
    value(9; "Intercompany")
    {
        Caption = 'Intercompany';
    }
    value(10; "Reporting")
    {
        Caption = 'Reporting';
    }
    value(11; "Final Review")
    {
        Caption = 'Final Review';
    }
}
````

---

### 3. Closing Validation Type Enum

````al
// filepath: c:\Users\LukmanASULAIMAN\source\repos\QMB_Stabilization\QMB_Stabilization\Enums\ClosingValidationType.Enum.al
enum 60081 "Closing Validation Type"
{
    Caption = 'Closing Validation Type';
    Extensible = true;

    value(0; "Manual")
    {
        Caption = 'Manual';
    }
    value(1; "No Open Expenses")
    {
        Caption = 'No Open Expenses';
    }
    value(2; "No Open Requisitions")
    {
        Caption = 'No Open Requisitions';
    }
    value(3; "No Pending Approvals")
    {
        Caption = 'No Pending Approvals';
    }
    value(4; "Bank Reconciled")
    {
        Caption = 'Bank Reconciled';
    }
    value(5; "No Unposted Journals")
    {
        Caption = 'No Unposted Journals';
    }
    value(6; "Inventory Adjusted")
    {
        Caption = 'Inventory Adjusted';
    }
    value(7; "Trial Balance Balanced")
    {
        Caption = 'Trial Balance Balanced';
    }
    value(8; "Budget Reviewed")
    {
        Caption = 'Budget Reviewed';
    }
}
````

---

### 4. Month-End Closing Header Table

````al
// filepath: c:\Users\LukmanASULAIMAN\source\repos\QMB_Stabilization\QMB_Stabilization\Tables\MonthEndClosingHeader.Table.al
table 60081 "Month-End Closing Header"
{
    Caption = 'Month-End Closing Header';
    DataClassification = CustomerContent;
    LookupPageId = "Month-End Closing List";
    DrillDownPageId = "Month-End Closing List";

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
        }
        field(2; "Accounting Period"; Code[10])
        {
            Caption = 'Accounting Period';
            TableRelation = "Accounting Period";

            trigger OnValidate()
            var
                AccPeriod: Record "Accounting Period";
            begin
                if AccPeriod.Get("Accounting Period") then begin
                    "Period Start Date" := AccPeriod."Starting Date";
                    "Period End Date" := CalcDate('<CM>', AccPeriod."Starting Date");
                    "Fiscal Year" := Date2DMY(AccPeriod."Starting Date", 3);
                end;
            end;
        }
        field(3; "Period Start Date"; Date)
        {
            Caption = 'Period Start Date';
            Editable = false;
        }
        field(4; "Period End Date"; Date)
        {
            Caption = 'Period End Date';
            Editable = false;
        }
        field(5; "Fiscal Year"; Integer)
        {
            Caption = 'Fiscal Year';
            Editable = false;
        }
        field(6; Status; Enum "Month-End Closing Status")
        {
            Caption = 'Status';
            Editable = false;
        }
        field(7; "Created By"; Code[50])
        {
            Caption = 'Created By';
            DataClassification = EndUserIdentifiableInformation;
            Editable = false;
        }
        field(8; "Created Date"; Date)
        {
            Caption = 'Created Date';
            Editable = false;
        }
        field(9; "Started Date"; Date)
        {
            Caption = 'Started Date';
            Editable = false;
        }
        field(10; "Completed Date"; Date)
        {
            Caption = 'Completed Date';
            Editable = false;
        }
        field(11; "Completed By"; Code[50])
        {
            Caption = 'Completed By';
            DataClassification = EndUserIdentifiableInformation;
            Editable = false;
        }
        field(12; "Total Tasks"; Integer)
        {
            Caption = 'Total Tasks';
            FieldClass = FlowField;
            CalcFormula = count("Month-End Closing Line" where("Document No." = field("No.")));
            Editable = false;
        }
        field(13; "Completed Tasks"; Integer)
        {
            Caption = 'Completed Tasks';
            FieldClass = FlowField;
            CalcFormula = count("Month-End Closing Line" where("Document No." = field("No."), Status = const(Completed)));
            Editable = false;
        }
        field(14; "Blocked Tasks"; Integer)
        {
            Caption = 'Blocked Tasks';
            FieldClass = FlowField;
            CalcFormula = count("Month-End Closing Line" where("Document No." = field("No."), Status = const(Blocked)));
            Editable = false;
        }
        field(15; "Comments"; Text[500])
        {
            Caption = 'Comments';
        }
    }

    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }
        key(Period; "Accounting Period", "Fiscal Year")
        {
        }
    }

    trigger OnInsert()
    var
        NoSeriesMgt: Codeunit NoSeriesManagement;
        CustomSetup: Record "Custom Setup";
    begin
        if "No." = '' then begin
            CustomSetup.Get();
            "No." := NoSeriesMgt.GetNextNo('MONTHEND', WorkDate(), true);
        end;
        "Created By" := CopyStr(UserId, 1, 50);
        "Created Date" := WorkDate();
        Status := Status::Open;
    end;

    trigger OnDelete()
    var
        ClosingLine: Record "Month-End Closing Line";
    begin
        if Status = Status::Completed then
            Error('Cannot delete a completed month-end closing.');

        ClosingLine.SetRange("Document No.", "No.");
        ClosingLine.DeleteAll(true);
    end;

    procedure InitializeFromTemplate()
    var
        Template: Record "Month-End Checklist Template";
        ClosingLine: Record "Month-End Closing Line";
        LineNo: Integer;
    begin
        if Status <> Status::Open then
            Error('Checklist can only be initialized when status is Open.');

        Template.SetRange(Active, true);
        Template.SetCurrentKey("Sequence No.");
        if Template.FindSet() then begin
            LineNo := 10000;
            repeat
                ClosingLine.Init();
                ClosingLine."Document No." := "No.";
                ClosingLine."Line No." := LineNo;
                ClosingLine."Task Code" := Template.Code;
                ClosingLine.Description := Template.Description;
                ClosingLine.Category := Template.Category;
                ClosingLine."Sequence No." := Template."Sequence No.";
                ClosingLine."Responsible User" := Template."Responsible Role";
                ClosingLine."Est. Duration (Minutes)" := Template."Est. Duration (Minutes)";
                ClosingLine."Auto-Validate" := Template."Auto-Validate";
                ClosingLine."Validation Type" := Template."Validation Type";
                ClosingLine."Related Page ID" := Template."Related Page ID";
                ClosingLine."Related Report ID" := Template."Related Report ID";
                ClosingLine.Blocking := Template.Blocking;
                ClosingLine.Instructions := Template.Instructions;
                ClosingLine.Status := ClosingLine.Status::Pending;
                ClosingLine.Insert(true);
                LineNo += 10000;
            until Template.Next() = 0;
        end;

        Status := Status::"In Progress";
        "Started Date" := WorkDate();
        Modify();
    end;

    procedure CompleteClosing()
    var
        ClosingLine: Record "Month-End Closing Line";
    begin
        ClosingLine.SetRange("Document No.", "No.");
        ClosingLine.SetFilter(Status, '<>%1', ClosingLine.Status::Completed);
        if not ClosingLine.IsEmpty then
            Error('Cannot complete closing. There are %1 incomplete tasks.', ClosingLine.Count);

        Status := Status::Completed;
        "Completed Date" := WorkDate();
        "Completed By" := CopyStr(UserId, 1, 50);
        Modify();
    end;

    procedure ReopenClosing()
    begin
        if Status <> Status::Completed then
            Error('Only completed closings can be reopened.');

        Status := Status::"In Progress";
        "Completed Date" := 0D;
        "Completed By" := '';
        Modify();
    end;

    procedure GetCompletionPercentage(): Decimal
    begin
        CalcFields("Total Tasks", "Completed Tasks");
        if "Total Tasks" = 0 then
            exit(0);
        exit(Round("Completed Tasks" / "Total Tasks" * 100, 0.1));
    end;
}
````

---

### 5. Month-End Closing Status Enum

````al
// filepath: c:\Users\LukmanASULAIMAN\source\repos\QMB_Stabilization\QMB_Stabilization\Enums\MonthEndClosingStatus.Enum.al
enum 60082 "Month-End Closing Status"
{
    Caption = 'Month-End Closing Status';
    Extensible = true;

    value(0; Open)
    {
        Caption = 'Open';
    }
    value(1; "In Progress")
    {
        Caption = 'In Progress';
    }
    value(2; Completed)
    {
        Caption = 'Completed';
    }
    value(3; Cancelled)
    {
        Caption = 'Cancelled';
    }
```


## License: unknown
https://github.com/nadeemshirazi786/ENYOGBC14EXT-New/blob/cd36edfc35e9b163549a3e280889702a3be3d6d2/EN%20WMS/Enums/e14229227.ENWMSDocumentStatus.al

```
I'll help you implement a Month-End Closing Checklist feature to streamline and accelerate the month-end process. This will include a checklist table, page, and integration with the Role Center.

## Solution Overview

| Component | Purpose |
|-----------|---------|
| **Month-End Checklist Template** | Define reusable checklist items |
| **Month-End Closing Header** | Track each period's closing process |
| **Month-End Closing Line** | Individual tasks with status tracking |
| **Closing Checklist Page** | Manage and execute closing tasks |
| **Automation Codeunit** | Pre-validate and auto-complete tasks |

---

### 1. Month-End Checklist Template Table

````al
// filepath: c:\Users\LukmanASULAIMAN\source\repos\QMB_Stabilization\QMB_Stabilization\Tables\MonthEndChecklistTemplate.Table.al
table 60080 "Month-End Checklist Template"
{
    Caption = 'Month-End Checklist Template';
    DataClassification = CustomerContent;
    LookupPageId = "Month-End Checklist Templates";
    DrillDownPageId = "Month-End Checklist Templates";

    fields
    {
        field(1; "Code"; Code[20])
        {
            Caption = 'Code';
            NotBlank = true;
        }
        field(2; Description; Text[100])
        {
            Caption = 'Description';
        }
        field(3; "Sequence No."; Integer)
        {
            Caption = 'Sequence No.';
            MinValue = 1;
        }
        field(4; Category; Enum "Closing Task Category")
        {
            Caption = 'Category';
        }
        field(5; "Responsible Role"; Code[20])
        {
            Caption = 'Responsible Role';
            TableRelation = "User Setup"."User ID";
        }
        field(6; "Est. Duration (Minutes)"; Integer)
        {
            Caption = 'Est. Duration (Minutes)';
            MinValue = 0;
        }
        field(7; "Auto-Validate"; Boolean)
        {
            Caption = 'Auto-Validate';
            ToolTip = 'If enabled, the system will automatically check if this task is complete.';
        }
        field(8; "Validation Type"; Enum "Closing Validation Type")
        {
            Caption = 'Validation Type';
        }
        field(9; "Related Page ID"; Integer)
        {
            Caption = 'Related Page ID';
            TableRelation = AllObjWithCaption."Object ID" where("Object Type" = const(Page));
        }
        field(10; "Related Report ID"; Integer)
        {
            Caption = 'Related Report ID';
            TableRelation = AllObjWithCaption."Object ID" where("Object Type" = const(Report));
        }
        field(11; "Blocking"; Boolean)
        {
            Caption = 'Blocking';
            ToolTip = 'If enabled, subsequent tasks cannot start until this task is completed.';
        }
        field(12; "Instructions"; Text[2048])
        {
            Caption = 'Instructions';
        }
        field(13; Active; Boolean)
        {
            Caption = 'Active';
            InitValue = true;
        }
    }

    keys
    {
        key(PK; "Code")
        {
            Clustered = true;
        }
        key(Sequence; "Sequence No.")
        {
        }
        key(Category; Category, "Sequence No.")
        {
        }
    }

    trigger OnInsert()
    begin
        if "Sequence No." = 0 then
            "Sequence No." := GetNextSequenceNo();
    end;

    local procedure GetNextSequenceNo(): Integer
    var
        Template: Record "Month-End Checklist Template";
    begin
        Template.SetCurrentKey("Sequence No.");
        if Template.FindLast() then
            exit(Template."Sequence No." + 10)
        else
            exit(10);
    end;
}
````

---

### 2. Closing Task Category Enum

````al
// filepath: c:\Users\LukmanASULAIMAN\source\repos\QMB_Stabilization\QMB_Stabilization\Enums\ClosingTaskCategory.Enum.al
enum 60080 "Closing Task Category"
{
    Caption = 'Closing Task Category';
    Extensible = true;

    value(0; " ")
    {
        Caption = ' ';
    }
    value(1; "Pre-Closing")
    {
        Caption = 'Pre-Closing';
    }
    value(2; "Receivables")
    {
        Caption = 'Receivables';
    }
    value(3; "Payables")
    {
        Caption = 'Payables';
    }
    value(4; "Inventory")
    {
        Caption = 'Inventory';
    }
    value(5; "Fixed Assets")
    {
        Caption = 'Fixed Assets';
    }
    value(6; "Bank Reconciliation")
    {
        Caption = 'Bank Reconciliation';
    }
    value(7; "Expense Processing")
    {
        Caption = 'Expense Processing';
    }
    value(8; "Accruals & Deferrals")
    {
        Caption = 'Accruals & Deferrals';
    }
    value(9; "Intercompany")
    {
        Caption = 'Intercompany';
    }
    value(10; "Reporting")
    {
        Caption = 'Reporting';
    }
    value(11; "Final Review")
    {
        Caption = 'Final Review';
    }
}
````

---

### 3. Closing Validation Type Enum

````al
// filepath: c:\Users\LukmanASULAIMAN\source\repos\QMB_Stabilization\QMB_Stabilization\Enums\ClosingValidationType.Enum.al
enum 60081 "Closing Validation Type"
{
    Caption = 'Closing Validation Type';
    Extensible = true;

    value(0; "Manual")
    {
        Caption = 'Manual';
    }
    value(1; "No Open Expenses")
    {
        Caption = 'No Open Expenses';
    }
    value(2; "No Open Requisitions")
    {
        Caption = 'No Open Requisitions';
    }
    value(3; "No Pending Approvals")
    {
        Caption = 'No Pending Approvals';
    }
    value(4; "Bank Reconciled")
    {
        Caption = 'Bank Reconciled';
    }
    value(5; "No Unposted Journals")
    {
        Caption = 'No Unposted Journals';
    }
    value(6; "Inventory Adjusted")
    {
        Caption = 'Inventory Adjusted';
    }
    value(7; "Trial Balance Balanced")
    {
        Caption = 'Trial Balance Balanced';
    }
    value(8; "Budget Reviewed")
    {
        Caption = 'Budget Reviewed';
    }
}
````

---

### 4. Month-End Closing Header Table

````al
// filepath: c:\Users\LukmanASULAIMAN\source\repos\QMB_Stabilization\QMB_Stabilization\Tables\MonthEndClosingHeader.Table.al
table 60081 "Month-End Closing Header"
{
    Caption = 'Month-End Closing Header';
    DataClassification = CustomerContent;
    LookupPageId = "Month-End Closing List";
    DrillDownPageId = "Month-End Closing List";

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
        }
        field(2; "Accounting Period"; Code[10])
        {
            Caption = 'Accounting Period';
            TableRelation = "Accounting Period";

            trigger OnValidate()
            var
                AccPeriod: Record "Accounting Period";
            begin
                if AccPeriod.Get("Accounting Period") then begin
                    "Period Start Date" := AccPeriod."Starting Date";
                    "Period End Date" := CalcDate('<CM>', AccPeriod."Starting Date");
                    "Fiscal Year" := Date2DMY(AccPeriod."Starting Date", 3);
                end;
            end;
        }
        field(3; "Period Start Date"; Date)
        {
            Caption = 'Period Start Date';
            Editable = false;
        }
        field(4; "Period End Date"; Date)
        {
            Caption = 'Period End Date';
            Editable = false;
        }
        field(5; "Fiscal Year"; Integer)
        {
            Caption = 'Fiscal Year';
            Editable = false;
        }
        field(6; Status; Enum "Month-End Closing Status")
        {
            Caption = 'Status';
            Editable = false;
        }
        field(7; "Created By"; Code[50])
        {
            Caption = 'Created By';
            DataClassification = EndUserIdentifiableInformation;
            Editable = false;
        }
        field(8; "Created Date"; Date)
        {
            Caption = 'Created Date';
            Editable = false;
        }
        field(9; "Started Date"; Date)
        {
            Caption = 'Started Date';
            Editable = false;
        }
        field(10; "Completed Date"; Date)
        {
            Caption = 'Completed Date';
            Editable = false;
        }
        field(11; "Completed By"; Code[50])
        {
            Caption = 'Completed By';
            DataClassification = EndUserIdentifiableInformation;
            Editable = false;
        }
        field(12; "Total Tasks"; Integer)
        {
            Caption = 'Total Tasks';
            FieldClass = FlowField;
            CalcFormula = count("Month-End Closing Line" where("Document No." = field("No.")));
            Editable = false;
        }
        field(13; "Completed Tasks"; Integer)
        {
            Caption = 'Completed Tasks';
            FieldClass = FlowField;
            CalcFormula = count("Month-End Closing Line" where("Document No." = field("No."), Status = const(Completed)));
            Editable = false;
        }
        field(14; "Blocked Tasks"; Integer)
        {
            Caption = 'Blocked Tasks';
            FieldClass = FlowField;
            CalcFormula = count("Month-End Closing Line" where("Document No." = field("No."), Status = const(Blocked)));
            Editable = false;
        }
        field(15; "Comments"; Text[500])
        {
            Caption = 'Comments';
        }
    }

    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }
        key(Period; "Accounting Period", "Fiscal Year")
        {
        }
    }

    trigger OnInsert()
    var
        NoSeriesMgt: Codeunit NoSeriesManagement;
        CustomSetup: Record "Custom Setup";
    begin
        if "No." = '' then begin
            CustomSetup.Get();
            "No." := NoSeriesMgt.GetNextNo('MONTHEND', WorkDate(), true);
        end;
        "Created By" := CopyStr(UserId, 1, 50);
        "Created Date" := WorkDate();
        Status := Status::Open;
    end;

    trigger OnDelete()
    var
        ClosingLine: Record "Month-End Closing Line";
    begin
        if Status = Status::Completed then
            Error('Cannot delete a completed month-end closing.');

        ClosingLine.SetRange("Document No.", "No.");
        ClosingLine.DeleteAll(true);
    end;

    procedure InitializeFromTemplate()
    var
        Template: Record "Month-End Checklist Template";
        ClosingLine: Record "Month-End Closing Line";
        LineNo: Integer;
    begin
        if Status <> Status::Open then
            Error('Checklist can only be initialized when status is Open.');

        Template.SetRange(Active, true);
        Template.SetCurrentKey("Sequence No.");
        if Template.FindSet() then begin
            LineNo := 10000;
            repeat
                ClosingLine.Init();
                ClosingLine."Document No." := "No.";
                ClosingLine."Line No." := LineNo;
                ClosingLine."Task Code" := Template.Code;
                ClosingLine.Description := Template.Description;
                ClosingLine.Category := Template.Category;
                ClosingLine."Sequence No." := Template."Sequence No.";
                ClosingLine."Responsible User" := Template."Responsible Role";
                ClosingLine."Est. Duration (Minutes)" := Template."Est. Duration (Minutes)";
                ClosingLine."Auto-Validate" := Template."Auto-Validate";
                ClosingLine."Validation Type" := Template."Validation Type";
                ClosingLine."Related Page ID" := Template."Related Page ID";
                ClosingLine."Related Report ID" := Template."Related Report ID";
                ClosingLine.Blocking := Template.Blocking;
                ClosingLine.Instructions := Template.Instructions;
                ClosingLine.Status := ClosingLine.Status::Pending;
                ClosingLine.Insert(true);
                LineNo += 10000;
            until Template.Next() = 0;
        end;

        Status := Status::"In Progress";
        "Started Date" := WorkDate();
        Modify();
    end;

    procedure CompleteClosing()
    var
        ClosingLine: Record "Month-End Closing Line";
    begin
        ClosingLine.SetRange("Document No.", "No.");
        ClosingLine.SetFilter(Status, '<>%1', ClosingLine.Status::Completed);
        if not ClosingLine.IsEmpty then
            Error('Cannot complete closing. There are %1 incomplete tasks.', ClosingLine.Count);

        Status := Status::Completed;
        "Completed Date" := WorkDate();
        "Completed By" := CopyStr(UserId, 1, 50);
        Modify();
    end;

    procedure ReopenClosing()
    begin
        if Status <> Status::Completed then
            Error('Only completed closings can be reopened.');

        Status := Status::"In Progress";
        "Completed Date" := 0D;
        "Completed By" := '';
        Modify();
    end;

    procedure GetCompletionPercentage(): Decimal
    begin
        CalcFields("Total Tasks", "Completed Tasks");
        if "Total Tasks" = 0 then
            exit(0);
        exit(Round("Completed Tasks" / "Total Tasks" * 100, 0.1));
    end;
}
````

---

### 5. Month-End Closing Status Enum

````al
// filepath: c:\Users\LukmanASULAIMAN\source\repos\QMB_Stabilization\QMB_Stabilization\Enums\MonthEndClosingStatus.Enum.al
enum 60082 "Month-End Closing Status"
{
    Caption = 'Month-End Closing Status';
    Extensible = true;

    value(0; Open)
    {
        Caption = 'Open';
    }
    value(1; "In Progress")
    {
        Caption = 'In Progress';
    }
    value(2; Completed)
    {
        Caption = 'Completed';
    }
    value(3; Cancelled)
    {
        Caption = 'Cancelled';
    }
```


## License: unknown
https://github.com/nadeemshirazi786/ENYOGBC14EXT-New/blob/cd36edfc35e9b163549a3e280889702a3be3d6d2/EN%20WMS/Enums/e14229227.ENWMSDocumentStatus.al

```
I'll help you implement a Month-End Closing Checklist feature to streamline and accelerate the month-end process. This will include a checklist table, page, and integration with the Role Center.

## Solution Overview

| Component | Purpose |
|-----------|---------|
| **Month-End Checklist Template** | Define reusable checklist items |
| **Month-End Closing Header** | Track each period's closing process |
| **Month-End Closing Line** | Individual tasks with status tracking |
| **Closing Checklist Page** | Manage and execute closing tasks |
| **Automation Codeunit** | Pre-validate and auto-complete tasks |

---

### 1. Month-End Checklist Template Table

````al
// filepath: c:\Users\LukmanASULAIMAN\source\repos\QMB_Stabilization\QMB_Stabilization\Tables\MonthEndChecklistTemplate.Table.al
table 60080 "Month-End Checklist Template"
{
    Caption = 'Month-End Checklist Template';
    DataClassification = CustomerContent;
    LookupPageId = "Month-End Checklist Templates";
    DrillDownPageId = "Month-End Checklist Templates";

    fields
    {
        field(1; "Code"; Code[20])
        {
            Caption = 'Code';
            NotBlank = true;
        }
        field(2; Description; Text[100])
        {
            Caption = 'Description';
        }
        field(3; "Sequence No."; Integer)
        {
            Caption = 'Sequence No.';
            MinValue = 1;
        }
        field(4; Category; Enum "Closing Task Category")
        {
            Caption = 'Category';
        }
        field(5; "Responsible Role"; Code[20])
        {
            Caption = 'Responsible Role';
            TableRelation = "User Setup"."User ID";
        }
        field(6; "Est. Duration (Minutes)"; Integer)
        {
            Caption = 'Est. Duration (Minutes)';
            MinValue = 0;
        }
        field(7; "Auto-Validate"; Boolean)
        {
            Caption = 'Auto-Validate';
            ToolTip = 'If enabled, the system will automatically check if this task is complete.';
        }
        field(8; "Validation Type"; Enum "Closing Validation Type")
        {
            Caption = 'Validation Type';
        }
        field(9; "Related Page ID"; Integer)
        {
            Caption = 'Related Page ID';
            TableRelation = AllObjWithCaption."Object ID" where("Object Type" = const(Page));
        }
        field(10; "Related Report ID"; Integer)
        {
            Caption = 'Related Report ID';
            TableRelation = AllObjWithCaption."Object ID" where("Object Type" = const(Report));
        }
        field(11; "Blocking"; Boolean)
        {
            Caption = 'Blocking';
            ToolTip = 'If enabled, subsequent tasks cannot start until this task is completed.';
        }
        field(12; "Instructions"; Text[2048])
        {
            Caption = 'Instructions';
        }
        field(13; Active; Boolean)
        {
            Caption = 'Active';
            InitValue = true;
        }
    }

    keys
    {
        key(PK; "Code")
        {
            Clustered = true;
        }
        key(Sequence; "Sequence No.")
        {
        }
        key(Category; Category, "Sequence No.")
        {
        }
    }

    trigger OnInsert()
    begin
        if "Sequence No." = 0 then
            "Sequence No." := GetNextSequenceNo();
    end;

    local procedure GetNextSequenceNo(): Integer
    var
        Template: Record "Month-End Checklist Template";
    begin
        Template.SetCurrentKey("Sequence No.");
        if Template.FindLast() then
            exit(Template."Sequence No." + 10)
        else
            exit(10);
    end;
}
````

---

### 2. Closing Task Category Enum

````al
// filepath: c:\Users\LukmanASULAIMAN\source\repos\QMB_Stabilization\QMB_Stabilization\Enums\ClosingTaskCategory.Enum.al
enum 60080 "Closing Task Category"
{
    Caption = 'Closing Task Category';
    Extensible = true;

    value(0; " ")
    {
        Caption = ' ';
    }
    value(1; "Pre-Closing")
    {
        Caption = 'Pre-Closing';
    }
    value(2; "Receivables")
    {
        Caption = 'Receivables';
    }
    value(3; "Payables")
    {
        Caption = 'Payables';
    }
    value(4; "Inventory")
    {
        Caption = 'Inventory';
    }
    value(5; "Fixed Assets")
    {
        Caption = 'Fixed Assets';
    }
    value(6; "Bank Reconciliation")
    {
        Caption = 'Bank Reconciliation';
    }
    value(7; "Expense Processing")
    {
        Caption = 'Expense Processing';
    }
    value(8; "Accruals & Deferrals")
    {
        Caption = 'Accruals & Deferrals';
    }
    value(9; "Intercompany")
    {
        Caption = 'Intercompany';
    }
    value(10; "Reporting")
    {
        Caption = 'Reporting';
    }
    value(11; "Final Review")
    {
        Caption = 'Final Review';
    }
}
````

---

### 3. Closing Validation Type Enum

````al
// filepath: c:\Users\LukmanASULAIMAN\source\repos\QMB_Stabilization\QMB_Stabilization\Enums\ClosingValidationType.Enum.al
enum 60081 "Closing Validation Type"
{
    Caption = 'Closing Validation Type';
    Extensible = true;

    value(0; "Manual")
    {
        Caption = 'Manual';
    }
    value(1; "No Open Expenses")
    {
        Caption = 'No Open Expenses';
    }
    value(2; "No Open Requisitions")
    {
        Caption = 'No Open Requisitions';
    }
    value(3; "No Pending Approvals")
    {
        Caption = 'No Pending Approvals';
    }
    value(4; "Bank Reconciled")
    {
        Caption = 'Bank Reconciled';
    }
    value(5; "No Unposted Journals")
    {
        Caption = 'No Unposted Journals';
    }
    value(6; "Inventory Adjusted")
    {
        Caption = 'Inventory Adjusted';
    }
    value(7; "Trial Balance Balanced")
    {
        Caption = 'Trial Balance Balanced';
    }
    value(8; "Budget Reviewed")
    {
        Caption = 'Budget Reviewed';
    }
}
````

---

### 4. Month-End Closing Header Table

````al
// filepath: c:\Users\LukmanASULAIMAN\source\repos\QMB_Stabilization\QMB_Stabilization\Tables\MonthEndClosingHeader.Table.al
table 60081 "Month-End Closing Header"
{
    Caption = 'Month-End Closing Header';
    DataClassification = CustomerContent;
    LookupPageId = "Month-End Closing List";
    DrillDownPageId = "Month-End Closing List";

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
        }
        field(2; "Accounting Period"; Code[10])
        {
            Caption = 'Accounting Period';
            TableRelation = "Accounting Period";

            trigger OnValidate()
            var
                AccPeriod: Record "Accounting Period";
            begin
                if AccPeriod.Get("Accounting Period") then begin
                    "Period Start Date" := AccPeriod."Starting Date";
                    "Period End Date" := CalcDate('<CM>', AccPeriod."Starting Date");
                    "Fiscal Year" := Date2DMY(AccPeriod."Starting Date", 3);
                end;
            end;
        }
        field(3; "Period Start Date"; Date)
        {
            Caption = 'Period Start Date';
            Editable = false;
        }
        field(4; "Period End Date"; Date)
        {
            Caption = 'Period End Date';
            Editable = false;
        }
        field(5; "Fiscal Year"; Integer)
        {
            Caption = 'Fiscal Year';
            Editable = false;
        }
        field(6; Status; Enum "Month-End Closing Status")
        {
            Caption = 'Status';
            Editable = false;
        }
        field(7; "Created By"; Code[50])
        {
            Caption = 'Created By';
            DataClassification = EndUserIdentifiableInformation;
            Editable = false;
        }
        field(8; "Created Date"; Date)
        {
            Caption = 'Created Date';
            Editable = false;
        }
        field(9; "Started Date"; Date)
        {
            Caption = 'Started Date';
            Editable = false;
        }
        field(10; "Completed Date"; Date)
        {
            Caption = 'Completed Date';
            Editable = false;
        }
        field(11; "Completed By"; Code[50])
        {
            Caption = 'Completed By';
            DataClassification = EndUserIdentifiableInformation;
            Editable = false;
        }
        field(12; "Total Tasks"; Integer)
        {
            Caption = 'Total Tasks';
            FieldClass = FlowField;
            CalcFormula = count("Month-End Closing Line" where("Document No." = field("No.")));
            Editable = false;
        }
        field(13; "Completed Tasks"; Integer)
        {
            Caption = 'Completed Tasks';
            FieldClass = FlowField;
            CalcFormula = count("Month-End Closing Line" where("Document No." = field("No."), Status = const(Completed)));
            Editable = false;
        }
        field(14; "Blocked Tasks"; Integer)
        {
            Caption = 'Blocked Tasks';
            FieldClass = FlowField;
            CalcFormula = count("Month-End Closing Line" where("Document No." = field("No."), Status = const(Blocked)));
            Editable = false;
        }
        field(15; "Comments"; Text[500])
        {
            Caption = 'Comments';
        }
    }

    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }
        key(Period; "Accounting Period", "Fiscal Year")
        {
        }
    }

    trigger OnInsert()
    var
        NoSeriesMgt: Codeunit NoSeriesManagement;
        CustomSetup: Record "Custom Setup";
    begin
        if "No." = '' then begin
            CustomSetup.Get();
            "No." := NoSeriesMgt.GetNextNo('MONTHEND', WorkDate(), true);
        end;
        "Created By" := CopyStr(UserId, 1, 50);
        "Created Date" := WorkDate();
        Status := Status::Open;
    end;

    trigger OnDelete()
    var
        ClosingLine: Record "Month-End Closing Line";
    begin
        if Status = Status::Completed then
            Error('Cannot delete a completed month-end closing.');

        ClosingLine.SetRange("Document No.", "No.");
        ClosingLine.DeleteAll(true);
    end;

    procedure InitializeFromTemplate()
    var
        Template: Record "Month-End Checklist Template";
        ClosingLine: Record "Month-End Closing Line";
        LineNo: Integer;
    begin
        if Status <> Status::Open then
            Error('Checklist can only be initialized when status is Open.');

        Template.SetRange(Active, true);
        Template.SetCurrentKey("Sequence No.");
        if Template.FindSet() then begin
            LineNo := 10000;
            repeat
                ClosingLine.Init();
                ClosingLine."Document No." := "No.";
                ClosingLine."Line No." := LineNo;
                ClosingLine."Task Code" := Template.Code;
                ClosingLine.Description := Template.Description;
                ClosingLine.Category := Template.Category;
                ClosingLine."Sequence No." := Template."Sequence No.";
                ClosingLine."Responsible User" := Template."Responsible Role";
                ClosingLine."Est. Duration (Minutes)" := Template."Est. Duration (Minutes)";
                ClosingLine."Auto-Validate" := Template."Auto-Validate";
                ClosingLine."Validation Type" := Template."Validation Type";
                ClosingLine."Related Page ID" := Template."Related Page ID";
                ClosingLine."Related Report ID" := Template."Related Report ID";
                ClosingLine.Blocking := Template.Blocking;
                ClosingLine.Instructions := Template.Instructions;
                ClosingLine.Status := ClosingLine.Status::Pending;
                ClosingLine.Insert(true);
                LineNo += 10000;
            until Template.Next() = 0;
        end;

        Status := Status::"In Progress";
        "Started Date" := WorkDate();
        Modify();
    end;

    procedure CompleteClosing()
    var
        ClosingLine: Record "Month-End Closing Line";
    begin
        ClosingLine.SetRange("Document No.", "No.");
        ClosingLine.SetFilter(Status, '<>%1', ClosingLine.Status::Completed);
        if not ClosingLine.IsEmpty then
            Error('Cannot complete closing. There are %1 incomplete tasks.', ClosingLine.Count);

        Status := Status::Completed;
        "Completed Date" := WorkDate();
        "Completed By" := CopyStr(UserId, 1, 50);
        Modify();
    end;

    procedure ReopenClosing()
    begin
        if Status <> Status::Completed then
            Error('Only completed closings can be reopened.');

        Status := Status::"In Progress";
        "Completed Date" := 0D;
        "Completed By" := '';
        Modify();
    end;

    procedure GetCompletionPercentage(): Decimal
    begin
        CalcFields("Total Tasks", "Completed Tasks");
        if "Total Tasks" = 0 then
            exit(0);
        exit(Round("Completed Tasks" / "Total Tasks" * 100, 0.1));
    end;
}
````

---

### 5. Month-End Closing Status Enum

````al
// filepath: c:\Users\LukmanASULAIMAN\source\repos\QMB_Stabilization\QMB_Stabilization\Enums\MonthEndClosingStatus.Enum.al
enum 60082 "Month-End Closing Status"
{
    Caption = 'Month-End Closing Status';
    Extensible = true;

    value(0; Open)
    {
        Caption = 'Open';
    }
    value(1; "In Progress")
    {
        Caption = 'In Progress';
    }
    value(2; Completed)
    {
        Caption = 'Completed';
    }
    value(3; Cancelled)
    {
        Caption = 'Cancelled';
    }
```


## License: unknown
https://github.com/nadeemshirazi786/ENYOGBC14EXT-New/blob/cd36edfc35e9b163549a3e280889702a3be3d6d2/EN%20WMS/Enums/e14229227.ENWMSDocumentStatus.al

```
I'll help you implement a Month-End Closing Checklist feature to streamline and accelerate the month-end process. This will include a checklist table, page, and integration with the Role Center.

## Solution Overview

| Component | Purpose |
|-----------|---------|
| **Month-End Checklist Template** | Define reusable checklist items |
| **Month-End Closing Header** | Track each period's closing process |
| **Month-End Closing Line** | Individual tasks with status tracking |
| **Closing Checklist Page** | Manage and execute closing tasks |
| **Automation Codeunit** | Pre-validate and auto-complete tasks |

---

### 1. Month-End Checklist Template Table

````al
// filepath: c:\Users\LukmanASULAIMAN\source\repos\QMB_Stabilization\QMB_Stabilization\Tables\MonthEndChecklistTemplate.Table.al
table 60080 "Month-End Checklist Template"
{
    Caption = 'Month-End Checklist Template';
    DataClassification = CustomerContent;
    LookupPageId = "Month-End Checklist Templates";
    DrillDownPageId = "Month-End Checklist Templates";

    fields
    {
        field(1; "Code"; Code[20])
        {
            Caption = 'Code';
            NotBlank = true;
        }
        field(2; Description; Text[100])
        {
            Caption = 'Description';
        }
        field(3; "Sequence No."; Integer)
        {
            Caption = 'Sequence No.';
            MinValue = 1;
        }
        field(4; Category; Enum "Closing Task Category")
        {
            Caption = 'Category';
        }
        field(5; "Responsible Role"; Code[20])
        {
            Caption = 'Responsible Role';
            TableRelation = "User Setup"."User ID";
        }
        field(6; "Est. Duration (Minutes)"; Integer)
        {
            Caption = 'Est. Duration (Minutes)';
            MinValue = 0;
        }
        field(7; "Auto-Validate"; Boolean)
        {
            Caption = 'Auto-Validate';
            ToolTip = 'If enabled, the system will automatically check if this task is complete.';
        }
        field(8; "Validation Type"; Enum "Closing Validation Type")
        {
            Caption = 'Validation Type';
        }
        field(9; "Related Page ID"; Integer)
        {
            Caption = 'Related Page ID';
            TableRelation = AllObjWithCaption."Object ID" where("Object Type" = const(Page));
        }
        field(10; "Related Report ID"; Integer)
        {
            Caption = 'Related Report ID';
            TableRelation = AllObjWithCaption."Object ID" where("Object Type" = const(Report));
        }
        field(11; "Blocking"; Boolean)
        {
            Caption = 'Blocking';
            ToolTip = 'If enabled, subsequent tasks cannot start until this task is completed.';
        }
        field(12; "Instructions"; Text[2048])
        {
            Caption = 'Instructions';
        }
        field(13; Active; Boolean)
        {
            Caption = 'Active';
            InitValue = true;
        }
    }

    keys
    {
        key(PK; "Code")
        {
            Clustered = true;
        }
        key(Sequence; "Sequence No.")
        {
        }
        key(Category; Category, "Sequence No.")
        {
        }
    }

    trigger OnInsert()
    begin
        if "Sequence No." = 0 then
            "Sequence No." := GetNextSequenceNo();
    end;

    local procedure GetNextSequenceNo(): Integer
    var
        Template: Record "Month-End Checklist Template";
    begin
        Template.SetCurrentKey("Sequence No.");
        if Template.FindLast() then
            exit(Template."Sequence No." + 10)
        else
            exit(10);
    end;
}
````

---

### 2. Closing Task Category Enum

````al
// filepath: c:\Users\LukmanASULAIMAN\source\repos\QMB_Stabilization\QMB_Stabilization\Enums\ClosingTaskCategory.Enum.al
enum 60080 "Closing Task Category"
{
    Caption = 'Closing Task Category';
    Extensible = true;

    value(0; " ")
    {
        Caption = ' ';
    }
    value(1; "Pre-Closing")
    {
        Caption = 'Pre-Closing';
    }
    value(2; "Receivables")
    {
        Caption = 'Receivables';
    }
    value(3; "Payables")
    {
        Caption = 'Payables';
    }
    value(4; "Inventory")
    {
        Caption = 'Inventory';
    }
    value(5; "Fixed Assets")
    {
        Caption = 'Fixed Assets';
    }
    value(6; "Bank Reconciliation")
    {
        Caption = 'Bank Reconciliation';
    }
    value(7; "Expense Processing")
    {
        Caption = 'Expense Processing';
    }
    value(8; "Accruals & Deferrals")
    {
        Caption = 'Accruals & Deferrals';
    }
    value(9; "Intercompany")
    {
        Caption = 'Intercompany';
    }
    value(10; "Reporting")
    {
        Caption = 'Reporting';
    }
    value(11; "Final Review")
    {
        Caption = 'Final Review';
    }
}
````

---

### 3. Closing Validation Type Enum

````al
// filepath: c:\Users\LukmanASULAIMAN\source\repos\QMB_Stabilization\QMB_Stabilization\Enums\ClosingValidationType.Enum.al
enum 60081 "Closing Validation Type"
{
    Caption = 'Closing Validation Type';
    Extensible = true;

    value(0; "Manual")
    {
        Caption = 'Manual';
    }
    value(1; "No Open Expenses")
    {
        Caption = 'No Open Expenses';
    }
    value(2; "No Open Requisitions")
    {
        Caption = 'No Open Requisitions';
    }
    value(3; "No Pending Approvals")
    {
        Caption = 'No Pending Approvals';
    }
    value(4; "Bank Reconciled")
    {
        Caption = 'Bank Reconciled';
    }
    value(5; "No Unposted Journals")
    {
        Caption = 'No Unposted Journals';
    }
    value(6; "Inventory Adjusted")
    {
        Caption = 'Inventory Adjusted';
    }
    value(7; "Trial Balance Balanced")
    {
        Caption = 'Trial Balance Balanced';
    }
    value(8; "Budget Reviewed")
    {
        Caption = 'Budget Reviewed';
    }
}
````

---

### 4. Month-End Closing Header Table

````al
// filepath: c:\Users\LukmanASULAIMAN\source\repos\QMB_Stabilization\QMB_Stabilization\Tables\MonthEndClosingHeader.Table.al
table 60081 "Month-End Closing Header"
{
    Caption = 'Month-End Closing Header';
    DataClassification = CustomerContent;
    LookupPageId = "Month-End Closing List";
    DrillDownPageId = "Month-End Closing List";

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
        }
        field(2; "Accounting Period"; Code[10])
        {
            Caption = 'Accounting Period';
            TableRelation = "Accounting Period";

            trigger OnValidate()
            var
                AccPeriod: Record "Accounting Period";
            begin
                if AccPeriod.Get("Accounting Period") then begin
                    "Period Start Date" := AccPeriod."Starting Date";
                    "Period End Date" := CalcDate('<CM>', AccPeriod."Starting Date");
                    "Fiscal Year" := Date2DMY(AccPeriod."Starting Date", 3);
                end;
            end;
        }
        field(3; "Period Start Date"; Date)
        {
            Caption = 'Period Start Date';
            Editable = false;
        }
        field(4; "Period End Date"; Date)
        {
            Caption = 'Period End Date';
            Editable = false;
        }
        field(5; "Fiscal Year"; Integer)
        {
            Caption = 'Fiscal Year';
            Editable = false;
        }
        field(6; Status; Enum "Month-End Closing Status")
        {
            Caption = 'Status';
            Editable = false;
        }
        field(7; "Created By"; Code[50])
        {
            Caption = 'Created By';
            DataClassification = EndUserIdentifiableInformation;
            Editable = false;
        }
        field(8; "Created Date"; Date)
        {
            Caption = 'Created Date';
            Editable = false;
        }
        field(9; "Started Date"; Date)
        {
            Caption = 'Started Date';
            Editable = false;
        }
        field(10; "Completed Date"; Date)
        {
            Caption = 'Completed Date';
            Editable = false;
        }
        field(11; "Completed By"; Code[50])
        {
            Caption = 'Completed By';
            DataClassification = EndUserIdentifiableInformation;
            Editable = false;
        }
        field(12; "Total Tasks"; Integer)
        {
            Caption = 'Total Tasks';
            FieldClass = FlowField;
            CalcFormula = count("Month-End Closing Line" where("Document No." = field("No.")));
            Editable = false;
        }
        field(13; "Completed Tasks"; Integer)
        {
            Caption = 'Completed Tasks';
            FieldClass = FlowField;
            CalcFormula = count("Month-End Closing Line" where("Document No." = field("No."), Status = const(Completed)));
            Editable = false;
        }
        field(14; "Blocked Tasks"; Integer)
        {
            Caption = 'Blocked Tasks';
            FieldClass = FlowField;
            CalcFormula = count("Month-End Closing Line" where("Document No." = field("No."), Status = const(Blocked)));
            Editable = false;
        }
        field(15; "Comments"; Text[500])
        {
            Caption = 'Comments';
        }
    }

    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }
        key(Period; "Accounting Period", "Fiscal Year")
        {
        }
    }

    trigger OnInsert()
    var
        NoSeriesMgt: Codeunit NoSeriesManagement;
        CustomSetup: Record "Custom Setup";
    begin
        if "No." = '' then begin
            CustomSetup.Get();
            "No." := NoSeriesMgt.GetNextNo('MONTHEND', WorkDate(), true);
        end;
        "Created By" := CopyStr(UserId, 1, 50);
        "Created Date" := WorkDate();
        Status := Status::Open;
    end;

    trigger OnDelete()
    var
        ClosingLine: Record "Month-End Closing Line";
    begin
        if Status = Status::Completed then
            Error('Cannot delete a completed month-end closing.');

        ClosingLine.SetRange("Document No.", "No.");
        ClosingLine.DeleteAll(true);
    end;

    procedure InitializeFromTemplate()
    var
        Template: Record "Month-End Checklist Template";
        ClosingLine: Record "Month-End Closing Line";
        LineNo: Integer;
    begin
        if Status <> Status::Open then
            Error('Checklist can only be initialized when status is Open.');

        Template.SetRange(Active, true);
        Template.SetCurrentKey("Sequence No.");
        if Template.FindSet() then begin
            LineNo := 10000;
            repeat
                ClosingLine.Init();
                ClosingLine."Document No." := "No.";
                ClosingLine."Line No." := LineNo;
                ClosingLine."Task Code" := Template.Code;
                ClosingLine.Description := Template.Description;
                ClosingLine.Category := Template.Category;
                ClosingLine."Sequence No." := Template."Sequence No.";
                ClosingLine."Responsible User" := Template."Responsible Role";
                ClosingLine."Est. Duration (Minutes)" := Template."Est. Duration (Minutes)";
                ClosingLine."Auto-Validate" := Template."Auto-Validate";
                ClosingLine."Validation Type" := Template."Validation Type";
                ClosingLine."Related Page ID" := Template."Related Page ID";
                ClosingLine."Related Report ID" := Template."Related Report ID";
                ClosingLine.Blocking := Template.Blocking;
                ClosingLine.Instructions := Template.Instructions;
                ClosingLine.Status := ClosingLine.Status::Pending;
                ClosingLine.Insert(true);
                LineNo += 10000;
            until Template.Next() = 0;
        end;

        Status := Status::"In Progress";
        "Started Date" := WorkDate();
        Modify();
    end;

    procedure CompleteClosing()
    var
        ClosingLine: Record "Month-End Closing Line";
    begin
        ClosingLine.SetRange("Document No.", "No.");
        ClosingLine.SetFilter(Status, '<>%1', ClosingLine.Status::Completed);
        if not ClosingLine.IsEmpty then
            Error('Cannot complete closing. There are %1 incomplete tasks.', ClosingLine.Count);

        Status := Status::Completed;
        "Completed Date" := WorkDate();
        "Completed By" := CopyStr(UserId, 1, 50);
        Modify();
    end;

    procedure ReopenClosing()
    begin
        if Status <> Status::Completed then
            Error('Only completed closings can be reopened.');

        Status := Status::"In Progress";
        "Completed Date" := 0D;
        "Completed By" := '';
        Modify();
    end;

    procedure GetCompletionPercentage(): Decimal
    begin
        CalcFields("Total Tasks", "Completed Tasks");
        if "Total Tasks" = 0 then
            exit(0);
        exit(Round("Completed Tasks" / "Total Tasks" * 100, 0.1));
    end;
}
````

---

### 5. Month-End Closing Status Enum

````al
// filepath: c:\Users\LukmanASULAIMAN\source\repos\QMB_Stabilization\QMB_Stabilization\Enums\MonthEndClosingStatus.Enum.al
enum 60082 "Month-End Closing Status"
{
    Caption = 'Month-End Closing Status';
    Extensible = true;

    value(0; Open)
    {
        Caption = 'Open';
    }
    value(1; "In Progress")
    {
        Caption = 'In Progress';
    }
    value(2; Completed)
    {
        Caption = 'Completed';
    }
    value(3; Cancelled)
    {
        Caption = 'Cancelled';
    }
```


## License: unknown
https://github.com/nadeemshirazi786/ENYOGBC14EXT-New/blob/cd36edfc35e9b163549a3e280889702a3be3d6d2/EN%20WMS/Enums/e14229227.ENWMSDocumentStatus.al

```
I'll help you implement a Month-End Closing Checklist feature to streamline and accelerate the month-end process. This will include a checklist table, page, and integration with the Role Center.

## Solution Overview

| Component | Purpose |
|-----------|---------|
| **Month-End Checklist Template** | Define reusable checklist items |
| **Month-End Closing Header** | Track each period's closing process |
| **Month-End Closing Line** | Individual tasks with status tracking |
| **Closing Checklist Page** | Manage and execute closing tasks |
| **Automation Codeunit** | Pre-validate and auto-complete tasks |

---

### 1. Month-End Checklist Template Table

````al
// filepath: c:\Users\LukmanASULAIMAN\source\repos\QMB_Stabilization\QMB_Stabilization\Tables\MonthEndChecklistTemplate.Table.al
table 60080 "Month-End Checklist Template"
{
    Caption = 'Month-End Checklist Template';
    DataClassification = CustomerContent;
    LookupPageId = "Month-End Checklist Templates";
    DrillDownPageId = "Month-End Checklist Templates";

    fields
    {
        field(1; "Code"; Code[20])
        {
            Caption = 'Code';
            NotBlank = true;
        }
        field(2; Description; Text[100])
        {
            Caption = 'Description';
        }
        field(3; "Sequence No."; Integer)
        {
            Caption = 'Sequence No.';
            MinValue = 1;
        }
        field(4; Category; Enum "Closing Task Category")
        {
            Caption = 'Category';
        }
        field(5; "Responsible Role"; Code[20])
        {
            Caption = 'Responsible Role';
            TableRelation = "User Setup"."User ID";
        }
        field(6; "Est. Duration (Minutes)"; Integer)
        {
            Caption = 'Est. Duration (Minutes)';
            MinValue = 0;
        }
        field(7; "Auto-Validate"; Boolean)
        {
            Caption = 'Auto-Validate';
            ToolTip = 'If enabled, the system will automatically check if this task is complete.';
        }
        field(8; "Validation Type"; Enum "Closing Validation Type")
        {
            Caption = 'Validation Type';
        }
        field(9; "Related Page ID"; Integer)
        {
            Caption = 'Related Page ID';
            TableRelation = AllObjWithCaption."Object ID" where("Object Type" = const(Page));
        }
        field(10; "Related Report ID"; Integer)
        {
            Caption = 'Related Report ID';
            TableRelation = AllObjWithCaption."Object ID" where("Object Type" = const(Report));
        }
        field(11; "Blocking"; Boolean)
        {
            Caption = 'Blocking';
            ToolTip = 'If enabled, subsequent tasks cannot start until this task is completed.';
        }
        field(12; "Instructions"; Text[2048])
        {
            Caption = 'Instructions';
        }
        field(13; Active; Boolean)
        {
            Caption = 'Active';
            InitValue = true;
        }
    }

    keys
    {
        key(PK; "Code")
        {
            Clustered = true;
        }
        key(Sequence; "Sequence No.")
        {
        }
        key(Category; Category, "Sequence No.")
        {
        }
    }

    trigger OnInsert()
    begin
        if "Sequence No." = 0 then
            "Sequence No." := GetNextSequenceNo();
    end;

    local procedure GetNextSequenceNo(): Integer
    var
        Template: Record "Month-End Checklist Template";
    begin
        Template.SetCurrentKey("Sequence No.");
        if Template.FindLast() then
            exit(Template."Sequence No." + 10)
        else
            exit(10);
    end;
}
````

---

### 2. Closing Task Category Enum

````al
// filepath: c:\Users\LukmanASULAIMAN\source\repos\QMB_Stabilization\QMB_Stabilization\Enums\ClosingTaskCategory.Enum.al
enum 60080 "Closing Task Category"
{
    Caption = 'Closing Task Category';
    Extensible = true;

    value(0; " ")
    {
        Caption = ' ';
    }
    value(1; "Pre-Closing")
    {
        Caption = 'Pre-Closing';
    }
    value(2; "Receivables")
    {
        Caption = 'Receivables';
    }
    value(3; "Payables")
    {
        Caption = 'Payables';
    }
    value(4; "Inventory")
    {
        Caption = 'Inventory';
    }
    value(5; "Fixed Assets")
    {
        Caption = 'Fixed Assets';
    }
    value(6; "Bank Reconciliation")
    {
        Caption = 'Bank Reconciliation';
    }
    value(7; "Expense Processing")
    {
        Caption = 'Expense Processing';
    }
    value(8; "Accruals & Deferrals")
    {
        Caption = 'Accruals & Deferrals';
    }
    value(9; "Intercompany")
    {
        Caption = 'Intercompany';
    }
    value(10; "Reporting")
    {
        Caption = 'Reporting';
    }
    value(11; "Final Review")
    {
        Caption = 'Final Review';
    }
}
````

---

### 3. Closing Validation Type Enum

````al
// filepath: c:\Users\LukmanASULAIMAN\source\repos\QMB_Stabilization\QMB_Stabilization\Enums\ClosingValidationType.Enum.al
enum 60081 "Closing Validation Type"
{
    Caption = 'Closing Validation Type';
    Extensible = true;

    value(0; "Manual")
    {
        Caption = 'Manual';
    }
    value(1; "No Open Expenses")
    {
        Caption = 'No Open Expenses';
    }
    value(2; "No Open Requisitions")
    {
        Caption = 'No Open Requisitions';
    }
    value(3; "No Pending Approvals")
    {
        Caption = 'No Pending Approvals';
    }
    value(4; "Bank Reconciled")
    {
        Caption = 'Bank Reconciled';
    }
    value(5; "No Unposted Journals")
    {
        Caption = 'No Unposted Journals';
    }
    value(6; "Inventory Adjusted")
    {
        Caption = 'Inventory Adjusted';
    }
    value(7; "Trial Balance Balanced")
    {
        Caption = 'Trial Balance Balanced';
    }
    value(8; "Budget Reviewed")
    {
        Caption = 'Budget Reviewed';
    }
}
````

---

### 4. Month-End Closing Header Table

````al
// filepath: c:\Users\LukmanASULAIMAN\source\repos\QMB_Stabilization\QMB_Stabilization\Tables\MonthEndClosingHeader.Table.al
table 60081 "Month-End Closing Header"
{
    Caption = 'Month-End Closing Header';
    DataClassification = CustomerContent;
    LookupPageId = "Month-End Closing List";
    DrillDownPageId = "Month-End Closing List";

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
        }
        field(2; "Accounting Period"; Code[10])
        {
            Caption = 'Accounting Period';
            TableRelation = "Accounting Period";

            trigger OnValidate()
            var
                AccPeriod: Record "Accounting Period";
            begin
                if AccPeriod.Get("Accounting Period") then begin
                    "Period Start Date" := AccPeriod."Starting Date";
                    "Period End Date" := CalcDate('<CM>', AccPeriod."Starting Date");
                    "Fiscal Year" := Date2DMY(AccPeriod."Starting Date", 3);
                end;
            end;
        }
        field(3; "Period Start Date"; Date)
        {
            Caption = 'Period Start Date';
            Editable = false;
        }
        field(4; "Period End Date"; Date)
        {
            Caption = 'Period End Date';
            Editable = false;
        }
        field(5; "Fiscal Year"; Integer)
        {
            Caption = 'Fiscal Year';
            Editable = false;
        }
        field(6; Status; Enum "Month-End Closing Status")
        {
            Caption = 'Status';
            Editable = false;
        }
        field(7; "Created By"; Code[50])
        {
            Caption = 'Created By';
            DataClassification = EndUserIdentifiableInformation;
            Editable = false;
        }
        field(8; "Created Date"; Date)
        {
            Caption = 'Created Date';
            Editable = false;
        }
        field(9; "Started Date"; Date)
        {
            Caption = 'Started Date';
            Editable = false;
        }
        field(10; "Completed Date"; Date)
        {
            Caption = 'Completed Date';
            Editable = false;
        }
        field(11; "Completed By"; Code[50])
        {
            Caption = 'Completed By';
            DataClassification = EndUserIdentifiableInformation;
            Editable = false;
        }
        field(12; "Total Tasks"; Integer)
        {
            Caption = 'Total Tasks';
            FieldClass = FlowField;
            CalcFormula = count("Month-End Closing Line" where("Document No." = field("No.")));
            Editable = false;
        }
        field(13; "Completed Tasks"; Integer)
        {
            Caption = 'Completed Tasks';
            FieldClass = FlowField;
            CalcFormula = count("Month-End Closing Line" where("Document No." = field("No."), Status = const(Completed)));
            Editable = false;
        }
        field(14; "Blocked Tasks"; Integer)
        {
            Caption = 'Blocked Tasks';
            FieldClass = FlowField;
            CalcFormula = count("Month-End Closing Line" where("Document No." = field("No."), Status = const(Blocked)));
            Editable = false;
        }
        field(15; "Comments"; Text[500])
        {
            Caption = 'Comments';
        }
    }

    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }
        key(Period; "Accounting Period", "Fiscal Year")
        {
        }
    }

    trigger OnInsert()
    var
        NoSeriesMgt: Codeunit NoSeriesManagement;
        CustomSetup: Record "Custom Setup";
    begin
        if "No." = '' then begin
            CustomSetup.Get();
            "No." := NoSeriesMgt.GetNextNo('MONTHEND', WorkDate(), true);
        end;
        "Created By" := CopyStr(UserId, 1, 50);
        "Created Date" := WorkDate();
        Status := Status::Open;
    end;

    trigger OnDelete()
    var
        ClosingLine: Record "Month-End Closing Line";
    begin
        if Status = Status::Completed then
            Error('Cannot delete a completed month-end closing.');

        ClosingLine.SetRange("Document No.", "No.");
        ClosingLine.DeleteAll(true);
    end;

    procedure InitializeFromTemplate()
    var
        Template: Record "Month-End Checklist Template";
        ClosingLine: Record "Month-End Closing Line";
        LineNo: Integer;
    begin
        if Status <> Status::Open then
            Error('Checklist can only be initialized when status is Open.');

        Template.SetRange(Active, true);
        Template.SetCurrentKey("Sequence No.");
        if Template.FindSet() then begin
            LineNo := 10000;
            repeat
                ClosingLine.Init();
                ClosingLine."Document No." := "No.";
                ClosingLine."Line No." := LineNo;
                ClosingLine."Task Code" := Template.Code;
                ClosingLine.Description := Template.Description;
                ClosingLine.Category := Template.Category;
                ClosingLine."Sequence No." := Template."Sequence No.";
                ClosingLine."Responsible User" := Template."Responsible Role";
                ClosingLine."Est. Duration (Minutes)" := Template."Est. Duration (Minutes)";
                ClosingLine."Auto-Validate" := Template."Auto-Validate";
                ClosingLine."Validation Type" := Template."Validation Type";
                ClosingLine."Related Page ID" := Template."Related Page ID";
                ClosingLine."Related Report ID" := Template."Related Report ID";
                ClosingLine.Blocking := Template.Blocking;
                ClosingLine.Instructions := Template.Instructions;
                ClosingLine.Status := ClosingLine.Status::Pending;
                ClosingLine.Insert(true);
                LineNo += 10000;
            until Template.Next() = 0;
        end;

        Status := Status::"In Progress";
        "Started Date" := WorkDate();
        Modify();
    end;

    procedure CompleteClosing()
    var
        ClosingLine: Record "Month-End Closing Line";
    begin
        ClosingLine.SetRange("Document No.", "No.");
        ClosingLine.SetFilter(Status, '<>%1', ClosingLine.Status::Completed);
        if not ClosingLine.IsEmpty then
            Error('Cannot complete closing. There are %1 incomplete tasks.', ClosingLine.Count);

        Status := Status::Completed;
        "Completed Date" := WorkDate();
        "Completed By" := CopyStr(UserId, 1, 50);
        Modify();
    end;

    procedure ReopenClosing()
    begin
        if Status <> Status::Completed then
            Error('Only completed closings can be reopened.');

        Status := Status::"In Progress";
        "Completed Date" := 0D;
        "Completed By" := '';
        Modify();
    end;

    procedure GetCompletionPercentage(): Decimal
    begin
        CalcFields("Total Tasks", "Completed Tasks");
        if "Total Tasks" = 0 then
            exit(0);
        exit(Round("Completed Tasks" / "Total Tasks" * 100, 0.1));
    end;
}
````

---

### 5. Month-End Closing Status Enum

````al
// filepath: c:\Users\LukmanASULAIMAN\source\repos\QMB_Stabilization\QMB_Stabilization\Enums\MonthEndClosingStatus.Enum.al
enum 60082 "Month-End Closing Status"
{
    Caption = 'Month-End Closing Status';
    Extensible = true;

    value(0; Open)
    {
        Caption = 'Open';
    }
    value(1; "In Progress")
    {
        Caption = 'In Progress';
    }
    value(2; Completed)
    {
        Caption = 'Completed';
    }
    value(3; Cancelled)
    {
        Caption = 'Cancelled';
    }
```


## License: unknown
https://github.com/nadeemshirazi786/ENYOGBC14EXT-New/blob/cd36edfc35e9b163549a3e280889702a3be3d6d2/EN%20WMS/Enums/e14229227.ENWMSDocumentStatus.al

```
I'll help you implement a Month-End Closing Checklist feature to streamline and accelerate the month-end process. This will include a checklist table, page, and integration with the Role Center.

## Solution Overview

| Component | Purpose |
|-----------|---------|
| **Month-End Checklist Template** | Define reusable checklist items |
| **Month-End Closing Header** | Track each period's closing process |
| **Month-End Closing Line** | Individual tasks with status tracking |
| **Closing Checklist Page** | Manage and execute closing tasks |
| **Automation Codeunit** | Pre-validate and auto-complete tasks |

---

### 1. Month-End Checklist Template Table

````al
// filepath: c:\Users\LukmanASULAIMAN\source\repos\QMB_Stabilization\QMB_Stabilization\Tables\MonthEndChecklistTemplate.Table.al
table 60080 "Month-End Checklist Template"
{
    Caption = 'Month-End Checklist Template';
    DataClassification = CustomerContent;
    LookupPageId = "Month-End Checklist Templates";
    DrillDownPageId = "Month-End Checklist Templates";

    fields
    {
        field(1; "Code"; Code[20])
        {
            Caption = 'Code';
            NotBlank = true;
        }
        field(2; Description; Text[100])
        {
            Caption = 'Description';
        }
        field(3; "Sequence No."; Integer)
        {
            Caption = 'Sequence No.';
            MinValue = 1;
        }
        field(4; Category; Enum "Closing Task Category")
        {
            Caption = 'Category';
        }
        field(5; "Responsible Role"; Code[20])
        {
            Caption = 'Responsible Role';
            TableRelation = "User Setup"."User ID";
        }
        field(6; "Est. Duration (Minutes)"; Integer)
        {
            Caption = 'Est. Duration (Minutes)';
            MinValue = 0;
        }
        field(7; "Auto-Validate"; Boolean)
        {
            Caption = 'Auto-Validate';
            ToolTip = 'If enabled, the system will automatically check if this task is complete.';
        }
        field(8; "Validation Type"; Enum "Closing Validation Type")
        {
            Caption = 'Validation Type';
        }
        field(9; "Related Page ID"; Integer)
        {
            Caption = 'Related Page ID';
            TableRelation = AllObjWithCaption."Object ID" where("Object Type" = const(Page));
        }
        field(10; "Related Report ID"; Integer)
        {
            Caption = 'Related Report ID';
            TableRelation = AllObjWithCaption."Object ID" where("Object Type" = const(Report));
        }
        field(11; "Blocking"; Boolean)
        {
            Caption = 'Blocking';
            ToolTip = 'If enabled, subsequent tasks cannot start until this task is completed.';
        }
        field(12; "Instructions"; Text[2048])
        {
            Caption = 'Instructions';
        }
        field(13; Active; Boolean)
        {
            Caption = 'Active';
            InitValue = true;
        }
    }

    keys
    {
        key(PK; "Code")
        {
            Clustered = true;
        }
        key(Sequence; "Sequence No.")
        {
        }
        key(Category; Category, "Sequence No.")
        {
        }
    }

    trigger OnInsert()
    begin
        if "Sequence No." = 0 then
            "Sequence No." := GetNextSequenceNo();
    end;

    local procedure GetNextSequenceNo(): Integer
    var
        Template: Record "Month-End Checklist Template";
    begin
        Template.SetCurrentKey("Sequence No.");
        if Template.FindLast() then
            exit(Template."Sequence No." + 10)
        else
            exit(10);
    end;
}
````

---

### 2. Closing Task Category Enum

````al
// filepath: c:\Users\LukmanASULAIMAN\source\repos\QMB_Stabilization\QMB_Stabilization\Enums\ClosingTaskCategory.Enum.al
enum 60080 "Closing Task Category"
{
    Caption = 'Closing Task Category';
    Extensible = true;

    value(0; " ")
    {
        Caption = ' ';
    }
    value(1; "Pre-Closing")
    {
        Caption = 'Pre-Closing';
    }
    value(2; "Receivables")
    {
        Caption = 'Receivables';
    }
    value(3; "Payables")
    {
        Caption = 'Payables';
    }
    value(4; "Inventory")
    {
        Caption = 'Inventory';
    }
    value(5; "Fixed Assets")
    {
        Caption = 'Fixed Assets';
    }
    value(6; "Bank Reconciliation")
    {
        Caption = 'Bank Reconciliation';
    }
    value(7; "Expense Processing")
    {
        Caption = 'Expense Processing';
    }
    value(8; "Accruals & Deferrals")
    {
        Caption = 'Accruals & Deferrals';
    }
    value(9; "Intercompany")
    {
        Caption = 'Intercompany';
    }
    value(10; "Reporting")
    {
        Caption = 'Reporting';
    }
    value(11; "Final Review")
    {
        Caption = 'Final Review';
    }
}
````

---

### 3. Closing Validation Type Enum

````al
// filepath: c:\Users\LukmanASULAIMAN\source\repos\QMB_Stabilization\QMB_Stabilization\Enums\ClosingValidationType.Enum.al
enum 60081 "Closing Validation Type"
{
    Caption = 'Closing Validation Type';
    Extensible = true;

    value(0; "Manual")
    {
        Caption = 'Manual';
    }
    value(1; "No Open Expenses")
    {
        Caption = 'No Open Expenses';
    }
    value(2; "No Open Requisitions")
    {
        Caption = 'No Open Requisitions';
    }
    value(3; "No Pending Approvals")
    {
        Caption = 'No Pending Approvals';
    }
    value(4; "Bank Reconciled")
    {
        Caption = 'Bank Reconciled';
    }
    value(5; "No Unposted Journals")
    {
        Caption = 'No Unposted Journals';
    }
    value(6; "Inventory Adjusted")
    {
        Caption = 'Inventory Adjusted';
    }
    value(7; "Trial Balance Balanced")
    {
        Caption = 'Trial Balance Balanced';
    }
    value(8; "Budget Reviewed")
    {
        Caption = 'Budget Reviewed';
    }
}
````

---

### 4. Month-End Closing Header Table

````al
// filepath: c:\Users\LukmanASULAIMAN\source\repos\QMB_Stabilization\QMB_Stabilization\Tables\MonthEndClosingHeader.Table.al
table 60081 "Month-End Closing Header"
{
    Caption = 'Month-End Closing Header';
    DataClassification = CustomerContent;
    LookupPageId = "Month-End Closing List";
    DrillDownPageId = "Month-End Closing List";

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
        }
        field(2; "Accounting Period"; Code[10])
        {
            Caption = 'Accounting Period';
            TableRelation = "Accounting Period";

            trigger OnValidate()
            var
                AccPeriod: Record "Accounting Period";
            begin
                if AccPeriod.Get("Accounting Period") then begin
                    "Period Start Date" := AccPeriod."Starting Date";
                    "Period End Date" := CalcDate('<CM>', AccPeriod."Starting Date");
                    "Fiscal Year" := Date2DMY(AccPeriod."Starting Date", 3);
                end;
            end;
        }
        field(3; "Period Start Date"; Date)
        {
            Caption = 'Period Start Date';
            Editable = false;
        }
        field(4; "Period End Date"; Date)
        {
            Caption = 'Period End Date';
            Editable = false;
        }
        field(5; "Fiscal Year"; Integer)
        {
            Caption = 'Fiscal Year';
            Editable = false;
        }
        field(6; Status; Enum "Month-End Closing Status")
        {
            Caption = 'Status';
            Editable = false;
        }
        field(7; "Created By"; Code[50])
        {
            Caption = 'Created By';
            DataClassification = EndUserIdentifiableInformation;
            Editable = false;
        }
        field(8; "Created Date"; Date)
        {
            Caption = 'Created Date';
            Editable = false;
        }
        field(9; "Started Date"; Date)
        {
            Caption = 'Started Date';
            Editable = false;
        }
        field(10; "Completed Date"; Date)
        {
            Caption = 'Completed Date';
            Editable = false;
        }
        field(11; "Completed By"; Code[50])
        {
            Caption = 'Completed By';
            DataClassification = EndUserIdentifiableInformation;
            Editable = false;
        }
        field(12; "Total Tasks"; Integer)
        {
            Caption = 'Total Tasks';
            FieldClass = FlowField;
            CalcFormula = count("Month-End Closing Line" where("Document No." = field("No.")));
            Editable = false;
        }
        field(13; "Completed Tasks"; Integer)
        {
            Caption = 'Completed Tasks';
            FieldClass = FlowField;
            CalcFormula = count("Month-End Closing Line" where("Document No." = field("No."), Status = const(Completed)));
            Editable = false;
        }
        field(14; "Blocked Tasks"; Integer)
        {
            Caption = 'Blocked Tasks';
            FieldClass = FlowField;
            CalcFormula = count("Month-End Closing Line" where("Document No." = field("No."), Status = const(Blocked)));
            Editable = false;
        }
        field(15; "Comments"; Text[500])
        {
            Caption = 'Comments';
        }
    }

    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }
        key(Period; "Accounting Period", "Fiscal Year")
        {
        }
    }

    trigger OnInsert()
    var
        NoSeriesMgt: Codeunit NoSeriesManagement;
        CustomSetup: Record "Custom Setup";
    begin
        if "No." = '' then begin
            CustomSetup.Get();
            "No." := NoSeriesMgt.GetNextNo('MONTHEND', WorkDate(), true);
        end;
        "Created By" := CopyStr(UserId, 1, 50);
        "Created Date" := WorkDate();
        Status := Status::Open;
    end;

    trigger OnDelete()
    var
        ClosingLine: Record "Month-End Closing Line";
    begin
        if Status = Status::Completed then
            Error('Cannot delete a completed month-end closing.');

        ClosingLine.SetRange("Document No.", "No.");
        ClosingLine.DeleteAll(true);
    end;

    procedure InitializeFromTemplate()
    var
        Template: Record "Month-End Checklist Template";
        ClosingLine: Record "Month-End Closing Line";
        LineNo: Integer;
    begin
        if Status <> Status::Open then
            Error('Checklist can only be initialized when status is Open.');

        Template.SetRange(Active, true);
        Template.SetCurrentKey("Sequence No.");
        if Template.FindSet() then begin
            LineNo := 10000;
            repeat
                ClosingLine.Init();
                ClosingLine."Document No." := "No.";
                ClosingLine."Line No." := LineNo;
                ClosingLine."Task Code" := Template.Code;
                ClosingLine.Description := Template.Description;
                ClosingLine.Category := Template.Category;
                ClosingLine."Sequence No." := Template."Sequence No.";
                ClosingLine."Responsible User" := Template."Responsible Role";
                ClosingLine."Est. Duration (Minutes)" := Template."Est. Duration (Minutes)";
                ClosingLine."Auto-Validate" := Template."Auto-Validate";
                ClosingLine."Validation Type" := Template."Validation Type";
                ClosingLine."Related Page ID" := Template."Related Page ID";
                ClosingLine."Related Report ID" := Template."Related Report ID";
                ClosingLine.Blocking := Template.Blocking;
                ClosingLine.Instructions := Template.Instructions;
                ClosingLine.Status := ClosingLine.Status::Pending;
                ClosingLine.Insert(true);
                LineNo += 10000;
            until Template.Next() = 0;
        end;

        Status := Status::"In Progress";
        "Started Date" := WorkDate();
        Modify();
    end;

    procedure CompleteClosing()
    var
        ClosingLine: Record "Month-End Closing Line";
    begin
        ClosingLine.SetRange("Document No.", "No.");
        ClosingLine.SetFilter(Status, '<>%1', ClosingLine.Status::Completed);
        if not ClosingLine.IsEmpty then
            Error('Cannot complete closing. There are %1 incomplete tasks.', ClosingLine.Count);

        Status := Status::Completed;
        "Completed Date" := WorkDate();
        "Completed By" := CopyStr(UserId, 1, 50);
        Modify();
    end;

    procedure ReopenClosing()
    begin
        if Status <> Status::Completed then
            Error('Only completed closings can be reopened.');

        Status := Status::"In Progress";
        "Completed Date" := 0D;
        "Completed By" := '';
        Modify();
    end;

    procedure GetCompletionPercentage(): Decimal
    begin
        CalcFields("Total Tasks", "Completed Tasks");
        if "Total Tasks" = 0 then
            exit(0);
        exit(Round("Completed Tasks" / "Total Tasks" * 100, 0.1));
    end;
}
````

---

### 5. Month-End Closing Status Enum

````al
// filepath: c:\Users\LukmanASULAIMAN\source\repos\QMB_Stabilization\QMB_Stabilization\Enums\MonthEndClosingStatus.Enum.al
enum 60082 "Month-End Closing Status"
{
    Caption = 'Month-End Closing Status';
    Extensible = true;

    value(0; Open)
    {
        Caption = 'Open';
    }
    value(1; "In Progress")
    {
        Caption = 'In Progress';
    }
    value(2; Completed)
    {
        Caption = 'Completed';
    }
    value(3; Cancelled)
    {
        Caption = 'Cancelled';
    }
```


## License: unknown
https://github.com/nadeemshirazi786/ENYOGBC14EXT-New/blob/cd36edfc35e9b163549a3e280889702a3be3d6d2/EN%20WMS/Enums/e14229227.ENWMSDocumentStatus.al

```
I'll help you implement a Month-End Closing Checklist feature to streamline and accelerate the month-end process. This will include a checklist table, page, and integration with the Role Center.

## Solution Overview

| Component | Purpose |
|-----------|---------|
| **Month-End Checklist Template** | Define reusable checklist items |
| **Month-End Closing Header** | Track each period's closing process |
| **Month-End Closing Line** | Individual tasks with status tracking |
| **Closing Checklist Page** | Manage and execute closing tasks |
| **Automation Codeunit** | Pre-validate and auto-complete tasks |

---

### 1. Month-End Checklist Template Table

````al
// filepath: c:\Users\LukmanASULAIMAN\source\repos\QMB_Stabilization\QMB_Stabilization\Tables\MonthEndChecklistTemplate.Table.al
table 60080 "Month-End Checklist Template"
{
    Caption = 'Month-End Checklist Template';
    DataClassification = CustomerContent;
    LookupPageId = "Month-End Checklist Templates";
    DrillDownPageId = "Month-End Checklist Templates";

    fields
    {
        field(1; "Code"; Code[20])
        {
            Caption = 'Code';
            NotBlank = true;
        }
        field(2; Description; Text[100])
        {
            Caption = 'Description';
        }
        field(3; "Sequence No."; Integer)
        {
            Caption = 'Sequence No.';
            MinValue = 1;
        }
        field(4; Category; Enum "Closing Task Category")
        {
            Caption = 'Category';
        }
        field(5; "Responsible Role"; Code[20])
        {
            Caption = 'Responsible Role';
            TableRelation = "User Setup"."User ID";
        }
        field(6; "Est. Duration (Minutes)"; Integer)
        {
            Caption = 'Est. Duration (Minutes)';
            MinValue = 0;
        }
        field(7; "Auto-Validate"; Boolean)
        {
            Caption = 'Auto-Validate';
            ToolTip = 'If enabled, the system will automatically check if this task is complete.';
        }
        field(8; "Validation Type"; Enum "Closing Validation Type")
        {
            Caption = 'Validation Type';
        }
        field(9; "Related Page ID"; Integer)
        {
            Caption = 'Related Page ID';
            TableRelation = AllObjWithCaption."Object ID" where("Object Type" = const(Page));
        }
        field(10; "Related Report ID"; Integer)
        {
            Caption = 'Related Report ID';
            TableRelation = AllObjWithCaption."Object ID" where("Object Type" = const(Report));
        }
        field(11; "Blocking"; Boolean)
        {
            Caption = 'Blocking';
            ToolTip = 'If enabled, subsequent tasks cannot start until this task is completed.';
        }
        field(12; "Instructions"; Text[2048])
        {
            Caption = 'Instructions';
        }
        field(13; Active; Boolean)
        {
            Caption = 'Active';
            InitValue = true;
        }
    }

    keys
    {
        key(PK; "Code")
        {
            Clustered = true;
        }
        key(Sequence; "Sequence No.")
        {
        }
        key(Category; Category, "Sequence No.")
        {
        }
    }

    trigger OnInsert()
    begin
        if "Sequence No." = 0 then
            "Sequence No." := GetNextSequenceNo();
    end;

    local procedure GetNextSequenceNo(): Integer
    var
        Template: Record "Month-End Checklist Template";
    begin
        Template.SetCurrentKey("Sequence No.");
        if Template.FindLast() then
            exit(Template."Sequence No." + 10)
        else
            exit(10);
    end;
}
````

---

### 2. Closing Task Category Enum

````al
// filepath: c:\Users\LukmanASULAIMAN\source\repos\QMB_Stabilization\QMB_Stabilization\Enums\ClosingTaskCategory.Enum.al
enum 60080 "Closing Task Category"
{
    Caption = 'Closing Task Category';
    Extensible = true;

    value(0; " ")
    {
        Caption = ' ';
    }
    value(1; "Pre-Closing")
    {
        Caption = 'Pre-Closing';
    }
    value(2; "Receivables")
    {
        Caption = 'Receivables';
    }
    value(3; "Payables")
    {
        Caption = 'Payables';
    }
    value(4; "Inventory")
    {
        Caption = 'Inventory';
    }
    value(5; "Fixed Assets")
    {
        Caption = 'Fixed Assets';
    }
    value(6; "Bank Reconciliation")
    {
        Caption = 'Bank Reconciliation';
    }
    value(7; "Expense Processing")
    {
        Caption = 'Expense Processing';
    }
    value(8; "Accruals & Deferrals")
    {
        Caption = 'Accruals & Deferrals';
    }
    value(9; "Intercompany")
    {
        Caption = 'Intercompany';
    }
    value(10; "Reporting")
    {
        Caption = 'Reporting';
    }
    value(11; "Final Review")
    {
        Caption = 'Final Review';
    }
}
````

---

### 3. Closing Validation Type Enum

````al
// filepath: c:\Users\LukmanASULAIMAN\source\repos\QMB_Stabilization\QMB_Stabilization\Enums\ClosingValidationType.Enum.al
enum 60081 "Closing Validation Type"
{
    Caption = 'Closing Validation Type';
    Extensible = true;

    value(0; "Manual")
    {
        Caption = 'Manual';
    }
    value(1; "No Open Expenses")
    {
        Caption = 'No Open Expenses';
    }
    value(2; "No Open Requisitions")
    {
        Caption = 'No Open Requisitions';
    }
    value(3; "No Pending Approvals")
    {
        Caption = 'No Pending Approvals';
    }
    value(4; "Bank Reconciled")
    {
        Caption = 'Bank Reconciled';
    }
    value(5; "No Unposted Journals")
    {
        Caption = 'No Unposted Journals';
    }
    value(6; "Inventory Adjusted")
    {
        Caption = 'Inventory Adjusted';
    }
    value(7; "Trial Balance Balanced")
    {
        Caption = 'Trial Balance Balanced';
    }
    value(8; "Budget Reviewed")
    {
        Caption = 'Budget Reviewed';
    }
}
````

---

### 4. Month-End Closing Header Table

````al
// filepath: c:\Users\LukmanASULAIMAN\source\repos\QMB_Stabilization\QMB_Stabilization\Tables\MonthEndClosingHeader.Table.al
table 60081 "Month-End Closing Header"
{
    Caption = 'Month-End Closing Header';
    DataClassification = CustomerContent;
    LookupPageId = "Month-End Closing List";
    DrillDownPageId = "Month-End Closing List";

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
        }
        field(2; "Accounting Period"; Code[10])
        {
            Caption = 'Accounting Period';
            TableRelation = "Accounting Period";

            trigger OnValidate()
            var
                AccPeriod: Record "Accounting Period";
            begin
                if AccPeriod.Get("Accounting Period") then begin
                    "Period Start Date" := AccPeriod."Starting Date";
                    "Period End Date" := CalcDate('<CM>', AccPeriod."Starting Date");
                    "Fiscal Year" := Date2DMY(AccPeriod."Starting Date", 3);
                end;
            end;
        }
        field(3; "Period Start Date"; Date)
        {
            Caption = 'Period Start Date';
            Editable = false;
        }
        field(4; "Period End Date"; Date)
        {
            Caption = 'Period End Date';
            Editable = false;
        }
        field(5; "Fiscal Year"; Integer)
        {
            Caption = 'Fiscal Year';
            Editable = false;
        }
        field(6; Status; Enum "Month-End Closing Status")
        {
            Caption = 'Status';
            Editable = false;
        }
        field(7; "Created By"; Code[50])
        {
            Caption = 'Created By';
            DataClassification = EndUserIdentifiableInformation;
            Editable = false;
        }
        field(8; "Created Date"; Date)
        {
            Caption = 'Created Date';
            Editable = false;
        }
        field(9; "Started Date"; Date)
        {
            Caption = 'Started Date';
            Editable = false;
        }
        field(10; "Completed Date"; Date)
        {
            Caption = 'Completed Date';
            Editable = false;
        }
        field(11; "Completed By"; Code[50])
        {
            Caption = 'Completed By';
            DataClassification = EndUserIdentifiableInformation;
            Editable = false;
        }
        field(12; "Total Tasks"; Integer)
        {
            Caption = 'Total Tasks';
            FieldClass = FlowField;
            CalcFormula = count("Month-End Closing Line" where("Document No." = field("No.")));
            Editable = false;
        }
        field(13; "Completed Tasks"; Integer)
        {
            Caption = 'Completed Tasks';
            FieldClass = FlowField;
            CalcFormula = count("Month-End Closing Line" where("Document No." = field("No."), Status = const(Completed)));
            Editable = false;
        }
        field(14; "Blocked Tasks"; Integer)
        {
            Caption = 'Blocked Tasks';
            FieldClass = FlowField;
            CalcFormula = count("Month-End Closing Line" where("Document No." = field("No."), Status = const(Blocked)));
            Editable = false;
        }
        field(15; "Comments"; Text[500])
        {
            Caption = 'Comments';
        }
    }

    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }
        key(Period; "Accounting Period", "Fiscal Year")
        {
        }
    }

    trigger OnInsert()
    var
        NoSeriesMgt: Codeunit NoSeriesManagement;
        CustomSetup: Record "Custom Setup";
    begin
        if "No." = '' then begin
            CustomSetup.Get();
            "No." := NoSeriesMgt.GetNextNo('MONTHEND', WorkDate(), true);
        end;
        "Created By" := CopyStr(UserId, 1, 50);
        "Created Date" := WorkDate();
        Status := Status::Open;
    end;

    trigger OnDelete()
    var
        ClosingLine: Record "Month-End Closing Line";
    begin
        if Status = Status::Completed then
            Error('Cannot delete a completed month-end closing.');

        ClosingLine.SetRange("Document No.", "No.");
        ClosingLine.DeleteAll(true);
    end;

    procedure InitializeFromTemplate()
    var
        Template: Record "Month-End Checklist Template";
        ClosingLine: Record "Month-End Closing Line";
        LineNo: Integer;
    begin
        if Status <> Status::Open then
            Error('Checklist can only be initialized when status is Open.');

        Template.SetRange(Active, true);
        Template.SetCurrentKey("Sequence No.");
        if Template.FindSet() then begin
            LineNo := 10000;
            repeat
                ClosingLine.Init();
                ClosingLine."Document No." := "No.";
                ClosingLine."Line No." := LineNo;
                ClosingLine."Task Code" := Template.Code;
                ClosingLine.Description := Template.Description;
                ClosingLine.Category := Template.Category;
                ClosingLine."Sequence No." := Template."Sequence No.";
                ClosingLine."Responsible User" := Template."Responsible Role";
                ClosingLine."Est. Duration (Minutes)" := Template."Est. Duration (Minutes)";
                ClosingLine."Auto-Validate" := Template."Auto-Validate";
                ClosingLine."Validation Type" := Template."Validation Type";
                ClosingLine."Related Page ID" := Template."Related Page ID";
                ClosingLine."Related Report ID" := Template."Related Report ID";
                ClosingLine.Blocking := Template.Blocking;
                ClosingLine.Instructions := Template.Instructions;
                ClosingLine.Status := ClosingLine.Status::Pending;
                ClosingLine.Insert(true);
                LineNo += 10000;
            until Template.Next() = 0;
        end;

        Status := Status::"In Progress";
        "Started Date" := WorkDate();
        Modify();
    end;

    procedure CompleteClosing()
    var
        ClosingLine: Record "Month-End Closing Line";
    begin
        ClosingLine.SetRange("Document No.", "No.");
        ClosingLine.SetFilter(Status, '<>%1', ClosingLine.Status::Completed);
        if not ClosingLine.IsEmpty then
            Error('Cannot complete closing. There are %1 incomplete tasks.', ClosingLine.Count);

        Status := Status::Completed;
        "Completed Date" := WorkDate();
        "Completed By" := CopyStr(UserId, 1, 50);
        Modify();
    end;

    procedure ReopenClosing()
    begin
        if Status <> Status::Completed then
            Error('Only completed closings can be reopened.');

        Status := Status::"In Progress";
        "Completed Date" := 0D;
        "Completed By" := '';
        Modify();
    end;

    procedure GetCompletionPercentage(): Decimal
    begin
        CalcFields("Total Tasks", "Completed Tasks");
        if "Total Tasks" = 0 then
            exit(0);
        exit(Round("Completed Tasks" / "Total Tasks" * 100, 0.1));
    end;
}
````

---

### 5. Month-End Closing Status Enum

````al
// filepath: c:\Users\LukmanASULAIMAN\source\repos\QMB_Stabilization\QMB_Stabilization\Enums\MonthEndClosingStatus.Enum.al
enum 60082 "Month-End Closing Status"
{
    Caption = 'Month-End Closing Status';
    Extensible = true;

    value(0; Open)
    {
        Caption = 'Open';
    }
    value(1; "In Progress")
    {
        Caption = 'In Progress';
    }
    value(2; Completed)
    {
        Caption = 'Completed';
    }
    value(3; Cancelled)
    {
        Caption = 'Cancelled';
    }
```


## License: unknown
https://github.com/nadeemshirazi786/ENYOGBC14EXT-New/blob/cd36edfc35e9b163549a3e280889702a3be3d6d2/EN%20WMS/Enums/e14229227.ENWMSDocumentStatus.al

```
I'll help you implement a Month-End Closing Checklist feature to streamline and accelerate the month-end process. This will include a checklist table, page, and integration with the Role Center.

## Solution Overview

| Component | Purpose |
|-----------|---------|
| **Month-End Checklist Template** | Define reusable checklist items |
| **Month-End Closing Header** | Track each period's closing process |
| **Month-End Closing Line** | Individual tasks with status tracking |
| **Closing Checklist Page** | Manage and execute closing tasks |
| **Automation Codeunit** | Pre-validate and auto-complete tasks |

---

### 1. Month-End Checklist Template Table

````al
// filepath: c:\Users\LukmanASULAIMAN\source\repos\QMB_Stabilization\QMB_Stabilization\Tables\MonthEndChecklistTemplate.Table.al
table 60080 "Month-End Checklist Template"
{
    Caption = 'Month-End Checklist Template';
    DataClassification = CustomerContent;
    LookupPageId = "Month-End Checklist Templates";
    DrillDownPageId = "Month-End Checklist Templates";

    fields
    {
        field(1; "Code"; Code[20])
        {
            Caption = 'Code';
            NotBlank = true;
        }
        field(2; Description; Text[100])
        {
            Caption = 'Description';
        }
        field(3; "Sequence No."; Integer)
        {
            Caption = 'Sequence No.';
            MinValue = 1;
        }
        field(4; Category; Enum "Closing Task Category")
        {
            Caption = 'Category';
        }
        field(5; "Responsible Role"; Code[20])
        {
            Caption = 'Responsible Role';
            TableRelation = "User Setup"."User ID";
        }
        field(6; "Est. Duration (Minutes)"; Integer)
        {
            Caption = 'Est. Duration (Minutes)';
            MinValue = 0;
        }
        field(7; "Auto-Validate"; Boolean)
        {
            Caption = 'Auto-Validate';
            ToolTip = 'If enabled, the system will automatically check if this task is complete.';
        }
        field(8; "Validation Type"; Enum "Closing Validation Type")
        {
            Caption = 'Validation Type';
        }
        field(9; "Related Page ID"; Integer)
        {
            Caption = 'Related Page ID';
            TableRelation = AllObjWithCaption."Object ID" where("Object Type" = const(Page));
        }
        field(10; "Related Report ID"; Integer)
        {
            Caption = 'Related Report ID';
            TableRelation = AllObjWithCaption."Object ID" where("Object Type" = const(Report));
        }
        field(11; "Blocking"; Boolean)
        {
            Caption = 'Blocking';
            ToolTip = 'If enabled, subsequent tasks cannot start until this task is completed.';
        }
        field(12; "Instructions"; Text[2048])
        {
            Caption = 'Instructions';
        }
        field(13; Active; Boolean)
        {
            Caption = 'Active';
            InitValue = true;
        }
    }

    keys
    {
        key(PK; "Code")
        {
            Clustered = true;
        }
        key(Sequence; "Sequence No.")
        {
        }
        key(Category; Category, "Sequence No.")
        {
        }
    }

    trigger OnInsert()
    begin
        if "Sequence No." = 0 then
            "Sequence No." := GetNextSequenceNo();
    end;

    local procedure GetNextSequenceNo(): Integer
    var
        Template: Record "Month-End Checklist Template";
    begin
        Template.SetCurrentKey("Sequence No.");
        if Template.FindLast() then
            exit(Template."Sequence No." + 10)
        else
            exit(10);
    end;
}
````

---

### 2. Closing Task Category Enum

````al
// filepath: c:\Users\LukmanASULAIMAN\source\repos\QMB_Stabilization\QMB_Stabilization\Enums\ClosingTaskCategory.Enum.al
enum 60080 "Closing Task Category"
{
    Caption = 'Closing Task Category';
    Extensible = true;

    value(0; " ")
    {
        Caption = ' ';
    }
    value(1; "Pre-Closing")
    {
        Caption = 'Pre-Closing';
    }
    value(2; "Receivables")
    {
        Caption = 'Receivables';
    }
    value(3; "Payables")
    {
        Caption = 'Payables';
    }
    value(4; "Inventory")
    {
        Caption = 'Inventory';
    }
    value(5; "Fixed Assets")
    {
        Caption = 'Fixed Assets';
    }
    value(6; "Bank Reconciliation")
    {
        Caption = 'Bank Reconciliation';
    }
    value(7; "Expense Processing")
    {
        Caption = 'Expense Processing';
    }
    value(8; "Accruals & Deferrals")
    {
        Caption = 'Accruals & Deferrals';
    }
    value(9; "Intercompany")
    {
        Caption = 'Intercompany';
    }
    value(10; "Reporting")
    {
        Caption = 'Reporting';
    }
    value(11; "Final Review")
    {
        Caption = 'Final Review';
    }
}
````

---

### 3. Closing Validation Type Enum

````al
// filepath: c:\Users\LukmanASULAIMAN\source\repos\QMB_Stabilization\QMB_Stabilization\Enums\ClosingValidationType.Enum.al
enum 60081 "Closing Validation Type"
{
    Caption = 'Closing Validation Type';
    Extensible = true;

    value(0; "Manual")
    {
        Caption = 'Manual';
    }
    value(1; "No Open Expenses")
    {
        Caption = 'No Open Expenses';
    }
    value(2; "No Open Requisitions")
    {
        Caption = 'No Open Requisitions';
    }
    value(3; "No Pending Approvals")
    {
        Caption = 'No Pending Approvals';
    }
    value(4; "Bank Reconciled")
    {
        Caption = 'Bank Reconciled';
    }
    value(5; "No Unposted Journals")
    {
        Caption = 'No Unposted Journals';
    }
    value(6; "Inventory Adjusted")
    {
        Caption = 'Inventory Adjusted';
    }
    value(7; "Trial Balance Balanced")
    {
        Caption = 'Trial Balance Balanced';
    }
    value(8; "Budget Reviewed")
    {
        Caption = 'Budget Reviewed';
    }
}
````

---

### 4. Month-End Closing Header Table

````al
// filepath: c:\Users\LukmanASULAIMAN\source\repos\QMB_Stabilization\QMB_Stabilization\Tables\MonthEndClosingHeader.Table.al
table 60081 "Month-End Closing Header"
{
    Caption = 'Month-End Closing Header';
    DataClassification = CustomerContent;
    LookupPageId = "Month-End Closing List";
    DrillDownPageId = "Month-End Closing List";

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
        }
        field(2; "Accounting Period"; Code[10])
        {
            Caption = 'Accounting Period';
            TableRelation = "Accounting Period";

            trigger OnValidate()
            var
                AccPeriod: Record "Accounting Period";
            begin
                if AccPeriod.Get("Accounting Period") then begin
                    "Period Start Date" := AccPeriod."Starting Date";
                    "Period End Date" := CalcDate('<CM>', AccPeriod."Starting Date");
                    "Fiscal Year" := Date2DMY(AccPeriod."Starting Date", 3);
                end;
            end;
        }
        field(3; "Period Start Date"; Date)
        {
            Caption = 'Period Start Date';
            Editable = false;
        }
        field(4; "Period End Date"; Date)
        {
            Caption = 'Period End Date';
            Editable = false;
        }
        field(5; "Fiscal Year"; Integer)
        {
            Caption = 'Fiscal Year';
            Editable = false;
        }
        field(6; Status; Enum "Month-End Closing Status")
        {
            Caption = 'Status';
            Editable = false;
        }
        field(7; "Created By"; Code[50])
        {
            Caption = 'Created By';
            DataClassification = EndUserIdentifiableInformation;
            Editable = false;
        }
        field(8; "Created Date"; Date)
        {
            Caption = 'Created Date';
            Editable = false;
        }
        field(9; "Started Date"; Date)
        {
            Caption = 'Started Date';
            Editable = false;
        }
        field(10; "Completed Date"; Date)
        {
            Caption = 'Completed Date';
            Editable = false;
        }
        field(11; "Completed By"; Code[50])
        {
            Caption = 'Completed By';
            DataClassification = EndUserIdentifiableInformation;
            Editable = false;
        }
        field(12; "Total Tasks"; Integer)
        {
            Caption = 'Total Tasks';
            FieldClass = FlowField;
            CalcFormula = count("Month-End Closing Line" where("Document No." = field("No.")));
            Editable = false;
        }
        field(13; "Completed Tasks"; Integer)
        {
            Caption = 'Completed Tasks';
            FieldClass = FlowField;
            CalcFormula = count("Month-End Closing Line" where("Document No." = field("No."), Status = const(Completed)));
            Editable = false;
        }
        field(14; "Blocked Tasks"; Integer)
        {
            Caption = 'Blocked Tasks';
            FieldClass = FlowField;
            CalcFormula = count("Month-End Closing Line" where("Document No." = field("No."), Status = const(Blocked)));
            Editable = false;
        }
        field(15; "Comments"; Text[500])
        {
            Caption = 'Comments';
        }
    }

    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }
        key(Period; "Accounting Period", "Fiscal Year")
        {
        }
    }

    trigger OnInsert()
    var
        NoSeriesMgt: Codeunit NoSeriesManagement;
        CustomSetup: Record "Custom Setup";
    begin
        if "No." = '' then begin
            CustomSetup.Get();
            "No." := NoSeriesMgt.GetNextNo('MONTHEND', WorkDate(), true);
        end;
        "Created By" := CopyStr(UserId, 1, 50);
        "Created Date" := WorkDate();
        Status := Status::Open;
    end;

    trigger OnDelete()
    var
        ClosingLine: Record "Month-End Closing Line";
    begin
        if Status = Status::Completed then
            Error('Cannot delete a completed month-end closing.');

        ClosingLine.SetRange("Document No.", "No.");
        ClosingLine.DeleteAll(true);
    end;

    procedure InitializeFromTemplate()
    var
        Template: Record "Month-End Checklist Template";
        ClosingLine: Record "Month-End Closing Line";
        LineNo: Integer;
    begin
        if Status <> Status::Open then
            Error('Checklist can only be initialized when status is Open.');

        Template.SetRange(Active, true);
        Template.SetCurrentKey("Sequence No.");
        if Template.FindSet() then begin
            LineNo := 10000;
            repeat
                ClosingLine.Init();
                ClosingLine."Document No." := "No.";
                ClosingLine."Line No." := LineNo;
                ClosingLine."Task Code" := Template.Code;
                ClosingLine.Description := Template.Description;
                ClosingLine.Category := Template.Category;
                ClosingLine."Sequence No." := Template."Sequence No.";
                ClosingLine."Responsible User" := Template."Responsible Role";
                ClosingLine."Est. Duration (Minutes)" := Template."Est. Duration (Minutes)";
                ClosingLine."Auto-Validate" := Template."Auto-Validate";
                ClosingLine."Validation Type" := Template."Validation Type";
                ClosingLine."Related Page ID" := Template."Related Page ID";
                ClosingLine."Related Report ID" := Template."Related Report ID";
                ClosingLine.Blocking := Template.Blocking;
                ClosingLine.Instructions := Template.Instructions;
                ClosingLine.Status := ClosingLine.Status::Pending;
                ClosingLine.Insert(true);
                LineNo += 10000;
            until Template.Next() = 0;
        end;

        Status := Status::"In Progress";
        "Started Date" := WorkDate();
        Modify();
    end;

    procedure CompleteClosing()
    var
        ClosingLine: Record "Month-End Closing Line";
    begin
        ClosingLine.SetRange("Document No.", "No.");
        ClosingLine.SetFilter(Status, '<>%1', ClosingLine.Status::Completed);
        if not ClosingLine.IsEmpty then
            Error('Cannot complete closing. There are %1 incomplete tasks.', ClosingLine.Count);

        Status := Status::Completed;
        "Completed Date" := WorkDate();
        "Completed By" := CopyStr(UserId, 1, 50);
        Modify();
    end;

    procedure ReopenClosing()
    begin
        if Status <> Status::Completed then
            Error('Only completed closings can be reopened.');

        Status := Status::"In Progress";
        "Completed Date" := 0D;
        "Completed By" := '';
        Modify();
    end;

    procedure GetCompletionPercentage(): Decimal
    begin
        CalcFields("Total Tasks", "Completed Tasks");
        if "Total Tasks" = 0 then
            exit(0);
        exit(Round("Completed Tasks" / "Total Tasks" * 100, 0.1));
    end;
}
````

---

### 5. Month-End Closing Status Enum

````al
// filepath: c:\Users\LukmanASULAIMAN\source\repos\QMB_Stabilization\QMB_Stabilization\Enums\MonthEndClosingStatus.Enum.al
enum 60082 "Month-End Closing Status"
{
    Caption = 'Month-End Closing Status';
    Extensible = true;

    value(0; Open)
    {
        Caption = 'Open';
    }
    value(1; "In Progress")
    {
        Caption = 'In Progress';
    }
    value(2; Completed)
    {
        Caption = 'Completed';
    }
    value(3; Cancelled)
    {
        Caption = 'Cancelled';
    }
```

