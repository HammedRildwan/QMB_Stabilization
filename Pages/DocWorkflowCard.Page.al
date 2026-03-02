page 70191 "Doc. Workflow Card"
{
    PageType = Card;
    SourceTable = Table70100;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("User ID"; "User ID")
                {
                }
                field("Table No."; "Table No.")
                {
                }
                field("Table Name"; "Table Name")
                {
                }
                field("Approval Limit"; "Approval Limit")
                {
                }
            }
            part(Line; 70192)
            {
                Caption = 'Line';
                SubPageLink = Sender User ID=FIELD(User ID),
                              Table No.=FIELD(Table No.),
                              Approval Limit=FIELD(Approval Limit);
            }
        }
    }

    actions
    {
    }
}

