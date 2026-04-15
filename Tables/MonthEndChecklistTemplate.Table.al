table 53003 "Month-End Checklist Template"
{
    Caption = 'Month-End Checklist Template';
    DataClassification = CustomerContent;
    LookupPageId = "Month-End Checklist Templates";
    DrillDownPageId = "Month-End Checklist Templates";

    fields
    {
        field(1; "Code"; Code[20])
        {
            Caption = 'Code';
            NotBlank = true;
        }
        field(2; Description; Text[100])
        {
            Caption = 'Description';
        }
        field(3; "Sequence No."; Integer)
        {
            Caption = 'Sequence No.';
            MinValue = 1;
        }
        field(4; Category; Enum "Closing Task Category")
        {
            Caption = 'Category';
        }
        field(5; "Responsible Role"; Code[50])
        {
            Caption = 'Responsible Role';
            TableRelation = "User Setup"."User ID";
        }
        field(6; "Est. Duration (Minutes)"; Integer)
        {
            Caption = 'Est. Duration (Minutes)';
            MinValue = 0;
        }
        field(7; "Auto-Validate"; Boolean)
        {
            Caption = 'Auto-Validate';
        }
        field(8; "Validation Type"; Enum "Closing Validation Type")
        {
            Caption = 'Validation Type';
        }
        field(9; "Related Page ID"; Integer)
        {
            Caption = 'Related Page ID';
            TableRelation = AllObjWithCaption."Object ID" where("Object Type" = const(Page));
        }
        field(10; "Related Report ID"; Integer)
        {
            Caption = 'Related Report ID';
            TableRelation = AllObjWithCaption."Object ID" where("Object Type" = const(Report));
        }
        field(11; "Blocking"; Boolean)
        {
            Caption = 'Blocking';
        }
        field(12; "Instructions"; Text[2048])
        {
            Caption = 'Instructions';
        }
        field(13; Active; Boolean)
        {
            Caption = 'Active';
            InitValue = true;
        }
    }

    keys
    {
        key(PK; "Code")
        {
            Clustered = true;
        }
        key(Sequence; "Sequence No.")
        {
        }
        key(Category; Category, "Sequence No.")
        {
        }
    }

    trigger OnInsert()
    begin
        if "Sequence No." = 0 then
            "Sequence No." := GetNextSequenceNo();
    end;

    local procedure GetNextSequenceNo(): Integer
    var
        Template: Record "Month-End Checklist Template";
    begin
        Template.SetCurrentKey("Sequence No.");
        if Template.FindLast() then
            exit(Template."Sequence No." + 10)
        else
            exit(10);
    end;
}
