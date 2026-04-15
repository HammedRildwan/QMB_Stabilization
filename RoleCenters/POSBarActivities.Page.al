page 53320 "POS Bar Activities"
{
    Caption = 'Bar Activities';
    PageType = CardPart;
    SourceTable = "POS Role Center Cue";
    RefreshOnActivate = true;

    layout
    {
        area(Content)
        {
            cuegroup(BarSales)
            {
                Caption = 'Bar';
                ShowCaption = true;

                field("Bar Open Trans"; Rec."Bar Open Trans")
                {
                    ApplicationArea = All;
                    Caption = 'Open Transactions';
                    ToolTip = 'Open transactions in Bar section.';
                    DrillDownPageId = "POS Transaction List";
                }
                field("Bar Today Sales"; Rec."Bar Today Sales")
                {
                    ApplicationArea = All;
                    Caption = 'Today''s Sales';
                    ToolTip = 'Today''s sales for Bar section.';
                }
                field("Bar Trans Count"; Rec."Bar Trans Count")
                {
                    ApplicationArea = All;
                    Caption = 'Transactions';
                    ToolTip = 'Transaction count for Bar section.';
                }

                actions
                {
                    action(BarTransactions)
                    {
                        ApplicationArea = All;
                        Caption = 'View Transactions';
                        Image = TileRed;
                        ToolTip = 'View Bar transactions.';
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
