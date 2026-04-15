page 53224 "Month-End Checklist Templates"
{
    Caption = 'Month-End Checklist Templates';
    PageType = List;
    SourceTable = "Month-End Checklist Template";
    SourceTableView = sorting("Sequence No.");
    ApplicationArea = All;
    UsageCategory = Administration;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Sequence No."; Rec."Sequence No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Sequence order.';
                }
                field("Code"; Rec."Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Task code.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Task description.';
                }
                field(Category; Rec.Category)
                {
                    ApplicationArea = All;
                    ToolTip = 'Task category.';
                }
                field("Responsible Role"; Rec."Responsible Role")
                {
                    ApplicationArea = All;
                    ToolTip = 'Default responsible user.';
                }
                field("Est. Duration (Minutes)"; Rec."Est. Duration (Minutes)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Estimated duration.';
                }
                field("Auto-Validate"; Rec."Auto-Validate")
                {
                    ApplicationArea = All;
                    ToolTip = 'Auto-validation enabled.';
                }
                field("Validation Type"; Rec."Validation Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Type of auto-validation.';
                }
                field(Blocking; Rec.Blocking)
                {
                    ApplicationArea = All;
                    ToolTip = 'Blocks subsequent tasks.';
                }
                field(Active; Rec.Active)
                {
                    ApplicationArea = All;
                    ToolTip = 'Template is active.';
                }
                field("Related Page ID"; Rec."Related Page ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Related page ID.';
                }
                field("Related Report ID"; Rec."Related Report ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Related report ID.';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(CreateDefaults)
            {
                ApplicationArea = All;
                Caption = 'Create Default Templates';
                Image = Setup;
                ToolTip = 'Create standard month-end checklist templates.';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    ClosingMgt: Codeunit "Month-End Closing Mgt.";
                begin
                    ClosingMgt.CreateDefaultTemplates();
                    CurrPage.Update(false);
                end;
            }
        }
    }
}
