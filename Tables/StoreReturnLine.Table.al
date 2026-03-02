table 70021 "Store Return Line"
{

    fields
    {
        field(1; "Document No."; Code[10])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(2; "Line No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(3; "Item No."; Code[10])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(4; Description; Text[60])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(5; "Unit of Measure"; Code[10])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(6; "Quantity Issued"; Decimal)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(7; "Quantity to Return"; Decimal)
        {
            BlankZero = true;
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 0;
        }
        field(8; "Unit Price"; Decimal)
        {
            BlankZero = true;
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 0;
            Editable = false;
        }
        field(9; Amount; Decimal)
        {
            BlankZero = true;
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 0;
            Editable = false;
        }
        field(10; "Location Code"; Code[10])
        {
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = Location.Code;
        }
        field(11; "Fixed Asset No"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(30; "Variant Code"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Item Variant".Code WHERE ("Item No."=FIELD("Item No."));
        }
    }

    keys
    {
        key(Key1;"Document No.","Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

