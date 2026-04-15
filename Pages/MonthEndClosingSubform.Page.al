page 53222 "Month-End Closing Subform"
{
    Caption = 'Closing Tasks';
    PageType = ListPart;
    SourceTable = "Month-End Closing Line";
    SourceTableView = sorting("Document No.", "Sequence No.");
    AutoSplitKey = true;
    DelayedInsert = true;

    layout
    {
        area(Content)
        {
            repeater(Lines)
            {
                field("Sequence No."; Rec."Sequence No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Task sequence number.';
                    Width = 5;
                }
                field("Task Code"; Rec."Task Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Task code from template.';
                    Width = 10;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Task description.';
                    Width = 30;
                }
                field(Category; Rec.Category)
                {
                    ApplicationArea = All;
                    ToolTip = 'Task category.';
                    Width = 12;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    ToolTip = 'Task status.';
                    StyleExpr = StatusStyle;
                    Width = 10;
                }
                field("Responsible User"; Rec."Responsible User")
                {
                    ApplicationArea = All;
                    ToolTip = 'User responsible for this task.';
                    Width = 15;
                }
                field("Completed By"; Rec."Completed By")
                {
                    ApplicationArea = All;
                    ToolTip = 'User who completed this task.';
                    Width = 15;
                }
                field("Completed Date"; Rec."Completed Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Date task was completed.';
                    Width = 10;
                }
                field("Auto-Validate"; Rec."Auto-Validate")
                {
                    ApplicationArea = All;
                    ToolTip = 'Task can be auto-validated.';
                    Width = 8;
                }
                field("Validation Result"; Rec."Validation Result")
                {
                    ApplicationArea = All;
                    ToolTip = 'Result of auto-validation.';
                    Width = 25;
                }
                field("Issue Found"; Rec."Issue Found")
                {
                    ApplicationArea = All;
                    ToolTip = 'Issue found during validation.';
                    Style = Unfavorable;
                    StyleExpr = Rec."Issue Found";
                    Width = 8;
                }
                field(Blocking; Rec.Blocking)
                {
                    ApplicationArea = All;
                    ToolTip = 'Task blocks subsequent tasks.';
                    Width = 8;
                }
                field(Notes; Rec.Notes)
                {
                    ApplicationArea = All;
                    ToolTip = 'Task notes.';
                    Width = 25;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(StartTask)
            {
                ApplicationArea = All;
                Caption = 'Start Task';
                Image = Start;
                ToolTip = 'Start working on this task.';

                trigger OnAction()
                begin
                    Rec.StartTask();
                    CurrPage.Update(false);
                end;
            }
            action(CompleteTask)
            {
                ApplicationArea = All;
                Caption = 'Complete Task';
                Image = Completed;
                ToolTip = 'Mark this task as complete.';

                trigger OnAction()
                begin
                    Rec.CompleteTask();
                    CurrPage.Update(false);
                end;
            }
            action(SkipTask)
            {
                ApplicationArea = All;
                Caption = 'Skip Task';
                Image = Cancel;
                ToolTip = 'Skip this task (non-blocking only).';

                trigger OnAction()
                begin
                    Rec.SkipTask();
                    CurrPage.Update(false);
                end;
            }
            action(ResetTask)
            {
                ApplicationArea = All;
                Caption = 'Reset Task';
                Image = Recalculate;
                ToolTip = 'Reset task to pending status.';

                trigger OnAction()
                begin
                    Rec.ResetTask();
                    CurrPage.Update(false);
                end;
            }
            action(OpenRelatedPage)
            {
                ApplicationArea = All;
                Caption = 'Open Related Page';
                Image = Navigate;
                ToolTip = 'Open the page related to this task.';

                trigger OnAction()
                begin
                    Rec.OpenRelatedPage();
                end;
            }
            action(RunRelatedReport)
            {
                ApplicationArea = All;
                Caption = 'Run Related Report';
                Image = Report;
                ToolTip = 'Run the report related to this task.';

                trigger OnAction()
                begin
                    Rec.RunRelatedReport();
                end;
            }
            action(ViewInstructions)
            {
                ApplicationArea = All;
                Caption = 'View Instructions';
                Image = Info;
                ToolTip = 'View detailed instructions for this task.';

                trigger OnAction()
                begin
                    if Rec.Instructions <> '' then
                        Message(Rec.Instructions)
                    else
                        Message('No instructions available for this task.');
                end;
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
            Rec.Status::Pending:
                StatusStyle := 'Standard';
            Rec.Status::"In Progress":
                StatusStyle := 'Attention';
            Rec.Status::Completed:
                StatusStyle := 'Favorable';
            Rec.Status::Blocked:
                StatusStyle := 'Unfavorable';
            Rec.Status::Skipped:
                StatusStyle := 'Subordinate';
        end;
    end;
}
