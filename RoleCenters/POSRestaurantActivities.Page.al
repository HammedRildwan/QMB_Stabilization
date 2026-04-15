page 53319 "POS Restaurant Activities"
{
    Caption = 'Restaurant Activities';
    PageType = CardPart;
    SourceTable = "POS Role Center Cue";
    RefreshOnActivate = true;

    layout
    {
        area(Content)
        {
            cuegroup(RestaurantSales)
            {
                Caption = 'Restaurant';
                ShowCaption = true;

                field("Restaurant Open Trans"; Rec."Restaurant Open Trans")
                {
                    ApplicationArea = All;
                    Caption = 'Open Transactions';
                    ToolTip = 'Open transactions in Restaurant section.';
                    DrillDownPageId = "POS Transaction List";
                }
                field("Restaurant Today Sales"; Rec."Restaurant Today Sales")
                {
                    ApplicationArea = All;
                    Caption = 'Today''s Sales';
                    ToolTip = 'Today''s sales for Restaurant section.';
                }
                field("Restaurant Trans Count"; Rec."Restaurant Trans Count")
                {
                    ApplicationArea = All;
                    Caption = 'Transactions';
                    ToolTip = 'Transaction count for Restaurant section.';
                }

                actions
                {
                    action(RestaurantTransactions)
                    {
                        ApplicationArea = All;
                        Caption = 'View Transactions';
                        Image = TileOrange;
                        ToolTip = 'View Restaurant transactions.';
                        RunObject = page "POS Transaction List";
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
        Rec.SetFilter("Date Filter", '%1', Today());
    end;
}
