table 53001 "Expense Request Header"
{
    LookupPageID = 53207;

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
        field(4; Requester; Text[50])
        {
            Editable = true;
            TableRelation = "User Setup"."User ID";
        }
        field(7; "No. Series"; Code[20])
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
            OptionCaption = ' ,Cash,Cheque,Bank Transfer';
            OptionMembers = " ",Cash,Cheque,BankTransfer;
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
        if status <> status::" " then
            ERROR('You cannot delete this record');
    end;

    trigger OnInsert()
    var
        NoSeries: Codeunit "No. Series";
    begin
        IF "No." = '' THEN BEGIN
            CustomSetup.GET;
            CustomSetup.TESTFIELD("Expense Nos.");
            "No." := NoSeries.GetNextNo(CustomSetup."Expense Nos.");
            "No. Series" := CustomSetup."Expense Nos.";
        END;

        UserSetup.GET(USERID);
        Requester := UserSetup."User ID";
        //"Shortcut Dimension 1 Code" := UserSetup."Shortcut Dimension 1 Code";
        //"Shortcut Dimension 2 Code" := UserSetup."Shortcut Dimension 2 Code";
        //Date := CURRENTDATETIME;
    end;

    trigger OnModify()
    begin
        if Status = Status::Approved then begin
            UserSetup.GET(USERID);
            IF NOT UserSetup."Modify Expense requistion" THEN
                ERROR('You cannot modify this record');
        end;
        "Last Modified DateTime" := CURRENTDATETIME;
        "Last Modified By" := USERID;
    end;

    var
        CustomSetup: Record 53000;
        Text002: Label 'cannot be specified without %1';
        UserSetup: Record 91;
        UserSetup2: Record 91;
        GenJournalLine: Record 81;
        GenJournalLine2: Record 81;
        GLEntry: Record 17;
        GLEntry2: Record 17;
        GenJnlPost: Codeunit 231;
        TestReportPrint: Codeunit 228;
        ExpenseRequestLine: Record 53002;
        ExpenseRequestLine2: Record 53002;
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
        IsVendorLine: Boolean;
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
        BuildExpensePaymentJournalLines();
        //COMMIT;


        GLEntry.SETRANGE("Document No.", "No.");
        IF GLEntry.FINDFIRST THEN
            ERROR('This document has been posted') ELSE BEGIN
            GenJournalLine.RESET;
            GenJournalLine.SETRANGE("Journal Template Name", 'PAYMENTS');
            GenJournalLine.SETRANGE("Journal Batch Name", 'BANK');
            GenJournalLine.FINDFIRST;
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
        IsVendorLine: Boolean;
    begin
        /*IF Status <> Status::Approved THEN
             ERROR(ErrorOnPosting); */

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

        BuildExpensePaymentJournalLines();

        COMMIT;
        GenJournalLine.RESET;
        GenJournalLine.SETRANGE("Journal Template Name", 'PAYMENTS');
        GenJournalLine.SETRANGE("Journal Batch Name", 'BANK');
        GenJournalLine.FINDFIRST;
        GenJnlPost.Preview(GenJournalLine);
    end;

    //[Scope('Internal')]
    procedure TestReport()
    var
        GenJournalLine: Record 81;
        GenJournalLine2: Record 81;
        IsVendorLine: Boolean;
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

        BuildExpensePaymentJournalLines();
        GenJournalLine.RESET;
        GenJournalLine.SETRANGE("Journal Template Name", 'PAYMENTS');
        GenJournalLine.SETRANGE("Journal Batch Name", 'BANK');
        GenJournalLine.FINDFIRST;
        TestReportPrint.PrintGenJnlLine(GenJournalLine);
    end;

    // [Scope('Internal')]
    procedure PostPrint()
    var
        GenJournalLine: Record 81;
        GenJournalLine2: Record 81;
        ExpenseRequestHeaderPrint: Record "Expense Request Header";
        IsVendorLine: Boolean;
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

        BuildExpensePaymentJournalLines();


        GLEntry.SETRANGE("Document No.", "No.");
        IF GLEntry.FINDFIRST THEN
            ERROR('This document has been posted') ELSE BEGIN

            GenJournalLine.RESET;
            GenJournalLine.SETRANGE("Journal Template Name", 'PAYMENTS');
            GenJournalLine.SETRANGE("Journal Batch Name", 'BANK');
            GenJournalLine.FINDFIRST;
            CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Post", GenJournalLine);

        END;

        CheckPostedJnl;

        ExpenseRequestHeaderPrint.SETRANGE("No.", "No.");
        REPORT.RUN(REPORT::"Expense Request Report", TRUE, FALSE, ExpenseRequestHeaderPrint);
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
                    IF NOT ExpenseRequestLine.posted THEN BEGIN
                        IF ExpenseRequestLine."Expense Type" = ExpenseRequestLine."Expense Type"::"Vendor Invoice" THEN
                            UpdateVendorInvoiceRemaining(ExpenseRequestLine);
                        ExpenseRequestLine.posted := TRUE;
                        ExpenseRequestLine.MODIFY;
                    END;
                UNTIL ExpenseRequestLine.NEXT = 0;
            END;

        END;
    end;

    local procedure BuildExpensePaymentJournalLines()
    var
        GenJournalLineLocal: Record "Gen. Journal Line";
        IsVendorLine: Boolean;
        DebitAmountLCY: Decimal;
        WHTAmountLCY: Decimal;
        NetAmountLCY: Decimal;
    begin
        LineNo := 0;
        LineNoB := 0;
        ExpenseRequestLine.SETRANGE("Document No.", "No.");
        IF ExpenseRequestLine.FINDSET THEN BEGIN
            REPEAT
                GenJournalLineLocal.INIT;
                GenJournalLineLocal."Journal Template Name" := 'PAYMENTS';
                GenJournalLineLocal."Journal Batch Name" := 'BANK';
                GenJournalLineLocal."Line No." := GetNextPaymentLineNo();
                GenJournalLineLocal."Document No." := ExpenseRequestLine."Document No.";
                GenJournalLineLocal.VALIDATE("Posting Date", Date);
                IsVendorLine := FALSE;

                IF ExpenseRequestLine."Expense Type" = ExpenseRequestLine."Expense Type"::"Maintenance Expenses" THEN BEGIN
                    GenJournalLineLocal."Account Type" := GenJournalLineLocal."Account Type"::"Fixed Asset";
                    GenJournalLineLocal.VALIDATE("Account No.", ExpenseRequestLine."Asset No.");
                    GenJournalLineLocal."FA Posting Type" := GenJournalLineLocal."FA Posting Type"::Maintenance;
                    GenJournalLineLocal."Maintenance Code" := ExpenseRequestLine."Maintenance Code";
                    LineNo += 10;
                    FAMaintDocNo := 'FAM_' + ExpenseRequestLine."Document No." + '_' + FORMAT(LineNo);
                    GenJournalLineLocal."Document No." := FAMaintDocNo;
                END ELSE
                    IF (ExpenseRequestLine."Expense Type" = ExpenseRequestLine."Expense Type"::"Vendor Invoice") THEN BEGIN
                        IsVendorLine := TRUE;
                        ExpenseRequestLine.TESTFIELD("Payee Code");
                        GenJournalLineLocal."Document Type" := GenJournalLineLocal."Document Type"::Payment;
                        GenJournalLineLocal."Account Type" := GenJournalLineLocal."Account Type"::Vendor;
                        GenJournalLineLocal.VALIDATE("Account No.", ExpenseRequestLine."Payee Code");
                        IF ExpenseRequestLine."Approved Document No." <> '' THEN BEGIN
                            GenJournalLineLocal.VALIDATE("Applies-to Doc. Type", GenJournalLineLocal."Applies-to Doc. Type"::Invoice);
                            GenJournalLineLocal.VALIDATE("Applies-to Doc. No.", ExpenseRequestLine."Approved Document No.");
                        END;

                        IF ExpenseRequestLine."Currency Code" <> '' THEN
                            DebitAmountLCY := ExpenseRequestLine."Amount (LCY)"
                        ELSE
                            DebitAmountLCY := ExpenseRequestLine.Amount;
                        GenJournalLineLocal.VALIDATE("Debit Amount", DebitAmountLCY);
                    END ELSE BEGIN
                        GenJournalLineLocal."Account Type" := GenJournalLineLocal."Account Type"::"G/L Account";
                        GenJournalLineLocal.VALIDATE("Account No.", ExpenseRequestLine."Expense Account No.");
                    END;

                GenJournalLineLocal.Description := COPYSTR(ExpenseRequestLine."Expense Description", 1, 50);
                IF NOT IsVendorLine THEN BEGIN
                    IF ExpenseRequestLine."Currency Code" <> '' THEN
                        DebitAmountLCY := ExpenseRequestLine."Amount (LCY)"
                    ELSE
                        DebitAmountLCY := ExpenseRequestLine.Amount;
                    GenJournalLineLocal.VALIDATE("Debit Amount", DebitAmountLCY);
                END;

                GenJournalLineLocal.VALIDATE("Shortcut Dimension 1 Code", "Shortcut Dimension 1 Code");
                GenJournalLineLocal.VALIDATE("Shortcut Dimension 2 Code", "Shortcut Dimension 2 Code");
                GenJournalLineLocal.VALIDATE("Dimension Set ID", ExpenseRequestLine."Dimension Set ID");

                IF ExpenseRequestLine."WHT Rate" = ExpenseRequestLine."WHT Rate"::"N/A" THEN BEGIN
                    GenJournalLineLocal."Bal. Account Type" := GenJournalLineLocal."Bal. Account Type"::"Bank Account";
                    GenJournalLineLocal.VALIDATE("Bal. Account No.", "Bank No.");
                    GenJournalLineLocal.INSERT;
                END ELSE BEGIN
                    GenJournalLineLocal.INSERT;
                    CustomSetup.GET;
                    CustomSetup.TESTFIELD("WHT Payable Account");

                    WHTAmountLCY := ABS(ExpenseRequestLine."WHT Amount (LCY)");
                    IF WHTAmountLCY = 0 THEN
                        WHTAmountLCY := ABS(ExpenseRequestLine."WHT Amount");
                    IF WHTAmountLCY > ABS(DebitAmountLCY) THEN
                        ERROR('Withholding amount cannot exceed debit amount for line %1.', ExpenseRequestLine."Line No.");

                    NetAmountLCY := DebitAmountLCY - WHTAmountLCY;
                    InsertPaymentCreditLine(ExpenseRequestLine, GenJournalLineLocal."Document No.", "Bank No.", NetAmountLCY, GenJournalLineLocal.Description, FALSE);
                    IF WHTAmountLCY <> 0 THEN
                        InsertPaymentCreditLine(ExpenseRequestLine, GenJournalLineLocal."Document No.", CustomSetup."WHT Payable Account", WHTAmountLCY, GenJournalLineLocal.Description, TRUE);
                END;
            UNTIL ExpenseRequestLine.NEXT = 0;
        END;
    end;

    local procedure InsertPaymentCreditLine(ExpenseLine: Record "Expense Request Line"; DocumentNo: Code[20]; AccountNo: Code[20]; CreditAmount: Decimal; LineDescription: Text[100]; PostToGL: Boolean)
    begin
        IF CreditAmount = 0 THEN
            EXIT;

        GenJournalLine4.INIT;
        GenJournalLine4."Journal Template Name" := 'PAYMENTS';
        GenJournalLine4."Journal Batch Name" := 'BANK';
        GenJournalLine4."Line No." := GetNextPaymentLineNo();
        GenJournalLine4."Document No." := DocumentNo;
        GenJournalLine4.VALIDATE("Posting Date", Date);

        IF PostToGL THEN
            GenJournalLine4."Account Type" := GenJournalLine4."Account Type"::"G/L Account"
        ELSE
            GenJournalLine4."Account Type" := GenJournalLine4."Account Type"::"Bank Account";

        GenJournalLine4.VALIDATE("Account No.", AccountNo);
        GenJournalLine4.Description := COPYSTR(LineDescription, 1, 50);
        GenJournalLine4.VALIDATE("Credit Amount", CreditAmount);
        GenJournalLine4.VALIDATE("Shortcut Dimension 1 Code", "Shortcut Dimension 1 Code");
        GenJournalLine4.VALIDATE("Shortcut Dimension 2 Code", "Shortcut Dimension 2 Code");
        GenJournalLine4.VALIDATE("Dimension Set ID", ExpenseLine."Dimension Set ID");
        GenJournalLine4.INSERT;
    end;

    local procedure GetNextPaymentLineNo(): Integer
    begin
        LineNoB += 10000;
        exit(LineNoB);
    end;

    procedure UpdateVendorInvoiceRemaining(ExpLine: Record "Expense Request Line")
    var
        PurchInvHeader: Record "Purch. Inv. Header";
    begin
        IF ExpLine."Approved Document No." = '' THEN
            EXIT;
        IF NOT PurchInvHeader.GET(ExpLine."Approved Document No.") THEN
            EXIT;

        IF NOT PurchInvHeader."Expense Balance Initialized" THEN BEGIN
            PurchInvHeader.CALCFIELDS(Amount);
            PurchInvHeader."Expense Remaining Balance" := PurchInvHeader.Amount;
            PurchInvHeader."Expense Balance Initialized" := TRUE;
        END;

        PurchInvHeader."Expense Remaining Balance" -= ExpLine.Amount;
        IF PurchInvHeader."Expense Remaining Balance" <= 0 THEN BEGIN
            PurchInvHeader."Expense Remaining Balance" := 0;
            PurchInvHeader."Expense Fully Paid" := TRUE;
        END;
        PurchInvHeader.MODIFY;
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


        GLEntry.SETCURRENTKEY("Document No.");
        GLEntry.SETRANGE("Document No.", ('FAM_' + "No."));
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
                MaintenanceLedgEntry.VALIDATE("Global Dimension 1 Code", GLEntry."Global Dimension 1 Code");
                MaintenanceLedgEntry.VALIDATE("Global Dimension 2 Code", GLEntry."Global Dimension 2 Code");
                MaintenanceLedgEntry.VALIDATE("Dimension Set ID", "Dimension Set ID");
                ExpenseRequestLine.SETRANGE("Document No.", "No.");
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


    end;
}

