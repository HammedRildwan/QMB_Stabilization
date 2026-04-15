table 53106 "POS Transaction Archive"
{
    Caption = 'POS Transaction Archive';
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
        }
        field(3; "Shift No."; Code[20])
        {
            Caption = 'Shift No.';
            DataClassification = CustomerContent;
        }
        field(10; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
            DataClassification = CustomerContent;
        }
        field(11; "Customer Name"; Text[100])
        {
            Caption = 'Customer Name';
            DataClassification = CustomerContent;
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
        }
        field(30; "Subtotal"; Decimal)
        {
            Caption = 'Subtotal';
            DataClassification = CustomerContent;
        }
        field(31; "Discount Amount"; Decimal)
        {
            Caption = 'Discount Amount';
            DataClassification = CustomerContent;
        }
        field(32; "Total Amount"; Decimal)
        {
            Caption = 'Total Amount';
            DataClassification = CustomerContent;
        }
        field(33; "Paid Amount"; Decimal)
        {
            Caption = 'Paid Amount';
            DataClassification = CustomerContent;
        }
        field(34; "Change Amount"; Decimal)
        {
            Caption = 'Change Amount';
            DataClassification = CustomerContent;
        }
        field(40; "Salesperson Code"; Code[20])
        {
            Caption = 'Salesperson Code';
            DataClassification = CustomerContent;
        }
        field(41; "Location Code"; Code[10])
        {
            Caption = 'Location Code';
            DataClassification = CustomerContent;
        }
        field(42; "Business Section"; Enum "POS Business Section")
        {
            Caption = 'Business Section';
            DataClassification = CustomerContent;
        }
        field(50; "Posted Invoice No."; Code[20])
        {
            Caption = 'Posted Invoice No.';
            DataClassification = CustomerContent;
        }
        field(51; "User ID"; Code[50])
        {
            Caption = 'User ID';
            DataClassification = CustomerContent;
        }
        field(52; "Archived DateTime"; DateTime)
        {
            Caption = 'Archived DateTime';
            DataClassification = CustomerContent;
        }
        field(60; "Line Count"; Integer)
        {
            Caption = 'Line Count';
            DataClassification = CustomerContent;
        }
        field(61; "Payment Count"; Integer)
        {
            Caption = 'Payment Count';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "Transaction No.")
        {
            Clustered = true;
        }
        key(Key2; "Transaction Date", "Business Section")
        {
        }
        key(Key3; "Terminal ID", "Transaction Date")
        {
        }
        key(Key4; "Shift No.")
        {
        }
        key(Key5; "Posted Invoice No.")
        {
        }
    }

    procedure ArchiveFromHeader(POSTransHeader: Record "POS Transaction Header")
    var
        POSTransLine: Record "POS Transaction Line";
        POSPaymentEntry: Record "POS Payment Entry";
    begin
        Init();
        "Transaction No." := POSTransHeader."Transaction No.";
        "Terminal ID" := POSTransHeader."Terminal ID";
        "Shift No." := POSTransHeader."Shift No.";
        "Customer No." := POSTransHeader."Customer No.";
        "Customer Name" := POSTransHeader."Customer Name";
        "Transaction Date" := POSTransHeader."Transaction Date";
        "Transaction Time" := POSTransHeader."Transaction Time";
        Status := POSTransHeader.Status;

        POSTransHeader.CalcFields(Subtotal);
        Subtotal := POSTransHeader.Subtotal;
        "Discount Amount" := POSTransHeader."Discount Amount";
        "Total Amount" := POSTransHeader."Total Amount";

        POSTransHeader.CalcFields("Paid Amount");
        "Paid Amount" := POSTransHeader."Paid Amount";
        "Change Amount" := POSTransHeader."Change Amount";

        "Salesperson Code" := POSTransHeader."Salesperson Code";
        "Location Code" := POSTransHeader."Location Code";
        "Business Section" := POSTransHeader."Business Section";
        "Posted Invoice No." := POSTransHeader."Posted Invoice No.";
        "User ID" := POSTransHeader."User ID";
        "Archived DateTime" := CurrentDateTime;

        POSTransLine.SetRange("Transaction No.", POSTransHeader."Transaction No.");
        "Line Count" := POSTransLine.Count;

        POSPaymentEntry.SetRange("Transaction No.", POSTransHeader."Transaction No.");
        "Payment Count" := POSPaymentEntry.Count;

        if not Insert() then
            Modify();
    end;
}
