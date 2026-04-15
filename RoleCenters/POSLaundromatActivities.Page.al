page 53321 "POS Laundromat Activities"
{
    Caption = 'Laundromat Activities';
    PageType = CardPart;
    SourceTable = "POS Role Center Cue";
    RefreshOnActivate = true;

    layout
    {
        area(Content)
        {
            cuegroup(LaundromatSales)
            {
                Caption = 'Laundromat';
                ShowCaption = true;

                field("Laundromat Open Trans"; Rec."Laundromat Open Trans")
                {
                    ApplicationArea = All;
                    Caption = 'Open Transactions';
                    ToolTip = 'Open transactions in Laundromat section.';
                    DrillDownPageId = "POS Transaction List";
                }
                field("Laundromat Today Sales"; Rec."Laundromat Today Sales")
                {
                    ApplicationArea = All;
                    Caption = 'Today''s Sales';
                    ToolTip = 'Today''s sales for Laundromat section.';
                }
                field("Laundromat Trans Count"; Rec."Laundromat Trans Count")
                {
                    ApplicationArea = All;
                    Caption = 'Transactions';
                    ToolTip = 'Transaction count for Laundromat section.';
                }

                actions
                {
                    action(LaundromatTransactions)
                    {
                        ApplicationArea = All;
                        Caption = 'View Transactions';
                        Image = TileBlue;
                        ToolTip = 'View Laundromat transactions.';
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
