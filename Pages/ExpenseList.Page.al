page 70120 "Expense List"
{
    CardPageID = "Expense Card";
    DeleteAllowed = false;
    Editable = false;
    PageType = List;
    SourceTable = Table60056;
    SourceTableView = WHERE (Posted = CONST (No));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; "No.")
                {
                }
                field(Date; Date)
                {
                }
                field("Expense Type"; "Expense Type")
                {
                }
                field(Requester; Requester)
                {
                }
                field(Status; Status)
                {
                }
                field("Total Line Amount"; "Total Line Amount")
                {
                }
                field(Purpose; Purpose)
                {
                }
                field("Shortcut Dimension 2 Code"; "Shortcut Dimension 2 Code")
                {
                }
                field("Shortcut Dimension 3 Code"; "Shortcut Dimension 3 Code")
                {
                }
                field(Posted; Posted)
                {
                }
            }
        }
        area(factboxes)
        {
            part(Approvals; 70194)
            {
                Caption = 'Approvals';
                SubPageLink = Document No.=FIELD(No.);
            }
            systempart(; Notes)
            {
            }
            systempart(; Links)
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
        FILTERGROUP(10);
        SETRANGE(Requester, UserSetup."User ID");
        FILTERGROUP(0);
    end;

    var
        UserSetup: Record "91";
}

