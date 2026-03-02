page 70190 "Doc. Workflow List"
{
    CardPageID = "Doc. Workflow Card";
    Editable = false;
    PageType = List;
    SourceTable = 70100;

    layout
    {
        area(content)
        {
            repeater(Group)
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
        }
    }

    actions
    {
    }
}

