page 53312 "POS Payment Subform"
{
    Caption = 'Payments';
    PageType = ListPart;
    SourceTable = "POS Payment Entry";
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(Payments)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the entry number.';
                    Visible = false;
                }
                field("Payment Method"; Rec."Payment Method")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the payment method.';
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the payment amount.';
                    Style = Strong;
                }
                field("Reference No."; Rec."Reference No.")
                {
                    ApplicationArea = All;
                    Caption = 'Payment Reference';
                    ToolTip = 'Specifies the payment reference (card auth, etc.).';
                }
                field("Payment DateTime"; Rec."Payment DateTime")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies when the payment was made.';
                }
            }
        }
    }
}
