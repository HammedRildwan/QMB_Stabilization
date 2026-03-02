page 70191 "Doc. Workflow Card"
{
    PageType = Card;
    SourceTable = 70100;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("User ID"; rec."User ID")
                {
                }
                field("Table No."; rec."Table No.")
                {
                }
                field("Table Name"; rec."Table Name")
                {
                }
                field("Approval Limit"; rec."Approval Limit")
                {
                }
            }
            part(Line; 70192)
            {
                Caption = 'Line';
                SubPageLink = "Sender User ID"=FIELD("User ID"),
                              "Table No."=FIELD("Table No."),
                              "Approval Limit"=FIELD("Approval Limit");
            }
        }
    }

    actions
    {
    }
}

