table 53105 "POS Payment Entry"
{
    Caption = 'POS Payment Entry';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            DataClassification = CustomerContent;
            AutoIncrement = true;
        }
        field(2; "Transaction No."; Code[20])
        {
            Caption = 'Transaction No.';
            DataClassification = CustomerContent;
            TableRelation = "POS Transaction Header";
        }
        field(3; "Shift No."; Code[20])
        {
            Caption = 'Shift No.';
            DataClassification = CustomerContent;
            TableRelation = "POS Shift";
        }
        field(10; "Payment Method"; Enum "POS Payment Method")
        {
            Caption = 'Payment Method';
            DataClassification = CustomerContent;
        }
        field(11; "Amount"; Decimal)
        {
            Caption = 'Amount';
            DataClassification = CustomerContent;
            AutoFormatType = 1;
        }
        field(12; "Tendered Amount"; Decimal)
        {
            Caption = 'Tendered Amount';
            DataClassification = CustomerContent;
            AutoFormatType = 1;

            trigger OnValidate()
            begin
                "Change Amount" := "Tendered Amount" - Amount;
                if "Change Amount" < 0 then
                    "Change Amount" := 0;
            end;
        }
        field(13; "Change Amount"; Decimal)
        {
            Caption = 'Change Amount';
            DataClassification = CustomerContent;
            AutoFormatType = 1;
            Editable = false;
        }
        field(20; "Reference No."; Code[50])
        {
            Caption = 'Reference No.';
            DataClassification = CustomerContent;
        }
        field(21; "Payment DateTime"; DateTime)
        {
            Caption = 'Payment DateTime';
            DataClassification = CustomerContent;
        }
        field(22; "User ID"; Code[50])
        {
            Caption = 'User ID';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(30; "Terminal ID"; Code[10])
        {
            Caption = 'Terminal ID';
            DataClassification = CustomerContent;
            TableRelation = "POS Terminal";
        }
        field(31; "Business Section"; Enum "POS Business Section")
        {
            Caption = 'Business Section';
            DataClassification = CustomerContent;
        }
        field(40; "Posted"; Boolean)
        {
            Caption = 'Posted';
            DataClassification = CustomerContent;
            Editable = false;
        }
    }

    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
        key(Key2; "Transaction No.")
        {
        }
        key(Key3; "Shift No.", "Payment Method")
        {
            SumIndexFields = Amount;
        }
        key(Key4; "Business Section", "Payment DateTime")
        {
        }
    }

    trigger OnInsert()
    var
        POSTransHeader: Record "POS Transaction Header";
    begin
        "Payment DateTime" := CurrentDateTime;
        "User ID" := UserId;

        if POSTransHeader.Get("Transaction No.") then begin
            "Shift No." := POSTransHeader."Shift No.";
            "Terminal ID" := POSTransHeader."Terminal ID";
            "Business Section" := POSTransHeader."Business Section";
        end;
    end;

    trigger OnModify()
    begin
        UpdateTransactionHeader();
    end;

    trigger OnDelete()
    begin
        UpdateTransactionHeader();
    end;

    local procedure UpdateTransactionHeader()
    var
        POSTransHeader: Record "POS Transaction Header";
    begin
        if POSTransHeader.Get("Transaction No.") then begin
            POSTransHeader.CalculateChange();
            POSTransHeader.Modify();
        end;
    end;
}
