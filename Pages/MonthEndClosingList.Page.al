page 70662 "Month-End Closing List"
{
    Caption = 'Month-End Closings';
    PageType = List;
    SourceTable = "Month-End Closing Header";
    CardPageId = "Month-End Closing Card";
    ApplicationArea = All;
    UsageCategory = Lists;
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Closing document number.';
                }
                field("Accounting Period"; Rec."Accounting Period")
                {
                    ApplicationArea = All;
                    ToolTip = 'Accounting period being closed.';
                }
                field("Fiscal Year"; Rec."Fiscal Year")
                {
                    ApplicationArea = All;
                    ToolTip = 'Fiscal year.';
                }
                field("Period Start Date"; Rec."Period Start Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Period start date.';
                }
                field("Period End Date"; Rec."Period End Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Period end date.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    ToolTip = 'Closing status.';
                    StyleExpr = StatusStyle;
                }
                field("Total Tasks"; Rec."Total Tasks")
                {
                    ApplicationArea = All;
                    ToolTip = 'Total tasks count.';
                }
                field("Completed Tasks"; Rec."Completed Tasks")
                {
                    ApplicationArea = All;
                    ToolTip = 'Completed tasks count.';
                    Style = Favorable;
                }
                field(CompletionPct; Rec.GetCompletionPercentage())
                {
                    ApplicationArea = All;
                    Caption = 'Completion %';
                    ToolTip = 'Completion percentage.';
                }
                field("Created By"; Rec."Created By")
                {
                    ApplicationArea = All;
                    ToolTip = 'Created by user.';
                }
                field("Completed Date"; Rec."Completed Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Completion date.';
                }
            }
        }
        area(FactBoxes)
        {
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
            action(NewClosing)
            {
                ApplicationArea = All;
                Caption = 'New Month-End Closing';
                Image = NewDocument;
                ToolTip = 'Create a new month-end closing process.';
                Promoted = true;
                PromotedCategory = New;
                PromotedIsBig = true;
                RunObject = page "Month-End Closing Card";
                RunPageMode = Create;
            }
        }
    }

    var
        StatusStyle: Text;

    trigger OnAfterGetRecord()
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
