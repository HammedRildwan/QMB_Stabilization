page 53303 "POS Checkout"
{
    Caption = 'POS Checkout';
    PageType = Card;
    SourceTable = "POS Transaction Header";
    UsageCategory = Tasks;
    ApplicationArea = All;
    InsertAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            group(QuickEntry)
            {
                Caption = 'Quick Entry';
                ShowCaption = false;

                field(BarcodeEntry; BarcodeInput)
                {
                    ApplicationArea = All;
                    Caption = 'Scan Barcode';
                    ToolTip = 'Enter or scan item barcode.';

                    trigger OnValidate()
                    var
                        POSTransMgt: Codeunit "POS Transaction Mgt.";
                    begin
                        if BarcodeInput <> '' then begin
                            POSTransMgt.AddItemByBarcode(Rec."Transaction No.", BarcodeInput);
                            BarcodeInput := '';
                            CurrPage.CartLines.Page.Update(false);
                            CurrPage.Update(false);
                        end;
                    end;
                }
                field(TransactionNo; Rec."Transaction No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the transaction number.';
                    Editable = false;
                    Style = Strong;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the transaction status.';
                    Editable = false;
                    StyleExpr = StatusStyle;
                }
            }
            group(CustomerInfo)
            {
                Caption = 'Customer';
                ShowCaption = true;
                Visible = ShowCustomerGroup;

                field("Customer No."; Rec."Customer No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the customer number.';
                }
                field("Customer Name"; Rec."Customer Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the customer name.';
                    Editable = false;
                }
            }
            part(CartLines; "POS Cart Subform")
            {
                ApplicationArea = All;
                Caption = 'Cart';
                SubPageLink = "Transaction No." = field("Transaction No.");
            }
            group(Totals)
            {
                Caption = 'Totals';
                ShowCaption = true;

                field(Subtotal; Rec.Subtotal)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the subtotal before discount.';
                    Editable = false;
                }
                field("Discount Amount"; Rec."Discount Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the total discount amount.';

                    trigger OnValidate()
                    begin
                        Rec.CalculateTotalAmount();
                        CurrPage.Update();
                    end;
                }
                field("Total Amount"; Rec."Total Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the total amount to pay.';
                    Editable = false;
                    Style = Strong;
                    StyleExpr = 'StrongAccent';
                }
                field("Paid Amount"; Rec."Paid Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the amount paid.';
                    Editable = false;
                }
                field(AmountDue; AmountDue)
                {
                    ApplicationArea = All;
                    Caption = 'Amount Due';
                    ToolTip = 'Specifies the remaining amount to pay.';
                    Editable = false;
                    Style = Attention;
                    StyleExpr = AmountDue > 0;
                }
                field("Change Amount"; Rec."Change Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the change to give back.';
                    Editable = false;
                    Style = Favorable;
                    StyleExpr = Rec."Change Amount" > 0;
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
            action(NewTransaction)
            {
                ApplicationArea = All;
                Caption = 'New Transaction';
                Image = NewDocument;
                Promoted = true;
                PromotedCategory = New;
                PromotedIsBig = true;
                ToolTip = 'Create a new transaction.';
                ShortcutKey = 'F2';

                trigger OnAction()
                var
                    POSTransMgt: Codeunit "POS Transaction Mgt.";
                    POSTerminal: Record "POS Terminal";
                    NewTransNo: Code[20];
                begin
                    if not POSTerminal.GetTerminalForCurrentUser() then
                        Error('No terminal assigned to current user.');

                    NewTransNo := POSTransMgt.CreateNewTransaction(POSTerminal."Terminal ID");
                    Rec.Get(NewTransNo);
                    CurrPage.Update(false);
                end;
            }
            action(PayCash)
            {
                ApplicationArea = All;
                Caption = 'Pay Cash';
                Image = Currencies;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Process cash payment.';
                ShortcutKey = 'F8';

                trigger OnAction()
                var
                    POSPaymentDialog: Page "POS Payment Dialog";
                    POSTransMgt: Codeunit "POS Transaction Mgt.";
                    TenderedAmount: Decimal;
                begin
                    if Rec.Status <> Rec.Status::Open then
                        Error('Transaction is not open.');

                    Rec.CalculateTotalAmount();
                    Rec.CalcFields("Paid Amount");
                    AmountDue := Rec."Total Amount" - Rec."Paid Amount";

                    if AmountDue <= 0 then
                        Error('Transaction is already fully paid.');

                    POSPaymentDialog.SetAmountDue(AmountDue);
                    if POSPaymentDialog.RunModal() = Action::OK then begin
                        TenderedAmount := POSPaymentDialog.GetTenderedAmount();
                        POSTransMgt.ProcessPayment(Rec."Transaction No.", Enum::"POS Payment Method"::Cash, TenderedAmount);
                        Rec.Get(Rec."Transaction No.");
                        CurrPage.Update(false);
                    end;
                end;
            }
            action(PostTransaction)
            {
                ApplicationArea = All;
                Caption = 'Post';
                Image = Post;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Post the transaction and create sales invoice.';
                ShortcutKey = 'F9';

                trigger OnAction()
                var
                    POSPosting: Codeunit "POS Posting";
                begin
                    if not Rec.IsFullyPaid() then
                        Error('Transaction must be fully paid before posting.');

                    if POSPosting.PostTransaction(Rec."Transaction No.") then begin
                        Message('Transaction posted successfully. Invoice No.: %1', Rec."Posted Invoice No.");
                        Rec.Get(Rec."Transaction No.");
                        CurrPage.Update(false);
                    end;
                end;
            }
            action(VoidTransaction)
            {
                ApplicationArea = All;
                Caption = 'Void';
                Image = VoidCheck;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Void this transaction.';

                trigger OnAction()
                var
                    POSTransMgt: Codeunit "POS Transaction Mgt.";
                    VoidReason: Text[250];
                begin
                    if Rec.Status = Rec.Status::Posted then
                        Error('Cannot void a posted transaction.');

                    VoidReason := '';
                    if Page.RunModal(Page::"POS Void Reason Dialog", Rec) = Action::OK then begin
                        POSTransMgt.VoidTransaction(Rec."Transaction No.", Rec."Void Reason");
                        CurrPage.Update(false);
                    end;
                end;
            }
        }
        area(Navigation)
        {
            action(ItemLookup)
            {
                ApplicationArea = All;
                Caption = 'Item Lookup';
                Image = Item;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Search for items.';
                ShortcutKey = 'F5';

                trigger OnAction()
                var
                    Item: Record Item;
                    POSTransMgt: Codeunit "POS Transaction Mgt.";
                begin
                    if Page.RunModal(Page::"Item List", Item) = Action::LookupOK then begin
                        POSTransMgt.AddItemByNo(Rec."Transaction No.", Item."No.", 1);
                        CurrPage.CartLines.Page.Update(false);
                        CurrPage.Update(false);
                    end;
                end;
            }
        }
    }

    var
        BarcodeInput: Code[50];
        AmountDue: Decimal;
        StatusStyle: Text;
        ShowCustomerGroup: Boolean;

    trigger OnAfterGetRecord()
    begin
        Rec.CalcFields(Subtotal, "Paid Amount");
        Rec.CalculateTotalAmount();
        AmountDue := Rec."Total Amount" - Rec."Paid Amount";

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

    trigger OnOpenPage()
    begin
        ShowCustomerGroup := true;
    end;
}
