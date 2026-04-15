codeunit 53321 "POS Posting"
{
    Description = 'POS Posting - Create and post Sales Invoice from POS Transaction';

    var
        POSSetup: Record "POS Setup";
        SetupRead: Boolean;

    // ============================================
    // Main Posting Entry Point
    // ============================================

    procedure PostTransaction(TransNo: Code[20]): Boolean
    var
        POSTransHeader: Record "POS Transaction Header";
        POSTransArchive: Record "POS Transaction Archive";
        SalesHeader: Record "Sales Header";
        SalesInvHeader: Record "Sales Invoice Header";
        PostedInvoiceNo: Code[20];
    begin
        GetSetup();

        // Get and validate transaction
        if not POSTransHeader.Get(TransNo) then
            Error('Transaction %1 not found.', TransNo);

        ValidateBeforePosting(POSTransHeader);

        // Create Sales Invoice
        SalesHeader := CreateSalesInvoice(POSTransHeader);

        // Create Sales Invoice Lines
        CreateSalesInvoiceLines(POSTransHeader, SalesHeader);

        // Post the Sales Invoice
        PostedInvoiceNo := PostSalesInvoice(SalesHeader);

        // Update POS Transaction
        POSTransHeader."Posted Invoice No." := PostedInvoiceNo;
        POSTransHeader.Status := POSTransHeader.Status::Posted;
        POSTransHeader.Modify();

        // Archive transaction
        POSTransArchive.ArchiveFromHeader(POSTransHeader);

        exit(true);
    end;

    // ============================================
    // Validation
    // ============================================

    local procedure ValidateBeforePosting(var POSTransHeader: Record "POS Transaction Header")
    var
        POSShift: Record "POS Shift";
    begin
        // Check status
        if POSTransHeader.Status = POSTransHeader.Status::Posted then
            Error('Transaction %1 has already been posted.', POSTransHeader."Transaction No.");

        if POSTransHeader.Status = POSTransHeader.Status::Voided then
            Error('Cannot post a voided transaction.');

        // Check payment
        if not POSTransHeader.IsFullyPaid() then
            Error('Transaction %1 is not fully paid. Amount due: %2',
                POSTransHeader."Transaction No.",
                POSTransHeader."Total Amount" - POSTransHeader."Paid Amount");

        // Check shift (if required)
        if POSSetup."Require Shift Open" then begin
            if POSTransHeader."Shift No." = '' then
                Error('Transaction must have a shift assigned.');

            if not POSShift.Get(POSTransHeader."Shift No.") then
                Error('Shift %1 not found.', POSTransHeader."Shift No.");

            if POSShift.Status <> POSShift.Status::Open then
                Error('Shift %1 is not open.', POSTransHeader."Shift No.");
        end;

        // Check customer
        POSTransHeader.TestField("Customer No.");

        // Check lines exist
        POSTransHeader.CalcFields("Line Count");
        if POSTransHeader."Line Count" = 0 then
            Error('Transaction %1 has no lines to post.', POSTransHeader."Transaction No.");
    end;

    // ============================================
    // Sales Invoice Creation
    // ============================================

    local procedure CreateSalesInvoice(POSTransHeader: Record "POS Transaction Header") SalesHeader: Record "Sales Header"
    begin
        SalesHeader.Init();
        SalesHeader."Document Type" := SalesHeader."Document Type"::Invoice;
        SalesHeader.Insert(true);

        // Set customer
        SalesHeader.Validate("Sell-to Customer No.", POSTransHeader."Customer No.");

        // Set dates
        SalesHeader.Validate("Document Date", POSTransHeader."Transaction Date");
        SalesHeader.Validate("Posting Date", POSTransHeader."Transaction Date");

        // Set location
        if POSTransHeader."Location Code" <> '' then
            SalesHeader.Validate("Location Code", POSTransHeader."Location Code");

        // Set salesperson
        if POSTransHeader."Salesperson Code" <> '' then
            SalesHeader.Validate("Salesperson Code", POSTransHeader."Salesperson Code");

        // Set dimensions
        if POSTransHeader."Shortcut Dimension 1 Code" <> '' then
            SalesHeader.Validate("Shortcut Dimension 1 Code", POSTransHeader."Shortcut Dimension 1 Code");
        if POSTransHeader."Shortcut Dimension 2 Code" <> '' then
            SalesHeader.Validate("Shortcut Dimension 2 Code", POSTransHeader."Shortcut Dimension 2 Code");

        // Set external document reference
        SalesHeader."External Document No." := POSTransHeader."Transaction No.";

        SalesHeader.Modify(true);

        exit(SalesHeader);
    end;

    local procedure CreateSalesInvoiceLines(POSTransHeader: Record "POS Transaction Header"; SalesHeader: Record "Sales Header")
    var
        POSTransLine: Record "POS Transaction Line";
        SalesLine: Record "Sales Line";
        LineNo: Integer;
    begin
        LineNo := 10000;

        POSTransLine.SetRange("Transaction No.", POSTransHeader."Transaction No.");
        if POSTransLine.FindSet() then
            repeat
                SalesLine.Init();
                SalesLine."Document Type" := SalesHeader."Document Type";
                SalesLine."Document No." := SalesHeader."No.";
                SalesLine."Line No." := LineNo;
                SalesLine.Insert(true);

                // Set item
                SalesLine.Validate(Type, SalesLine.Type::Item);
                SalesLine.Validate("No.", POSTransLine."Item No.");

                // Set location
                if POSTransLine."Location Code" <> '' then
                    SalesLine.Validate("Location Code", POSTransLine."Location Code");

                // Set variant
                if POSTransLine."Variant Code" <> '' then
                    SalesLine.Validate("Variant Code", POSTransLine."Variant Code");

                // Set UOM
                if POSTransLine."Unit of Measure Code" <> '' then
                    SalesLine.Validate("Unit of Measure Code", POSTransLine."Unit of Measure Code");

                // Set quantity and price
                SalesLine.Validate(Quantity, POSTransLine.Quantity);
                SalesLine.Validate("Unit Price", POSTransLine."Unit Price");

                // Set discount
                if POSTransLine."Discount %" <> 0 then
                    SalesLine.Validate("Line Discount %", POSTransLine."Discount %");

                // Set dimensions
                if POSTransLine."Shortcut Dimension 1 Code" <> '' then
                    SalesLine.Validate("Shortcut Dimension 1 Code", POSTransLine."Shortcut Dimension 1 Code");
                if POSTransLine."Shortcut Dimension 2 Code" <> '' then
                    SalesLine.Validate("Shortcut Dimension 2 Code", POSTransLine."Shortcut Dimension 2 Code");

                SalesLine.Modify(true);

                LineNo += 10000;
            until POSTransLine.Next() = 0;
    end;

    local procedure PostSalesInvoice(var SalesHeader: Record "Sales Header"): Code[20]
    var
        SalesPost: Codeunit "Sales-Post";
        SalesInvHeader: Record "Sales Invoice Header";
    begin
        // Post the invoice
        SalesHeader.Ship := true;
        SalesHeader.Invoice := true;
        SalesPost.Run(SalesHeader);

        // Get posted invoice number
        SalesInvHeader.SetRange("Pre-Assigned No.", SalesHeader."No.");
        if SalesInvHeader.FindLast() then
            exit(SalesInvHeader."No.");

        SalesInvHeader.SetRange("Pre-Assigned No.");
        SalesInvHeader.SetRange("Order No.", SalesHeader."No.");
        if SalesInvHeader.FindLast() then
            exit(SalesInvHeader."No.");

        // Fallback - get last invoice for this customer
        SalesInvHeader.SetRange("Order No.");
        SalesInvHeader.SetRange("Sell-to Customer No.", SalesHeader."Sell-to Customer No.");
        if SalesInvHeader.FindLast() then
            exit(SalesInvHeader."No.");

        exit('');
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
}
