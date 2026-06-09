page 53248 "Expenses Pending Approval"
{
    CardPageID = "Expense Card";
    DeleteAllowed = false;
    Editable = false;
    //Entitlements = "Dynamics 365 Business Central Premium";
    PageType = List;
    SourceTable = 53001;
    SourceTableView = WHERE(Posted = CONST(false));

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
            part(Approvals; 53215)
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
        //UserSetup.GET(USERID);
        rec.FilterGroup(10);
        rec.SetRange(Status, rec.Status::"Pending Approval");
        rec.FilterGroup(0);
    end;

    var
        UserSetup: Record 91;
}

