page 53213 "Doc. Workflow Subform"
{
    PageType = ListPart;
    SourceTable = 53011;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Sender User ID"; rec."Sender User ID")
                {
                    Visible = false;
                }
                field("Table No."; rec."Table No.")
                {
                    Visible = false;
                }
                field(Sequence; rec.Sequence)
                {
                }
                field(Approver; rec.Approver)
                {
                }
            }
        }
    }

    actions
    {
    }
}

