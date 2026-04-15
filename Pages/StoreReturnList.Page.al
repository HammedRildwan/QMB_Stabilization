page 53204 "Store Return List"
{
    CardPageID = "Store Return Card";
    Editable = false;
    PageType = List;
    SourceTable = 53008;
    SourceTableView = SORTING("No.")
                      ORDER(Descending)
                      WHERE(Posted = CONST(false));

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
                field(Requester; rec.Requester)
                {
                }
                field("Shortcut Dimension 2 Code"; rec."Shortcut Dimension 2 Code")
                {
                }
                field("Shortcut Dimension 1 Code"; rec."Shortcut Dimension 1 Code")
                {
                }
                field("Asset No."; rec."Asset No.")
                {
                }
                field("Requisition No."; rec."Requisition No.")
                {
                }
                field(Status; rec.Status)
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
}

