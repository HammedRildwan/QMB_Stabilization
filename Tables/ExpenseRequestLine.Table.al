table 53002 "Expense Request Line"
{

    fields
    {
        field(1; "Document No."; Code[15])
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Line No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(3; "Expense Description"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(22; "Expense Type"; Option)
        {
            Editable = true;
            OptionCaption = ' ,Direct Expense,Vendor Invoice,Maintenance Expenses';
            OptionMembers = " ","Direct Expense","Vendor Invoice","Maintenance Expenses";
        }
        field(4; "Expense Account No."; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "G/L Account"."No." WHERE("Direct Posting" = CONST(true));

            trigger OnValidate()
            var
                GLAccount: Record "G/L Account";
            begin
                IF GLAccount.GET("Expense Account No.") THEN
                    "Account Name" := GLAccount.Name
                ELSE
                    "Account Name" := '';

                CustomSetup.Get();
                "Budgeted Amount" := 0;
                "Budget Balance" := 0;
                "G/L Balance" := 0;
                IF CustomSetup."Budget Code" <> '' THEN begin
                    GLBudgetEntry.SetFilter("Budget Name", CustomSetup."Budget Code");
                    GLBudgetEntry.SetFilter("G/L Account No.", "Expense Account No.");
                    GLBudgetEntry.SetFilter(Date, '%1..%2', CALCDATE('<-CY>', Today), CALCDATE('<CY>', Today));
                    IF GLBudgetEntry.FINDFIRST THEN begin
                        repeat
                            if GLBudgetEntry.Amount <> 0 then
                                "Budgeted Amount" += GLBudgetEntry.Amount;
                        until GLBudgetEntry.NEXT = 0;
                    end;

                    GLEntry.SetFilter("G/L Account No.", "Expense Account No.");
                    GLEntry.SetFilter("Posting Date", '%1..%2', CALCDATE('<-CY>', Today), CALCDATE('<CY>', Today));
                    IF GLEntry.FINDFIRST THEN begin
                        repeat
                            if GLEntry.Amount <> 0 then
                                "G/L Balance" += GLEntry.Amount;
                        until GLEntry.NEXT = 0;
                    end;

                    "Budget Balance" := "Budgeted Amount" - "G/L Balance";
                end;


            end;

        }
        field(5; "Account Name"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(6; Amount; Decimal)
        {
            BlankZero = true;
            DataClassification = ToBeClassified;

            trigger OnValidate()
            var
                WHTRate: Decimal;
                ExpReq: Record "Expense Request Header";
                Currency: Record Currency;
                CurrExchRate: Record "Currency Exchange Rate";
            begin
                //IF "Expense Description" = '' THEN
                //Amount := 0;
                ExpReq.GET("Document No.");
                IF "Currency Code" = '' THEN
                    "Amount (LCY)" := Amount
                ELSE BEGIN
                    TESTFIELD("Exchange Rate");
                    IF "Exchange Rate" <> 0 THEN
                        "Currency Factor" := 100 / "Exchange Rate";
                    "Amount (LCY)" := ROUND(
                      CurrExchRate.ExchangeAmtFCYToLCY(
                        ExpReq.Date, "Currency Code",
                        Amount, "Currency Factor" / 100));

                    Amount := ROUND(Amount, Currency."Amount Rounding Precision");
                    TESTFIELD(Amount);
                    WHTRate := 0;

                    IF "WHT Rate" = "WHT Rate"::"10%" THEN
                        WHTRate := 0.1
                    ELSE IF "WHT Rate" = "WHT Rate"::"5%" THEN
                        WHTRate := 0.05
                    ELSE
                        WHTRate := 0;

                    VALIDATE("WHT Amount", Amount * WHTRate);
                END;
            end;
        }
        field(7; "Amount (LCY)"; Decimal)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(8; "Maintenance Code"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = Maintenance;
        }
        field(9; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1),
                                                          Blocked = CONST(false));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(1, "Shortcut Dimension 1 Code");
            end;
        }
        field(10; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2),
                                                          Blocked = CONST(false));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(2, "Shortcut Dimension 2 Code");
            end;
        }
        field(11; "Shortcut Dimension 3 Code"; Code[20])
        {
            CaptionClass = '1,2,3';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(3),
                                                          Blocked = CONST(false));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(3, "Shortcut Dimension 3 Code");
            end;
        }
        field(12; "Shortcut Dimension 4 Code"; Code[20])
        {
            CaptionClass = '1,2,4';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(4),
                                                          Blocked = CONST(false));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(4, "Shortcut Dimension 4 Code");
            end;
        }
        field(13; "Shortcut Dimension 5 Code"; Code[20])
        {
            CaptionClass = '1,2,5';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(5),
                                                          Blocked = CONST(false));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(5, "Shortcut Dimension 5 Code");
            end;
        }
        field(14; "Shortcut Dimension 6 Code"; Code[20])
        {
            CaptionClass = '1,2,6';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(6),
                                                          Blocked = CONST(false));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(6, "Shortcut Dimension 6 Code");
            end;
        }
        field(16; "Asset No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Editable = true;
            TableRelation = "Fixed Asset"."No.";
        }
        field(17; "Currency Code"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = Currency.Code;

            trigger OnValidate()
            begin
                ExpReq.GET("Document No.");
                IF "Currency Code" <> '' THEN BEGIN
                    IF ("Currency Code" <> xRec."Currency Code") OR
                       (CurrFieldNo = FIELDNO("Currency Code")) OR
                       ("Currency Factor" = 0)
                    THEN
                        "Currency Factor" :=
                          CurrExchRate.ExchangeRate(ExpReq.Date, "Currency Code");
                END ELSE
                    "Currency Factor" := 0;

                VALIDATE(Amount, 0);
            end;
        }
        field(18; "Currency Factor"; Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 15;
            Editable = false;
            MinValue = 0;

            trigger OnValidate()
            begin

                IF ("Currency Code" = '') AND ("Currency Factor" <> 0) THEN
                    FIELDERROR("Currency Factor", STRSUBSTNO(Text002, FIELDCAPTION("Currency Code")));
                VALIDATE(Amount);
            end;
        }
        field(19; "Exchange Rate"; Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 2 : 9;

            trigger OnValidate()
            begin
                ExpReq.GET("Document No.");
                IF "Currency Code" = '' THEN
                    "Amount (LCY)" := Amount
                ELSE BEGIN
                    TESTFIELD("Exchange Rate");
                    IF "Exchange Rate" <> 0 THEN
                        "Currency Factor" := 100 / "Exchange Rate";
                    "Amount (LCY)" := ROUND(
                      CurrExchRate.ExchangeAmtFCYToLCY(
                        ExpReq.Date, "Currency Code",
                        Amount, "Currency Factor" / 100));
                END;
            end;
        }
        field(20; Remark; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(21; posted; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(25; "WHT Rate"; Option)
        {
            DataClassification = ToBeClassified;
            Editable = false;
            OptionCaption = 'N/A,5%,10%,2%';
            OptionMembers = "N/A","5%","10%","2%";

            trigger OnValidate()
            var
                WHTRate: Decimal;
                VATRate: Decimal;
                StampDutyRate: Decimal;
            begin
                TESTFIELD(Amount);
                WHTRate := 0;
                VATRate := 0;
                StampDutyRate := 0;

                IF "WHT Rate" = "WHT Rate"::"10%" THEN
                    WHTRate := 0.1
                ELSE IF "WHT Rate" = "WHT Rate"::"5%" THEN
                    WHTRate := 0.05
                ELSE IF "WHT Rate" = "WHT Rate"::"2%" THEN
                    WHTRate := 0.02
                ELSE
                    WHTRate := 0;

                VALIDATE("WHT Amount", Amount * WHTRate);
                // UpdateDeductionsValues;
            end;
        }
        field(23; "WHT Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            Editable = false;

            trigger OnValidate()
            begin
                //  UpdateDeductionsValues;
            end;
        }
        field(24; "WHT Amount (LCY)"; Decimal)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(26; "Budgeted Amount"; Decimal)
        {
            Editable = false;
        }
        field(27; "Budget Balance"; Decimal)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(28; "G/L Balance"; Decimal)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(29; "Payee Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = IF ("Expense Type" = FILTER("Direct Expense")) "G/L Account"."No." WHERE(Blocked = Filter(false),
                                                                                                    "Direct Posting" = CONST(true))
            ELSE IF ("Expense Type" = FILTER("Maintenance Expenses")) "Fixed Asset"."No." WHERE(Blocked = Filter(false))
            ELSE IF ("Expense Type" = CONST("Vendor Invoice")) Vendor."No." WHERE(Blocked = CONST(" "));

            trigger OnValidate()
            var
                Customer: Record Customer;
                Employee: Record Employee;
                Vendor: Record Vendor;

            begin
                IF ("Expense Type" = "Expense Type"::"Direct Expense") THEN BEGIN
                    GLAccount.GET("Payee Code");
                    "Payee Name" := GLAccount.Name;
                END ELSE IF ("Expense Type" = "Expense Type"::"Vendor Invoice") THEN BEGIN
                    Vendor.GET("Payee Code");
                    "Payee Name" := Vendor.Name;
                    IF Vendor."Vendor Posting Group" = '' then
                        error('Posting Group must be set for the payables account!');
                    VendorPostingGroup.GET(Vendor."Vendor Posting Group");
                    If VendorPostingGroup."Payables Account" = '' then
                        error('Payables account must be setup for the posting group!')
                    else
                        VALIDATE("Expense Account No.", VendorPostingGroup."Payables Account");
                END;
            end;
        }
        field(30; "Payee Name"; Text[150])
        {
            DataClassification = ToBeClassified;
        }
        field(47; "Approved Document No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = IF ("Expense Type" = CONST("Vendor Invoice")) "Purch. Inv. Header"."No.";
            // ELSE IF ("Expense Type" = CONST("Retirement Reimbursement")) "e-Retirement Header"."Document No" WHERE(Posted = CONST(true), "Additional Pay Amount (LCY)" = FILTER(> 0), "Staff No" = FIELD("Payee Code"));

            trigger OnValidate()
            var
                //ExpenseRequestsRegister: Record "Expense Requests Register";
                PurchInvHeader: Record "Purch. Inv. Header";
            begin

                //populate relevant fileds with data from approved travel or expense request
                //TESTFIELD("Transaction Type");
                CASE "Expense Type" OF
                    "Expense Type"::"Vendor Invoice":
                        BEGIN
                            PurchInvHeader.SETFILTER("No.", "Approved Document No.");
                            IF PurchInvHeader.FINDFIRST THEN BEGIN
                                "Expense Description" := COPYSTR(PurchInvHeader."Posting Description", 1, 100);
                                PurchInvHeader.CALCFIELDS("Amount Including VAT");
                                VALIDATE("Shortcut Dimension 1 Code", PurchInvHeader."Shortcut Dimension 1 Code");
                                VALIDATE("Shortcut Dimension 2 Code", PurchInvHeader."Shortcut Dimension 2 Code");
                                // VALIDATE("Payee Code", PurchInvHeader."Pay-to Vendor No.");
                                Amount := PurchInvHeader."Amount Including VAT";
                            END;
                        END;

                END;
            end;
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
        field(481; "Expense Category"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Maintenance,Labour,Lubricant,Fuel,Others,Fixed Asset';
            OptionMembers = " ",Maintenance,Labour,Lubricant,Fuel,Others,"Fixed Asset";
        }
    }

    keys
    {
        key(Key1; "Document No.", "Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnModify()
    begin
        ExpReq.GET("Document No.");
        IF ExpReq.Status = ExpReq.Status::Approved THEN BEGIN
            UserSetup.GET(USERID);
            //  IF NOT ((UserSetup."Modify Expense requistion") OR (UserSetup."Modify Expense requistion")) THEN
            //    ERROR('You cannot modify this record');
        END;
    end;

    var
        GLAccount: Record 15;
        DimMgt: Codeunit 408;
        ExpReq: Record 53001;
        CurrExchRate: Record 330;
        CustomSetup: Record "Custom Setup";
        Text002: Label 'cannot be specified without %1';
        UserSetup: Record 91;
        GLBudgetEntry: Record "G/L Budget Entry";
        GLEntry: Record "G/L Entry";
        VendorPostingGroup: Record "Vendor Posting Group";

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
            "Dimension Set ID", StrSubstNo('%1', "Document No."),
            "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code");
        IF OldDimSetID <> "Dimension Set ID" THEN
            MODIFY;
    end;
}

