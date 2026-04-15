table 53017 "Unrecon. Bank Legder Schedule"
{

    fields
    {
        field(1; "Rec. Statement No."; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            DataClassification = ToBeClassified;
        }
        field(3; "Bank Account No."; Code[20])
        {
            Caption = 'Bank Account No.';
            DataClassification = ToBeClassified;
            TableRelation = "Bank Account";
        }
        field(4; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
            DataClassification = ToBeClassified;
        }
        field(5; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            DataClassification = ToBeClassified;
        }
        field(6; Description; Text[100])
        {
            Caption = 'Description';
            DataClassification = ToBeClassified;
        }
        field(7; Amount; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Amount';
            DataClassification = ToBeClassified;
        }
        field(8; "Amount (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Amount (LCY)';
            DataClassification = ToBeClassified;
        }
        field(9; "Transaction No."; Integer)
        {
            Caption = 'Transaction No.';
            DataClassification = ToBeClassified;
        }
        field(10; "Statement Status"; Option)
        {
            Caption = 'Statement Status';
            DataClassification = ToBeClassified;
            OptionCaption = 'Open,Bank Acc. Entry Applied,Check Entry Applied,Closed';
            OptionMembers = Open,"Bank Acc. Entry Applied","Check Entry Applied",Closed;
        }
        field(11; "Statement No."; Code[20])
        {
            Caption = 'Statement No.';
            DataClassification = ToBeClassified;
            TableRelation = "Bank Acc. Reconciliation Line"."Statement No." WHERE("Bank Account No." = FIELD("Bank Account No."));
            //This property is currently not supported
            //TestTableRelation = false;
        }
        field(12; "Statement Line No."; Integer)
        {
            Caption = 'Statement Line No.';
            DataClassification = ToBeClassified;
            TableRelation = "Bank Acc. Reconciliation Line"."Statement Line No." WHERE("Bank Account No." = FIELD("Bank Account No."),
                                                                                        "Statement No." = FIELD("Statement No."));
            //This property is currently not supported
            //TestTableRelation = false;
        }
        field(13; "Document Date"; Date)
        {
            Caption = 'Document Date';
            ClosingDates = true;
            DataClassification = ToBeClassified;
        }
        field(14; "External Document No."; Code[35])
        {
            Caption = 'External Document No.';
            DataClassification = ToBeClassified;
        }
        field(15; "Locked Reconciliation No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Bank Acc. Reconciliation Line"."Statement No." WHERE("Bank Account No." = FIELD("Bank Account No."));
            //This property is currently not supported
            //TestTableRelation = false;
        }
        field(16; "Status at Lock"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Open,Closed';
            OptionMembers = " ",Open,Closed;
        }
    }

    keys
    {
        key(Key1; "Rec. Statement No.", "Entry No.", "Bank Account No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

