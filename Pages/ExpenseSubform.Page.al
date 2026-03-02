page 70122 "Expense Subform"
{
    AutoSplitKey = true;
    CardPageID = "Expense Card";
    DelayedInsert = true;
    MultipleNewLines = true;
    PageType = ListPart;
    SourceTable = 60057;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Expense Category"; rec."Expense Category")
                {
                    Editable = NOT ApprovedNotEditable;
                }
                field("Expense type"; rec."Expense type")
                {
                    Editable = NOT ApprovedNotEditable;
                }
                field("Expense Description"; rec."Expense Description")
                {
                    Editable = NOT ApprovedNotEditable;
                }
                field("Expense Account No."; rec."Expense Account No.")
                {
                    Editable = NOT ApprovedNotEditable;
                }
                field("Account Name"; rec."Account Name")
                {
                    Editable = false;
                }
                field("Maintenance Code"; rec."Maintenance Code")
                {
                    Editable = NOT ApprovedNotEditable;
                }
                field("Asset No."; rec."Asset No.")
                {
                    Editable = NOT ApprovedNotEditable;
                }
                field(Amount; rec.Amount)
                {
                    Editable = NOT ApprovedNotEditable;
                }
                field("Amount (LCY)"; rec."Amount (LCY)")
                {
                    Editable = false;
                }
                field("Exchange Rate"; rec."Exchange Rate")
                {
                    Editable = NOT ApprovedNotEditable;
                }
                field("WHT Rate"; rec."WHT Rate")
                {
                    Editable = NOT ApprovedNotEditable;
                }
                field("WHT Amount"; rec."WHT Amount")
                {
                    Editable = false;
                }
                field("WHT Amount (LCY)"; rec."WHT Amount (LCY)")
                {
                    Editable = false;
                }
                field("Budgeted Amount"; rec."Budgeted Amount")
                {
                    Editable = false;
                }
                field("Budget Balance"; rec."Budget Balance")
                {
                    Editable = false;
                }
                field("G/L Balance"; rec."G/L Balance")
                {
                    Editable = false;
                }
                field("Payee Code"; rec."Payee Code")
                {
                    Editable = NOT ApprovedNotEditable;
                }
                field("Payee Name"; rec."Payee Name")
                {
                    Editable = false;
                }
                field("Shortcut Dimension 1 Code"; rec."Shortcut Dimension 1 Code")
                {
                    Editable = NOT ApprovedNotEditable;
                }
                field("Shortcut Dimension 2 Code"; rec."Shortcut Dimension 2 Code")
                {
                    Editable = NOT ApprovedNotEditable;
                }
                field("Shortcut Dimension 3 Code"; rec."Shortcut Dimension 3 Code")
                {
                    Editable = NOT ApprovedNotEditable;
                }
                field(Remark; rec.Remark)
                {
                    Editable = NOT ApprovedNotEditable;
                }
                field("Currency Code"; rec."Currency Code")
                {
                    Editable = NOT ApprovedNotEditable;
                }
                field(posted; rec.posted)
                {
                    Editable = false;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        // ExpenseRequestHeader2.GET("Document No.");
        // IF ((ExpenseRequestHeader2.Status = ExpenseRequestHeader2.Status::Approved) OR (ExpenseRequestHeader2.Status = ExpenseRequestHeader2.Status::"Pending Approval")) THEN
        //  AmountEditable := FALSE
        // ELSE
        //  AmountEditable := TRUE;

        IF rec."Document No." <> '' THEN BEGIN
            ExpenseRequestHeader.GET(rec."Document No.");
            IF ExpenseRequestHeader.Status = ExpenseRequestHeader.Status::Approved THEN
                ApprovedNotEditable := TRUE
            ELSE
                ApprovedNotEditable := FALSE;
        END;
    end;

    trigger OnModifyRecord(): Boolean
    begin
        // ExpenseRequestHeader.GET("Document No.");
        // IF ((ExpenseRequestHeader.Status = ExpenseRequestHeader.Status::Approved) OR (ExpenseRequestHeader.Status = ExpenseRequestHeader.Status::"Pending Approval")) AND (ExpenseRequestHeader."Trip No" = '') THEN BEGIN
        //  UserSetup.GET(USERID);
        //  IF NOT UserSetup."Modify Expense requistion" THEN
        //  ERROR('You cannot modify this record');
        // END;

        //ExpenseRequestHeader2.GET("Document No.");
        // IF ((ExpenseRequestHeader2.Status = ExpenseRequestHeader2.Status::Approved) OR (ExpenseRequestHeader2.Status = ExpenseRequestHeader2.Status::"Pending Approval")) THEN
        //  AmountEditable := FALSE
        // ELSE
        //  AmountEditable := TRUE;
    end;

    var
        EditExpAccNo: Boolean;
        EditAsset: Boolean;
        ExpenseRequestHeader: Record 60056;
        UserSetup: Record 91;
        AmountEditable: Boolean;
        ExpenseRequestHeader2: Record 60056;
        ApprovedNotEditable: Boolean;
}

