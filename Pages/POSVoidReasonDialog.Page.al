page 53307 "POS Void Reason Dialog"
{
    Caption = 'Void Reason';
    PageType = StandardDialog;
    SourceTable = "POS Transaction Header";
    Editable = true;

    layout
    {
        area(Content)
        {
            group(ReasonGroup)
            {
                Caption = 'Void Reason';
                ShowCaption = false;

                field(TransNo; Rec."Transaction No.")
                {
                    ApplicationArea = All;
                    Caption = 'Transaction No.';
                    ToolTip = 'Specifies the transaction to void.';
                    Editable = false;
                }
                field(TotalAmount; Rec."Total Amount")
                {
                    ApplicationArea = All;
                    Caption = 'Total Amount';
                    ToolTip = 'Specifies the transaction total.';
                    Editable = false;
                }
                field(VoidReason; Rec."Void Reason")
                {
                    ApplicationArea = All;
                    Caption = 'Reason';
                    ToolTip = 'Enter the reason for voiding this transaction.';
                    MultiLine = true;

                    trigger OnValidate()
                    begin
                        if Rec."Void Reason" = '' then
                            Error('Void reason is required.');
                    end;
                }
            }
        }
    }

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        if CloseAction = Action::OK then begin
            if Rec."Void Reason" = '' then begin
                Error('You must enter a void reason.');
                exit(false);
            end;
        end;
        exit(true);
    end;
}
