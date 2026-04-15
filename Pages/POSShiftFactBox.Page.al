page 53308 "POS Shift FactBox"
{
    Caption = 'Shift Information';
    PageType = CardPart;
    SourceTable = "POS Shift";
    Editable = false;

    layout
    {
        area(Content)
        {
            field("Shift No."; Rec."Shift No.")
            {
                ApplicationArea = All;
                Caption = 'Shift No.';
                ToolTip = 'Specifies the shift number.';
                Style = Strong;
            }
            field("Terminal ID"; Rec."Terminal ID")
            {
                ApplicationArea = All;
                Caption = 'Terminal';
                ToolTip = 'Specifies the terminal ID.';
            }
            field("User ID"; Rec."User ID")
            {
                ApplicationArea = All;
                Caption = 'Cashier';
                ToolTip = 'Specifies the cashier.';
            }
            field(Status; Rec.Status)
            {
                ApplicationArea = All;
                Caption = 'Status';
                ToolTip = 'Specifies the shift status.';
                StyleExpr = StatusStyle;
            }
            field("Opening DateTime"; Rec."Opening DateTime")
            {
                ApplicationArea = All;
                Caption = 'Opened';
                ToolTip = 'Specifies when the shift was opened.';
            }
            field("Opening Float"; Rec."Opening Float")
            {
                ApplicationArea = All;
                Caption = 'Opening Float';
                ToolTip = 'Specifies the opening float amount.';
            }
            field(TotalSales; Rec."Total Sales")
            {
                ApplicationArea = All;
                Caption = 'Total Sales';
                ToolTip = 'Specifies total sales for this shift.';
                Style = Strong;
            }
            field(CashSales; Rec."Total Cash Sales")
            {
                ApplicationArea = All;
                Caption = 'Cash Sales';
                ToolTip = 'Specifies cash sales for this shift.';
            }
            field(TransactionCount; Rec."Transaction Count")
            {
                ApplicationArea = All;
                Caption = 'Transactions';
                ToolTip = 'Specifies the number of transactions.';
            }
            field(ExpectedCash; ExpectedCashCalc)
            {
                ApplicationArea = All;
                Caption = 'Expected Cash';
                ToolTip = 'Specifies the expected cash in drawer.';
                Style = Strong;
            }
        }
    }

    var
        ExpectedCashCalc: Decimal;
        StatusStyle: Text;

    trigger OnAfterGetRecord()
    begin
        Rec.CalcFields("Total Sales", "Total Cash Sales", "Transaction Count");
        ExpectedCashCalc := Rec."Opening Float" + Rec."Total Cash Sales";

        case Rec.Status of
            Rec.Status::Open:
                StatusStyle := 'Favorable';
            Rec.Status::Suspended:
                StatusStyle := 'Attention';
            Rec.Status::Closed:
                StatusStyle := 'Standard';
        end;
    end;
}
