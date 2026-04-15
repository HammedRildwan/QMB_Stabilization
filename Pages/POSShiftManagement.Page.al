page 53306 "POS Shift Management"
{
    Caption = 'Shift Management';
    PageType = Card;
    SourceTable = "POS Shift";
    UsageCategory = Tasks;
    ApplicationArea = All;
    InsertAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            group(CurrentShift)
            {
                Caption = 'Current Shift';
                ShowCaption = true;

                field("Shift No."; Rec."Shift No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the shift number.';
                    Editable = false;
                    Style = Strong;
                }
                field("Terminal ID"; Rec."Terminal ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the terminal ID.';
                    Editable = false;
                }
                field("User ID"; Rec."User ID")
                {
                    ApplicationArea = All;
                    Caption = 'Cashier';
                    ToolTip = 'Specifies the cashier ID.';
                    Editable = false;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the shift status.';
                    Editable = false;
                    StyleExpr = StatusStyle;
                }
            }
            group(Timing)
            {
                Caption = 'Timing';
                ShowCaption = true;

                field("Opening DateTime"; Rec."Opening DateTime")
                {
                    ApplicationArea = All;
                    Caption = 'Opened';
                    ToolTip = 'Specifies when the shift was opened.';
                    Editable = false;
                }
                field("Closing DateTime"; Rec."Closing DateTime")
                {
                    ApplicationArea = All;
                    Caption = 'Closed';
                    ToolTip = 'Specifies when the shift was closed.';
                    Editable = false;
                }
                field(ShiftDuration; ShiftDurationText)
                {
                    ApplicationArea = All;
                    Caption = 'Duration';
                    ToolTip = 'Specifies shift duration.';
                    Editable = false;
                }
            }
            group(Amounts)
            {
                Caption = 'Amounts';
                ShowCaption = true;

                field("Opening Float"; Rec."Opening Float")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the opening cash float.';
                    Editable = IsOpen;
                }
                field(TotalSales; Rec."Total Sales")
                {
                    ApplicationArea = All;
                    Caption = 'Total Sales';
                    ToolTip = 'Specifies total sales for this shift.';
                    Editable = false;
                    Style = Strong;
                }
                field(CashSales; Rec."Total Cash Sales")
                {
                    ApplicationArea = All;
                    Caption = 'Cash Sales';
                    ToolTip = 'Specifies cash sales for this shift.';
                    Editable = false;
                }
                field(ExpectedCash; ExpectedCashAmount)
                {
                    ApplicationArea = All;
                    Caption = 'Expected Cash';
                    ToolTip = 'Specifies expected cash in drawer (Float + Cash Sales).';
                    Editable = false;
                    Style = Strong;
                }
                field("Declared Cash"; Rec."Declared Cash")
                {
                    ApplicationArea = All;
                    Caption = 'Closing Cash';
                    ToolTip = 'Specifies actual cash counted at close.';
                    Editable = IsClosing;
                }
                field("Variance"; Rec."Variance")
                {
                    ApplicationArea = All;
                    Caption = 'Cash Difference';
                    ToolTip = 'Specifies the difference between expected and actual cash.';
                    Editable = false;
                    StyleExpr = CashDiffStyle;
                }
            }
            group(Statistics)
            {
                Caption = 'Statistics';
                ShowCaption = true;

                field(TransactionCount; Rec."Transaction Count")
                {
                    ApplicationArea = All;
                    Caption = 'Total Transactions';
                    ToolTip = 'Specifies the number of transactions in this shift.';
                    Editable = false;
                }
            }
            group(Notes)
            {
                Caption = 'Notes';
                ShowCaption = true;
                Visible = false;
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(OpenShift)
            {
                ApplicationArea = All;
                Caption = 'Open New Shift';
                Image = Open;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Open a new shift.';

                trigger OnAction()
                var
                    POSShiftMgt: Codeunit "POS Shift Mgt.";
                    POSTerminal: Record "POS Terminal";
                    OpeningFloat: Decimal;
                begin
                    if POSShiftMgt.HasOpenShift() then
                        Error('A shift is already open. Close the current shift first.');

                    if not POSTerminal.GetTerminalForCurrentUser() then
                        Error('No terminal assigned to current user.');

                    if Page.RunModal(Page::"POS Float Entry", Rec) = Action::OK then begin
                        OpeningFloat := FloatEntryAmount;
                        POSShiftMgt.OpenShift(POSTerminal."Terminal ID", OpeningFloat);
                        CurrPage.Close();
                    end;
                end;
            }
            action(CloseShift)
            {
                ApplicationArea = All;
                Caption = 'Close Shift';
                Image = Close;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Close the current shift.';

                trigger OnAction()
                var
                    POSShiftMgt: Codeunit "POS Shift Mgt.";
                begin
                    if Rec.Status <> Rec.Status::Open then
                        Error('No open shift to close.');

                    IsClosing := true;
                    CurrPage.Update(false);

                    if Rec."Declared Cash" = 0 then
                        Error('Enter the closing cash amount before closing the shift.');

                    Rec.Variance := Rec."Expected Cash" - Rec."Declared Cash";
                    Rec.Modify();

                    POSShiftMgt.CloseShift(Rec."Shift No.", Rec."Declared Cash");
                    Message('Shift closed successfully.\Expected Cash: %1\Actual Cash: %2\Difference: %3',
                        ExpectedCashAmount, Rec."Declared Cash", Rec.Variance);
                    CurrPage.Close();
                end;
            }
            action(SuspendShift)
            {
                ApplicationArea = All;
                Caption = 'Suspend Shift';
                Image = Pause;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Temporarily suspend the shift.';

                trigger OnAction()
                var
                    POSShiftMgt: Codeunit "POS Shift Mgt.";
                begin
                    if Rec.Status <> Rec.Status::Open then
                        Error('Only open shifts can be suspended.');

                    POSShiftMgt.SuspendShift(Rec."Shift No.");
                    CurrPage.Update(false);
                end;
            }
            action(ResumeShift)
            {
                ApplicationArea = All;
                Caption = 'Resume Shift';
                Image = Start;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Resume a suspended shift.';

                trigger OnAction()
                var
                    POSShiftMgt: Codeunit "POS Shift Mgt.";
                    POSTerminal: Record "POS Terminal";
                begin
                    if Rec.Status <> Rec.Status::Suspended then
                        Error('Only suspended shifts can be resumed.');

                    if not POSTerminal.GetTerminalForCurrentUser() then
                        Error('No terminal assigned to current user.');

                    POSShiftMgt.ResumeShift(Rec."Shift No.", POSTerminal."Terminal ID");
                    CurrPage.Update(false);
                end;
            }
        }
        area(Navigation)
        {
            action(ViewTransactions)
            {
                ApplicationArea = All;
                Caption = 'Transactions';
                Image = List;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'View transactions for this shift.';
                RunObject = page "POS Transaction List";
                RunPageLink = "Shift No." = field("Shift No.");
            }
        }
    }

    var
        ExpectedCashAmount: Decimal;
        ShiftDurationText: Text;
        StatusStyle: Text;
        CashDiffStyle: Text;
        IsOpen: Boolean;
        IsClosing: Boolean;
        FloatEntryAmount: Decimal;

    trigger OnAfterGetRecord()
    var
        Duration: Duration;
    begin
        Rec.CalcFields("Total Sales", "Total Cash Sales", "Transaction Count");
        ExpectedCashAmount := Rec."Opening Float" + Rec."Total Cash Sales";

        IsOpen := Rec.Status = Rec.Status::Open;
        IsClosing := false;

        if Rec."Closing DateTime" <> 0DT then
            Duration := Rec."Closing DateTime" - Rec."Opening DateTime"
        else if Rec."Opening DateTime" <> 0DT then
            Duration := CurrentDateTime() - Rec."Opening DateTime";

        ShiftDurationText := Format(Duration);

        case Rec.Status of
            Rec.Status::Open:
                StatusStyle := 'Favorable';
            Rec.Status::Suspended:
                StatusStyle := 'Attention';
            Rec.Status::Closed:
                StatusStyle := 'Standard';
        end;

        if Rec.Variance = 0 then
            CashDiffStyle := 'Standard'
        else if Rec.Variance > 0 then
            CashDiffStyle := 'Favorable'
        else
            CashDiffStyle := 'Attention';
    end;

    trigger OnOpenPage()
    var
        POSShiftMgt: Codeunit "POS Shift Mgt.";
        POSTerminal: Record "POS Terminal";
        CurrentShift: Record "POS Shift";
    begin
        if POSTerminal.GetTerminalForCurrentUser() then
            if POSShiftMgt.GetCurrentShift(POSTerminal."Terminal ID", CurrentShift) then
                Rec.Get(CurrentShift."Shift No.");
    end;
}
