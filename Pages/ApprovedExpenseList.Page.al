page 70124 "Approved Expense List"
{
    CardPageID = "Expense Card";
    Editable = false;
    PageType = List;
    SourceTable = 60056;
    SourceTableView = WHERE(Posted = CONST(false),
                            Status = FILTER(Approved),
                            "Not Paid" = FILTER(false),
                            "Expense Type" = FILTER('Maintenance Expense' | ' '));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; rec."No.")
                {
                }
                field(Date; rec.Date)
                {
                }
                field("Expense Type"; rec."Expense Type")
                {
                }
                field(Requester; rec.Requester)
                {
                }
                field(Status; rec.Status)
                {
                }
                field("Total Line Amount"; rec."Total Line Amount")
                {
                }
                field("Shortcut Dimension 1 Code"; rec."Shortcut Dimension 1 Code")
                {
                }
                field(Purpose; rec.Purpose)
                {
                }
                field("Bank No."; rec."Bank No.")
                {
                }
                field("Bank Name"; rec."Bank Name")
                {
                }
                field("Shortcut Dimension 2 Code"; rec."Shortcut Dimension 2 Code")
                {
                }
                field("Shortcut Dimension 3 Code"; rec."Shortcut Dimension 3 Code")
                {
                }
                field(Posted; rec.Posted)
                {
                }
            }
        }
        area(factboxes)
        {
            part(Approvals; 70194)
            {
                Caption = 'Approvals';
                SubPageLink = "Document No." = FIELD("No.");
            }
            systempart(Notes; Notes)
            {
            }
            systempart(Links; Links)
            {
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin
        /*UserSetup.GET(USERID);
         FILTERGROUP(10);
         SETRANGE(Requester,UserSetup."User ID");
         FILTERGROUP(0);*/

    end;

    var
        UserSetup: Record 91;
        ExpenseRequestHeader: Record 60056;
}

