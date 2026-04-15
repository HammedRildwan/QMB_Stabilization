table 53103 "POS Transaction Header"
{
    Caption = 'POS Transaction Header';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Transaction No."; Code[20])
        {
            Caption = 'Transaction No.';
            DataClassification = CustomerContent;
        }
        field(2; "Terminal ID"; Code[10])
        {
            Caption = 'Terminal ID';
            DataClassification = CustomerContent;
            TableRelation = "POS Terminal";
            Editable = false;
        }
        field(3; "Shift No."; Code[20])
        {
            Caption = 'Shift No.';
            DataClassification = CustomerContent;
            TableRelation = "POS Shift";
            Editable = false;
        }
        field(10; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
            DataClassification = CustomerContent;
            TableRelation = Customer;

            trigger OnValidate()
            var
                Customer: Record Customer;
            begin
                if Customer.Get("Customer No.") then begin
                    "Customer Name" := Customer.Name;
                    "Customer Price Group" := Customer."Customer Price Group";
                end else begin
                    "Customer Name" := '';
                    "Customer Price Group" := '';
                end;
            end;
        }
        field(11; "Customer Name"; Text[100])
        {
            Caption = 'Customer Name';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(12; "Customer Price Group"; Code[10])
        {
            Caption = 'Customer Price Group';
            DataClassification = CustomerContent;
            TableRelation = "Customer Price Group";
        }
        field(20; "Transaction Date"; Date)
        {
            Caption = 'Transaction Date';
            DataClassification = CustomerContent;
        }
        field(21; "Transaction Time"; Time)
        {
            Caption = 'Transaction Time';
            DataClassification = CustomerContent;
        }
        field(22; "Status"; Enum "POS Transaction Status")
        {
            Caption = 'Status';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(30; "Subtotal"; Decimal)
        {
            Caption = 'Subtotal';
            FieldClass = FlowField;
            CalcFormula = sum("POS Transaction Line"."Line Amount" where("Transaction No." = field("Transaction No.")));
            Editable = false;
        }
        field(31; "Discount Amount"; Decimal)
        {
            Caption = 'Discount Amount';
            DataClassification = CustomerContent;
            MinValue = 0;

            trigger OnValidate()
            begin
                CalculateTotalAmount();
            end;
        }
        field(32; "Total Amount"; Decimal)
        {
            Caption = 'Total Amount';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(33; "Paid Amount"; Decimal)
        {
            Caption = 'Paid Amount';
            FieldClass = FlowField;
            CalcFormula = sum("POS Payment Entry".Amount where("Transaction No." = field("Transaction No.")));
            Editable = false;
        }
        field(34; "Change Amount"; Decimal)
        {
            Caption = 'Change Amount';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(40; "Salesperson Code"; Code[20])
        {
            Caption = 'Salesperson Code';
            DataClassification = CustomerContent;
            TableRelation = "Salesperson/Purchaser";
        }
        field(41; "Location Code"; Code[10])
        {
            Caption = 'Location Code';
            DataClassification = CustomerContent;
            TableRelation = Location;
        }
        field(42; "Business Section"; Enum "POS Business Section")
        {
            Caption = 'Business Section';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50; "Posted Invoice No."; Code[20])
        {
            Caption = 'Posted Invoice No.';
            DataClassification = CustomerContent;
            TableRelation = "Sales Invoice Header";
            Editable = false;
        }
        field(51; "Void Reason"; Text[250])
        {
            Caption = 'Void Reason';
            DataClassification = CustomerContent;
        }
        field(52; "User ID"; Code[50])
        {
            Caption = 'User ID';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(60; "Shortcut Dimension 1 Code"; Code[20])
        {
            Caption = 'Shortcut Dimension 1 Code';
            DataClassification = CustomerContent;
            CaptionClass = '1,2,1';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));
        }
        field(61; "Shortcut Dimension 2 Code"; Code[20])
        {
            Caption = 'Shortcut Dimension 2 Code';
            DataClassification = CustomerContent;
            CaptionClass = '1,2,2';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));
        }
        field(70; "Line Count"; Integer)
        {
            Caption = 'Line Count';
            FieldClass = FlowField;
            CalcFormula = count("POS Transaction Line" where("Transaction No." = field("Transaction No.")));
            Editable = false;
        }
    }

    keys
    {
        key(PK; "Transaction No.")
        {
            Clustered = true;
        }
        key(Key2; "Terminal ID", "Transaction Date")
        {
        }
        key(Key3; "Shift No.", "Status")
        {
        }
        key(Key4; "Business Section", "Transaction Date", "Status")
        {
        }
        key(Key5; "Customer No.", "Transaction Date")
        {
        }
    }

    trigger OnInsert()
    var
        POSSetup: Record "POS Setup";
        NoSeries: Codeunit "No. Series";
    begin
        if "Transaction No." = '' then begin
            POSSetup.GetSetup();
            POSSetup.TestField("POS Transaction Nos.");
            "Transaction No." := NoSeries.GetNextNo(POSSetup."POS Transaction Nos.");
        end;
        "Transaction Date" := Today;
        "Transaction Time" := Time;
        "User ID" := UserId;
        Status := Status::Open;
    end;

    trigger OnDelete()
    var
        POSTransLine: Record "POS Transaction Line";
        POSPaymentEntry: Record "POS Payment Entry";
    begin
        if Status <> Status::Open then
            Error('Cannot delete a transaction that is not Open.');

        POSTransLine.SetRange("Transaction No.", "Transaction No.");
        POSTransLine.DeleteAll(true);

        POSPaymentEntry.SetRange("Transaction No.", "Transaction No.");
        POSPaymentEntry.DeleteAll(true);
    end;

    procedure CalculateTotalAmount()
    begin
        CalcFields(Subtotal);
        "Total Amount" := Subtotal - "Discount Amount";
        if "Total Amount" < 0 then
            "Total Amount" := 0;
    end;

    procedure CalculateChange()
    begin
        CalcFields("Paid Amount");
        if "Paid Amount" > "Total Amount" then
            "Change Amount" := "Paid Amount" - "Total Amount"
        else
            "Change Amount" := 0;
    end;

    procedure IsFullyPaid(): Boolean
    begin
        CalcFields("Paid Amount");
        exit("Paid Amount" >= "Total Amount");
    end;
}
