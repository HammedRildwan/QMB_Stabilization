page 70038 "Store Return Subform"
{
    AutoSplitKey = true;
    DelayedInsert = true;
    MultipleNewLines = true;
    PageType = ListPart;
    SourceTable = 70021;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Item No."; rec."Item No.")
                {
                }
                field(Description; rec.Description)
                {
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
                field("Quantity Issued"; rec."Quantity Issued")
                {
                }
                field("Quantity to Return"; rec."Quantity to Return")
                {
                }
                field("Fixed Asset No"; rec."Fixed Asset No")
                {
                    Editable = false;
                }
                field("Unit Price"; rec."Unit Price")
                {
                }
                field(Amount; rec.Amount)
                {
                }
            }
        }
    }

    actions
    {
    }
}

