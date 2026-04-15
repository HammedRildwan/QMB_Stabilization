table 53005 "Month-End Closing Line"
{
    Caption = 'Month-End Closing Line';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            TableRelation = "Month-End Closing Header";
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(3; "Task Code"; Code[20])
        {
            Caption = 'Task Code';
        }
        field(4; Description; Text[100])
        {
            Caption = 'Description';
        }
        field(5; Category; Enum "Closing Task Category")
        {
            Caption = 'Category';
        }
        field(6; "Sequence No."; Integer)
        {
            Caption = 'Sequence No.';
        }
        field(7; Status; Enum "Closing Task Status")
        {
            Caption = 'Status';

            trigger OnValidate()
            begin
                case Status of
                    Status::Completed:
                        begin
                            "Completed Date" := WorkDate();
                            "Completed By" := CopyStr(UserId, 1, 50);
                            "Completed Time" := Time;
                        end;
                    Status::Pending, Status::"In Progress":
                        begin
                            "Completed Date" := 0D;
                            "Completed By" := '';
                            "Completed Time" := 0T;
                        end;
                end;
            end;
        }
        field(8; "Responsible User"; Code[50])
        {
            Caption = 'Responsible User';
            TableRelation = "User Setup"."User ID";
        }
        field(9; "Est. Duration (Minutes)"; Integer)
        {
            Caption = 'Est. Duration (Minutes)';
        }
        field(10; "Actual Duration (Minutes)"; Integer)
        {
            Caption = 'Actual Duration (Minutes)';
        }
        field(11; "Started Date"; Date)
        {
            Caption = 'Started Date';
        }
        field(12; "Started Time"; Time)
        {
            Caption = 'Started Time';
        }
        field(13; "Completed Date"; Date)
        {
            Caption = 'Completed Date';
            Editable = false;
        }
        field(14; "Completed Time"; Time)
        {
            Caption = 'Completed Time';
            Editable = false;
        }
        field(15; "Completed By"; Code[50])
        {
            Caption = 'Completed By';
            DataClassification = EndUserIdentifiableInformation;
            Editable = false;
        }
        field(16; "Auto-Validate"; Boolean)
        {
            Caption = 'Auto-Validate';
        }
        field(17; "Validation Type"; Enum "Closing Validation Type")
        {
            Caption = 'Validation Type';
        }
        field(18; "Validation Result"; Text[250])
        {
            Caption = 'Validation Result';
            Editable = false;
        }
        field(19; "Related Page ID"; Integer)
        {
            Caption = 'Related Page ID';
        }
        field(20; "Related Report ID"; Integer)
        {
            Caption = 'Related Report ID';
        }
        field(21; Blocking; Boolean)
        {
            Caption = 'Blocking';
        }
        field(22; Instructions; Text[2048])
        {
            Caption = 'Instructions';
        }
        field(23; Notes; Text[500])
        {
            Caption = 'Notes';
        }
        field(24; "Issue Found"; Boolean)
        {
            Caption = 'Issue Found';
        }
        field(25; "Issue Description"; Text[500])
        {
            Caption = 'Issue Description';
        }
    }

    keys
    {
        key(PK; "Document No.", "Line No.")
        {
            Clustered = true;
        }
        key(Sequence; "Document No.", "Sequence No.")
        {
        }
        key(Category; "Document No.", Category, "Sequence No.")
        {
        }
        key(Status; "Document No.", Status)
        {
        }
    }

    procedure StartTask()
    begin
        TestStatusUpdate();
        if Status = Status::Pending then begin
            Status := Status::"In Progress";
            "Started Date" := WorkDate();
            "Started Time" := Time;
            Modify();
        end;
    end;

    procedure CompleteTask()
    var
        ClosingMgt: Codeunit "Month-End Closing Mgt.";
        Passed: Boolean;
        ValidationMsg: Text[250];
    begin
        TestStatusUpdate();
        if "Auto-Validate" then begin
            ClosingMgt.ValidateTask(Rec, Passed, ValidationMsg);
            "Validation Result" := ValidationMsg;
            if not Passed then
                "Issue Found" := true;
        end;

        Status := Status::Completed;
        "Completed Date" := WorkDate();
        "Completed Time" := Time;
        "Completed By" := CopyStr(UserId, 1, 50);

        if "Started Date" <> 0D then
            "Actual Duration (Minutes)" := CalcDurationMinutes();

        Modify();
        UpdateBlockedTasks();
    end;

    procedure SkipTask()
    begin
        TestStatusUpdate();
        if Blocking then
            Error('Blocking tasks cannot be skipped.');

        Status := Status::Skipped;
        "Completed Date" := WorkDate();
        "Completed By" := CopyStr(UserId, 1, 50);
        Modify();
    end;

    procedure ResetTask()
    begin
        Status := Status::Pending;
        "Started Date" := 0D;
        "Started Time" := 0T;
        "Completed Date" := 0D;
        "Completed Time" := 0T;
        "Completed By" := '';
        "Actual Duration (Minutes)" := 0;
        "Validation Result" := '';
        "Issue Found" := false;
        Modify();
    end;

    procedure OpenRelatedPage()
    begin
        if "Related Page ID" <> 0 then
            Page.Run("Related Page ID");
    end;

    procedure RunRelatedReport()
    begin
        if "Related Report ID" <> 0 then
            Report.Run("Related Report ID");
    end;

    local procedure TestStatusUpdate()
    var
        Header: Record "Month-End Closing Header";
    begin
        Header.Get("Document No.");
        if Header.Status = Header.Status::Completed then
            Error('Cannot modify tasks on a completed closing.');

        if Status = Status::Blocked then
            Error('This task is blocked by a previous incomplete blocking task.');
    end;

    local procedure CalcDurationMinutes(): Integer
    var
        StartDateTime: DateTime;
        EndDateTime: DateTime;
        DurationMs: BigInteger;
    begin
        StartDateTime := CreateDateTime("Started Date", "Started Time");
        EndDateTime := CreateDateTime("Completed Date", "Completed Time");
        DurationMs := EndDateTime - StartDateTime;
        exit(Round(DurationMs / 60000, 1));
    end;

    local procedure UpdateBlockedTasks()
    var
        ClosingLine: Record "Month-End Closing Line";
    begin
        if not Blocking then
            exit;

        ClosingLine.SetRange("Document No.", "Document No.");
        ClosingLine.SetFilter("Sequence No.", '>%1', "Sequence No.");
        ClosingLine.SetRange(Status, ClosingLine.Status::Blocked);
        if ClosingLine.FindSet() then
            repeat
                if not IsPreviousBlockingTaskIncomplete(ClosingLine) then begin
                    ClosingLine.Status := ClosingLine.Status::Pending;
                    ClosingLine.Modify();
                end;
            until ClosingLine.Next() = 0;
    end;

    local procedure IsPreviousBlockingTaskIncomplete(var CheckLine: Record "Month-End Closing Line"): Boolean
    var
        PrevLine: Record "Month-End Closing Line";
    begin
        PrevLine.SetRange("Document No.", CheckLine."Document No.");
        PrevLine.SetFilter("Sequence No.", '<%1', CheckLine."Sequence No.");
        PrevLine.SetRange(Blocking, true);
        PrevLine.SetFilter(Status, '<>%1&<>%2', PrevLine.Status::Completed, PrevLine.Status::Skipped);
        exit(not PrevLine.IsEmpty);
    end;
}
