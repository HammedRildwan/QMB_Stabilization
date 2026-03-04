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
    begin
        if "No." = '' then begin
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
        ClosingLine.SetFilter(Status, '<>%1&<>%2', ClosingLine.Status::Completed, ClosingLine.Status::Skipped);
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
