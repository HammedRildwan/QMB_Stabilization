page 70036 "Store Return List"
{
    CardPageID = "Store Return Card";
    Editable = false;
    PageType = List;
    SourceTable = Table70020;
    SourceTableView = SORTING (No.)
                      ORDER(Descending)
                      WHERE (Posted = CONST (No));

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
                field(Requester; Requester)
                {
                }
                field("Shortcut Dimension 2 Code"; "Shortcut Dimension 2 Code")
                {
                }
                field("Shortcut Dimension 1 Code"; "Shortcut Dimension 1 Code")
                {
                }
                field("Asset No."; "Asset No.")
                {
                }
                field("Requisition No."; "Requisition No.")
                {
                }
                field(Status; Status)
                {
                }
                field("Work Order No."; "Work Order No.")
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

