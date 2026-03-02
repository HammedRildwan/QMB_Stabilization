page 60009 "Maintenace Work Card"
{
    PageType = Document;
    SourceTable = Table60009;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("No."; "No.")
                {
                }
                field("Truck No."; "Truck No.")
                {
                }
                field("Business Unit"; "Business Unit")
                {
                }
                field("GPC Service Location"; "GPC Service Location")
                {
                }
                field("Job Type"; "Job Type")
                {

                    trigger OnValidate()
                    begin
                        IF "Job Type" = "Job Type"::Repair THEN BEGIN
                            RoutineVisible := TRUE;
                            RepairVisible := FALSE;
                            EnableMaintenanceType := TRUE;
                        END ELSE BEGIN
                            RoutineVisible := FALSE;
                            EnableMaintenanceType := FALSE;
                            "Maintenance Type" := "Maintenance Type"::" ";
                        END;

                        IF "Job Type" = "Job Type"::"Road Work" THEN BEGIN
                            RepairVisible := TRUE;
                            RoutineVisible := FALSE;
                        END ELSE
                            RepairVisible := FALSE;

                        IF "Job Type" = "Job Type"::"6" THEN
                            ReturnEditable := TRUE
                        ELSE
                            ReturnEditable := FALSE;
                    end;
                }
                field("Maintenance Type"; "Maintenance Type")
                {
                    Enabled = EnableMaintenanceType;
                }
                field("Refrence Job"; "Refrence Job")
                {
                }
                field("Cause fo Return"; "Cause fo Return")
                {
                }
                field("Return Job Description"; "Return Job Description")
                {
                    Editable = ReturnEditable;
                }
                field(Priority; Priority)
                {
                }
                field("Fault Reported"; "Fault Reported")
                {
                    MultiLine = true;
                }
                field("Supervisor Assesment"; "Supervisor Assesment")
                {
                    MultiLine = true;
                }
                field("Brought In Odometer Reading"; "Brought In Odometer Reading")
                {
                }
                field("Brought-In Condition"; "Brought-In Condition")
                {
                }
                field("WAC - Vehicle Papers"; "WAC - Vehicle Papers")
                {
                }
                field("Veh. Inspection Officer No."; "Veh. Inspection Officer No.")
                {
                }
                field("Veh. Inspection Officer Name"; "Veh. Inspection Officer Name")
                {
                }
                field("Overall Status"; "Overall Status")
                {
                }
                field("Approval Status"; "Approval Status")
                {
                }
            }
            group("Routine Maintenance")
            {
                Caption = 'Routine Maintenance Checklist';
                Visible = RoutineVisible;
                field("WAC - Engine Oil Level"; "WAC - Engine Oil Level")
                {
                }
                field("WAC - Electrical System"; "WAC - Electrical System")
                {
                }
                field("WAC - Air Cleaner"; "WAC - Air Cleaner")
                {
                }
                field("WAC - Air Tank"; "WAC - Air Tank")
                {
                }
                field("WAC - Water Filter"; "WAC - Water Filter")
                {
                }
                field("WAC - Gas Filter"; "WAC - Gas Filter")
                {
                }
                field("WAC - Axle Hub Lubricant"; "WAC - Axle Hub Lubricant")
                {
                }
                field("WAC - Coolant Level"; "WAC - Coolant Level")
                {
                }
                field("WAC - Transmission Oil Level"; "WAC - Transmission Oil Level")
                {
                }
                group("Walkaround Checklist")
                {
                    Caption = 'Repair Work Checklist';
                    Visible = RepairVisible;
                    field("WAC - Engine Noises"; "WAC - Engine Noises")
                    {
                    }
                    field("WAC - Leaks"; "WAC - Leaks")
                    {
                    }
                    field("WAC - Tyre Pressue"; "WAC - Tyre Pressue")
                    {
                    }
                    field("WAC - Windshield and Wipers"; "WAC - Windshield and Wipers")
                    {
                    }
                    field("WAC - Battery"; "WAC - Battery")
                    {
                    }
                    field("WAC - Steering"; "WAC - Steering")
                    {
                    }
                    field("WAC - Engine Belts and Hoses"; "WAC - Engine Belts and Hoses")
                    {
                    }
                    field("WAC - Brakes"; "WAC - Brakes")
                    {
                    }
                    field("VIO Observation/Remark"; "VIO Observation/Remark")
                    {
                        MultiLine = true;
                    }
                }
                group("Engine/Cabin")
                {
                    Caption = 'Engine/Cabin';
                    field("WAC - Fan belt tension"; "WAC - Fan belt tension")
                    {
                    }
                    field("WAC - Pulley for clearance"; "WAC - Pulley for clearance")
                    {
                    }
                    field("WAC -  Tie Rod clearance"; "WAC -  Tie Rod clearance")
                    {
                    }
                    field("WAC - Oil Leakage"; "WAC - Oil Leakage")
                    {
                    }
                    field("WAC - Fuel Leakage"; "WAC - Fuel Leakage")
                    {
                    }
                    field("WAC - Coolant Spill/Leaks"; "WAC - Coolant Spill/Leaks")
                    {
                    }
                    field("WAC - Air Cleaner Housing"; "WAC - Air Cleaner Housing")
                    {
                    }
                    field("WAC- Air Leakage"; "WAC- Air Leakage")
                    {
                    }
                    field("WAC - Dashboard Functions"; "WAC - Dashboard Functions")
                    {
                    }
                    field("WAC - Air Pressure"; "WAC - Air Pressure")
                    {
                    }
                    field("WAC - Oil Pressure"; "WAC - Oil Pressure")
                    {
                    }
                    field("WAC - Water Temperature"; "WAC - Water Temperature")
                    {
                    }
                    field("WAC - Exhaust Leakage"; "WAC - Exhaust Leakage")
                    {
                    }
                    field("WAC - Front Shock Absorber"; "WAC - Front Shock Absorber")
                    {
                    }
                    field("WAC - Cab Barrel"; "WAC - Cab Barrel")
                    {
                    }
                    field("WAC - Cab Shocks"; "WAC - Cab Shocks")
                    {
                    }
                    field("WAC - Cabin Locks"; "WAC - Cabin Locks")
                    {
                    }
                    field("WAC - Bushings for Clearance"; "WAC - Bushings for Clearance")
                    {
                    }
                    field("WAC - Battery Terminals"; "WAC - Battery Terminals")
                    {
                    }
                }
                group(Chassis)
                {
                    field("WAC - Chassis Beams"; "WAC - Chassis Beams")
                    {
                    }
                    field("WAC - Kingpin"; "WAC - Kingpin")
                    {
                    }
                    field("WAC - Trailer Connecting Hose"; "WAC - Trailer Connecting Hose")
                    {
                    }
                    field("WAC - Hydrometer & Diesel Tank"; "WAC - Hydrometer & Diesel Tank")
                    {
                    }
                    field("WAC - Tractor Brake"; "WAC - Tractor Brake")
                    {
                    }
                    field("WAC - Transmission Fluid Level"; "WAC - Transmission Fluid Level")
                    {
                    }
                    field("WAC - Gearbox Oil Level"; "WAC - Gearbox Oil Level")
                    {
                    }
                    field("WAC Axle Oil Level"; "WAC Axle Oil Level")
                    {
                    }
                    field("WAC - Propeller"; "WAC - Propeller")
                    {
                    }
                    field("WAC - Air Tank & Disch. Water"; "WAC - Air Tank & Disch. Water")
                    {
                    }
                }
                group("Semi Trailer")
                {
                    field("WAC -Trailer Air Valve Leakage"; "WAC -Trailer Air Valve Leakage")
                    {
                    }
                    field("WAC - Wheel Studs"; "WAC - Wheel Studs")
                    {
                    }
                    field("WAC - Brake Lining"; "WAC - Brake Lining")
                    {
                    }
                    field("WAC - Hub Covers"; "WAC - Hub Covers")
                    {
                    }
                    field("WAC - Spring/Center Bolt"; "WAC - Spring/Center Bolt")
                    {
                    }
                    field("WAC - Equalizer"; "WAC - Equalizer")
                    {
                    }
                    field("WAC - Shock Absorbers"; "WAC - Shock Absorbers")
                    {
                    }
                    field("WAC - Shackle Pins"; "WAC - Shackle Pins")
                    {
                    }
                }
                field("WAC - Overall Trailer Appearan"; "WAC - Overall Trailer Appearan")
                {
                    Caption = 'WAC - Overall Trailer Appearance';
                }
            }
            part("Job Details"; 60011)
            {
                Caption = 'Job Details';
                SubPageLink = Document No.=FIELD(No.);
            }
            group(HSE)
            {
                Caption = 'HSE';
                Visible = false;
                field("Machine Off"; "Machine Off")
                {
                }
                field("Safety Googles"; "Safety Googles")
                {
                }
                field("Safety Boots"; "Safety Boots")
                {
                }
                field("Driving Test Feedback"; "Driving Test Feedback")
                {
                }
                field("Final Inspection Done"; "Final Inspection Done")
                {
                }
                field("Gate-Out Time"; "Gate-Out Time")
                {
                }
            }
            group(Audit)
            {
                field("Job done satisfactorily"; "Job done satisfactorily")
                {
                }
                field("Part(s) Reqested"; "Part(s) Reqested")
                {
                }
                field("Created By ID"; "Created By ID")
                {
                    Editable = false;
                }
                field("Gate In Date and Time"; "Gate In Date and Time")
                {
                    Editable = false;
                }
                field("Part Requested DateTime"; "Part Requested DateTime")
                {
                }
                field("Part Received DateTime"; "Part Received DateTime")
                {
                }
            }
            group(Delivery)
            {
                Caption = 'Delivery';
                field(Delivered; Delivered)
                {

                    trigger OnValidate()
                    begin
                        IF CONFIRM('Are you sure the work has been delivered and satisfactorily done?', FALSE) THEN
                            CurrPage.EDITABLE := FALSE;
                    end;
                }
                field("Delivered By"; "Delivered By")
                {
                }
                field("Delivery Date/Time"; "Delivery Date/Time")
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
            part(; 1174)
            {
                SubPageLink = Table ID=CONST(60009);
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
        area(processing)
        {
            group(Notification)
            {
                Caption = 'Notification';
                action("Send to VIO")
                {
                    Image = SendTo;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        MESSAGE('Do you want to send to VIO?');
                    end;
                }
                action("Request for Spare Part")
                {
                    Image = Receipt;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        TESTFIELD("Approval Status", "Approval Status"::Approved);

                        IF "Part(s) Reqested" THEN
                            ERROR('Parts have been requested')
                        ELSE BEGIN
                            StoreRequisitionHeader.INIT;
                            StoreRequisitionHeader.INSERT(TRUE);
                            StoreRequisitionHeader."Approved Work Order No." := "No.";
                            StoreRequisitionHeader."Request Type" := StoreRequisitionHeader."Request Type"::Maintenance;
                            StoreRequisitionLine."Fixed Asset No." := "Truck No.";
                            StoreRequisitionHeader.MODIFY;
                            COMMIT;
                            "Part(s) Reqested" := TRUE;
                        END;
                        //"Approval Status" := "Approval Status"::"Pending Approval";
                        "Overall Status" := "Overall Status"::"Awaiting Parts";

                        /*
                        IF "Approval Status" <> "Approval Status"::Approved THEN
                          ERROR('Work Order must be approved before you can request spare parts!')
                        ELSE
                          MESSAGE('Use Store Requisition to request Spare Parts from Store and link up to this approved Work Order!');
                        */

                    end;
                }
                action("Close Job")
                {
                    Image = Close;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        TESTFIELD("Job done satisfactorily");
                        TESTFIELD("Approval Status", "Approval Status"::Approved);

                        IF "Created By ID" <> USERID THEN
                            ERROR('You cannot close this work order, contact the initiator');


                        IF "Created By ID" = USERID THEN BEGIN
                            "Overall Status" := "Overall Status"::Closed;
                            MODIFY;

                        END;
                    end;
                }
            }
            group(Approval)
            {
                Caption = 'Approval';
                action(SendApprovalRequest)
                {
                    Caption = 'Send Approval Request';
                    Image = SendApprovalRequest;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedOnly = true;

                    trigger OnAction()
                    begin
                        IF "Approval Status" = "Approval Status"::Approved THEN
                            ERROR('The document is already approved!');

                        TESTFIELD("Veh. Inspection Officer No.");
                        TESTFIELD("Brought In Odometer Reading");
                        TESTFIELD("Fault Reported");
                        TESTFIELD("Supervisor Assesment");
                        TESTFIELD("GPC Service Location");
                        IF "Job Type" = "Job Type"::"6" THEN BEGIN
                            TESTFIELD("Refrence Job");
                            TESTFIELD("Cause fo Return");
                            TESTFIELD("Fault Reported");
                            TESTFIELD("Return Job Description");
                        END;



                        MaintenaceWorkLine.SETFILTER("Document No.", "No.");
                        IF MaintenaceWorkLine.FIND('-') THEN BEGIN
                            MaintenaceWorkLine.TESTFIELD("Fault Area Code");
                            MaintenaceWorkLine.TESTFIELD("Fault Code");
                            MaintenaceWorkLine.TESTFIELD("Workshop Supervisor");
                            MaintenaceWorkLine.TESTFIELD("Assigned Technician");
                            MaintenaceWorkLine.TESTFIELD("Job Start Date");
                            MaintenaceWorkLine.TESTFIELD("Asset No.");
                            MaintenaceWorkLine.TESTFIELD("QMB Service Location");

                        END;



                        MaintenanceWorkHeader.SETRANGE("No.", "No.");
                        IF MaintenanceWorkHeader.FINDFIRST THEN
                            RecID := MaintenanceWorkHeader.RECORDID;
                        Description := STRSUBSTNO(Text001, "Truck No.", "Job Type");
                        DocumentApprovalWorkflow.SendApprovalRequest(RecID.TABLENO, "No.", RecID, 0, TODAY, 0, Description);
                        "Approval Status" := "Approval Status"::"Pending Approval";
                        MODIFY;
                    end;
                }
                action(CancelApprovalRequest)
                {
                    Caption = 'Cancel Approval Request';
                    Ellipsis = true;
                    Image = Cancel;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedOnly = true;

                    trigger OnAction()
                    begin
                        IF "Approval Status" = "Approval Status"::Approved THEN
                            ERROR('The document is already approved!');

                        MaintenanceWorkHeader.SETRANGE("No.", "No.");
                        IF MaintenanceWorkHeader.FINDFIRST THEN
                            RecID := MaintenanceWorkHeader.RECORDID;
                        DocumentApprovalWorkflow.CancelApprovalRequest(RecID.TABLENO, "No.");
                        "Approval Status" := "Approval Status"::" ";
                        MODIFY;
                    end;
                }
                action(Approve)
                {
                    Caption = 'Approve';
                    Image = Approve;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "1535";
                    begin
                        IF "Approval Status" = "Approval Status"::Approved THEN
                            ERROR('The document is already approved!');

                        DocumentApprovalWorkflow.ApproveDocument(RecID.TABLENO, "No.", RecID);
                        IF DocumentApprovalWorkflow.ApprovalStatusCheck(RecID.TABLENO, "No.", RecID) THEN BEGIN
                            "Approval Status" := "Approval Status"::Approved;
                            MODIFY;
                        END;
                    end;
                }
                action(Reject)
                {
                    Caption = 'Reject';
                    Image = Reject;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "1535";
                    begin
                        IF "Approval Status" = "Approval Status"::Approved THEN
                            ERROR('The document is already approved!');

                        DocumentApprovalWorkflow.RejectDocument("No.");
                        IF NOT DocumentApprovalWorkflow.ApprovalStatusCheck(RecID.TABLENO, "No.", RecID) THEN BEGIN
                            "Approval Status" := "Approval Status"::Rejected;
                            MODIFY;
                        END;
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        IF "Job Type" = "Job Type"::Repair THEN
            EnableMaintenanceType := TRUE
        ELSE BEGIN
            EnableMaintenanceType := FALSE;
            "Maintenance Type" := "Maintenance Type"::" ";
        END;

        IF "Job Type" = "Job Type"::"6" THEN
            ReturnEditable := TRUE
        ELSE
            ReturnEditable := FALSE;
        //IF "Overall Status" = "Overall Status"::Closed THEN
        //CurrPage.EDITABLE := FALSE;
        //IF Delivered := TRUE
        //ELSE BEGIN
        //CurrPage.EDITABLE := FALSE;
    end;

    trigger OnOpenPage()
    begin
        //IF "Overall Status" = "Overall Status"::Closed THEN
        //CurrPage.EDITABLE := FALSE;
    end;

    var
        StoreRequisitionHeader: Record "70018";
        StoreRequisitionLine: Record "70019";
        EnableMaintenanceType: Boolean;
        DocumentApprovalWorkflow: Codeunit "50000";
        MaintenanceWorkHeader: Record "60009";
        MaintenaceWorkLine: Record "60010";
        RecRef: RecordRef;
        RecID: RecordID;
        Description: Text;
        Text001: Label 'Maintenance Work for Truck %1 with %2 Job Type';
        RoutineVisible: Boolean;
        RepairVisible: Boolean;
        UserSetup: Record "91";
        PageEditable: Boolean;
        ReturnEditable: Boolean;
}

