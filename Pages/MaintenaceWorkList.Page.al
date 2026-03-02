page 60010 "Maintenace Work List"
{
    CardPageID = "Maintenace Work Card";
    Editable = false;
    PageType = List;
    SourceTable = Table60009;
    SourceTableView = WHERE (Approval Status=FILTER(<>Approved));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No.";"No.")
                {
                }
                field("GPC Service Location";"GPC Service Location")
                {
                }
                field("Truck No.";"Truck No.")
                {
                }
                field("Business Unit";"Business Unit")
                {
                }
                field("Job Type";"Job Type")
                {
                }
                field("Maintenance Type";"Maintenance Type")
                {
                }
                field("Overall Status";"Overall Status")
                {
                }
                field(Priority;Priority)
                {
                }
                field("Created By ID";"Created By ID")
                {
                }
                field("Gate In Date and Time";"Gate In Date and Time")
                {
                }
                field("Approval Status";"Approval Status")
                {
                }
            }
        }
        area(factboxes)
        {
            part(Approvals;70194)
            {
                Caption = 'Approvals';
                SubPageLink = Document No.=FIELD(No.);
            }
            systempart(;Links)
            {
            }
            systempart(;Notes)
            {
            }
        }
    }

    actions
    {
    }
}

