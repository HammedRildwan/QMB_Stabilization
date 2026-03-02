table 70100 "Doc. Workflow Header"
{

    fields
    {
        field(1; "User ID"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "User Setup"."User ID";
        }
        field(2; "Table No."; Integer)
        {
            DataClassification = ToBeClassified;
            TableRelation = AllObj."Object ID" WHERE ("Object Type"=FILTER(Table));

            trigger OnValidate()
            begin
                IF AllObj.GET(AllObj."Object Type"::Table,"Table No.") THEN
                  "Table Name" := AllObj."Object Name"
                ELSE
                  "Table Name" := '';
            end;
        }
        field(3;"Table Name";Text[70])
        {
            DataClassification = ToBeClassified;
        }
        field(4;"Approval Limit";Decimal)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1;"User ID","Table No.","Approval Limit")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        AllObj: Record 2000000038;
}

