table 60057 "Expense Request Line"
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
                ExpReq: Record "Expense Request Header";
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
        ExpReq: Record 60056;
        CurrExchRate: Record 330;
        Text002: Label 'cannot be specified without %1';
        UserSetup: Record 91;

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

