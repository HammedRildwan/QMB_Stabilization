page 53314 "POS Cashier Activities"
{
    Caption = 'Cashier Activities';
    PageType = CardPart;
    SourceTable = "POS Role Center Cue";
    RefreshOnActivate = true;

    layout
    {
        area(Content)
        {
            cuegroup(MyShift)
            {
                Caption = 'My Shift';
                ShowCaption = true;

                field("My Open Trans"; Rec."My Open Trans")
                {
                    ApplicationArea = All;
                    Caption = 'Open Transactions';
                    ToolTip = 'Specifies your open transactions.';
                    DrillDownPageId = "POS Transaction List";
                }
                field("My Today Sales"; Rec."My Today Sales")
                {
                    ApplicationArea = All;
                    Caption = 'Today''s Sales';
                    ToolTip = 'Specifies your total sales today.';
                }
                field("My Transaction Count"; Rec."My Transaction Count")
                {
                    ApplicationArea = All;
                    Caption = 'Transaction Count';
                    ToolTip = 'Specifies your transaction count today.';
                }

                actions
                {
                    action(NewTransaction)
                    {
                        ApplicationArea = All;
                        Caption = 'New Transaction';
                        Image = TileNew;
                        ToolTip = 'Start a new POS transaction.';
                        RunObject = page "POS Checkout";
                    }
                    action(ManageShift)
                    {
                        ApplicationArea = All;
                        Caption = 'Manage Shift';
                        Image = TileSettings;
                        ToolTip = 'Open or close your shift.';
                        RunObject = page "POS Shift Management";
                    }
                }
            }
            cuegroup(QuickAccess)
            {
                Caption = 'Quick Access';
                ShowCaption = true;

                actions
                {
                    action(ItemLookup)
                    {
                        ApplicationArea = All;
                        Caption = 'Item Lookup';
                        Image = TileInfo;
                        ToolTip = 'Search for items.';
                        RunObject = page "Item List";
                    }
                    action(CustomerLookup)
                    {
                        ApplicationArea = All;
                        Caption = 'Customer Lookup';
                        Image = TileBlue;
                        ToolTip = 'Search for customers.';
                        RunObject = page "Customer List";
                    }
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.Reset();
        if not Rec.Get() then begin
            Rec.Init();
            Rec.Insert();
        end;
        Rec.SetFilter("User ID Filter", UserId());
        Rec.SetFilter("Date Filter", '%1', Today());
    end;
}
