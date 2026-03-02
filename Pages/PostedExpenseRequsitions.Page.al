page 60081 "Posted Expense Requsitions"
{
    CardPageID = "Expense Card";
    Editable = false;
    PageType = List;
    SourceTable = Table60056;
    SourceTableView = SORTING (No.)
                      ORDER(Descending)
                      WHERE (Status = CONST (Approved),
                            Posted = CONST (Yes));

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
                field("Last Modified DateTime"; "Last Modified DateTime")
                {
                }
                field("Expense Type"; "Expense Type")
                {
                }
                field(Requester; Requester)
                {
                }
                field("Shortcut Dimension 1 Code"; "Shortcut Dimension 1 Code")
                {
                }
                field("Shortcut Dimension 2 Code"; "Shortcut Dimension 2 Code")
                {
                }
                field("Shortcut Dimension 3 Code"; "Shortcut Dimension 3 Code")
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
}

