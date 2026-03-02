page 70122 "Expense Subform"
{
    AutoSplitKey = true;
    CardPageID = "Expense Card";
    DelayedInsert = true;
    MultipleNewLines = true;
    PageType = ListPart;
    SourceTable = Table60057;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Expense Category"; "Expense Category")
                {
                    Editable = NOT ApprovedNotEditable;
                }
                field("Expense Description"; "Expense Description")
                {
                    Editable = NOT ApprovedNotEditable;
                }
                field("Expense Account No."; "Expense Account No.")
                {
                }
                field("Account Name"; "Account Name")
                {
                    Editable = false;
                }
                field("Maintenance Code"; "Maintenance Code")
                {
                    Editable = NOT ApprovedNotEditable;
                }
                field("Asset No."; "Asset No.")
                {
                    Editable = NOT ApprovedNotEditable;

                    trigger OnValidate()
                    begin
                        IF "Expense Category" = "Expense Category"::Maintenance THEN
                            "Asset No." := "Shortcut Dimension 4 Code";
                    end;
                }
                field(Amount; Amount)
                {
                    Editable = NOT ApprovedNotEditable;
                }
                field("Shortcut Dimension 1 Code"; "Shortcut Dimension 1 Code")
                {
                    Editable = NOT ApprovedNotEditable;
                }
                field("Shortcut Dimension 2 Code"; "Shortcut Dimension 2 Code")
                {
                    Editable = NOT ApprovedNotEditable;
                }
                field("Shortcut Dimension 3 Code"; "Shortcut Dimension 3 Code")
                {
                    Editable = NOT ApprovedNotEditable;
                }
                field("Shortcut Dimension 4 Code"; "Shortcut Dimension 4 Code")
                {
                    Editable = NOT ApprovedNotEditable;

                    trigger OnValidate()
                    begin
                        IF "Expense Category" = "Expense Category"::Maintenance THEN
                            "Asset No." := "Shortcut Dimension 4 Code";
                    end;
                }
                field(Remark; Remark)
                {
                    Editable = NOT ApprovedNotEditable;
                }
                field("Currency Code"; "Currency Code")
                {
                    Editable = NOT ApprovedNotEditable;
                }
                field(posted; posted)
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

