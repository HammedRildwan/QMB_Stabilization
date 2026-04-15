table 53104 "POS Transaction Line"
{
    Caption = 'POS Transaction Line';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Transaction No."; Code[20])
        {
            Caption = 'Transaction No.';
            DataClassification = CustomerContent;
            TableRelation = "POS Transaction Header";
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
            DataClassification = CustomerContent;
        }
        field(10; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            DataClassification = CustomerContent;
            TableRelation = Item;

            trigger OnValidate()
            var
                Item: Record Item;
                POSTransHeader: Record "POS Transaction Header";
            begin
                if Item.Get("Item No.") then begin
                    Description := Item.Description;
                    "Unit of Measure Code" := Item."Sales Unit of Measure";
                    if "Unit of Measure Code" = '' then
                        "Unit of Measure Code" := Item."Base Unit of Measure";

                    // Get price from BC Sales Price or fallback to Item.Unit Price
                    if POSTransHeader.Get("Transaction No.") then
                        "Unit Price" := GetSalesPrice(Item, POSTransHeader."Customer Price Group", POSTransHeader."Transaction Date")
                    else
                        "Unit Price" := Item."Unit Price";

                    if Quantity = 0 then
                        Quantity := 1;
                    CalculateLineAmount();
                end else begin
                    Description := '';
                    "Unit Price" := 0;
                    "Unit of Measure Code" := '';
                end;
            end;
        }
        field(11; "Barcode"; Code[50])
        {
            Caption = 'Barcode';
            DataClassification = CustomerContent;

            trigger OnValidate()
            var
                Item: Record Item;
                ItemReference: Record "Item Reference";
            begin
                if Barcode = '' then
                    exit;

                // Try to find item by barcode (Item Reference)
                ItemReference.SetRange("Reference Type", ItemReference."Reference Type"::"Bar Code");
                ItemReference.SetRange("Reference No.", Barcode);
                if ItemReference.FindFirst() then begin
                    Validate("Item No.", ItemReference."Item No.");
                    if ItemReference."Variant Code" <> '' then
                        "Variant Code" := ItemReference."Variant Code";
                    exit;
                end;

                // Fallback: Try as Item No.
                if Item.Get(Barcode) then begin
                    Validate("Item No.", Barcode);
                    exit;
                end;

                Error('Item with barcode %1 not found.', Barcode);
            end;
        }
        field(12; "Description"; Text[100])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(20; "Quantity"; Decimal)
        {
            Caption = 'Quantity';
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 5;
            MinValue = 0;

            trigger OnValidate()
            begin
                CalculateLineAmount();
            end;
        }
        field(21; "Unit of Measure Code"; Code[10])
        {
            Caption = 'Unit of Measure Code';
            DataClassification = CustomerContent;
            TableRelation = "Item Unit of Measure".Code where("Item No." = field("Item No."));
        }
        field(22; "Unit Price"; Decimal)
        {
            Caption = 'Unit Price';
            DataClassification = CustomerContent;
            AutoFormatType = 2;
            MinValue = 0;

            trigger OnValidate()
            begin
                CalculateLineAmount();
            end;
        }
        field(30; "Discount %"; Decimal)
        {
            Caption = 'Discount %';
            DataClassification = CustomerContent;
            MinValue = 0;
            MaxValue = 100;

            trigger OnValidate()
            begin
                "Discount Amount" := Round(Quantity * "Unit Price" * "Discount %" / 100);
                CalculateLineAmount();
            end;
        }
        field(31; "Discount Amount"; Decimal)
        {
            Caption = 'Discount Amount';
            DataClassification = CustomerContent;
            AutoFormatType = 1;
            MinValue = 0;

            trigger OnValidate()
            begin
                if Quantity * "Unit Price" <> 0 then
                    "Discount %" := Round("Discount Amount" / (Quantity * "Unit Price") * 100, 0.00001)
                else
                    "Discount %" := 0;
                CalculateLineAmount();
            end;
        }
        field(32; "Line Amount"; Decimal)
        {
            Caption = 'Line Amount';
            DataClassification = CustomerContent;
            AutoFormatType = 1;
            Editable = false;
        }
        field(40; "Location Code"; Code[10])
        {
            Caption = 'Location Code';
            DataClassification = CustomerContent;
            TableRelation = Location;
        }
        field(41; "Variant Code"; Code[10])
        {
            Caption = 'Variant Code';
            DataClassification = CustomerContent;
            TableRelation = "Item Variant".Code where("Item No." = field("Item No."));
        }
        field(50; "Shortcut Dimension 1 Code"; Code[20])
        {
            Caption = 'Shortcut Dimension 1 Code';
            DataClassification = CustomerContent;
            CaptionClass = '1,2,1';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));
        }
        field(51; "Shortcut Dimension 2 Code"; Code[20])
        {
            Caption = 'Shortcut Dimension 2 Code';
            DataClassification = CustomerContent;
            CaptionClass = '1,2,2';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));
        }
    }

    keys
    {
        key(PK; "Transaction No.", "Line No.")
        {
            Clustered = true;
        }
        key(Key2; "Item No.")
        {
        }
    }

    trigger OnInsert()
    var
        POSTransLine: Record "POS Transaction Line";
    begin
        if "Line No." = 0 then begin
            POSTransLine.SetRange("Transaction No.", "Transaction No.");
            if POSTransLine.FindLast() then
                "Line No." := POSTransLine."Line No." + 10000
            else
                "Line No." := 10000;
        end;
    end;

    trigger OnModify()
    begin
        UpdateHeaderTotals();
    end;

    trigger OnDelete()
    begin
        UpdateHeaderTotals();
    end;

    local procedure CalculateLineAmount()
    begin
        "Line Amount" := Round(Quantity * "Unit Price" - "Discount Amount", 0.01);
        if "Line Amount" < 0 then
            "Line Amount" := 0;
    end;

    local procedure UpdateHeaderTotals()
    var
        POSTransHeader: Record "POS Transaction Header";
    begin
        if POSTransHeader.Get("Transaction No.") then begin
            POSTransHeader.CalculateTotalAmount();
            POSTransHeader.Modify();
        end;
    end;

    local procedure GetSalesPrice(Item: Record Item; CustomerPriceGroup: Code[10]; PriceDate: Date): Decimal
    var
        PriceListLine: Record "Price List Line";
    begin
        // Try to find BC Price List Line for Customer Price Group (V16+ pricing)
        if CustomerPriceGroup <> '' then begin
            PriceListLine.SetRange("Asset Type", PriceListLine."Asset Type"::Item);
            PriceListLine.SetRange("Asset No.", Item."No.");
            PriceListLine.SetRange("Source Type", PriceListLine."Source Type"::"Customer Price Group");
            PriceListLine.SetRange("Source No.", CustomerPriceGroup);
            PriceListLine.SetRange(Status, PriceListLine.Status::Active);
            PriceListLine.SetFilter("Starting Date", '<=%1|%2', PriceDate, 0D);
            PriceListLine.SetFilter("Ending Date", '>=%1|%2', PriceDate, 0D);
            if PriceListLine.FindLast() then
                exit(PriceListLine."Unit Price");
        end;

        // Fallback to Item.Unit Price
        exit(Item."Unit Price");
    end;
}
