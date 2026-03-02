table 70019 "Store Requisition Line"
{

    fields
    {
        field(1; "Document No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Line No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(3; "Item No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Item."No." WHERE(Type = CONST(Inventory));

            trigger OnValidate()
            var
                StoreRequisitionHeader: Record 70018;
                Item: Record 27;
            begin
                IF Item.GET("Item No.") THEN BEGIN
                    Description := Item.Description;
                    "Unit Price" := Item."Unit Cost";
                    "Unit of Measure" := Item."Base Unit of Measure";
                    "Inventory Posting Group" := Item."Inventory Posting Group";
                    //"Available Quantity":= Item."Net Change";
                    Item.SETFILTER("Location Filter", "Location Code");
                    Item.CALCFIELDS(Inventory);
                    "Available Quantity" := Item.Inventory;
                    //"Qty in Store at the moment" := Item.Inventory;

                END ELSE BEGIN
                    Description := '';
                    "Unit Price" := 0;
                    "Unit of Measure" := '';
                    "Available Quantity" := 0.0;
                    //VALUE := 0;
                    "Qty in Store at the moment" := 0;
                END;
            end;
        }
        field(4; Description; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(5; "Unit of Measure"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Unit of Measure";
        }
        field(6; "Quantity Requested"; Decimal)
        {
            BlankZero = true;
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 0;

            trigger OnValidate()
            var
                StoreRequisitionHeader: Record 70018;
                Text002: Label 'Store Location should be selected on the header!';
                Text001: Label 'There is no sufficient quantity for this item!';
                Text003: Label 'Quantity to Issue cannot be greater than %1';
                Item: Record 27;
            begin
                StoreRequisitionHeader.GET("Document No.");
                IF StoreRequisitionHeader."Store Location" <> '' THEN
                    "Location Code" := StoreRequisitionHeader."Store Location"
                ELSE
                    ERROR(Text002);
                "Fixed Asset No." := StoreRequisitionHeader."Asset No.";

                Item.SETCURRENTKEY("No.");
                Item.SETRANGE("No.", "Item No.");
                Item.SETFILTER("Location Filter", '%1', "Location Code");
                IF Item.FINDFIRST THEN BEGIN
                    Item.CALCFIELDS("Net Change");
                    "Available Quantity" := Item."Net Change";
                    "Qty in Store at the moment" := Item."Net Change";
                    IF Item."Net Change" < "Quantity Requested" THEN
                        MESSAGE(Text001);
                END;

                Amount := "Unit Price" * "Quantity to Issue";
            end;
        }
        field(7; "Quantity to Issue"; Decimal)
        {
            BlankZero = true;
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 0;

            trigger OnValidate()
            var
                StoreRequisitionHeader: Record 70018;
                Text001: Label 'There is no sufficient quantity for this item!';
                Text002: Label 'Store Location should be selected on the header!';
                Text003: Label 'Quantity to Issue cannot be greater than %1';
                Item: Record 27;
            begin
                StoreRequisitionHeader.GET("Document No.");
                IF StoreRequisitionHeader."Store Location" <> '' THEN
                    "Location Code" := StoreRequisitionHeader."Store Location"
                ELSE
                    ERROR(Text002);
                TESTFIELD("Location Code");

                IF StoreRequisitionHeader."Request Type" = StoreRequisitionHeader."Request Type"::Maintenance THEN
                    TESTFIELD("Maintenance Code");

                ItemQty := "Quantity to Issue";

                IF "Quantity to Issue" > "Quantity Requested" THEN
                    ERROR(Text003, "Quantity Requested");

                Item.SETCURRENTKEY("No.");
                Item.SETRANGE("No.", "Item No.");
                Item.SETFILTER("Location Filter", '%1', "Location Code");
                IF Item.FINDFIRST THEN BEGIN
                    Item.CALCFIELDS("Net Change");
                    IF Item."Net Change" < ItemQty THEN
                        ERROR(Text001);
                END;

                Amount := "Unit Price" * "Quantity to Issue";
            end;
        }
        field(8; "Unit Price"; Decimal)
        {
            BlankZero = true;
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(9; Amount; Decimal)
        {
            BlankZero = true;
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(10; "Location Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = Location.Code;

            trigger OnValidate()
            var
                StoreRequisitionHeader: Record 70018;
                Text002: Label 'Store Location should be selected on the header!';
                Item: Record 27;
            begin
                IF Item.GET("Item No.") THEN BEGIN
                    Description := Item.Description;
                    "Unit Price" := Item."Unit Cost";
                    "Unit of Measure" := Item."Base Unit of Measure";
                    //"Available Quantity":= Item."Net Change";
                    Item.SETFILTER("Location Filter", "Location Code");
                    Item.CALCFIELDS(Inventory);
                    "Available Quantity" := Item.Inventory;
                    //"Qty in Store at the moment" := Item.Inventory;

                END ELSE BEGIN
                    Description := '';
                    "Unit Price" := 0;
                    "Unit of Measure" := '';
                    "Available Quantity" := 0.0;
                    //VALUE := 0;
                    "Qty in Store at the moment" := 0;
                END;
            end;
        }
        field(11; "Available Quantity"; Decimal)
        {
            BlankZero = true;
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(12; "Qty in Store at the moment"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Item Ledger Entry".Quantity WHERE("Item No." = FIELD("Item No."),
                                                                  "Location Code" = FIELD("Location Code")));
            Editable = false;
        }
        field(13; "Shortcut Dimension 3 Code"; Code[20])
        {
            CaptionClass = '1,2,3';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(3),
                                                          Blocked = CONST(false));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(3, "Shortcut Dimension 3 Code");
            end;
        }
        field(14; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1),
                                                          Blocked = CONST(false));

            trigger OnValidate()
            begin
                //ValidateShortcutDimCode(1,"Shortcut Dimension 1 Code");
            end;
        }
        field(15; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2),
                                                          Blocked = CONST(false));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(2, "Shortcut Dimension 2 Code");
            end;
        }
        field(16; "Fixed Asset No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Fixed Asset"."No.";

            trigger OnValidate()
            var
                StoreRequisitionHeader: Record 70018;
                Truck: Record 5600;
            begin
                StoreRequisitionHeader.GET("Document No.");
                IF (StoreRequisitionHeader."Request Type" = StoreRequisitionHeader."Request Type"::Maintenance) AND
                  (StoreRequisitionHeader."Maintenance Type" = StoreRequisitionHeader."Maintenance Type"::Truck) THEN BEGIN
                    IF Truck.GET("Fixed Asset No.") THEN BEGIN
                        //  VALIDATE("Shortcut Dimension 2 Code",Truck."Operation Code");
                        //  VALIDATE("Shortcut Dimension 4 Code",Truck."Truck ID");  //can be replaced with Fixed assets as dimension
                        MODIFY;
                    END;
                END;
            end;
        }
        field(17; "Maintenance Code"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Fault Code";
        }
        field(18; "Posting Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(19; "Old Spare Part Returned"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(20; "Old Spare Return Location"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Location.Code;
        }
        field(21; "Quantity Issued"; Decimal)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(22; "Remaining Quantity"; Decimal)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(23; "Shortcut Dimension 4 Code"; Code[20])
        {
            CaptionClass = '1,2,4';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(4),
                                                          Blocked = CONST(false));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(4, "Shortcut Dimension 4 Code");
            end;
        }
        field(24; "Inventory Posting Group"; Code[20])
        {
            Caption = 'Inventory Posting Group';
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = "Inventory Posting Group";

            trigger OnValidate()
            begin
                /*IF "Inventory Posting Group" <> '' THEN
                  TESTFIELD(Type,Type::Inventory);*/

            end;
        }
        field(25; Posted; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(26; "Actual Cost Amount"; Decimal)
        {
            Editable = false;
            FieldClass = Normal;
        }
        field(27; "Actual Posting Date"; Date)
        {
            CalcFormula = Lookup("Item Ledger Entry"."Posting Date" WHERE("Document No." = FIELD("Document No."),
                                                                           "Item No." = FIELD("Item No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(28; "Assigned Technician"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = Resource."No." WHERE(Type = CONST(Person));

            trigger OnValidate()
            var
                ResourceRec: Record 156;
            begin
                IF ResourceRec.GET("Assigned Technician") THEN
                    "Technician Name" := ResourceRec.Name
                ELSE
                    "Technician Name" := '';
            end;
        }
        field(29; "Technician Name"; Text[80])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(30; "Variant Code"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Item Variant".Code WHERE("Item No." = FIELD("Item No."));
        }
        field(480; "Dimension Set ID"; Integer)
        {
            Caption = 'Dimension Set ID';
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = "Dimension Set Entry";

            trigger OnLookup()
            begin
                ShowDocDim;
            end;

            trigger OnValidate()
            begin
                //DimMgt.UpdateGlobalDimFromDimSetID("Dimension Set ID","Shortcut Dimension 3 Code");
            end;
        }
        field(50000; "Date-H"; Date)
        {
            CalcFormula = Lookup("Store Requisition Header"."Request Date" WHERE("No." = FIELD("Document No.")));
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "Document No.", "Line No.")
        {
            Clustered = true;
        }
        key(Key2; "Fixed Asset No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        StoreRequisitionHeader.GET("Document No.");
        IF StoreRequisitionHeader."Store Location" <> '' THEN
            "Location Code" := StoreRequisitionHeader."Store Location"
        ELSE
            ERROR(Text002);
        "Fixed Asset No." := StoreRequisitionHeader."Asset No.";

        IF (StoreRequisitionHeader."Request Type" = StoreRequisitionHeader."Request Type"::Maintenance) AND
          (StoreRequisitionHeader."Maintenance Type" = StoreRequisitionHeader."Maintenance Type"::Truck) THEN BEGIN
            Truck.GET(StoreRequisitionHeader."Asset No.");
            //    VALIDATE("Shortcut Dimension 2 Code",Truck."Operation Code");
        END;
    end;

    trigger OnModify()
    begin
        StoreRequisitionHeader.GET("Document No.");
        "Fixed Asset No." := StoreRequisitionHeader."Asset No.";

        IF (StoreRequisitionHeader."Request Type" = StoreRequisitionHeader."Request Type"::Maintenance) AND
          (StoreRequisitionHeader."Maintenance Type" = StoreRequisitionHeader."Maintenance Type"::Truck) THEN BEGIN
            Truck.GET(StoreRequisitionHeader."Asset No.");
            //  VALIDATE("Shortcut Dimension 2 Code",Truck."Operation Code");
        END;
    end;

    var
        Item: Record 27;
        ItemQty: Decimal;
        Text001: Label 'There is no sufficient quantity for this item!';
        DimMgt: Codeunit DimensionManagement;
        StoreRequisitionHeader: Record 70018;
        Text002: Label 'Store Location should be selected on the header!';
        Text003: Label 'Sorry, you can not issue more than the requested quantity %1!';
        FARec: Record 5600;
        Truck: Record 5600;
        ResourceRec: Record 156;

    procedure ValidateShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    begin
        DimMgt.ValidateShortcutDimValues(FieldNumber, ShortcutDimCode, "Dimension Set ID");
    end;

    //[Scope('Internal')]
    procedure ShowDocDim()
    var
        OldDimSetID: Integer;
    begin
        OldDimSetID := "Dimension Set ID";
        "Dimension Set ID" :=
         DimMgt.EditDimensionSet(
           "Dimension Set ID", STRSUBSTNO('%1', "Document No."),
           "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code");
        IF OldDimSetID <> "Dimension Set ID" THEN
            MODIFY;
    end;
}

