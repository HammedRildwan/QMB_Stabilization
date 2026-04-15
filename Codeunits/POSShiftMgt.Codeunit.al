codeunit 53412 "POS Shift Mgt."
{
    Description = 'POS Shift Management - Open/close shifts, float validation';

    var
        POSSetup: Record "POS Setup";
        SetupRead: Boolean;

    // ============================================
    // Shift Opening
    // ============================================

    procedure OpenShift(TerminalID: Code[10]; OpeningFloat: Decimal): Code[20]
    var
        POSShift: Record "POS Shift";
        POSTerminal: Record "POS Terminal";
    begin
        GetSetup();

        // Validate terminal
        if not POSTerminal.Get(TerminalID) then
            Error('Terminal %1 not found.', TerminalID);

        POSTerminal.TestField(Active);

        // Check no existing open shift
        if POSTerminal."Current Shift No." <> '' then
            Error('Terminal %1 already has an open shift: %2', TerminalID, POSTerminal."Current Shift No.");

        // Validate opening float
        if OpeningFloat < 0 then
            Error('Opening float cannot be negative.');

        // Create shift
        POSShift.Init();
        POSShift."Terminal ID" := TerminalID;
        POSShift."Opening Float" := OpeningFloat;
        POSShift."Expected Cash" := OpeningFloat;
        POSShift.Status := POSShift.Status::Open;
        POSShift."Business Section" := POSTerminal."Business Section";
        POSShift.Insert(true);

        // Update terminal
        POSTerminal."Current Shift No." := POSShift."Shift No.";
        POSTerminal.Modify();

        exit(POSShift."Shift No.");
    end;

    // ============================================
    // Shift Closing
    // ============================================

    procedure CloseShift(ShiftNo: Code[20]; DeclaredCash: Decimal): Boolean
    var
        POSShift: Record "POS Shift";
        POSTerminal: Record "POS Terminal";
        POSTransHeader: Record "POS Transaction Header";
    begin
        GetSetup();

        // Validate shift
        if not POSShift.Get(ShiftNo) then
            Error('Shift %1 not found.', ShiftNo);

        if POSShift.Status <> POSShift.Status::Open then
            Error('Shift %1 is not open.', ShiftNo);

        // Check for open transactions
        POSTransHeader.SetRange("Shift No.", ShiftNo);
        POSTransHeader.SetRange(Status, POSTransHeader.Status::Open);
        if not POSTransHeader.IsEmpty then
            Error('Cannot close shift with open transactions. Please complete or void all transactions first.');

        // Calculate expected cash
        POSShift.CalculateExpectedCash();

        // Record declared cash and variance
        POSShift."Declared Cash" := DeclaredCash;
        POSShift.Variance := POSShift."Expected Cash" - DeclaredCash;

        // Close the shift
        POSShift.Status := POSShift.Status::Closed;
        POSShift."Closing DateTime" := CurrentDateTime;
        POSShift.Modify();

        // Clear terminal's current shift
        if POSTerminal.Get(POSShift."Terminal ID") then begin
            POSTerminal."Current Shift No." := '';
            POSTerminal.Modify();
        end;

        exit(true);
    end;

    // ============================================
    // Shift Suspension
    // ============================================

    procedure SuspendShift(ShiftNo: Code[20]): Boolean
    var
        POSShift: Record "POS Shift";
        POSTerminal: Record "POS Terminal";
    begin
        if not POSShift.Get(ShiftNo) then
            Error('Shift %1 not found.', ShiftNo);

        if POSShift.Status <> POSShift.Status::Open then
            Error('Shift %1 is not open.', ShiftNo);

        POSShift.Status := POSShift.Status::Suspended;
        POSShift.Modify();

        // Clear terminal's current shift
        if POSTerminal.Get(POSShift."Terminal ID") then begin
            POSTerminal."Current Shift No." := '';
            POSTerminal.Modify();
        end;

        exit(true);
    end;

    procedure ResumeShift(ShiftNo: Code[20]; TerminalID: Code[10]): Boolean
    var
        POSShift: Record "POS Shift";
        POSTerminal: Record "POS Terminal";
    begin
        if not POSShift.Get(ShiftNo) then
            Error('Shift %1 not found.', ShiftNo);

        if POSShift.Status <> POSShift.Status::Suspended then
            Error('Shift %1 is not suspended.', ShiftNo);

        // Validate terminal
        if not POSTerminal.Get(TerminalID) then
            Error('Terminal %1 not found.', TerminalID);

        if POSTerminal."Current Shift No." <> '' then
            Error('Terminal %1 already has an open shift.', TerminalID);

        // Resume shift
        POSShift."Terminal ID" := TerminalID;
        POSShift.Status := POSShift.Status::Open;
        POSShift.Modify();

        // Update terminal
        POSTerminal."Current Shift No." := ShiftNo;
        POSTerminal.Modify();

        exit(true);
    end;

    // ============================================
    // Validation
    // ============================================

    procedure HasOpenShift(): Boolean
    var
        POSTerminal: Record "POS Terminal";
    begin
        if not POSTerminal.GetTerminalForCurrentUser() then
            exit(false);
        exit(POSTerminal."Current Shift No." <> '');
    end;

    procedure ValidateShiftOpen(TerminalID: Code[10]): Boolean
    var
        POSTerminal: Record "POS Terminal";
        POSShift: Record "POS Shift";
    begin
        GetSetup();

        // If shift not required, always return true
        if not POSSetup."Require Shift Open" then
            exit(true);

        if not POSTerminal.Get(TerminalID) then
            exit(false);

        if POSTerminal."Current Shift No." = '' then
            exit(false);

        if not POSShift.Get(POSTerminal."Current Shift No.") then
            exit(false);

        exit(POSShift.Status = POSShift.Status::Open);
    end;

    procedure GetCurrentShift(TerminalID: Code[10]; var POSShift: Record "POS Shift"): Boolean
    var
        POSTerminal: Record "POS Terminal";
    begin
        if not POSTerminal.Get(TerminalID) then
            exit(false);

        if POSTerminal."Current Shift No." = '' then
            exit(false);

        exit(POSShift.Get(POSTerminal."Current Shift No."));
    end;

    // ============================================
    // Shift Summary
    // ============================================

    procedure GetShiftSummary(ShiftNo: Code[20]; var TotalSales: Decimal; var CashSales: Decimal; var TransCount: Integer; var Variance: Decimal)
    var
        POSShift: Record "POS Shift";
    begin
        if not POSShift.Get(ShiftNo) then
            exit;

        POSShift.CalcFields("Total Sales", "Total Cash Sales", "Transaction Count");

        TotalSales := POSShift."Total Sales";
        CashSales := POSShift."Total Cash Sales";
        TransCount := POSShift."Transaction Count";
        Variance := POSShift.Variance;
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
