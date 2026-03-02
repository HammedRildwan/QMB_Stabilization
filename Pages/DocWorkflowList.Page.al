page 70190 "Doc. Workflow List"
{
    CardPageID = "Doc. Workflow Card";
    Editable = false;
    PageType = List;
    SourceTable = Table70100;

    layout
    {
        area(content)
        {
            repeater(Group)
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
        }
    }

    actions
    {
    }
}

