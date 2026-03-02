page 70121 "Expense Card"
{
    DeleteAllowed = false;
    PageType = Card;
    SourceTable = 60056;
    SourceTableView = WHERE(Posted = CONST(false));

    layout
    {
        area(content)
        {
            group(General)
            {
                field("No."; rec."No.")
                {
                    Editable = false;
                }
                field(Date; rec.Date)
                {
                }
                field(Requester; rec.Requester)
                {
                }
                field("Expense Type"; rec."Expense Type")
                {
                }
                field("Trip No"; rec."Trip No")
                {
                }
                field("Maintenance Work Order"; rec."Maintenance Work Order")
                {
                }
                field(Status; rec.Status)
                {
                }
                field(Purpose; rec.Purpose)
                {
                }
                field("Total Line Amount"; rec."Total Line Amount")
                {
                }
                field(Payee; rec.Payee)
                {
                }
                field(Posted; rec.Posted)
                {
                    Editable = false;
                }
                field("Payment Option"; rec."Payment Option")
                {
                }
                field("Bank No."; rec."Bank No.")
                {
                }
                field("Bank Name"; rec."Bank Name")
                {
                }
                field("Cheque No."; rec."Cheque No.")
                {
                }
                field("Shortcut Dimension 1 Code"; rec."Shortcut Dimension 1 Code")
                {
                    Editable = true;
                    ShowMandatory = true;
                }
                field("Shortcut Dimension 2 Code"; rec."Shortcut Dimension 2 Code")
                {
                    Editable = true;
                    ShowMandatory = true;
                }
                field("Shortcut Dimension 3 Code"; rec."Shortcut Dimension 3 Code")
                {
                }
                field("Truck Code"; rec."Truck Code")
                {
                }
                field("Last Modified DateTime"; rec."Last Modified DateTime")
                {
                    Editable = false;
                }
                field("Last Modified By"; rec."Last Modified By")
                {
                    Editable = false;
                }
                field("Not Paid"; rec."Not Paid")
                {
                }
                field("BU Head Approval"; rec."BU Head Approval")
                {
                    Editable = true;
                    Visible = true;
                }
                field("JM Approval"; rec."JM Approval")
                {
                    Editable = false;
                }
            }
            part(Lines; 70122)
            {
                Caption = 'Lines';
                SubPageLink = "Document No." = FIELD("No.");
            }
        }
        area(factboxes)
        {
            part(Approvals; 70194)
            {
                Caption = 'Approvals';
                SubPageLink = "Document No." = FIELD("No.");
            }
            systempart(Links; Links)
            {
            }
            systempart(Notes; Notes)
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
                    TESTFIELD(rec.Purpose);
                    TESTFIELD(rec.Date);
                    TESTFIELD(rec.Payee);
                    TESTFIELD(rec."Expense Type");
                    CALCFIELDS(rec."Total Line Amount");
                    IF rec."Total Line Amount" = 0 THEN
                        ERROR('Line Amount must have value!');

                    IF rec.Status = rec.Status::Approved THEN
                        ERROR('The document is already approved!');
                    CALCFIELDS(rec."Total Line Amount");
                    ExpenseRequestHeader.SETRANGE("No.", rec."No.");
                    IF ExpenseRequestHeader.FINDFIRST THEN
                        RecID := ExpenseRequestHeader.RECORDID;
                    DocumentApprovalWorkflow.SendApprovalRequest(RecID.TABLENO, rec."No.", RecID, rec."Total Line Amount", rec.Date, rec."Total Line Amount", STRSUBSTNO('Expense Approval Requisition for %1', rec.Payee));
                    rec.Status := rec.Status::"Pending Approval";
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
                        ERROR('The document is already approved!');

                    ExpenseRequestHeader.SETRANGE("No.", rec."No.");
                    IF ExpenseRequestHeader.FINDFIRST THEN
                        RecID := ExpenseRequestHeader.RECORDID;
                    DocumentApprovalWorkflow.CancelApprovalRequest(RecID.TABLENO, rec."No.");
                    rec.Status := rec.Status::" ";
                    rec.MODIFY;
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
                    ApprovalsMgmt: Codeunit 1535;
                begin
                    rec.TESTFIELD(Purpose);
                    rec.TESTFIELD(Payee);
                    rec.TESTFIELD("Shortcut Dimension 1 Code");
                    rec.TESTFIELD("Shortcut Dimension 2 Code");
                    rec.CALCFIELDS("Total Line Amount");
                    IF rec."Total Line Amount" = 0 THEN
                        ERROR('Line Amount must have value!');

                    IF rec.Status = rec.Status::Approved THEN
                        ERROR('The document is already approved!');

                    DocumentApprovalWorkflow.ApproveDocument(RecID.TABLENO, rec."No.", RecID);
                    IF DocumentApprovalWorkflow.ApprovalStatusCheck(RecID.TABLENO, rec."No.", RecID) THEN BEGIN
                        rec.Status := rec.Status::Approved;
                        rec.MODIFY;
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
                    IF rec.Status = rec.Status::Approved THEN
                        ERROR('The document is already approved!');

                    DocumentApprovalWorkflow.RejectDocument(rec."No.");
                    IF NOT DocumentApprovalWorkflow.ApprovalStatusCheck(RecID.TABLENO, rec."No.", RecID) THEN BEGIN
                        rec.Status := rec.Status::Rejected;
                        rec.MODIFY;
                    END;
                end;
            }
            action("Test Report")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Test Report';
                Ellipsis = true;
                Image = TestReport;
                ToolTip = 'View a test report so that you can find and correct any errors before you perform the actual posting of the journal or document.';
                Visible = false;

                trigger OnAction()
                begin
                    TestReport;
                end;
            }
            action(Preview)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Preview Posting';
                Image = ViewPostedOrder;
                ToolTip = 'Review the different types of entries that will be created when you post the document or journal.';

                trigger OnAction()
                var
                    GenJnlPost: Codeunit 231;
                begin
                    PreviewPosting;
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
                ShortCutKey = 'F9';
                ToolTip = 'Finalize the document or journal by posting the amounts and quantities to the related accounts in your company books.';

                trigger OnAction()
                begin
                    // IF Posted = TRUE
                    //  THEN ERROR('The document has already been posted');

                    IF NOT CONFIRM('Do you want to Post?', TRUE) THEN
                        CurrPage.CLOSE
                    ELSE BEGIN
                        PostExpense;
                        MESSAGE('Expense Posted');


                    END;
                end;
            }
            action("Post and Print")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Post and &Print';
                Image = PostPrint;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ShortCutKey = 'Shift+F9';
                ToolTip = 'Finalize and prepare to print the document or journal. The values and quantities are posted to the related accounts. A report request window where you can specify what to include on the print-out.';

                trigger OnAction()
                begin
                    // IF Posted = TRUE
                    //  THEN ERROR('The document has already been posted');
                    IF NOT CONFIRM('Do you want to Post?', TRUE) THEN
                        CurrPage.CLOSE
                    ELSE BEGIN
                        PostPrint;
                        MESSAGE('Expense Posted');

                    END;
                end;
            }
            action(PostMaint)
            {
                Caption = 'PostMaint';
                Visible = false;

                trigger OnAction()
                begin
                    PostMaintenanceOnIssue;
                end;
            }
        }
    }

    trigger OnModifyRecord(): Boolean
    begin
        // IF ((Status = Status::Approved) OR (Status = Status::"Pending Approval")) THEN BEGIN// AND ("Trip No" = '') THEN BEGIN
        //  UserSetup.GET(USERID);
        //  IF NOT UserSetup."Modify Expense requistion" THEN
        //    ERROR('You cannot modify this record');
        // END;
    end;

    trigger OnOpenPage()
    begin
        IF Posted THEN
            CurrPage.EDITABLE := FALSE
        ELSE
            CurrPage.EDITABLE := TRUE;

        /*IF Status = Status::Approved THEN
          ApprovedNotEditable := TRUE
        ELSE
          ApprovedNotEditable := FALSE;
        */

    end;

    var
        DocumentApprovalWorkflow: Codeunit 50000;
        ExpenseRequestHeader: Record 60056;
        ExpenseRequestLine: Record 60057;
        RecRef: RecordRef;
        RecID: RecordID;
        UserSetup: Record 91;
        ExpenseEditable: Boolean;
        ApprovedNotEditable: Boolean;
}

