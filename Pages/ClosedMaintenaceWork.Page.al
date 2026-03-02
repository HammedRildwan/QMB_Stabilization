page 60051 "Closed Maintenace Work"
{
    CardPageID = "Maintenace Work Card";
    Editable = false;
    PageType = List;
    SourceTable = Table60009;
    SourceTableView = WHERE (Delivered = FILTER (Yes));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; "No.")
                {
                }
                field("GPC Service Location"; "GPC Service Location")
                {
                }
                field("Truck No."; "Truck No.")
                {
                }
                field("Business Unit"; "Business Unit")
                {
                }
                field("Job Type"; "Job Type")
                {
                }
                field("Supervisor Assesment"; "Supervisor Assesment")
                {
                }
                field(Delivered; Delivered)
                {
                }
                field("Delivered By"; "Delivered By")
                {
                }
                field("Delivery Date/Time"; "Delivery Date/Time")
                {
                }
                field("Maintenance Type"; "Maintenance Type")
                {
                }
                field(Priority; Priority)
                {
                }
                field("Created By ID"; "Created By ID")
                {
                }
                field("Gate In Date and Time"; "Gate In Date and Time")
                {
                }
                field("Approval Status"; "Approval Status")
                {
                }
            }
        }
        area(factboxes)
        {
            part(Approvals; 70194)
            {
                Caption = 'Approvals';
                SubPageLink = Document No.=FIELD(No.);
            }
            systempart(; Links)
            {
            }
            systempart(; Notes)
            {
            }
        }
    }

    actions
    {
    }
}

