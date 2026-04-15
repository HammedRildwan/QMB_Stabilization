// ------------------------------------------------------------------------------------------------
// My Pending Approvals Part
// ListPart showing current user's pending approval requests
// Shared across multiple Role Centers
// ------------------------------------------------------------------------------------------------
page 53219 "QMB Stab. My Approvals Part"
{
    Caption = 'My Pending Approvals';
    PageType = ListPart;

    SourceTable = "Document Approval Entry";
    SourceTableView = sorting("Sequence") order(descending) where(Status = const(Pending), Open = const(true));
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(ApprovalList)
            {

                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'The document number awaiting approval.';

                    trigger OnDrillDown()
                    begin
                        ShowDocument();
                    end;
                }
                field("Document Date"; Rec."Document Date")
                {
                    ApplicationArea = All;
                    Caption = 'Document Date';
                    ToolTip = 'The date of the document awaiting approval.';
                }
                field("Document Description"; Rec."Document Description")
                {
                    ApplicationArea = All;
                    Caption = 'Description';
                    ToolTip = 'The description of the document awaiting approval.';
                }
                field("Document Amount"; Rec."Document Amount")
                {
                    ApplicationArea = All;
                    Caption = 'Amount';
                    ToolTip = 'The amount of the document awaiting approval.';
                }
                field("Requested By"; Rec.Sender)
                {
                    ApplicationArea = All;
                    ToolTip = 'The user who submitted the approval request.';
                }
                field("Request Date"; DT2Date(Rec."Send for Approval DateTime"))
                {
                    ApplicationArea = All;
                    Caption = 'Request Date';
                    ToolTip = 'The date the approval was requested.';
                }
                field("Due Date"; DT2Date(Rec."Send for Approval DateTime"))
                {
                    ApplicationArea = All;
                    ToolTip = 'The date by which the approval should be completed.';
                    Style = Attention;
                    StyleExpr = OverdueStyle;
                }

            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(Approve)
            {
                ApplicationArea = All;
                Caption = 'Approve';
                Image = Approve;
                ToolTip = 'Approve the selected request.';

                trigger OnAction()
                var
                    ApprovalMgt: Codeunit "Document Approval Workflow";
                    ApprovalEntry: Record "Document Approval Entry";
                begin
                    ApprovalEntry := Rec;
                    //ApprovalMgt.ApproveDocument(ApprovalEntry);
                    CurrPage.Update(false);
                end;
            }
            action(Reject)
            {
                ApplicationArea = All;
                Caption = 'Reject';
                Image = Reject;
                ToolTip = 'Reject the selected request.';

                trigger OnAction()
                var
                    ApprovalEntry: Record "Document Approval Entry";
                    ApprovalMgt: Codeunit "Document Approval Workflow";
                begin
                    ApprovalEntry := Rec;
                    //ApprovalMgt.RejectDocument(ApprovalEntry);
                    CurrPage.Update(false);
                end;
            }
            action(ViewDocument)
            {
                ApplicationArea = All;
                Caption = 'View Document';
                Image = Document;
                ToolTip = 'Open the document awaiting approval.';

                trigger OnAction()
                begin
                    ShowDocument();
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.SetRange(Approver, UserId);
        Rec.SetRange(Open, true);
    end;

    trigger OnAfterGetRecord()
    begin
        OverdueStyle := (Rec."Send for Approval DateTime" <> 0DT) and (DT2Date(Rec."Send for Approval DateTime") < Today);
    end;

    var
        OverdueStyle: Boolean;

    local procedure ShowDocument()
    var
        ExpenseRequestHeader: Record "Expense Request Header";
        StoreRequisitionHeader: Record "Store Requisition Header";
        StoreReturnHeader: Record "Store Return Header";
    begin
        // Use Table No. to determine which entity to open
        case Rec."Table No." of
            Database::"Expense Request Header":
                if ExpenseRequestHeader.Get(Rec."Document No.") then
                    Page.Run(Page::"Expense Card", ExpenseRequestHeader);
            Database::"Store Requisition Header":
                if StoreRequisitionHeader.Get(Rec."Document No.") then
                    Page.Run(Page::"Store Requisition Card", StoreRequisitionHeader);
            Database::"Store Return Header":
                if StoreReturnHeader.Get(Rec."Document No.") then
                    Page.Run(Page::"Store Return Card", StoreReturnHeader);
            else
                Message('Unknown document type (Table No. %1). Please contact your administrator.', Rec."Table No.");
        end;
    end;
}
