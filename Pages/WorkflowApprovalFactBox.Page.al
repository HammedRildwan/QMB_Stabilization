page 53215 "Workflow Approval FactBox"
{
    PageType = CardPart;
    SourceTable = 53012;

    layout
    {
        area(content)
        {
            field(Sequence; rec.Sequence)
            {
            }
            field(Sender; rec.Sender)
            {
            }
            field(Approver; rec.Approver)
            {
            }
            field(Status; rec.Status)
            {
            }
            field("Status Change DateTime"; rec."Status Change DateTime")
            {
            }
            field("Send for Approval DateTime"; rec."Send for Approval DateTime")
            {
            }
        }
    }

    actions
    {
    }
}

