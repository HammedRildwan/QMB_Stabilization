page 70120 "Expense List"
{
    CardPageID = "Expense Card";
    DeleteAllowed = false;
    Editable = false;
    PageType = List;
    SourceTable = 60056;
    SourceTableView = WHERE (Posted = CONST (false));

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
                field(Purpose; rec.Purpose)
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
                SubPageLink = "Document No."=FIELD("No.");
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
        UserSetup.GET(USERID);
        rec.FilterGroup(10);
        rec.SetRange(Requester, UserSetup."User ID");
        rec.FilterGroup(0);
    end;

    var
        UserSetup: Record 91;
}

