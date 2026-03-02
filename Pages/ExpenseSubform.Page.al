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
                field("Expense Description"; rec."Expense Description")
                {
                    Editable = NOT ApprovedNotEditable;
                }
                field("Expense Account No."; rec."Expense Account No.")
                {
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

                    trigger OnValidate()
                    begin
                        IF "Expense Category" = "Expense Category"::Maintenance THEN
                            "Asset No." := "Shortcut Dimension 4 Code";
                    end;
                }
                field(Amount; rec.Amount)
                {
                    Editable = NOT ApprovedNotEditable;
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
                field("Shortcut Dimension 4 Code"; rec."Shortcut Dimension 4 Code")
                {
                    Editable = NOT ApprovedNotEditable;

                    trigger OnValidate()
                    begin
                        IF "Expense Category" = "Expense Category"::Maintenance THEN
                            "Asset No." := "Shortcut Dimension 4 Code";
                    end;
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

        IF "Document No." <> '' THEN BEGIN
            ExpenseRequestHeader.GET("Document No.");
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
        ExpenseRequestHeader: Record "60056";
        UserSetup: Record "91";
        AmountEditable: Boolean;
        ExpenseRequestHeader2: Record "60056";
        ApprovedNotEditable: Boolean;
}

