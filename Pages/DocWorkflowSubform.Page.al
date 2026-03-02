page 70192 "Doc. Workflow Subform"
{
    PageType = ListPart;
    SourceTable = Table70101;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Sender User ID"; "Sender User ID")
                {
                    Visible = false;
                }
                field("Table No."; "Table No.")
                {
                    Visible = false;
                }
                field(Sequence; Sequence)
                {
                }
                field(Approver; Approver)
                {
                }
            }
        }
    }

    actions
    {
    }
}

