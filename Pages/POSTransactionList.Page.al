page 53310 "POS Transaction List"
{
    Caption = 'POS Transactions';
    PageType = List;
    SourceTable = "POS Transaction Header";
    UsageCategory = Lists;
    ApplicationArea = All;
    CardPageId = "POS Transaction Card";
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(Transactions)
            {
                field("Transaction No."; Rec."Transaction No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the transaction number.';
                    Style = Strong;
                }
                field("Transaction Date"; Rec."Transaction Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the transaction date.';
                }
                field("Terminal ID"; Rec."Terminal ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the terminal.';
                }
                field("Business Section"; Rec."Business Section")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the business section.';
                }
                field("Customer No."; Rec."Customer No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the customer.';
                }
                field("Customer Name"; Rec."Customer Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the customer name.';
                }
                field("Total Amount"; Rec."Total Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the total amount.';
                    Style = Strong;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the status.';
                    StyleExpr = StatusStyle;
                }
                field("User ID"; Rec."User ID")
                {
                    ApplicationArea = All;
                    Caption = 'Cashier';
                    ToolTip = 'Specifies the cashier.';
                }
                field("Posted Invoice No."; Rec."Posted Invoice No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the posted invoice number.';
                }
            }
        }
        area(FactBoxes)
        {
            part(ShiftInfo; "POS Shift FactBox")
            {
                ApplicationArea = All;
                SubPageLink = "Shift No." = field("Shift No.");
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ViewDetails)
            {
                ApplicationArea = All;
                Caption = 'View Details';
                Image = View;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'View transaction details.';
                RunObject = page "POS Transaction Card";
                RunPageLink = "Transaction No." = field("Transaction No.");
            }
            action(PrintReceipt)
            {
                ApplicationArea = All;
                Caption = 'Print Receipt';
                Image = Print;
                Promoted = true;
                PromotedCategory = Report;
                ToolTip = 'Print the transaction receipt.';

                trigger OnAction()
                begin
                    Message('Receipt printing will be implemented in Reports phase.');
                end;
            }
        }
        area(Navigation)
        {
            action(ViewPostedInvoice)
            {
                ApplicationArea = All;
                Caption = 'Posted Invoice';
                Image = PostedOrder;
                ToolTip = 'View the posted sales invoice.';

                trigger OnAction()
                var
                    SalesInvoiceHeader: Record "Sales Invoice Header";
                begin
                    if Rec."Posted Invoice No." = '' then
                        Error('Transaction has not been posted.');

                    SalesInvoiceHeader.Get(Rec."Posted Invoice No.");
                    Page.Run(Page::"Posted Sales Invoice", SalesInvoiceHeader);
                end;
            }
        }
    }

    var
        StatusStyle: Text;

    trigger OnAfterGetRecord()
    begin
        case Rec.Status of
            Rec.Status::Open:
                StatusStyle := 'Standard';
            Rec.Status::Paid:
                StatusStyle := 'Favorable';
            Rec.Status::Posted:
                StatusStyle := 'Strong';
            Rec.Status::Voided:
                StatusStyle := 'Attention';
        end;
    end;
}
