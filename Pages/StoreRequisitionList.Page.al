page 70033 "Store Requisition List"
{
    CardPageID = "Store Requisition Card";
    Editable = false;
    PageType = List;
    SourceTable = Table70018;
    SourceTableView = SORTING (No.)
                      ORDER(Descending)
                      WHERE (Posted = CONST (No),
                            Status = FILTER (<> Approved));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; "No.")
                {
                }
                field("Request Date"; "Request Date")
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
                field("Store Location"; "Store Location")
                {
                }
                field("Request Type"; "Request Type")
                {
                }
                field("Approved Work Order No."; "Approved Work Order No.")
                {
                }
                field("Asset No."; "Asset No.")
                {
                }
                field(Status; Status)
                {
                }
            }
        }
        area(factboxes)
        {
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

