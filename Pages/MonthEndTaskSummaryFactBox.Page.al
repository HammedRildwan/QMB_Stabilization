page 70664 "Month-End Task Summary FactBox"
{
    Caption = 'Task Summary';
    PageType = CardPart;
    SourceTable = "Month-End Closing Header";

    layout
    {
        area(Content)
        {
            group(Summary)
            {
                ShowCaption = false;

                field(TotalTasks; Rec."Total Tasks")
                {
                    ApplicationArea = All;
                    Caption = 'Total Tasks';
                    ToolTip = 'Total number of tasks.';
                }
                field(CompletedTasks; Rec."Completed Tasks")
                {
                    ApplicationArea = All;
                    Caption = 'Completed';
                    ToolTip = 'Completed tasks.';
                    Style = Favorable;
                }
                field(PendingTasks; GetPendingCount())
                {
                    ApplicationArea = All;
                    Caption = 'Pending';
                    ToolTip = 'Pending tasks.';
                    Style = Attention;
                }
                field(BlockedTasks; Rec."Blocked Tasks")
                {
                    ApplicationArea = All;
                    Caption = 'Blocked';
                    ToolTip = 'Blocked tasks.';
                    Style = Unfavorable;
                }
                field(CompletionPct; Rec.GetCompletionPercentage())
                {
                    ApplicationArea = All;
                    Caption = 'Completion %';
                    ToolTip = 'Percentage complete.';
                    Style = Strong;
                }
            }
            group(ByCategory)
            {
                Caption = 'Remaining by Category';

                field(PreClosing; GetCategoryCount("Closing Task Category"::"Pre-Closing"))
                {
                    ApplicationArea = All;
                    Caption = 'Pre-Closing';
                    ToolTip = 'Pre-closing tasks remaining.';
                }
                field(BankRecon; GetCategoryCount("Closing Task Category"::"Bank Reconciliation"))
                {
                    ApplicationArea = All;
                    Caption = 'Bank Recon';
                    ToolTip = 'Bank reconciliation tasks remaining.';
                }
                field(Inventory; GetCategoryCount("Closing Task Category"::Inventory))
                {
                    ApplicationArea = All;
                    Caption = 'Inventory';
                    ToolTip = 'Inventory tasks remaining.';
                }
                field(Reporting; GetCategoryCount("Closing Task Category"::Reporting))
                {
                    ApplicationArea = All;
                    Caption = 'Reporting';
                    ToolTip = 'Reporting tasks remaining.';
                }
                field(FinalReview; GetCategoryCount("Closing Task Category"::"Final Review"))
                {
                    ApplicationArea = All;
                    Caption = 'Final Review';
                    ToolTip = 'Final review tasks remaining.';
                }
            }
        }
    }

    local procedure GetPendingCount(): Integer
    var
        Line: Record "Month-End Closing Line";
    begin
        Line.SetRange("Document No.", Rec."No.");
        Line.SetFilter(Status, '%1|%2', Line.Status::Pending, Line.Status::"In Progress");
        exit(Line.Count);
    end;

    local procedure GetCategoryCount(Category: Enum "Closing Task Category"): Integer
    var
        Line: Record "Month-End Closing Line";
    begin
        Line.SetRange("Document No.", Rec."No.");
        Line.SetRange(Category, Category);
        Line.SetFilter(Status, '<>%1&<>%2', Line.Status::Completed, Line.Status::Skipped);
        exit(Line.Count);
    end;
}
