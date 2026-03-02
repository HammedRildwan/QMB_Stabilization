page 70035 "Store Requistion Subform"
{
    AutoSplitKey = true;
    DelayedInsert = true;
    MultipleNewLines = true;
    PageType = ListPart;
    SourceTable = Table70019;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Posting Date"; "Posting Date")
                {
                }
                field("Item No."; "Item No.")
                {
                }
                field(Description; Description)
                {
                    Editable = false;
                }
                field("Unit of Measure"; "Unit of Measure")
                {
                }
                field("Variant Code"; "Variant Code")
                {
                }
                field("Location Code"; "Location Code")
                {
                }
                field("Fixed Asset No."; "Fixed Asset No.")
                {
                    Editable = false;
                }
                field("Shortcut Dimension 2 Code"; "Shortcut Dimension 2 Code")
                {
                }
                field("Shortcut Dimension 3 Code"; "Shortcut Dimension 3 Code")
                {
                    ShowMandatory = true;
                }
                field("Maintenance Code"; "Maintenance Code")
                {
                    ShowMandatory = true;
                }
                field("Available Quantity"; "Available Quantity")
                {
                }
                field("Quantity Requested"; "Quantity Requested")
                {
                }
                field("Quantity to Issue"; "Quantity to Issue")
                {
                }
                field("Quantity Issued"; "Quantity Issued")
                {
                }
                field("Remaining Quantity"; "Remaining Quantity")
                {
                }
                field(Amount; Amount)
                {
                }
                field("Unit Price"; "Unit Price")
                {
                }
                field("Assigned Technician"; "Assigned Technician")
                {
                }
                field("Technician Name"; "Technician Name")
                {
                }
                field("Old Spare Part Returned"; "Old Spare Part Returned")
                {
                }
            }
        }
    }

    actions
    {
    }

    var
        ItemAvailFormsMgt: Codeunit "353";
}

