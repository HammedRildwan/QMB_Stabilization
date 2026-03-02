page 70124 "Approved Expense List"
{
    CardPageID = "Expense Card";
    Editable = false;
    PageType = List;
    SourceTable = Table60056;
    SourceTableView = WHERE (Posted = CONST (No),
                            Status = FILTER (Approved),
                            Not Paid=FILTER(No),
                            Expense Type=FILTER(Maintenance|Trans R-Work|Miscellaneous|' '));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No.";"No.")
                {
                }
                field(Date;Date)
                {
                }
                field("Expense Type";"Expense Type")
                {
                }
                field(Requester;Requester)
                {
                }
                field(Status;Status)
                {
                }
                field("Total Line Amount";"Total Line Amount")
                {
                }
                field("Shortcut Dimension 1 Code";"Shortcut Dimension 1 Code")
                {
                }
                field(Purpose;Purpose)
                {
                }
                field("Bank No.";"Bank No.")
                {
                }
                field("Bank Name";"Bank Name")
                {
                }
                field("Shortcut Dimension 2 Code";"Shortcut Dimension 2 Code")
                {
                }
                field("Shortcut Dimension 3 Code";"Shortcut Dimension 3 Code")
                {
                }
                field(Posted;Posted)
                {
                }
            }
        }
        area(factboxes)
        {
            part(Approvals;70194)
            {
                Caption = 'Approvals';
                SubPageLink = Document No.=FIELD(No.);
            }
            systempart(;Notes)
            {
            }
            systempart(;Links)
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
        UserSetup: Record "91";
        ExpenseRequestHeader: Record "60056";
}

