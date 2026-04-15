page 53318 "POS Hypermart Activities"
{
    Caption = 'Hypermart Activities';
    PageType = CardPart;
    SourceTable = "POS Role Center Cue";
    RefreshOnActivate = true;

    layout
    {
        area(Content)
        {
            cuegroup(HypermartSales)
            {
                Caption = 'Hypermart';
                ShowCaption = true;

                field("Hypermart Open Trans"; Rec."Hypermart Open Trans")
                {
                    ApplicationArea = All;
                    Caption = 'Open Transactions';
                    ToolTip = 'Open transactions in Hypermart section.';
                    DrillDownPageId = "POS Transaction List";
                }
                field("Hypermart Today Sales"; Rec."Hypermart Today Sales")
                {
                    ApplicationArea = All;
                    Caption = 'Today''s Sales';
                    ToolTip = 'Today''s sales for Hypermart section.';
                }
                field("Hypermart Trans Count"; Rec."Hypermart Trans Count")
                {
                    ApplicationArea = All;
                    Caption = 'Transactions';
                    ToolTip = 'Transaction count for Hypermart section.';
                }

                actions
                {
                    action(HypermartTransactions)
                    {
                        ApplicationArea = All;
                        Caption = 'View Transactions';
                        Image = TileYellow;
                        ToolTip = 'View Hypermart transactions.';
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
