table 53102 "POS Shift"
{
    Caption = 'POS Shift';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Shift No."; Code[20])
        {
            Caption = 'Shift No.';
            DataClassification = CustomerContent;
        }
        field(2; "Terminal ID"; Code[10])
        {
            Caption = 'Terminal ID';
            DataClassification = CustomerContent;
            TableRelation = "POS Terminal";
        }
        field(3; "User ID"; Code[50])
        {
            Caption = 'User ID';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(10; "Opening DateTime"; DateTime)
        {
            Caption = 'Opening DateTime';
            DataClassification = CustomerContent;
        }
        field(11; "Closing DateTime"; DateTime)
        {
            Caption = 'Closing DateTime';
            DataClassification = CustomerContent;
        }
        field(20; "Opening Float"; Decimal)
        {
            Caption = 'Opening Float';
            DataClassification = CustomerContent;
            MinValue = 0;
        }
        field(21; "Expected Cash"; Decimal)
        {
            Caption = 'Expected Cash';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(22; "Declared Cash"; Decimal)
        {
            Caption = 'Declared Cash';
            DataClassification = CustomerContent;
            MinValue = 0;

            trigger OnValidate()
            begin
                Variance := "Expected Cash" - "Declared Cash";
            end;
        }
        field(23; "Variance"; Decimal)
        {
            Caption = 'Variance';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(30; "Status"; Enum "POS Shift Status")
        {
            Caption = 'Status';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(40; "Total Sales"; Decimal)
        {
            Caption = 'Total Sales';
            FieldClass = FlowField;
            CalcFormula = sum("POS Transaction Header"."Total Amount" where("Shift No." = field("Shift No."), Status = filter(Posted)));
            Editable = false;
        }
        field(41; "Total Cash Sales"; Decimal)
        {
            Caption = 'Total Cash Sales';
            FieldClass = FlowField;
            CalcFormula = sum("POS Payment Entry".Amount where("Shift No." = field("Shift No."), "Payment Method" = const(Cash)));
            Editable = false;
        }
        field(42; "Transaction Count"; Integer)
        {
            Caption = 'Transaction Count';
            FieldClass = FlowField;
            CalcFormula = count("POS Transaction Header" where("Shift No." = field("Shift No."), Status = filter(Posted)));
            Editable = false;
        }
        field(50; "Business Section"; Enum "POS Business Section")
        {
            Caption = 'Business Section';
            DataClassification = CustomerContent;
            Editable = false;
        }
    }

    keys
    {
        key(PK; "Shift No.")
        {
            Clustered = true;
        }
        key(Key2; "Terminal ID", "Status")
        {
        }
        key(Key3; "User ID", "Opening DateTime")
        {
        }
        key(Key4; "Business Section", "Opening DateTime")
        {
        }
    }

    trigger OnInsert()
    var
        POSSetup: Record "POS Setup";
        NoSeries: Codeunit "No. Series";
    begin
        if "Shift No." = '' then begin
            POSSetup.GetSetup();
            POSSetup.TestField("POS Shift Nos.");
            "Shift No." := NoSeries.GetNextNo(POSSetup."POS Shift Nos.");
        end;
        "User ID" := UserId;
        "Opening DateTime" := CurrentDateTime;
    end;

    procedure CalculateExpectedCash()
    begin
        CalcFields("Total Cash Sales");
        "Expected Cash" := "Opening Float" + "Total Cash Sales";
        Modify();
    end;
}
