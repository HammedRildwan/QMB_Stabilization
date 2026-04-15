page 53302 "POS Terminal Card"
{
    Caption = 'POS Terminal Card';
    PageType = Card;
    SourceTable = "POS Terminal";

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';
                ShowCaption = true;

                field("Terminal ID"; Rec."Terminal ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the unique identifier for the terminal.';
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the name of the terminal.';
                }
                field("Business Section"; Rec."Business Section")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the business section this terminal serves.';
                }
                field(Active; Rec.Active)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies whether the terminal is active.';
                }
            }
            group(Location)
            {
                Caption = 'Location & Pricing';
                ShowCaption = true;

                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the location code for the terminal.';
                }
                field("Default Customer No."; Rec."Default Customer No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the default customer for cash sales.';
                }
                field("Customer Price Group"; Rec."Customer Price Group")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the customer price group for this terminal.';
                }
            }
            group(Assignment)
            {
                Caption = 'Assignment';
                ShowCaption = true;

                field("Assigned User ID"; Rec."Assigned User ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the user assigned to this terminal.';
                }
                field("Current Shift No."; Rec."Current Shift No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the current open shift on this terminal.';
                }
                field("Last Transaction No."; Rec."Last Transaction No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the last transaction processed on this terminal.';
                }
            }
            group(Dimensions)
            {
                Caption = 'Dimensions';
                ShowCaption = true;

                field("Dimension 1 Code"; Rec."Dimension 1 Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the shortcut dimension 1 code.';
                }
                field("Dimension 2 Code"; Rec."Dimension 2 Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the shortcut dimension 2 code.';
                }
            }
            group(Hardware)
            {
                Caption = 'Hardware';
                ShowCaption = true;

                field("Receipt Printer Name"; Rec."Receipt Printer Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the receipt printer name for this terminal.';
                }
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
                Caption = 'Open Shift';
                Image = Start;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Open a new shift for this terminal.';

                trigger OnAction()
                begin
                    if Rec.HasOpenShift() then
                        Error('A shift is already open on this terminal.');
                    Message('Shift management will be implemented in Phase 2.');
                end;
            }
            action(CloseShift)
            {
                ApplicationArea = All;
                Caption = 'Close Shift';
                Image = Stop;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Close the current shift for this terminal.';

                trigger OnAction()
                begin
                    if not Rec.HasOpenShift() then
                        Error('No shift is currently open on this terminal.');
                    Message('Shift management will be implemented in Phase 2.');
                end;
            }
            action(OpenCheckout)
            {
                ApplicationArea = All;
                Caption = 'Open Checkout';
                Image = Sales;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Open the checkout screen for this terminal.';

                trigger OnAction()
                begin
                    Message('Checkout page will be implemented in Phase 3.');
                end;
            }
        }
        area(Navigation)
        {
            action(Shifts)
            {
                ApplicationArea = All;
                Caption = 'Shift History';
                Image = History;
                ToolTip = 'View shift history for this terminal.';

                trigger OnAction()
                var
                    POSShift: Record "POS Shift";
                begin
                    POSShift.SetRange("Terminal ID", Rec."Terminal ID");
                    Page.Run(0, POSShift);
                end;
            }
            action(Transactions)
            {
                ApplicationArea = All;
                Caption = 'Transaction History';
                Image = LedgerEntries;
                ToolTip = 'View transaction history for this terminal.';

                trigger OnAction()
                var
                    POSTransArchive: Record "POS Transaction Archive";
                begin
                    POSTransArchive.SetRange("Terminal ID", Rec."Terminal ID");
                    Page.Run(0, POSTransArchive);
                end;
            }
        }
    }
}
