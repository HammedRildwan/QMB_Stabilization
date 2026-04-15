table 53011 "Doc. Workflow Line"
{

    fields
    {
        field(1; "Sender User ID"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(2; Sequence; Integer)
        {
            BlankZero = true;
            DataClassification = ToBeClassified;
        }
        field(3; Approver; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "User Setup"."User ID";
        }
        field(4; "Table No."; Integer)
        {
            DataClassification = ToBeClassified;
            TableRelation = AllObj."Object ID" WHERE("Object Type" = FILTER(Table));
        }
        field(5; "Approval Limit"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Sender User ID", Sequence, "Table No.", "Approval Limit")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

