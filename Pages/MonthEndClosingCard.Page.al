page 53221 "Month-End Closing Card"
{
    Caption = 'Month-End Closing';
    PageType = Document;
    SourceTable = "Month-End Closing Header";
    RefreshOnActivate = true;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the document number.';
                }
                field("Accounting Period"; Rec."Accounting Period")
                {
                    ApplicationArea = All;
                    ToolTip = 'Select the accounting period to close.';
                    Importance = Promoted;
                }
                field("Period Start Date"; Rec."Period Start Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Shows the start date of the selected period.';
                }
                field("Period End Date"; Rec."Period End Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Shows the end date of the selected period.';
                }
                field("Fiscal Year"; Rec."Fiscal Year")
                {
                    ApplicationArea = All;
                    ToolTip = 'Shows the fiscal year.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    ToolTip = 'Shows the current status of the closing process.';
                    Importance = Promoted;
                    StyleExpr = StatusStyle;
                }
            }
            group(Progress)
            {
                Caption = 'Progress';

                field("Total Tasks"; Rec."Total Tasks")
                {
                    ApplicationArea = All;
                    ToolTip = 'Shows the total number of tasks.';
                }
                field("Completed Tasks"; Rec."Completed Tasks")
                {
                    ApplicationArea = All;
                    ToolTip = 'Shows the number of completed tasks.';
                    Style = Favorable;
                }
                field("Blocked Tasks"; Rec."Blocked Tasks")
                {
                    ApplicationArea = All;
                    ToolTip = 'Shows the number of blocked tasks.';
                    Style = Unfavorable;
                }
                field(CompletionPct; Rec.GetCompletionPercentage())
                {
                    ApplicationArea = All;
                    Caption = 'Completion %';
                    ToolTip = 'Shows the completion percentage.';
                    Style = Strong;
                }
            }
            group(Audit)
            {
                Caption = 'Audit Trail';

                field("Created By"; Rec."Created By")
                {
                    ApplicationArea = All;
                    ToolTip = 'Shows who created this closing.';
                }
                field("Created Date"; Rec."Created Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Shows when this closing was created.';
                }
                field("Started Date"; Rec."Started Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Shows when the closing process started.';
                }
                field("Completed Date"; Rec."Completed Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Shows when the closing was completed.';
                }
                field("Completed By"; Rec."Completed By")
                {
                    ApplicationArea = All;
                    ToolTip = 'Shows who completed this closing.';
                }
            }
            part(Lines; "Month-End Closing Subform")
            {
                ApplicationArea = All;
                Caption = 'Closing Tasks';
                SubPageLink = "Document No." = field("No.");
                UpdatePropagation = Both;
            }
            group(NotesGroup)
            {
                Caption = 'Comments';

                field(Comments; Rec.Comments)
                {
                    ApplicationArea = All;
                    MultiLine = true;
                    ToolTip = 'Enter any comments about this closing process.';
                }
            }
        }
        area(FactBoxes)
        {
            part(TaskSummary; "Month-End Task Summary FactBox")
            {
                ApplicationArea = All;
                SubPageLink = "No." = field("No.");
            }
            systempart(Notes; Notes)
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(InitializeChecklist)
            {
                ApplicationArea = All;
                Caption = 'Initialize Checklist';
                Image = Setup;
                ToolTip = 'Create checklist tasks from template.';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    if Rec.Status <> Rec.Status::Open then
                        Error('Checklist can only be initialized when status is Open.');
                    Rec.InitializeFromTemplate();
                    CurrPage.Update(false);
                end;
            }
            action(RunAutoValidations)
            {
                ApplicationArea = All;
                Caption = 'Run Auto-Validations';
                Image = CheckList;
                ToolTip = 'Automatically validate all auto-check tasks.';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    ClosingMgt: Codeunit "Month-End Closing Mgt.";
                begin
                    if Rec.Status <> Rec.Status::"In Progress" then
                        Error('Validations can only be run when status is In Progress.');
                    ClosingMgt.RunAllValidations(Rec);
                    CurrPage.Update(false);
                end;
            }
            action(CompleteClosing)
            {
                ApplicationArea = All;
                Caption = 'Complete Closing';
                Image = Completed;
                ToolTip = 'Mark the month-end closing as complete.';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    if Rec.Status <> Rec.Status::"In Progress" then
                        Error('Only closings with status In Progress can be completed.');
                    Rec.CompleteClosing();
                    CurrPage.Update(false);
                end;
            }
            action(ReopenClosing)
            {
                ApplicationArea = All;
                Caption = 'Reopen';
                Image = ReOpen;
                ToolTip = 'Reopen a completed closing for corrections.';
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    Rec.ReopenClosing();
                    CurrPage.Update(false);
                end;
            }
        }
        area(Navigation)
        {
            action(TrialBalance)
            {
                ApplicationArea = All;
                Caption = 'Trial Balance';
                Image = Report;
                RunObject = report "Trial Balance";
                ToolTip = 'Print trial balance for the period.';
            }
            action(IncomeStatement)
            {
                ApplicationArea = All;
                Caption = 'Income Statement';
                Image = Report;
                RunObject = report "Income Statement";
                ToolTip = 'Print income statement.';
            }
            action(BalanceSheet)
            {
                ApplicationArea = All;
                Caption = 'Balance Sheet';
                Image = Report;
                RunObject = report "Balance Sheet";
                ToolTip = 'Print balance sheet.';
            }
        }
    }

    var
        StatusStyle: Text;

    trigger OnAfterGetRecord()
    begin
        SetStatusStyle();
    end;

    local procedure SetStatusStyle()
    begin
        case Rec.Status of
            Rec.Status::Open:
                StatusStyle := 'Standard';
            Rec.Status::"In Progress":
                StatusStyle := 'Attention';
            Rec.Status::Completed:
                StatusStyle := 'Favorable';
            Rec.Status::Cancelled:
                StatusStyle := 'Unfavorable';
        end;
    end;
}
