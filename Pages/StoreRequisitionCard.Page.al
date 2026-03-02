page 70034 "Store Requisition Card"
{
    PageType = Card;
    SourceTable = Table70018;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Request Date"; "Request Date")
                {
                }
                field(Requester; Requester)
                {
                }
                field("Shortcut Dimension 1 Code"; "Shortcut Dimension 1 Code")
                {
                    Importance = Additional;
                }
                field("Shortcut Dimension 2 Code"; "Shortcut Dimension 2 Code")
                {
                    Importance = Additional;

                    trigger OnValidate()
                    begin
                        IF "Shortcut Dimension 2 Code" <> xRec."Shortcut Dimension 2 Code" THEN BEGIN
                            StoreRequisitionLine.SETFILTER("Document No.", "No.");
                            IF StoreRequisitionLine.FINDSET THEN BEGIN
                                REPEAT
                                    StoreRequisitionLine.VALIDATE("Shortcut Dimension 2 Code", "Shortcut Dimension 2 Code");
                                UNTIL StoreRequisitionLine.NEXT = 0;
                            END;
                        END;
                    end;
                }
                field("Store Location"; "Store Location")
                {
                }
                field("Request Type"; "Request Type")
                {

                    trigger OnValidate()
                    begin
                        MaintTypeEditable := FALSE;
                        IF ("Request Type" = "Request Type"::Maintenance) OR ("Request Type" = "Request Type"::"Internal Consumption")
                          OR ("Request Type" = "Request Type"::"Road Work") THEN BEGIN
                            MaintTypeEditable := TRUE;
                        END;

                        IF "Request Type" = "Request Type"::Refurbishment THEN
                            RefVendEditable := TRUE;
                    end;
                }
                field("Refurbishment Vendor"; "Refurbishment Vendor")
                {
                    Editable = RefVendEditable;
                }
                field("Maintenance Type"; "Maintenance Type")
                {
                    Editable = MaintTypeEditable;

                    trigger OnValidate()
                    begin
                        WorkOrderEnabled := FALSE;
                        IF "Maintenance Type" = "Maintenance Type"::Truck THEN BEGIN
                            WorkOrderEnabled := TRUE;
                        END;
                    end;
                }
                field("Approved Work Order No."; "Approved Work Order No.")
                {
                    Enabled = WorkOrderEnabled;
                    ShowMandatory = true;
                }
                field("Asset No."; "Asset No.")
                {

                    trigger OnValidate()
                    begin
                        IF "Maintenance Type" = "Maintenance Type"::Truck THEN BEGIN
                            IF "Asset No." <> xRec."Asset No." THEN BEGIN
                                StoreRequisitionLine.SETFILTER("Document No.", "No.");
                                IF StoreRequisitionLine.FINDSET THEN BEGIN
                                    REPEAT
                                        StoreRequisitionLine.VALIDATE("Fixed Asset No.", "Asset No.");
                                        StoreRequisitionLine.MODIFY;
                                    UNTIL StoreRequisitionLine.NEXT = 0;
                                END;
                            END;
                        END;
                    end;
                }
                field(Justification; Justification)
                {
                    MultiLine = true;
                    ShowMandatory = true;
                }
                field("Not Issued"; "Not Issued")
                {
                }
                field(Status; Status)
                {
                    Editable = false;
                }
            }
            part(Lines; 70035)
            {
                Caption = 'Request Lines';
                SubPageLink = Document No.=FIELD(No.);
            }
        }
        area(factboxes)
        {
            part(Approvals; 70194)
            {
                Caption = 'Approvals';
                SubPageLink = Document No.=FIELD(No.);
            }
            systempart(; Notes)
            {
            }
            systempart(; Links)
            {
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(SendApprovalRequest)
            {
                Caption = 'Send Approval Request';
                Image = SendApprovalRequest;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;

                trigger OnAction()
                begin
                    IF Status = Status::Approved THEN
                        ERROR(Text001);
                    //Ensure all required fields are captured
                    TESTFIELD("Store Location");
                    TESTFIELD(Justification);
                    TESTFIELD("Request Date");
                    TESTFIELD("Request Type");

                    IF ("Request Type" = "Request Type"::Maintenance) AND ("Maintenance Type" = "Maintenance Type"::Truck) THEN BEGIN
                        TESTFIELD("Approved Work Order No.");
                        TESTFIELD("Asset No.");
                    END;

                    IF ("Request Type" = "Request Type"::Maintenance) AND ("Maintenance Type" = "Maintenance Type"::"Other Assets") THEN
                        TESTFIELD("Asset No.");

                    StoreRequisitionLine.SETFILTER("Document No.", "No.");
                    IF NOT StoreRequisitionLine.FINDFIRST THEN
                        ERROR(Text005)
                    ELSE BEGIN
                        REPEAT
                            StoreRequisitionLine.TESTFIELD("Shortcut Dimension 2 Code");
                            StoreRequisitionLine.TESTFIELD("Shortcut Dimension 3 Code");
                            IF "Request Type" = "Request Type"::Maintenance THEN
                                StoreRequisitionLine.TESTFIELD("Fixed Asset No.");
                            StoreRequisitionLine.TESTFIELD("Location Code");
                        UNTIL StoreRequisitionLine.NEXT = 0;
                    END;

                    StoreRequisitionHeader.SETRANGE("No.", "No.");
                    IF StoreRequisitionHeader.FINDFIRST THEN
                        RecID := StoreRequisitionHeader.RECORDID;
                    DocumentApprovalWorkflow.SendApprovalRequest(RecID.TABLENO, "No.", RecID, 0, "Request Date", 0, Justification);
                    Status := Status::"Pending Approval";
                    MODIFY;

                    MESSAGE('Document sent for Approval');


                    // CAImprestMgt.SETRANGE("No.","No.");
                    // IF CAImprestMgt.FINDFIRST THEN
                    //  RecID := CAImprestMgt.RECORDID;
                    // DocumentApprovalWorkflow.SendApprovalRequest(RecID.TABLENO,"No.",RecID,0,Date,"Amount (LCY)",Purpose);
                    // Status := Status::"Pending Approval";
                    // MODIFY;
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
                    IF Status = Status::Approved THEN
                        ERROR(Text001);

                    StoreRequisitionHeader.SETRANGE("No.", "No.");
                    IF StoreRequisitionHeader.FINDFIRST THEN
                        RecID := StoreRequisitionHeader.RECORDID;
                    DocumentApprovalWorkflow.CancelApprovalRequest(RecID.TABLENO, "No.");
                    Status := Status::" ";
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
                    IF Status = Status::Approved THEN
                        ERROR(Text001);
                    IF Status <> Status::"Pending Approval" THEN
                        ERROR('The document must be pending approval!');

                    StoreRequisitionLine.SETFILTER("Document No.", "No.");
                    IF NOT StoreRequisitionLine.FINDFIRST THEN
                        ERROR(Text005)
                    ELSE BEGIN
                        REPEAT
                            StoreRequisitionLine.TESTFIELD("Shortcut Dimension 2 Code");
                            StoreRequisitionLine.TESTFIELD("Shortcut Dimension 3 Code");
                            IF "Request Type" = "Request Type"::Maintenance THEN
                                StoreRequisitionLine.TESTFIELD("Fixed Asset No.");
                            StoreRequisitionLine.TESTFIELD("Location Code");
                        UNTIL StoreRequisitionLine.NEXT = 0;
                    END;

                    DocumentApprovalWorkflow.ApproveDocument(RecID.TABLENO, "No.", RecID);
                    IF DocumentApprovalWorkflow.ApprovalStatusCheck(RecID.TABLENO, "No.", RecID) THEN BEGIN
                        Status := Status::Approved;
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
                    IF Status = Status::Approved THEN
                        ERROR(Text001);

                    DocumentApprovalWorkflow.RejectDocument("No.");
                    IF NOT DocumentApprovalWorkflow.ApprovalStatusCheck(RecID.TABLENO, "No.", RecID) THEN BEGIN
                        Status := Status::Rejected;
                        MODIFY;
                    END;
                end;
            }
            action("Test Report")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Test Report';
                Ellipsis = true;
                Image = TestReport;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                ToolTip = 'View a test report so that you can find and correct any errors before you perform the actual posting of the document.';
                Visible = false;

                trigger OnAction()
                begin
                    TestReport;
                end;
            }
            action(Post)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'P&ost';
                Image = PostOrder;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ShortCutKey = 'F9';
                ToolTip = 'Finalize the document by posting the amounts and quantities to the related accounts in your company books.';

                trigger OnAction()
                begin
                    TESTFIELD(Posted, FALSE);
                    IF Status <> Status::Approved THEN
                        ERROR('You can not post the document without approval')
                    ELSE
                        PostIssue;
                    IF ("Request Type" = "Request Type"::Maintenance) OR ("Request Type" = "Request Type"::"Road Work") THEN
                        InsertMaintJournal;
                end;
            }
            action("Post and &Print")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Post and &Print';
                Image = PostPrint;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ShortCutKey = 'Shift+F9';
                ToolTip = 'Finalize and prepare to print the document. The values and quantities are posted to the related accounts. A report request window where you can specify what to include on the print-out.';

                trigger OnAction()
                begin
                    TESTFIELD(Posted, FALSE);
                    IF Status <> Status::Approved THEN
                        ERROR('You can not post the document without approval')
                    ELSE
                        PostIssuePrint;

                    IF ("Request Type" = "Request Type"::Maintenance) OR ("Request Type" = "Request Type"::"Road Work") THEN
                        InsertMaintJournal;
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        WorkOrderEnabled := FALSE;
        IF "Maintenance Type" = "Maintenance Type"::Truck THEN
            WorkOrderEnabled := TRUE;


        IF Posted = TRUE THEN
            CurrPage.EDITABLE := FALSE;
    end;

    trigger OnOpenPage()
    begin
        WorkOrderEnabled := FALSE;
        IF "Maintenance Type" = "Maintenance Type"::Truck THEN
            WorkOrderEnabled := TRUE;

        IF Posted = TRUE THEN
            CurrPage.EDITABLE := FALSE;
    end;

    var
        DocumentApprovalWorkflow: Codeunit "50000";
        StoreRequisitionHeader: Record "70018";
        RecRef: RecordRef;
        RecID: RecordID;
        StoreRequisitionLine: Record "70019";
        Text001: Label 'The document is already approved!';
        Text002: Label 'The document must be approved!';
        Text003: Label 'Sorry, you must receive the old spare part!';
        Text004: Label 'Sorry, you must specify the return location!';
        MaintenanceWorkHeader: Record "60009";
        WorkOrderEnabled: Boolean;
        Text005: Label 'Your requisition must have at least one line!';
        MaintTypeEditable: Boolean;
        RefVendEditable: Boolean;
}

