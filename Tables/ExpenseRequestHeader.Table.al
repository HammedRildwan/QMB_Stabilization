table 60056 "Expense Request Header"
{
    LookupPageID = 70120;

    fields
    {
        field(1; "No."; Code[10])
        {
        }
        field(2; Date; Date)
        {

            trigger OnValidate()
            begin
                IF Date > TODAY THEN
                    ERROR('Date cannot be greater than today');
            end;
        }
        field(4; Requester; Text[20])
        {
            Editable = true;
            TableRelation = "User Setup"."User ID";
        }
        field(7; "No. Series"; Code[10])
        {
            TableRelation = "No. Series".Code;
        }
        field(8; Status; Option)
        {
            Editable = false;
            OptionCaption = ' ,Pending Approval,Approved,Rejected,Posted';
            OptionMembers = " ","Pending Approval",Approved,Rejected,Posted;
        }
        field(9; Treated; Boolean)
        {
        }
        field(10; "Expense Type"; Option)
        {
            Editable = true;
            OptionCaption = ' ,Direct Expense,Vendor Invoice,Maintenance Expenses';
            OptionMembers = " ","Direct Expense","Vendor Invoice","Maintenance Expenses";
        }
        field(11; "Payment Option"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Cash,Cheque';
            OptionMembers = " ",Cash,Cheque;
        }
        field(12; "Bank No."; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Bank Account";

            trigger OnValidate()
            var
                BankAccount: Record "Bank Account";
            begin
                IF BankAccount.GET("Bank No.") THEN
                    "Bank Name" := BankAccount.Name
                ELSE
                    "Bank Name" := '';
            end;
        }
        field(13; "Bank Name"; Text[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(14; "Cheque No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(15; Payee; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(16; Posted; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(17; "Total Line Amount"; Decimal)
        {
            CalcFormula = Sum("Expense Request Line".Amount WHERE("Document No." = FIELD("No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(18; "External Document No."; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(19; Purpose; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(21; "Haulage Cash Advance No."; Code[10])
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                // IF HaulageCashAdvance.GET("Haulage Cash Advance No.") THEN BEGIN
                //  Payee := HaulageCashAdvance.Payee;
                //  "Amount Collected" := HaulageCashAdvance."Cash Amount";
                // END;
            end;
        }
        field(22; "Amount Collected"; Decimal)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(23; Balance; Decimal)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(24; "Shortcut Dimension 1 Code"; Code[50])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1),
                                                          "Blocked" = CONST(false));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(1, "Shortcut Dimension 1 Code");
            end;
        }
        field(25; "Shortcut Dimension 2 Code"; Code[50])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2),
                                                          "Blocked" = CONST(false));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(2, "Shortcut Dimension 2 Code");
            end;
        }
        field(26; "Time Created"; Time)
        {
            DataClassification = ToBeClassified;
        }
        field(27; "Shortcut Dimension 3 Code"; Code[20])
        {
            CaptionClass = '1,2,3';
            Caption = 'Shortcut Dimension 3 Code';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(3),
                                                          "Blocked" = CONST(false));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(3, "Shortcut Dimension 3 Code");
            end;
        }
        field(28; "Trip No"; Code[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(29; "Not Paid"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(30; "Maintenance Road Work Approval"; Boolean)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                // UserSetup.GET(USERID);
                // IF UserSetup."RoadWork Approval" = FALSE THEN
                //  ERROR('You cannot approve!');
                // IF "Maintenance Road Work Approval" THEN BEGIN
                //  "Maintenace Super Head ID" := UserSetup2."User ID";
                //  "Maint Approved DateTime" := CURRENTDATETIME;
                // END ELSE BEGIN
                //  "Maint Approved DateTime" := 0DT;
                //  "Maintenace Super Head ID" := '';
                //  END;
            end;
        }
        field(31; "Maintenace Super Head ID"; Code[15])
        {
            DataClassification = ToBeClassified;
        }
        field(32; "Maint Approved DateTime"; DateTime)
        {
            DataClassification = ToBeClassified;
        }
        field(480; "Dimension Set ID"; Integer)
        {
            Caption = 'Dimension Set ID';
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = "Dimension Set Entry";

            trigger OnLookup()
            begin
                ShowDocDim;
            end;

            trigger OnValidate()
            begin
                DimMgt.UpdateGlobalDimFromDimSetID("Dimension Set ID", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code");
            end;
        }
        field(481; "Payee Account Name"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(482; "Payee Account Number"; Text[20])
        {
            DataClassification = ToBeClassified;
        }
        field(483; "Payee Bank Name"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(484; "Last Modified DateTime"; DateTime)
        {
            DataClassification = ToBeClassified;
        }
        field(485; "Last Modified By"; Code[40])
        {
            DataClassification = ToBeClassified;
        }
        field(486; "BU Head Approval"; Boolean)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                // UserSetup2.GET(USERID);
                // IF UserSetup2."Business Unit Head" = FALSE THEN
                //  ERROR('You cannot approve!');
                //
                // TESTFIELD("Expense Type","Expense Type"::"Trip Allowance");
                // TESTFIELD(Status,Status::Approved);
                // TESTFIELD("Total Line Amount");
                // IF "BU Head Approval" THEN BEGIN
                //  "BU Head ID" := UserSetup2."User ID";
                //  "BU Head Approved DateTime" := CURRENTDATETIME;
                // END ELSE BEGIN
                //  "BU Head Approved DateTime" := 0DT;
                //  "BU Head ID" := '';
                //
                //  END;
            end;
        }
        field(487; "BU Head ID"; Code[15])
        {
            DataClassification = ToBeClassified;
        }
        field(488; "BU Head Approved DateTime"; DateTime)
        {
            DataClassification = ToBeClassified;
        }
        field(489; "JM Approval"; Boolean)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                //TESTFIELD("BU Head Approval",TRUE);

                // UserSetup2.GET(USERID);
                // IF UserSetup2.JM = FALSE THEN
                //  ERROR('You cannot approve!');
                //
                // TESTFIELD("Expense Type","Expense Type"::"Trip Allowance");
                // TESTFIELD(Status,Status::Approved);
                // TESTFIELD("Total Line Amount");
                // IF "JM Approval" THEN BEGIN
                //  "JM ID" := UserSetup2."User ID";
                //  "JM Approved DateTime" := CURRENTDATETIME;
                // END ELSE BEGIN
                //  "JM Approved DateTime" := 0DT;
                //  "JM ID" := '';
                //
                //  END;
            end;
        }
        field(490; "JM ID"; Code[15])
        {
            DataClassification = ToBeClassified;
        }
        field(491; "JM Approved DateTime"; DateTime)
        {
            DataClassification = ToBeClassified;
        }
        field(492; "Truck Code"; Code[10])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "No.", Requester)
        {
        }
    }

    trigger OnDelete()
    begin
        //ERROR('You can not delete this record!');
    end;

    trigger OnInsert()
    begin
        IF "No." = '' THEN BEGIN
            CustomSetup.GET;
            CustomSetup.TESTFIELD("Expense Nos.");
            NoSeriesMgt.InitSeries(CustomSetup."Expense Nos.", xRec."No. Series", 0D, "No.", "No. Series");
        END;

        UserSetup.GET(USERID);
        Requester := UserSetup."User ID";
        //"Shortcut Dimension 1 Code" := UserSetup."Shortcut Dimension 1 Code";
        //"Shortcut Dimension 2 Code" := UserSetup."Shortcut Dimension 2 Code";
        //Date := CURRENTDATETIME;
    end;

    trigger OnModify()
    begin
        // ERROR('You can not modify this record!');
        "Last Modified DateTime" := CURRENTDATETIME;
        "Last Modified By" := USERID;
    end;

    var
        CustomSetup: Record 60005;
        NoSeriesMgt: Codeunit 396;
        Text002: Label 'cannot be specified without %1';
        UserSetup: Record 91;
        UserSetup2: Record 91;
        GenJournalLine: Record 81;
        GenJournalLine2: Record 81;
        GLEntry: Record 17;
        GLEntry2: Record 17;
        GenJnlPost: Codeunit 231;
        TestReportPrint: Codeunit 228;
        ExpenseRequestLine: Record 60057;
        ExpenseRequestLine2: Record 60057;
        BankAccount: Record 270;
        ErrorOnPosting: Label 'This document needs to be approved before posting.';
        DimMgt: Codeunit 408;
        LineNo: Integer;
        FAMaintDocNo: Code[20];
        FASetup: Record 5603;
        LineNoB: Integer;
        GenJournalLine4: Record 81;

    //[Scope('Internal')]
    procedure PostExpense()
    var
        GenJournalLine: Record 81;
        GenJournalLine2: Record 81;
    begin
        //To confirm if the records dont exist
        IF Status <> Status::Approved THEN
            ERROR(ErrorOnPosting);

        IF Posted THEN
            ERROR('This Document has already been posted');

        //To check if fields are not empty
        TESTFIELD(Payee);
        TESTFIELD("Payment Option");
        TESTFIELD("Bank No.");
        IF "Payment Option" = "Payment Option"::Cheque THEN
            TESTFIELD("Cheque No.");
        LineNo := 0;
        GenJournalLine2.SETRANGE("Journal Template Name", 'PAYMENTS');
        GenJournalLine2.SETRANGE("Journal Batch Name", 'BANK');
        IF GenJournalLine2.FINDFIRST THEN
            GenJournalLine2.DELETEALL;

        IF "Expense Type" = "Expense Type"::"Maintenance Expenses" THEN BEGIN
            ExpenseRequestLine2.SETRANGE("Document No.", "No.");
            IF ExpenseRequestLine2.FINDSET THEN BEGIN
                REPEAT
                    ExpenseRequestLine2.TESTFIELD("Asset No.");
                UNTIL ExpenseRequestLine2.NEXT = 0;
            END;
        END;

        //Posting to Journal
        LineNo := 0;
        ExpenseRequestLine.SETRANGE("Document No.", "No.");
        IF ExpenseRequestLine.FINDSET THEN BEGIN
            REPEAT
                GenJournalLine.INIT;
                GenJournalLine."Journal Template Name" := 'PAYMENTS';
                GenJournalLine."Journal Batch Name" := 'BANK';
                GenJournalLine."Line No." := ExpenseRequestLine."Line No.";
                GenJournalLine."Document No." := ExpenseRequestLine."Document No.";
                GenJournalLine.VALIDATE("Posting Date", Date);
                IF "Expense Type" = ("Expense Type"::"Maintenance Expenses") THEN BEGIN
                    GenJournalLine."Account Type" := GenJournalLine."Account Type"::"Fixed Asset";
                    GenJournalLine.VALIDATE("Account No.", ExpenseRequestLine."Asset No.");
                    GenJournalLine."FA Posting Type" := GenJournalLine."FA Posting Type"::Maintenance;
                    GenJournalLine."Maintenance Code" := ExpenseRequestLine."Maintenance Code";
                    LineNo += 10;
                    FAMaintDocNo := 'FAM_' + ExpenseRequestLine."Document No." + '_' + FORMAT(LineNo);
                    GenJournalLine."Document No." := FAMaintDocNo;
                END ELSE BEGIN
                    GenJournalLine."Account Type" := GenJournalLine."Account Type"::"G/L Account";
                    GenJournalLine.VALIDATE("Account No.", ExpenseRequestLine."Expense Account No.")
                END;
                GenJournalLine.Description := COPYSTR(ExpenseRequestLine."Expense Description", 1, 50);
                IF ExpenseRequestLine."Currency Code" <> '' THEN
                    GenJournalLine.VALIDATE("Debit Amount", ExpenseRequestLine."Amount (LCY)")
                ELSE
                    GenJournalLine.VALIDATE("Debit Amount", ExpenseRequestLine.Amount);
                GenJournalLine."Bal. Account Type" := GenJournalLine."Bal. Account Type"::"Bank Account";
                GenJournalLine.VALIDATE("Bal. Account No.", "Bank No.");
                GenJournalLine.VALIDATE("Shortcut Dimension 1 Code", "Shortcut Dimension 1 Code");
                GenJournalLine.VALIDATE("Shortcut Dimension 2 Code", "Shortcut Dimension 2 Code");
                //      GenJournalLine.VALIDATE("Shortcut Dimension 4 Code",ExpenseRequestLine."Shortcut Dimension 4 Code");
                GenJournalLine.VALIDATE("Dimension Set ID", ExpenseRequestLine."Dimension Set ID");
                GenJournalLine.INSERT;
            UNTIL ExpenseRequestLine.NEXT = 0;
        END;
        //COMMIT;


        GLEntry.SETRANGE("Document No.", GenJournalLine."Document No.");
        IF GLEntry.FINDFIRST THEN
            ERROR('This document has been posted') ELSE BEGIN
            CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Post", GenJournalLine);
            Posted := TRUE;
        END;

        CheckPostedJnl;
    end;

    //[Scope('Internal')]
    procedure PreviewPosting()
    var
        GenJournalLine: Record 81;
        GenJournalLine2: Record 81;
    begin
        IF Status <> Status::Approved THEN
            ERROR(ErrorOnPosting);

        TESTFIELD(Payee);
        TESTFIELD("Payment Option");
        TESTFIELD("Bank No.");
        IF "Payment Option" = "Payment Option"::Cheque THEN
            TESTFIELD("Cheque No.");

        IF "Expense Type" = "Expense Type"::"Maintenance Expenses" THEN BEGIN
            ExpenseRequestLine2.SETRANGE("Document No.", "No.");
            IF ExpenseRequestLine2.FINDSET THEN BEGIN
                REPEAT
                    ExpenseRequestLine2.TESTFIELD("Asset No.");
                UNTIL ExpenseRequestLine2.NEXT = 0;
            END;
        END;


        GenJournalLine2.SETRANGE("Journal Template Name", 'PAYMENTS');
        GenJournalLine2.SETRANGE("Journal Batch Name", 'BANK');
        IF GenJournalLine2.FINDSET THEN
            GenJournalLine2.DELETEALL;

        LineNo := 0;
        ExpenseRequestLine.SETRANGE("Document No.", "No.");
        IF ExpenseRequestLine.FINDSET THEN BEGIN
            REPEAT
                GenJournalLine.INIT;
                GenJournalLine."Journal Template Name" := 'PAYMENTS';
                GenJournalLine."Journal Batch Name" := 'BANK';
                GenJournalLine."Line No." := ExpenseRequestLine."Line No.";
                GenJournalLine."Document No." := ExpenseRequestLine."Document No.";
                GenJournalLine.VALIDATE("Posting Date", Date);
                IF "Expense Type" = "Expense Type"::"Maintenance Expenses" THEN BEGIN
                    GenJournalLine."Account Type" := GenJournalLine."Account Type"::"Fixed Asset";
                    GenJournalLine.VALIDATE("Account No.", ExpenseRequestLine."Asset No.");
                    GenJournalLine."FA Posting Type" := GenJournalLine."FA Posting Type"::Maintenance;
                    GenJournalLine."Maintenance Code" := ExpenseRequestLine."Maintenance Code";
                    LineNo += 10;
                    FAMaintDocNo := 'FAM_' + ExpenseRequestLine."Document No." + '_' + FORMAT(LineNo);
                    GenJournalLine."Document No." := FAMaintDocNo;
                END ELSE BEGIN
                    GenJournalLine."Account Type" := GenJournalLine."Account Type"::"G/L Account";
                    GenJournalLine.VALIDATE("Account No.", ExpenseRequestLine."Expense Account No.")
                END;
                GenJournalLine.Description := COPYSTR(ExpenseRequestLine."Expense Description", 1, 50);
                IF ExpenseRequestLine."Currency Code" <> '' THEN
                    GenJournalLine.VALIDATE("Debit Amount", ExpenseRequestLine."Amount (LCY)")
                ELSE
                    GenJournalLine.VALIDATE("Debit Amount", ExpenseRequestLine.Amount);
                GenJournalLine."Bal. Account Type" := GenJournalLine."Bal. Account Type"::"Bank Account";
                GenJournalLine.VALIDATE("Bal. Account No.", "Bank No.");
                GenJournalLine."Shortcut Dimension 1 Code" := "Shortcut Dimension 1 Code";
                GenJournalLine."Shortcut Dimension 2 Code" := "Shortcut Dimension 2 Code";
                //   GenJournalLine."Shortcut Dimension 4 Code" := ExpenseRequestLine."Asset No.";
                GenJournalLine.INSERT;
            UNTIL ExpenseRequestLine.NEXT = 0;
        END;
        COMMIT;

        GenJnlPost.Preview(GenJournalLine);
    end;

    //[Scope('Internal')]
    procedure TestReport()
    var
        GenJournalLine: Record 81;
        GenJournalLine2: Record 81;
    begin
        IF Status <> Status::Approved THEN
            ERROR(ErrorOnPosting);

        TESTFIELD(Payee);
        TESTFIELD("Payment Option");
        TESTFIELD("Bank No.");
        IF "Payment Option" = "Payment Option"::Cheque THEN
            TESTFIELD("Cheque No.");
        LineNo := 0;
        IF "Expense Type" = "Expense Type"::"Maintenance Expenses" THEN BEGIN
            ExpenseRequestLine2.SETRANGE("Document No.", "No.");
            IF ExpenseRequestLine2.FINDSET THEN BEGIN
                REPEAT
                    ExpenseRequestLine2.TESTFIELD("Asset No.");
                UNTIL ExpenseRequestLine2.NEXT = 0;
            END;
        END;


        GenJournalLine2.SETRANGE("Journal Template Name", 'PAYMENTS');
        GenJournalLine2.SETRANGE("Journal Batch Name", 'BANK');
        IF GenJournalLine2.FINDSET THEN
            GenJournalLine2.DELETEALL;

        ExpenseRequestLine.SETRANGE("Document No.", "No.");
        IF ExpenseRequestLine.FINDSET THEN BEGIN
            REPEAT
                GenJournalLine.INIT;
                GenJournalLine."Journal Template Name" := 'PAYMENTS';
                GenJournalLine."Journal Batch Name" := 'BANK';
                GenJournalLine."Line No." := ExpenseRequestLine."Line No.";
                GenJournalLine."Document No." := ExpenseRequestLine."Document No.";
                GenJournalLine.VALIDATE("Posting Date", Date);

                IF "Expense Type" = "Expense Type"::"Maintenance Expenses" THEN BEGIN
                    GenJournalLine."Account Type" := GenJournalLine."Account Type"::"Fixed Asset";
                    GenJournalLine.VALIDATE("Account No.", ExpenseRequestLine."Asset No.");
                    GenJournalLine."FA Posting Type" := GenJournalLine."FA Posting Type"::Maintenance;
                    GenJournalLine."Maintenance Code" := ExpenseRequestLine."Maintenance Code";
                    LineNo += 10;
                    FAMaintDocNo := 'FAM_' + ExpenseRequestLine."Document No." + '_' + FORMAT(LineNo);
                    GenJournalLine."Document No." := FAMaintDocNo;
                END ELSE BEGIN
                    GenJournalLine."Account Type" := GenJournalLine."Account Type"::"G/L Account";
                    GenJournalLine.VALIDATE("Account No.", ExpenseRequestLine."Expense Account No.")
                END;

                GenJournalLine.Description := COPYSTR(ExpenseRequestLine."Expense Description", 1, 50);
                IF ExpenseRequestLine."Currency Code" <> '' THEN
                    GenJournalLine.VALIDATE("Debit Amount", ExpenseRequestLine."Amount (LCY)")
                ELSE
                    GenJournalLine.VALIDATE("Debit Amount", ExpenseRequestLine.Amount);

                GenJournalLine."Bal. Account Type" := GenJournalLine."Bal. Account Type"::"Bank Account";
                GenJournalLine.VALIDATE("Bal. Account No.", "Bank No.");
                GenJournalLine."Shortcut Dimension 1 Code" := "Shortcut Dimension 1 Code";
                GenJournalLine."Shortcut Dimension 2 Code" := "Shortcut Dimension 2 Code";
                //   GenJournalLine."Shortcut Dimension 4 Code" := ExpenseRequestLine."Asset No.";
                GenJournalLine.INSERT;
            UNTIL ExpenseRequestLine.NEXT = 0;
        END;
        COMMIT;
        TestReportPrint.PrintGenJnlLine(GenJournalLine);
    end;

    // [Scope('Internal')]
    procedure PostPrint()
    var
        GenJournalLine: Record 81;
        GenJournalLine2: Record 81;
    begin
        IF Status <> Status::Approved THEN
            ERROR(ErrorOnPosting);

        TESTFIELD(Payee);
        TESTFIELD("Payment Option");
        TESTFIELD("Bank No.");
        IF "Payment Option" = "Payment Option"::Cheque THEN
            TESTFIELD("Cheque No.");

        IF "Expense Type" = "Expense Type"::"Maintenance Expenses" THEN BEGIN
            ExpenseRequestLine2.SETRANGE("Document No.", "No.");
            IF ExpenseRequestLine2.FINDSET THEN BEGIN
                REPEAT
                    ExpenseRequestLine2.TESTFIELD("Asset No.");
                UNTIL ExpenseRequestLine2.NEXT = 0;
            END;
        END;


        LineNo := 0;
        GenJournalLine2.SETRANGE("Journal Template Name", 'PAYMENTS');
        GenJournalLine2.SETRANGE("Journal Batch Name", 'BANK');
        IF GenJournalLine2.FINDSET THEN
            GenJournalLine2.DELETEALL;

        ExpenseRequestLine.SETRANGE("Document No.", "No.");
        IF ExpenseRequestLine.FINDSET THEN BEGIN
            REPEAT
                GenJournalLine.INIT;
                GenJournalLine."Journal Template Name" := 'PAYMENTS';
                GenJournalLine."Journal Batch Name" := 'BANK';
                GenJournalLine."Line No." := ExpenseRequestLine."Line No.";
                GenJournalLine."Document No." := ExpenseRequestLine."Document No.";
                GenJournalLine.VALIDATE("Posting Date", Date);

                IF "Expense Type" = "Expense Type"::"Maintenance Expenses" THEN BEGIN
                    GenJournalLine."Account Type" := GenJournalLine."Account Type"::"Fixed Asset";
                    GenJournalLine.VALIDATE("Account No.", ExpenseRequestLine."Asset No.");
                    GenJournalLine."FA Posting Type" := GenJournalLine."FA Posting Type"::Maintenance;
                    GenJournalLine."Maintenance Code" := ExpenseRequestLine."Maintenance Code";
                    LineNo += 10;
                    FAMaintDocNo := 'FAM_' + ExpenseRequestLine."Document No." + '_' + FORMAT(LineNo);
                    GenJournalLine."Document No." := FAMaintDocNo;
                END ELSE BEGIN
                    GenJournalLine."Account Type" := GenJournalLine."Account Type"::"G/L Account";
                    GenJournalLine.VALIDATE("Account No.", ExpenseRequestLine."Expense Account No.")
                END;
                GenJournalLine.Description := COPYSTR(ExpenseRequestLine."Expense Description", 1, 50);
                GenJournalLine.VALIDATE("Debit Amount", ExpenseRequestLine.Amount);
                GenJournalLine."Bal. Account Type" := GenJournalLine."Bal. Account Type"::"Bank Account";
                GenJournalLine.VALIDATE("Bal. Account No.", "Bank No.");
                GenJournalLine."Shortcut Dimension 1 Code" := "Shortcut Dimension 1 Code";
                GenJournalLine."Shortcut Dimension 2 Code" := "Shortcut Dimension 2 Code";
                //     GenJournalLine."Shortcut Dimension 4 Code" := ExpenseRequestLine."Asset No.";
                //GenJournalLine.VALIDATE("Dimension Set ID","Dimension Set ID");
                GenJournalLine.INSERT;
            UNTIL ExpenseRequestLine.NEXT = 0;
        END;


        GLEntry.SETRANGE("Document No.", GenJournalLine."Document No.");
        IF GLEntry.FINDFIRST THEN
            ERROR('This document has been posted') ELSE BEGIN

            CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Post+Print", GenJournalLine);

        END;

        CheckPostedJnl;
    end;

    //[Scope('Internal')]
    procedure CheckPostedJnl()
    begin
        GLEntry.SETCURRENTKEY("Document No.", "Posting Date");
        GLEntry.SETRANGE("Document No.", "No.");
        IF GLEntry.FINDFIRST THEN BEGIN
            Posted := TRUE;
            MODIFY;

            ExpenseRequestLine.SETFILTER("Document No.", "No.");
            IF ExpenseRequestLine.FINDSET THEN BEGIN
                REPEAT
                    ExpenseRequestLine.posted := TRUE;
                    ExpenseRequestLine.MODIFY;
                UNTIL ExpenseRequestLine.NEXT = 0;
            END;

        END;
    end;

    procedure ValidateShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    begin
        DimMgt.ValidateShortcutDimValues(FieldNumber, ShortcutDimCode, "Dimension Set ID");
    end;

    // [Scope('Internal')]
    procedure ShowDocDim()
    var
        OldDimSetID: Integer;
    begin
        OldDimSetID := "Dimension Set ID";
        "Dimension Set ID" :=
          DimMgt.EditDimensionSet(
            "Dimension Set ID", STRSUBSTNO('%1', "No."),
            "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code");
        IF OldDimSetID <> "Dimension Set ID" THEN
            MODIFY;
    end;

    //  [Scope('Internal')]
    procedure PostMaintenanceOnIssue()
    var
        FAJournalLine: Record 5621;
        FAJournalLine2: Record 5621;
        MaintenanceLedgEntry: Record 5625;
        MaintenanceLedgEntry2: Record 5625;
    begin
        /*
        
        GLEntry.SETCURRENTKEY("Document No.");
        GLEntry.SETRANGE("Document No.",('FAM_'+"No."));
        IF GLEntry.FINDFIRST THEN BEGIN
          REPEAT
            MaintenanceLedgEntry2.SETRANGE("Entry No.");
            IF MaintenanceLedgEntry2.FINDLAST THEN
              LineNo := MaintenanceLedgEntry2."Entry No.";
              LineNoB += 10000;
            MaintenanceLedgEntry."Entry No." := LineNo + 1;
            MaintenanceLedgEntry."Document No." := GLEntry."Document No.";
            MaintenanceLedgEntry."Posting Date" := GLEntry."Posting Date";
            MaintenanceLedgEntry."Document Date" := GLEntry."Posting Date";
            MaintenanceLedgEntry."FA Posting Date" := GLEntry."Posting Date";
            MaintenanceLedgEntry."Depreciation Book Code" := 'GPC';
            MaintenanceLedgEntry."User ID" := USERID;
            MaintenanceLedgEntry.Quantity := GLEntry.Quantity;
            MaintenanceLedgEntry.VALIDATE("Global Dimension 1 Code",GLEntry."Global Dimension 1 Code");
            MaintenanceLedgEntry.VALIDATE("Global Dimension 2 Code",GLEntry."Global Dimension 2 Code");
            MaintenanceLedgEntry.VALIDATE("Dimension Set ID","Dimension Set ID");
            ExpenseRequestLine.SETRANGE("Document No.","No.");
            ExpenseRequestLine.SETRANGE("Line No.", LineNoB);
            IF ExpenseRequestLine.FINDFIRST THEN BEGIN
              MaintenanceLedgEntry."FA No." := ExpenseRequestLine."Asset No.";
              MaintenanceLedgEntry."Maintenance Code" := ExpenseRequestLine."Maintenance Code";
              MaintenanceLedgEntry.Description := ('Maintanence for ' + ExpenseRequestLine."Asset No.");
            END;
            MaintenanceLedgEntry."Debit Amount" := ABS(GLEntry.Amount);
            MaintenanceLedgEntry.Amount := ABS(GLEntry.Amount);
            MaintenanceLedgEntry.INSERT;
          UNTIL GLEntry.NEXT = 0;
        END;
        */

    end;
}

