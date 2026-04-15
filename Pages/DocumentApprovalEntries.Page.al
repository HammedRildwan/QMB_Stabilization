page 53214 "Document Approval Entries"
{
    PageType = List;
    SourceTable = "Document Approval Entry";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Sequence; Rec.Sequence)
                {
                }
                field("Table No."; Rec."Table No.")
                {
                }
                field("Document No."; Rec."Document No.")
                {
                }
                field(Sender; Rec.Sender)
                {
                }
                field(Approver; Rec.Approver)
                {
                }
                field(Status; Rec.Status)
                {
                }
                field("Record ID to Approve"; Rec."Record ID to Approve")
                {
                }
                field("Document Date"; Rec."Document Date")
                {
                }
                field("Document Amount"; Rec."Document Amount")
                {
                }
                field("Document Description"; Rec."Document Description")
                {
                }
                field(Open; Rec.Open)
                {
                }
                field("Status Change DateTime"; Rec."Status Change DateTime")
                {
                }
                field("Send for Approval DateTime"; Rec."Send for Approval DateTime")
                {
                }
            }
        }
    }

    actions
    {
    }
}

