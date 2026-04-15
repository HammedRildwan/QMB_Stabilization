page 53316 "POS Manager Activities"
{
    Caption = 'Manager Summary';
    PageType = CardPart;
    SourceTable = "POS Role Center Cue";
    RefreshOnActivate = true;

    layout
    {
        area(Content)
        {
            cuegroup(TodaySummary)
            {
                Caption = 'Today''s Summary';
                ShowCaption = true;

                field("Total Open Trans"; Rec."Total Open Trans")
                {
                    ApplicationArea = All;
                    Caption = 'Open Transactions';
                    ToolTip = 'Specifies total open transactions across all sections.';
                    DrillDownPageId = "POS Transaction List";
                }
                field("Total Today Sales"; Rec."Total Today Sales")
                {
                    ApplicationArea = All;
                    Caption = 'Total Sales';
                    ToolTip = 'Specifies total sales today across all sections.';
                }
                field("Total Posted Today"; Rec."Total Posted Today")
                {
                    ApplicationArea = All;
                    Caption = 'Total Transactions';
                    ToolTip = 'Specifies total transaction count today.';
                }

                actions
                {
                    action(AllTransactions)
                    {
                        ApplicationArea = All;
                        Caption = 'All Transactions';
                        Image = TileGreen;
                        ToolTip = 'View all transactions.';
                        RunObject = page "POS Transaction List";
                    }
                    action(POSSetup)
                    {
                        ApplicationArea = All;
                        Caption = 'POS Setup';
                        Image = TileSettings;
                        ToolTip = 'Configure POS settings.';
                        RunObject = page "POS Setup";
                    }
                }
            }
            cuegroup(Terminals)
            {
                Caption = 'Terminals';
                ShowCaption = true;

                actions
                {
                    action(ManageTerminals)
                    {
                        ApplicationArea = All;
                        Caption = 'Manage Terminals';
                        Image = TileInfo;
                        ToolTip = 'View and manage POS terminals.';
                        RunObject = page "POS Terminal List";
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
