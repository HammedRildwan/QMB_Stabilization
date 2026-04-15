pageextension 53001 "Bank Acc. Reconciliation Lines" extends "Bank Acc. Reconciliation Lines"
{
    layout
    {
        addafter("Statement Amount")
        {
            field("Payment Reference No."; Rec."Payment Reference No.")
            {
                ApplicationArea = All;
            }
            field("Debit Amount"; Rec."Debit Amount")
            {
                ApplicationArea = All;
                Caption = 'Debit Amount';
                ToolTip = 'Specifies Debit Amount';
            }
            field("Credit Amount"; Rec."Credit Amount")
            {
                ApplicationArea = All;
                Caption = 'Credit Amount';
                ToolTip = 'Specifies Credit Amount';
            }
            field("Exception Reason"; Rec."Exception Reason")
            {
                ApplicationArea = All;
                Caption = 'Exception Reason';
                ToolTip = 'Specifies Exception Reason';
            }

        }
        addafter("Applied Entries")
        {
            field("Applied Credit Amount"; Rec."Applied Credit Amount")
            {
                ApplicationArea = All;
                Caption = 'Applied Credit Amount';
                ToolTip = 'Specifies Applied Credit Amount';
            }
            field("Applied Debit Amount"; Rec."Applied Debit Amount")
            {
                ApplicationArea = All;
                Caption = 'Applied Debit Amount';
                ToolTip = 'Specifies Applied Debit Amount';
            }



        }
    }

}

