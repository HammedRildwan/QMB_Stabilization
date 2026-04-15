page 53300 "POS Setup"
{
    Caption = 'POS Setup';
    PageType = Card;
    SourceTable = "POS Setup";
    UsageCategory = Administration;
    ApplicationArea = All;
    InsertAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';
                ShowCaption = true;

                field("Default Location Code"; Rec."Default Location Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the default location for POS transactions.';
                }
                field("Cash Payment Account"; Rec."Cash Payment Account")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the G/L account for cash payments.';
                }
                field("Require Shift Open"; Rec."Require Shift Open")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies whether a shift must be open before creating transactions.';
                }
                field("Allow Price Override"; Rec."Allow Price Override")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies whether cashiers can override item prices.';
                }
                field("Allow Negative Inventory"; Rec."Allow Negative Inventory")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies whether to allow sales when inventory is insufficient.';
                }
            }
            group(Numbering)
            {
                Caption = 'Number Series';
                ShowCaption = true;

                field("POS Transaction Nos."; Rec."POS Transaction Nos.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number series for POS transactions.';
                }
                field("POS Shift Nos."; Rec."POS Shift Nos.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number series for POS shifts.';
                }
                field("Receipt Nos."; Rec."Receipt Nos.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number series for POS receipts.';
                }
                field("Sales Invoice Nos."; Rec."Sales Invoice Nos.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number series for sales invoices created from POS.';
                }
            }
            group(Dimensions)
            {
                Caption = 'Dimensions';
                ShowCaption = true;

                field("Cashier Dimension Code"; Rec."Cashier Dimension Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the dimension code for cashier tracking.';
                }
                field("Default Cashier Dimension"; Rec."Default Cashier Dimension")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the default cashier dimension value.';
                }
                field("Business Section Dimension"; Rec."Business Section Dimension")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the dimension code for business section tracking.';
                }
            }
            group(Hypermart)
            {
                Caption = 'Hypermart Settings';
                ShowCaption = true;

                field("Hypermart Customer No."; Rec."Hypermart Customer No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the default cash customer for Hypermart transactions.';
                }
                field("Hypermart Price Group"; Rec."Hypermart Price Group")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the customer price group for Hypermart pricing.';
                }
            }
            group(Restaurant)
            {
                Caption = 'Restaurant Settings';
                ShowCaption = true;

                field("Restaurant Customer No."; Rec."Restaurant Customer No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the default cash customer for Restaurant transactions.';
                }
                field("Restaurant Price Group"; Rec."Restaurant Price Group")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the customer price group for Restaurant pricing.';
                }
            }
            group(Bar)
            {
                Caption = 'Bar Settings';
                ShowCaption = true;

                field("Bar Customer No."; Rec."Bar Customer No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the default cash customer for Bar transactions.';
                }
                field("Bar Price Group"; Rec."Bar Price Group")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the customer price group for Bar pricing.';
                }
            }
            group(Laundromat)
            {
                Caption = 'Laundromat Settings';
                ShowCaption = true;

                field("Laundromat Customer No."; Rec."Laundromat Customer No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the default cash customer for Laundromat transactions.';
                }
                field("Laundromat Price Group"; Rec."Laundromat Price Group")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the customer price group for Laundromat pricing.';
                }
            }
        }
    }

    actions
    {
        area(Navigation)
        {
            action(Terminals)
            {
                ApplicationArea = All;
                Caption = 'POS Terminals';
                Image = ServiceSetup;
                RunObject = page "POS Terminal List";
                ToolTip = 'View and manage POS terminals.';
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.GetSetup();
    end;
}
