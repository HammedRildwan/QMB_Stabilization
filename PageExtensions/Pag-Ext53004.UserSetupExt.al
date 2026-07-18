pageextension 53004 "User Setup Ext" extends "User Setup"
{
    layout
    {
        addlast(Control1)
        {
            field("Modify Expense requistion"; Rec."Modify Expense requistion")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies whether the user is allowed to modify approved expense requisitions.';
            }
        }
    }
}
