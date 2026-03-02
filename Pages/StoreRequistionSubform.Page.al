page 70035 "Store Requistion Subform"
{
    AutoSplitKey = true;
    DelayedInsert = true;
    MultipleNewLines = true;
    PageType = ListPart;
    SourceTable = 70019;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Posting Date"; rec."Posting Date")
                {
                }
                field("Item No."; rec."Item No.")
                {
                }
                field(Description; rec.Description)
                {
                    Editable = false;
                }
                field("Unit of Measure"; rec."Unit of Measure")
                {
                }
                field("Variant Code"; rec."Variant Code")
                {
                }
                field("Location Code"; rec."Location Code")
                {
                }
                field("Fixed Asset No."; rec."Fixed Asset No.")
                {
                    Editable = false;
                }
                field("Shortcut Dimension 2 Code"; rec."Shortcut Dimension 2 Code")
                {
                }
                field("Shortcut Dimension 3 Code"; rec."Shortcut Dimension 3 Code")
                {
                    ShowMandatory = true;
                }
                field("Maintenance Code"; rec."Maintenance Code")
                {
                    ShowMandatory = true;
                }
                field("Available Quantity"; rec."Available Quantity")
                {
                }
                field("Quantity Requested"; rec."Quantity Requested")
                {
                }
                field("Quantity to Issue"; rec."Quantity to Issue")
                {
                }
                field("Quantity Issued"; rec."Quantity Issued")
                {
                }
                field("Remaining Quantity"; rec."Remaining Quantity")
                {
                }
                field(Amount; rec.Amount)
                {
                }
                field("Unit Price"; rec."Unit Price")
                {
                }
                field("Assigned Technician"; rec."Assigned Technician")
                {
                }
                field("Technician Name"; rec."Technician Name")
                {
                }
                field("Old Spare Part Returned"; rec."Old Spare Part Returned")
                {
                }
            }
        }
    }

    actions
    {
    }

    var
        ItemAvailFormsMgt: Codeunit 353;
}

