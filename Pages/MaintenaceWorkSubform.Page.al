page 60011 "Maintenace Work Subform"
{
    PageType = ListPart;
    SourceTable = Table60010;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Fault Area Code"; "Fault Area Code")
                {
                }
                field("Fault Code"; "Fault Code")
                {
                }
                field("Fault Description"; "Fault Description")
                {
                }
                field("Estimated Labour Hour"; "Estimated Labour Hour")
                {
                }
                field("Additional Details"; "Additional Details")
                {
                }
                field("Spare Parts Needed"; "Spare Parts Needed")
                {
                }
                field("Asset No."; "Asset No.")
                {
                }
                field("Shortcut Dimension 1 Code"; "Shortcut Dimension 1 Code")
                {
                }
                field("QMB Service Location"; "QMB Service Location")
                {
                }
                field("Workshop Supervisor"; "Workshop Supervisor")
                {
                }
                field("Workshop Supervisor Name"; "Workshop Supervisor Name")
                {
                }
                field("Assigned Technician"; "Assigned Technician")
                {
                }
                field("Technician Name"; "Technician Name")
                {
                }
                field("Job Status"; "Job Status")
                {
                }
                field("Job Start Date"; "Job Start Date")
                {
                }
                field("Job Job Start Time"; "Job Job Start Time")
                {
                }
                field("Job Pause Date"; "Job Pause Date")
                {
                }
                field("Job Pause Time"; "Job Pause Time")
                {
                }
                field("Job Resume Date"; "Job Resume Date")
                {
                }
                field("Job Resume Time"; "Job Resume Time")
                {
                }
                field("Job Complete Date"; "Job Complete Date")
                {
                }
                field("Job Complete Time"; "Job Complete Time")
                {
                }
            }
        }
    }

    actions
    {
    }

    var
        Employee: Record "5200";
}

