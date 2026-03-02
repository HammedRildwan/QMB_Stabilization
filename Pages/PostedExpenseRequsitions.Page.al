page 60081 "Posted Expense Requsitions"
{
    CardPageID = "Expense Card";
    Editable = false;
    PageType = List;
    SourceTable = 60056;
    SourceTableView = SORTING ("No.")
                      ORDER(Descending)
                      WHERE (Status = CONST (Approved),
                            Posted = CONST (true));

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
                field("Last Modified DateTime"; rec."Last Modified DateTime")
                {
                }
                field("Expense Type"; rec."Expense Type")
                {
                }
                field(Requester; rec.Requester)
                {
                }
                field("Shortcut Dimension 1 Code"; rec."Shortcut Dimension 1 Code")
                {
                }
                field("Shortcut Dimension 2 Code"; rec."Shortcut Dimension 2 Code")
                {
                }
                field("Shortcut Dimension 3 Code"; rec."Shortcut Dimension 3 Code")
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
                SubPageLink = "Document No."=FIELD(No.);
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

