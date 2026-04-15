page 53301 "POS Terminal List"
{
    Caption = 'POS Terminals';
    PageType = List;
    SourceTable = "POS Terminal";
    UsageCategory = Lists;
    ApplicationArea = All;
    CardPageId = "POS Terminal Card";
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Terminal ID"; Rec."Terminal ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the unique identifier for the terminal.';
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the name of the terminal.';
                }
                field("Business Section"; Rec."Business Section")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the business section this terminal serves.';
                }
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the location code for the terminal.';
                }
                field(Active; Rec.Active)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies whether the terminal is active.';
                }
                field("Current Shift No."; Rec."Current Shift No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the current open shift on this terminal.';
                }
                field("Assigned User ID"; Rec."Assigned User ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the user assigned to this terminal.';
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
            action(OpenCheckout)
            {
                ApplicationArea = All;
                Caption = 'Open Checkout';
                Image = Sales;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Open the checkout screen for this terminal.';

                trigger OnAction()
                begin
                    // Will open POS Checkout page
                    Message('Checkout page will be implemented in Phase 3.');
                end;
            }
        }
    }
}
