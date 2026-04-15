codeunit 53320 "POS Transaction Mgt."
{
    Description = 'POS Transaction Management - Cart operations, payment processing';

    var
        POSSetup: Record "POS Setup";
        SetupRead: Boolean;

    // ============================================
    // Transaction Creation
    // ============================================

    procedure CreateNewTransaction(TerminalID: Code[10]): Code[20]
    var
        POSTransHeader: Record "POS Transaction Header";
        POSTerminal: Record "POS Terminal";
        POSShift: Record "POS Shift";
    begin
        GetSetup();

        POSTerminal.Get(TerminalID);
        POSTerminal.TestField(Active);

        // Validate shift if required
        if POSSetup."Require Shift Open" then begin
            POSTerminal.TestField("Current Shift No.");
            POSShift.Get(POSTerminal."Current Shift No.");
            POSShift.TestField(Status, POSShift.Status::Open);
        end;

        // Create transaction header
        POSTransHeader.Init();
        POSTransHeader.Insert(true);

        // Set terminal/shift info
        POSTransHeader."Terminal ID" := TerminalID;
        POSTransHeader."Shift No." := POSTerminal."Current Shift No.";
        POSTransHeader."Location Code" := POSTerminal."Location Code";
        POSTransHeader."Business Section" := POSTerminal."Business Section";
        POSTransHeader."Customer Price Group" := POSTerminal."Customer Price Group";

        // Set default customer from terminal
        if POSTerminal."Default Customer No." <> '' then
            POSTransHeader.Validate("Customer No.", POSTerminal."Default Customer No.");

        // Set dimensions
        POSTransHeader."Shortcut Dimension 1 Code" := POSTerminal."Dimension 1 Code";
        POSTransHeader."Shortcut Dimension 2 Code" := POSTerminal."Dimension 2 Code";

        POSTransHeader.Modify();

        // Update terminal last transaction
        POSTerminal."Last Transaction No." := POSTransHeader."Transaction No.";
        POSTerminal.Modify();

        exit(POSTransHeader."Transaction No.");
    end;

    // ============================================
    // Item Entry (Barcode/Item No.)
    // ============================================

    procedure AddItemByBarcode(TransNo: Code[20]; Barcode: Code[50]): Boolean
    var
        POSTransHeader: Record "POS Transaction Header";
        POSTransLine: Record "POS Transaction Line";
        ExistingLine: Record "POS Transaction Line";
    begin
        if not POSTransHeader.Get(TransNo) then
            exit(false);

        if POSTransHeader.Status <> POSTransHeader.Status::Open then
            Error('Cannot add items to a transaction that is not Open.');

        // Check if item already exists in cart, then increment
        ExistingLine.SetRange("Transaction No.", TransNo);
        ExistingLine.SetRange(Barcode, Barcode);
        if ExistingLine.FindFirst() then begin
            ExistingLine.Validate(Quantity, ExistingLine.Quantity + 1);
            ExistingLine.Modify(true);
            UpdateTransactionTotals(TransNo);
            exit(true);
        end;

        // Create new line
        POSTransLine.Init();
        POSTransLine."Transaction No." := TransNo;
        POSTransLine."Location Code" := POSTransHeader."Location Code";
        POSTransLine."Shortcut Dimension 1 Code" := POSTransHeader."Shortcut Dimension 1 Code";
        POSTransLine."Shortcut Dimension 2 Code" := POSTransHeader."Shortcut Dimension 2 Code";
        POSTransLine.Insert(true);

        // Validate barcode (triggers item lookup)
        POSTransLine.Validate(Barcode, Barcode);
        POSTransLine.Modify(true);

        UpdateTransactionTotals(TransNo);
        exit(true);
    end;

    procedure AddItemByNo(TransNo: Code[20]; ItemNo: Code[20]; Qty: Decimal): Boolean
    var
        POSTransHeader: Record "POS Transaction Header";
        POSTransLine: Record "POS Transaction Line";
        ExistingLine: Record "POS Transaction Line";
    begin
        if not POSTransHeader.Get(TransNo) then
            exit(false);

        if POSTransHeader.Status <> POSTransHeader.Status::Open then
            Error('Cannot add items to a transaction that is not Open.');

        if Qty <= 0 then
            Qty := 1;

        // Check if item already exists in cart
        ExistingLine.SetRange("Transaction No.", TransNo);
        ExistingLine.SetRange("Item No.", ItemNo);
        if ExistingLine.FindFirst() then begin
            ExistingLine.Validate(Quantity, ExistingLine.Quantity + Qty);
            ExistingLine.Modify(true);
            UpdateTransactionTotals(TransNo);
            exit(true);
        end;

        // Create new line
        POSTransLine.Init();
        POSTransLine."Transaction No." := TransNo;
        POSTransLine."Location Code" := POSTransHeader."Location Code";
        POSTransLine."Shortcut Dimension 1 Code" := POSTransHeader."Shortcut Dimension 1 Code";
        POSTransLine."Shortcut Dimension 2 Code" := POSTransHeader."Shortcut Dimension 2 Code";
        POSTransLine.Insert(true);

        POSTransLine.Validate("Item No.", ItemNo);
        POSTransLine.Validate(Quantity, Qty);
        POSTransLine.Modify(true);

        UpdateTransactionTotals(TransNo);
        exit(true);
    end;

    // ============================================
    // Line Operations
    // ============================================

    procedure UpdateLineQuantity(TransNo: Code[20]; LineNo: Integer; NewQty: Decimal): Boolean
    var
        POSTransLine: Record "POS Transaction Line";
    begin
        if not POSTransLine.Get(TransNo, LineNo) then
            exit(false);

        if NewQty <= 0 then begin
            POSTransLine.Delete(true);
        end else begin
            POSTransLine.Validate(Quantity, NewQty);
            POSTransLine.Modify(true);
        end;

        UpdateTransactionTotals(TransNo);
        exit(true);
    end;

    procedure VoidLine(TransNo: Code[20]; LineNo: Integer): Boolean
    var
        POSTransLine: Record "POS Transaction Line";
    begin
        if not POSTransLine.Get(TransNo, LineNo) then
            exit(false);

        POSTransLine.Delete(true);
        UpdateTransactionTotals(TransNo);
        exit(true);
    end;

    procedure VoidTransaction(TransNo: Code[20]; VoidReason: Text[250]): Boolean
    var
        POSTransHeader: Record "POS Transaction Header";
    begin
        if not POSTransHeader.Get(TransNo) then
            exit(false);

        if not (POSTransHeader.Status in [POSTransHeader.Status::Open, POSTransHeader.Status::Paid]) then
            Error('Cannot void a transaction that has been posted.');

        POSTransHeader.Status := POSTransHeader.Status::Voided;
        POSTransHeader."Void Reason" := VoidReason;
        POSTransHeader.Modify();

        exit(true);
    end;

    // ============================================
    // Price Calculation
    // ============================================

    procedure GetItemSalesPrice(ItemNo: Code[20]; CustomerPriceGroup: Code[10]; UOMCode: Code[10]; Qty: Decimal; PriceDate: Date): Decimal
    var
        Item: Record Item;
        PriceListLine: Record "Price List Line";
    begin
        if not Item.Get(ItemNo) then
            exit(0);

        // Use BC V16+ Price List Line
        if CustomerPriceGroup <> '' then begin
            PriceListLine.SetRange("Asset Type", PriceListLine."Asset Type"::Item);
            PriceListLine.SetRange("Asset No.", ItemNo);
            PriceListLine.SetRange("Source Type", PriceListLine."Source Type"::"Customer Price Group");
            PriceListLine.SetRange("Source No.", CustomerPriceGroup);
            PriceListLine.SetRange(Status, PriceListLine.Status::Active);
            PriceListLine.SetFilter("Starting Date", '<=%1|%2', PriceDate, 0D);
            PriceListLine.SetFilter("Ending Date", '>=%1|%2', PriceDate, 0D);

            // Check for minimum quantity
            PriceListLine.SetFilter("Minimum Quantity", '<=%1', Qty);

            if PriceListLine.FindLast() then
                exit(PriceListLine."Unit Price");
        end;

        // Fallback to Item Unit Price
        exit(Item."Unit Price");
    end;

    // ============================================
    // Inventory Check
    // ============================================

    procedure CheckInventoryAvailable(ItemNo: Code[20]; LocationCode: Code[10]; Qty: Decimal): Boolean
    var
        Item: Record Item;
        InventorySetup: Record "Inventory Setup";
        AvailableQty: Decimal;
    begin
        if not Item.Get(ItemNo) then
            exit(false);

        InventorySetup.Get();
        GetSetup();

        // If negative inventory allowed, always return true
        if POSSetup."Allow Negative Inventory" then
            exit(true);

        // Calculate available quantity
        Item.SetFilter("Location Filter", LocationCode);
        Item.CalcFields(Inventory, "Qty. on Sales Order", "Reserved Qty. on Inventory");
        AvailableQty := Item.Inventory - Item."Qty. on Sales Order" - Item."Reserved Qty. on Inventory";

        exit(AvailableQty >= Qty);
    end;

    // ============================================
    // Payment Processing
    // ============================================

    procedure ProcessPayment(TransNo: Code[20]; PaymentMethod: Enum "POS Payment Method"; TenderedAmount: Decimal): Boolean
    var
        POSTransHeader: Record "POS Transaction Header";
        POSPaymentEntry: Record "POS Payment Entry";
        AmountDue: Decimal;
        PaymentAmount: Decimal;
    begin
        if not POSTransHeader.Get(TransNo) then
            exit(false);

        if POSTransHeader.Status <> POSTransHeader.Status::Open then
            Error('Cannot process payment for a transaction that is not Open.');

        // Calculate amount due
        POSTransHeader.CalculateTotalAmount();
        POSTransHeader.CalcFields("Paid Amount");
        AmountDue := POSTransHeader."Total Amount" - POSTransHeader."Paid Amount";

        if AmountDue <= 0 then
            Error('Transaction is already fully paid.');

        // Determine payment amount
        if TenderedAmount >= AmountDue then
            PaymentAmount := AmountDue
        else
            PaymentAmount := TenderedAmount;

        // Create payment entry
        POSPaymentEntry.Init();
        POSPaymentEntry."Transaction No." := TransNo;
        POSPaymentEntry."Payment Method" := PaymentMethod;
        POSPaymentEntry.Amount := PaymentAmount;
        POSPaymentEntry."Tendered Amount" := TenderedAmount;
        POSPaymentEntry.Validate("Tendered Amount");
        POSPaymentEntry.Insert(true);

        // Update header
        POSTransHeader.CalculateChange();

        // Check if fully paid
        POSTransHeader.CalcFields("Paid Amount");
        if POSTransHeader."Paid Amount" >= POSTransHeader."Total Amount" then
            POSTransHeader.Status := POSTransHeader.Status::Paid;

        POSTransHeader.Modify();

        exit(true);
    end;

    procedure GetAmountDue(TransNo: Code[20]): Decimal
    var
        POSTransHeader: Record "POS Transaction Header";
    begin
        if not POSTransHeader.Get(TransNo) then
            exit(0);

        POSTransHeader.CalculateTotalAmount();
        POSTransHeader.CalcFields("Paid Amount");
        exit(POSTransHeader."Total Amount" - POSTransHeader."Paid Amount");
    end;

    procedure GetChange(TransNo: Code[20]): Decimal
    var
        POSTransHeader: Record "POS Transaction Header";
    begin
        if not POSTransHeader.Get(TransNo) then
            exit(0);

        exit(POSTransHeader."Change Amount");
    end;

    // ============================================
    // Helpers
    // ============================================

    local procedure GetSetup()
    begin
        if SetupRead then
            exit;
        POSSetup.GetSetup();
        SetupRead := true;
    end;

    local procedure UpdateTransactionTotals(TransNo: Code[20])
    var
        POSTransHeader: Record "POS Transaction Header";
    begin
        if POSTransHeader.Get(TransNo) then begin
            POSTransHeader.CalculateTotalAmount();
            POSTransHeader.Modify();
        end;
    end;
}
