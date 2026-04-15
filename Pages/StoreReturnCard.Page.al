page 53205 "Store Return Card"
{
    PageType = Card;
    SourceTable = "Store Return Header";


    layout
    {
        area(content)
        {
            group(General)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                }
                field(Date; Rec.Date)
                {
                    ApplicationArea = All;
                }
                field("Requisition No."; Rec."Requisition No.")
                {
                    ApplicationArea = All;
                }
                field("Work Order No."; Rec."Work Order No.")
                {
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = All;
                }
                field("Asset No."; Rec."Asset No.")
                {
                    ApplicationArea = All;
                }
                field(Justification; Rec.Justification)
                {
                    ApplicationArea = All;
                    MultiLine = true;
                }
                field(Requester; Rec.Requester)
                {
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                }
            }
            part(Lines; "Store Return Subform")
            {
                Caption = 'Lines';
                SubPageLink = "Document No." = field("No.");
                ApplicationArea = All;
            }
        }
        area(factboxes)
        {
            part(Approvals; "Workflow Approval FactBox")
            {
                Caption = 'Approvals';
                SubPageLink = "Document No." = field("No.");
                ApplicationArea = All;
            }
            systempart(Notes; Notes)
            {
                ApplicationArea = All;
            }
            systempart(Links; Links)
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(SendApprovalRequest)
            {
                ApplicationArea = All;
                Caption = 'Send Approval Request';
                Image = SendApprovalRequest;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;

                trigger OnAction()
                begin
                    if Rec.Status = Rec.Status::Approved then
                        Error(Text001);

                    StoreReturnHeader.SetRange("No.", Rec."No.");
                    if StoreReturnHeader.FindFirst() then
                        RecID := StoreReturnHeader.RecordId;
                    DocumentApprovalWorkflow.SendApprovalRequest(RecID.TableNo, Rec."No.", RecID, 0, Rec.Date, 0, Rec.Justification);
                    Rec.Status := Rec.Status::"Pending Approval";
                    Rec.Modify();
                end;
            }
            action(CancelApprovalRequest)
            {
                ApplicationArea = All;
                Caption = 'Cancel Approval Request';
                Ellipsis = true;
                Image = Cancel;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;

                trigger OnAction()
                begin
                    if Rec.Status = Rec.Status::Approved then
                        Error(Text001);

                    StoreReturnHeader.SetRange("No.", Rec."No.");
                    if StoreReturnHeader.FindFirst() then
                        RecID := StoreReturnHeader.RecordId;
                    DocumentApprovalWorkflow.CancelApprovalRequest(RecID.TableNo, Rec."No.");
                    Rec.Status := Rec.Status::" ";
                    Rec.Modify();
                end;
            }
            action(Approve)
            {
                ApplicationArea = All;
                Caption = 'Approve';
                Image = Approve;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    if Rec.Status = Rec.Status::Approved then
                        Error(Text001);

                    DocumentApprovalWorkflow.ApproveDocument(RecID.TableNo, Rec."No.", RecID);
                    if DocumentApprovalWorkflow.ApprovalStatusCheck(RecID.TableNo, Rec."No.", RecID) then begin
                        Rec.Status := Rec.Status::Approved;
                        Rec.Modify();
                    end;
                end;
            }
            action(Reject)
            {
                ApplicationArea = All;
                Caption = 'Reject';
                Image = Reject;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    if Rec.Status = Rec.Status::Approved then
                        Error(Text001);

                    DocumentApprovalWorkflow.RejectDocument(Rec."No.");
                    if not DocumentApprovalWorkflow.ApprovalStatusCheck(RecID.TableNo, Rec."No.", RecID) then begin
                        Rec.Status := Rec.Status::Rejected;
                        Rec.Modify();
                    end;
                end;
            }
            action("Test Report")
            {
                ApplicationArea = All;
                Caption = 'Test Report';
                Ellipsis = true;
                Image = TestReport;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                ToolTip = 'View a test report so that you can find and correct any errors before you perform the actual posting of the document.';

                trigger OnAction()
                begin
                    TestReport();
                end;
            }
            action(Post)
            {
                ApplicationArea = All;
                Caption = 'P&ost';
                Image = PostOrder;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                ShortCutKey = 'F9';
                ToolTip = 'Finalize the document by posting the amounts and quantities to the related accounts in your company books.';

                trigger OnAction()
                begin
                    Rec.TestField(Posted, false);
                    PostReturn();
                    Rec.Posted := true;
                    Rec.Modify();
                end;
            }
            action("Post and &Print")
            {
                ApplicationArea = All;
                Caption = 'Post and &Print';
                Image = PostPrint;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                ShortCutKey = 'Shift+F9';
                ToolTip = 'Finalize and prepare to print the document. The values and quantities are posted to the related accounts. A report request window where you can specify what to include on the print-out.';

                trigger OnAction()
                begin
                    Rec.TestField(Posted, false);
                    PostReturnPrint();
                    Rec.Posted := true;
                    Rec.Modify();
                end;
            }
        }
    }

    var
        DocumentApprovalWorkflow: Codeunit "Document Approval Workflow";
        StoreReturnHeader: Record "Store Return Header";
        RecID: RecordID;
        Text001: Label 'The document is already approved!';

    local procedure TestReport()
    begin
        // Placeholder for test report logic
    end;

    local procedure PostReturn()
    begin
        // Placeholder for posting logic
    end;

    local procedure PostReturnPrint()
    begin
        PostReturn();
        // Placeholder for print logic
    end;
}

