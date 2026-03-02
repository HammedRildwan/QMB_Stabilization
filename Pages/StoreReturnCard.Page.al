page 70037 "Store Return Card"
{
    PageType = Card;
    SourceTable = 70020;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("No."; rec."No.")
                {
                }
                field(Date; rec.Date)
                {
                }
                field("Requisition No."; rec."Requisition No.")
                {
                }
                field("Work Order No."; rec."Work Order No.")
                {
                }
                field("Shortcut Dimension 1 Code"; rec."Shortcut Dimension 1 Code")
                {
                }
                field("Shortcut Dimension 2 Code"; rec."Shortcut Dimension 2 Code")
                {
                }
                field("Asset No."; rec."Asset No.")
                {
                }
                field(Justification; rec.Justification)
                {
                    MultiLine = true;
                }
                field(Requester; rec.Requester)
                {
                }
                field(Status; rec.Status)
                {
                }
            }
            part(Lines; 70038)
            {
                Caption = 'Lines';
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

                    StoreReturnHeader.SETRANGE("No.", "No.");
                    IF StoreReturnHeader.FINDFIRST THEN
                        RecID := StoreReturnHeader.RECORDID;
                    DocumentApprovalWorkflow.SendApprovalRequest(RecID.TABLENO, "No.", RecID, 0, Date, 0, Justification);
                    Status := Status::"Pending Approval";
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
                    IF Status = Status::Approved THEN
                        ERROR(Text001);

                    StoreReturnHeader.SETRANGE("No.", "No.");
                    IF StoreReturnHeader.FINDFIRST THEN
                        RecID := StoreReturnHeader.RECORDID;
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
                PromotedOnly = true;
                ShortCutKey = 'F9';
                ToolTip = 'Finalize the document by posting the amounts and quantities to the related accounts in your company books.';

                trigger OnAction()
                begin
                    TESTFIELD(Posted, FALSE);
                    PostReturn;
                    Posted := TRUE;
                    MODIFY;
                end;
            }
            action("Post and &Print")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Post and &Print';
                Image = PostPrint;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                ShortCutKey = 'Shift+F9';
                ToolTip = 'Finalize and prepare to print the document. The values and quantities are posted to the related accounts. A report request window where you can specify what to include on the print-out.';

                trigger OnAction()
                begin
                    TESTFIELD(Posted, FALSE);
                    PostReturnPrint;
                    Posted := TRUE;
                    MODIFY;
                end;
            }
        }
    }

    var
        DocumentApprovalWorkflow: Codeunit "50000";
        StoreReturnHeader: Record "70020";
        RecRef: RecordRef;
        RecID: RecordID;
        Text001: Label 'The document is already approved!';
}

