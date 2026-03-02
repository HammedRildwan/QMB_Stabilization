page 70038 "Store Return Subform"
{
    AutoSplitKey = true;
    DelayedInsert = true;
    MultipleNewLines = true;
    PageType = ListPart;
    SourceTable = Table70021;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Item No."; "Item No.")
                {
                }
                field(Description; Description)
                {
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
                field("Quantity Issued"; "Quantity Issued")
                {
                }
                field("Quantity to Return"; "Quantity to Return")
                {
                }
                field("Fixed Asset No"; "Fixed Asset No")
                {
                    Editable = false;
                }
                field("Unit Price"; "Unit Price")
                {
                }
                field(Amount; Amount)
                {
                }
            }
        }
    }

    actions
    {
    }
}

