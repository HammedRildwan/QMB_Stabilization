page 53226 "Posted Store Requisition List"
{
    ApplicationArea = All;
    UsageCategory = History;
    Caption = 'Posted Store Requisitions';
    CardPageID = "Store Requisition Card";
    Editable = false;
    PageType = List;
    SourceTable = 53006;
    SourceTableView = SORTING("No.")
                      ORDER(Descending)
                      WHERE(Posted = CONST(true));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; rec."No.")
                {
                }
                field("Request Date"; rec."Request Date")
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
                field("Store Location"; rec."Store Location")
                {
                }
                field("Request Type"; rec."Request Type")
                {
                }
                field("Asset No."; rec."Asset No.")
                {
                }
                field(Status; rec.Status)
                {
                }
                field("Posted DateTime"; rec."Posted DateTime")
                {
                }
                field("Posted By"; rec."Posted By")
                {
                }
            }
        }
        area(factboxes)
        {
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
