table 70102 "Document Approval Entry"
{

    fields
    {
        field(1; Sequence; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Table No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(3; "Document No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(4; Sender; Code[30])
        {
            DataClassification = ToBeClassified;
        }
        field(5; Approver; Code[30])
        {
            DataClassification = ToBeClassified;
        }
        field(7; Status; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Pending,Approved,Rejected';
            OptionMembers = " ",Pending,Approved,Rejected;
        }
        field(8; "Record ID to Approve"; RecordID)
        {
            DataClassification = ToBeClassified;
        }
        field(9; "Document Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(10; "Document Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(11; "Document Description"; Text[150])
        {
            DataClassification = ToBeClassified;
        }
        field(12; Open; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(13; "Status Change DateTime"; DateTime)
        {
            DataClassification = ToBeClassified;
        }
        field(14; "Send for Approval DateTime"; DateTime)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; Sequence)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

