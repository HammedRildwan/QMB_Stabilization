page 70034 "Store Requisition Card"
{
    PageType = Card;
    SourceTable = "Store Requisition Header";

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
                field("Request Date"; Rec."Request Date")
                {
                    ApplicationArea = All;
                }
                field(Requester; Rec.Requester)
                {
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    ApplicationArea = All;
                    Importance = Additional;
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = All;
                    Importance = Additional;

                    trigger OnValidate()
                    begin
                        if Rec."Shortcut Dimension 2 Code" <> xRec."Shortcut Dimension 2 Code" then begin
                            StoreRequisitionLine.SetFilter("Document No.", Rec."No.");
                            if StoreRequisitionLine.FindSet() then begin
                                repeat
                                    StoreRequisitionLine.Validate("Shortcut Dimension 2 Code", Rec."Shortcut Dimension 2 Code");
                                    StoreRequisitionLine.Modify();
                                until StoreRequisitionLine.Next() = 0;
                            end;
                        end;
                    end;
                }
                field("Store Location"; Rec."Store Location")
                {
                    ApplicationArea = All;
                }
                field("Request Type"; Rec."Request Type")
                {
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        MaintTypeEditable := false;
                        if (Rec."Request Type" = Rec."Request Type"::Maintenance) or (Rec."Request Type" = Rec."Request Type"::"Internal Consumption")
                           then begin
                            MaintTypeEditable := true;
                        end;

                    end;
                }
                field("Maintenance Type"; Rec."Maintenance Type")
                {
                    ApplicationArea = All;
                    Editable = MaintTypeEditable;

                    trigger OnValidate()
                    begin
                        WorkOrderEnabled := false;
                        if Rec."Maintenance Type" = Rec."Maintenance Type"::Vehicle then begin
                            WorkOrderEnabled := true;
                        end;
                    end;
                }
                field("Asset No."; Rec."Asset No.")
                {
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        if Rec."Maintenance Type" = Rec."Maintenance Type"::Vehicle then begin
                            if Rec."Asset No." <> xRec."Asset No." then begin
                                StoreRequisitionLine.SetFilter("Document No.", Rec."No.");
                                if StoreRequisitionLine.FindSet() then begin
                                    repeat
                                        StoreRequisitionLine.Validate("Fixed Asset No.", Rec."Asset No.");
                                        StoreRequisitionLine.Modify();
                                    until StoreRequisitionLine.Next() = 0;
                                end;
                            end;
                        end;
                    end;
                }
                field(Justification; Rec.Justification)
                {
                    ApplicationArea = All;
                    MultiLine = true;
                    ShowMandatory = true;
                }
                field("Not Issued"; Rec."Not Issued")
                {
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
            }
            part(Lines; "Store Requistion Subform")
            {
                Caption = 'Request Lines';
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
                    // Ensure all required fields are captured
                    Rec.TestField("Store Location");
                    Rec.TestField(Justification);
                    Rec.TestField("Request Date");
                    Rec.TestField("Request Type");

                    if (Rec."Request Type" = Rec."Request Type"::Maintenance) and (Rec."Maintenance Type" = Rec."Maintenance Type"::Vehicle) then begin
                        Rec.TestField("Asset No.");
                    end;

                    if (Rec."Request Type" = Rec."Request Type"::Maintenance) and (Rec."Maintenance Type" = Rec."Maintenance Type"::"Other Assets") then
                        Rec.TestField("Asset No.");

                    StoreRequisitionLine.SetFilter("Document No.", Rec."No.");
                    if not StoreRequisitionLine.FindFirst() then
                        Error(Text005)
                    else begin
                        repeat
                            StoreRequisitionLine.TestField("Shortcut Dimension 2 Code");
                            StoreRequisitionLine.TestField("Shortcut Dimension 3 Code");
                            if Rec."Request Type" = Rec."Request Type"::Maintenance then
                                StoreRequisitionLine.TestField("Fixed Asset No.");
                            StoreRequisitionLine.TestField("Location Code");
                        until StoreRequisitionLine.Next() = 0;
                    end;

                    StoreRequisitionHeader.SetRange("No.", Rec."No.");
                    if StoreRequisitionHeader.FindFirst() then
                        RecID := StoreRequisitionHeader.RecordId;
                    DocumentApprovalWorkflow.SendApprovalRequest(RecID.TableNo, Rec."No.", RecID, 0, Rec."Request Date", 0, Rec.Justification);
                    Rec.Status := Rec.Status::"Pending Approval";
                    Rec.Modify();

                    Message('Document sent for Approval');
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

                    StoreRequisitionHeader.SetRange("No.", Rec."No.");
                    if StoreRequisitionHeader.FindFirst() then
                        RecID := StoreRequisitionHeader.RecordId;
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
                    if Rec.Status <> Rec.Status::"Pending Approval" then
                        Error('The document must be pending approval!');

                    StoreRequisitionLine.SetFilter("Document No.", Rec."No.");
                    if not StoreRequisitionLine.FindFirst() then
                        Error(Text005)
                    else begin
                        repeat
                            StoreRequisitionLine.TestField("Shortcut Dimension 2 Code");
                            StoreRequisitionLine.TestField("Shortcut Dimension 3 Code");
                            if Rec."Request Type" = Rec."Request Type"::Maintenance then
                                StoreRequisitionLine.TestField("Fixed Asset No.");
                            StoreRequisitionLine.TestField("Location Code");
                        until StoreRequisitionLine.Next() = 0;
                    end;

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
            action(Post)
            {
                ApplicationArea = All;
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
                    Rec.TestField(Posted, false);
                    if Rec.Status <> Rec.Status::Approved then
                        Error('You cannot post the document without approval')
                    else
                        PostIssue();
                end;
            }
            action("Post and &Print")
            {
                ApplicationArea = All;
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
                    Rec.TestField(Posted, false);
                    if Rec.Status <> Rec.Status::Approved then
                        Error('You cannot post the document without approval')
                    else
                        PostIssuePrint();
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        WorkOrderEnabled := false;
        if Rec."Maintenance Type" = Rec."Maintenance Type"::Vehicle then
            WorkOrderEnabled := true;

        if Rec.Posted then
            CurrPage.Editable := false;
    end;

    trigger OnOpenPage()
    begin
        WorkOrderEnabled := false;
        if Rec."Maintenance Type" = Rec."Maintenance Type"::Vehicle then
            WorkOrderEnabled := true;

        if Rec.Posted then
            CurrPage.Editable := false;
    end;

    var
        DocumentApprovalWorkflow: Codeunit "Document Approval Workflow";
        StoreRequisitionHeader: Record "Store Requisition Header";
        RecID: RecordID;
        StoreRequisitionLine: Record "Store Requisition Line";
        Text001: Label 'The document is already approved!';
        Text005: Label 'Your requisition must have at least one line!';
        WorkOrderEnabled: Boolean;
        MaintTypeEditable: Boolean;
        RefVendEditable: Boolean;

    local procedure PostIssue()
    begin
        // Placeholder for posting logic
        Rec.Posted := true;
        Rec."Posted DateTime" := CurrentDateTime;
        Rec."Posted By" := UserId;
        Rec.Modify();
    end;

    local procedure PostIssuePrint()
    begin
        PostIssue();
        // Placeholder for print logic
    end;
}

