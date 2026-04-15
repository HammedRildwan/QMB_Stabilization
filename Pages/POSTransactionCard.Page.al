page 53311 "POS Transaction Card"
{
    Caption = 'POS Transaction';
    PageType = Card;
    SourceTable = "POS Transaction Header";
    Editable = false;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

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
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the transaction status.';
                    StyleExpr = StatusStyle;
                }
                field("Terminal ID"; Rec."Terminal ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the terminal.';
                }
                field("Shift No."; Rec."Shift No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the shift number.';
                }
                field("Business Section"; Rec."Business Section")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the business section.';
                }
            }
            group(Customer)
            {
                Caption = 'Customer';

                field("Customer No."; Rec."Customer No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the customer number.';
                }
                field("Customer Name"; Rec."Customer Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the customer name.';
                }
                field("Customer Price Group"; Rec."Customer Price Group")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the customer price group.';
                }
            }
            part(Lines; "POS Cart Subform")
            {
                ApplicationArea = All;
                Caption = 'Lines';
                SubPageLink = "Transaction No." = field("Transaction No.");
                Editable = false;
            }
            group(Totals)
            {
                Caption = 'Totals';

                field(Subtotal; Rec.Subtotal)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the subtotal.';
                }
                field("Discount Amount"; Rec."Discount Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the discount amount.';
                }
                field("Total Amount"; Rec."Total Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the total amount.';
                    Style = Strong;
                }
                field("Paid Amount"; Rec."Paid Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the amount paid.';
                }
                field("Change Amount"; Rec."Change Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the change given.';
                }
            }
            part(Payments; "POS Payment Subform")
            {
                ApplicationArea = All;
                Caption = 'Payments';
                SubPageLink = "Transaction No." = field("Transaction No.");
            }
            group(Posting)
            {
                Caption = 'Posting';

                field("Posted Invoice No."; Rec."Posted Invoice No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the posted invoice number.';
                }
                field("Transaction Date Posted"; Rec."Transaction Date")
                {
                    ApplicationArea = All;
                    Caption = 'Posting Date';
                    ToolTip = 'Specifies the posting date.';
                    Visible = Rec.Status = Rec.Status::Posted;
                }
            }
            group(VoidInfo)
            {
                Caption = 'Void Information';
                Visible = Rec.Status = Rec.Status::Voided;

                field("Void Reason"; Rec."Void Reason")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the void reason.';
                    Style = Attention;
                }
            }
            group(Audit)
            {
                Caption = 'Audit';

                field("User ID"; Rec."User ID")
                {
                    ApplicationArea = All;
                    Caption = 'Cashier';
                    ToolTip = 'Specifies the cashier.';
                }
            }
        }
        area(FactBoxes)
        {
            part(ShiftFactBox; "POS Shift FactBox")
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
            action(PrintReceipt)
            {
                ApplicationArea = All;
                Caption = 'Print Receipt';
                Image = Print;
                Promoted = true;
                PromotedCategory = Report;
                PromotedIsBig = true;
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
                Promoted = true;
                PromotedCategory = Process;
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
        Rec.CalcFields(Subtotal, "Paid Amount");

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
