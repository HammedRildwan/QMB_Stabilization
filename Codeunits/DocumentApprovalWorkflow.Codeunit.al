codeunit 53400 "Document Approval Workflow"
{

    trigger OnRun()
    begin
    end;

    var
        DocWorkflowHeader: Record 53010;
        DocWorkflowLine: Record 53011;
        DocumentApprovalEntry: Record 53012;
        Text001: Label 'Approval request has been sent.';
        Text002: Label 'The approval cannot be cancelled because it has been treated by your approver.';
        Text003: Label 'Please hold on. This document requires a prior approval.';
        DocumentApprovalEntry2: Record 53012;
        UserSetup: Record 91;
        Text004: Label 'This document has been approved.';
        Text005: Label 'The document has been rejected.';
        UserSetup2: Record 91;
        SMTPMail: Codeunit "Mail Management";
        Text006: Label 'Dear ';
        Text007: Label '%1 requires your approval.';
        Recipient: Text[30];
        NextApprover: Code[30];
        Originator: Code[30];
        Subject: Text[100];
        Body: Text[250];
        Text008: Label '%1 requires your approval. Please click on the link below to approve or reject the document.';
        Text009: Label 'This is a system generated mail.';
        Text010: Label '%1 has been approved.';
        Text011: Label 'Please note that transaction %1 has been approved.';
        Text012: Label '%1 has been rejected.';
        Text013: Label 'Please note that transaction %1 has been rejected.';
        WebLink: Text;
        Text014: Label 'You are not eligible to approve yet as the preceeding officer is yet to approve.';
        SeqNo: Integer;

    procedure SendApprovalRequest(TableID: Integer; DocNo: Code[10]; RecID: RecordID; Limit: Decimal; DocDate: Date; DocAmount: Decimal; DocDesc: Text)
    begin
        //create approval entries
        DocumentApprovalEntry.Sequence := 0;
        DocWorkflowHeader.SETRANGE("User ID", USERID);
        DocWorkflowHeader.SETRANGE("Table No.", TableID);
        DocWorkflowHeader.SETFILTER("Approval Limit", '>=%1', Limit);
        IF DocWorkflowHeader.FINDFIRST THEN;
        DocWorkflowLine.SETRANGE("Sender User ID", DocWorkflowHeader."User ID");
        DocWorkflowLine.SETRANGE("Table No.", DocWorkflowHeader."Table No.");
        DocWorkflowLine.SETRANGE("Approval Limit", DocWorkflowHeader."Approval Limit");

        IF DocWorkflowLine.FINDFIRST THEN BEGIN
            REPEAT
                DocumentApprovalEntry.INIT;
                DocumentApprovalEntry.Sequence += 1;
                DocumentApprovalEntry."Table No." := DocWorkflowHeader."Table No.";
                DocumentApprovalEntry."Document No." := DocNo;
                DocumentApprovalEntry."Record ID to Approve" := RecID;
                DocumentApprovalEntry.Sender := DocWorkflowHeader."User ID";
                DocumentApprovalEntry.VALIDATE(Approver, DocWorkflowLine.Approver);
                DocumentApprovalEntry."Document Date" := DocDate;
                DocumentApprovalEntry."Document Amount" := DocAmount;
                DocumentApprovalEntry."Document Description" := COPYSTR(DocDesc, 1, 150);
                DocumentApprovalEntry.INSERT;
            UNTIL DocWorkflowLine.NEXT = 0;
        END;

        //make first approval entry visible for approval and send email to approver
        DocumentApprovalEntry.RESET;
        DocumentApprovalEntry.SETCURRENTKEY(Sequence, "Document No.");
        DocumentApprovalEntry.SETRANGE(Sequence, 1);
        DocumentApprovalEntry.SETRANGE("Document No.", DocNo);
        IF DocumentApprovalEntry.FINDFIRST THEN BEGIN
            Recipient := DocumentApprovalEntry.Approver;
            DocumentApprovalEntry.Open := TRUE;
            DocumentApprovalEntry."Send for Approval DateTime" := CURRENTDATETIME;
            DocumentApprovalEntry.MODIFY;
            UserSetup.GET(USERID);
            UserSetup2.GET(Recipient);
            SendMailApprover(Text007, DocumentApprovalEntry."Record ID to Approve", UserSetup."User ID", UserSetup."E-Mail", UserSetup2."E-Mail", UserSetup2."User ID", Text008);
        END;
    end;

    procedure CancelApprovalRequest(TableID: Integer; DocNo: Code[10])
    begin
        DocumentApprovalEntry.RESET;
        DocumentApprovalEntry.SETCURRENTKEY(Sequence, "Document No.");
        DocumentApprovalEntry.SETRANGE("Document No.", DocNo);
        IF DocumentApprovalEntry.FINDFIRST THEN
            IF DocumentApprovalEntry.Status = DocumentApprovalEntry.Status::" " THEN
                DocumentApprovalEntry.DELETEALL;
        IF DocumentApprovalEntry.Status <> DocumentApprovalEntry.Status::" " THEN
            ERROR(Text002);
    end;

    procedure ApproveDocument(TableID: Integer; DocNo: Code[10]; RecID: RecordID)
    var
        Seq: Integer;
    begin
        //approve document
        DocumentApprovalEntry.RESET;
        DocumentApprovalEntry.SETCURRENTKEY("Document No.", Status, Approver);
        DocumentApprovalEntry.SETRANGE("Document No.", DocNo);
        DocumentApprovalEntry.SETRANGE(Approver, USERID);
        IF DocumentApprovalEntry.FINDFIRST THEN BEGIN
            Originator := DocumentApprovalEntry.Sender;
            DocumentApprovalEntry.Status := DocumentApprovalEntry.Status::Approved;
            DocumentApprovalEntry."Status Change DateTime" := CURRENTDATETIME;
            DocumentApprovalEntry.MODIFY;
            MESSAGE(Text004);
        END;

        //make next approval entry visible for approval and send email to next approver
        DocumentApprovalEntry.RESET;
        DocumentApprovalEntry.SETCURRENTKEY(Sequence, "Document No.");
        DocumentApprovalEntry.SETRANGE("Document No.", DocNo);
        DocumentApprovalEntry.SETRANGE(Open, FALSE);
        IF DocumentApprovalEntry.FINDFIRST THEN BEGIN
            NextApprover := DocumentApprovalEntry.Approver;
            DocumentApprovalEntry.Open := TRUE;
            DocumentApprovalEntry.MODIFY;
            UserSetup.GET(USERID);
            UserSetup2.GET(NextApprover);
            SendMailApprover(Text007, DocumentApprovalEntry."Record ID to Approve", UserSetup."User ID", UserSetup."E-Mail", UserSetup2."E-Mail", UserSetup2."User ID", Text008);
        END ELSE BEGIN
            //notify originator
            UserSetup.GET(USERID);
            UserSetup2.GET(Originator);
            SendMailOriginator(Text010, DocumentApprovalEntry."Record ID to Approve", UserSetup."User ID", UserSetup."E-Mail", UserSetup2."E-Mail", UserSetup2."User ID", Text011);
        END;
    end;

    procedure RejectDocument(DocNo: Code[10])
    var
        Seq: Integer;
    begin
        DocumentApprovalEntry.RESET;
        DocumentApprovalEntry.SETCURRENTKEY("Document No.", Status, Approver);
        DocumentApprovalEntry.SETRANGE("Document No.", DocNo);
        DocumentApprovalEntry.SETRANGE(Approver, USERID);
        IF DocumentApprovalEntry.FINDFIRST THEN BEGIN
            Originator := DocumentApprovalEntry.Sender;
            DocumentApprovalEntry.Status := DocumentApprovalEntry.Status::Rejected;
            DocumentApprovalEntry."Status Change DateTime" := CURRENTDATETIME;
            DocumentApprovalEntry.MODIFY;
            MESSAGE(Text005);
            UserSetup.GET(USERID);
            UserSetup2.GET(Originator);
            SendMailOriginator(Text012, DocumentApprovalEntry."Record ID to Approve", UserSetup."User ID", UserSetup."E-Mail", UserSetup2."E-Mail", UserSetup2."User ID", Text013);
        END;
    end;

    local procedure SendMailApprover(SubjectText: Text[100]; RecID: RecordID; SenderName: Text[100]; SenderAddress: Text[100]; RecepientAddress: Text[100]; RecipientName: Text[100]; BodyText: Text)
    var
        Recipients: List of [Text];
    begin
        Subject := STRSUBSTNO(SubjectText, RecID);
        Recipients.Add(RecepientAddress);
        /*
    SMTPMail.CreateMessage(SenderName, SenderAddress, Recipients, Subject, '', TRUE);
    SMTPMail.AppendBody(FORMAT(STRSUBSTNO(Text006 + RecipientName + ',')));
    SMTPMail.AppendBody('<br><br>');
    SMTPMail.AppendBody(FORMAT(STRSUBSTNO(BodyText, RecID)));
    SMTPMail.AppendBody('<br><br>');
    SMTPMail.AppendBody(GETURL(CLIENTTYPE::Web, COMPANYNAME, OBJECTTYPE::Page, PAGE::"Document Approval Entries", DocumentApprovalEntry, TRUE));
    SMTPMail.AppendBody('<br><br>');
    SMTPMail.AppendBody('Regards');
    SMTPMail.AppendBody('<br><br>');
    SMTPMail.AppendBody(SenderName);
    SMTPMail.AppendBody('<HR>');
    SMTPMail.AppendBody(FORMAT(STRSUBSTNO(Text009)));
    SMTPMail.Send; */
    end;

    local procedure SendMailOriginator(SubjectText: Text[100]; RecID: RecordID; SenderName: Text[100]; SenderAddress: Text[100]; RecepientAddress: Text[100]; RecipientName: Text[100]; BodyText: Text)
    var
        Recipients: List of [Text];
    begin
        Subject := STRSUBSTNO(SubjectText, RecID);
        Recipients.Add(RecepientAddress);
        /*
        SMTPMail.CreateMessage(SenderName, SenderAddress, Recipients, Subject, '', TRUE);
        SMTPMail.AppendBody(FORMAT(STRSUBSTNO(Text006 + RecipientName + ',')));
        SMTPMail.AppendBody('<br><br>');
        SMTPMail.AppendBody(FORMAT(STRSUBSTNO(BodyText, RecID)));
        SMTPMail.AppendBody('<br><br>');
        SMTPMail.AppendBody('Regards');
        SMTPMail.AppendBody('<br><br>');
        SMTPMail.AppendBody(FORMAT(STRSUBSTNO(SenderName)));
        SMTPMail.AppendBody('<HR>');
        SMTPMail.AppendBody(FORMAT(STRSUBSTNO(Text009)));
        SMTPMail.Send; */
    end;

    procedure ApprovalStatusCheck(TableID: Integer; DocNo: Code[10]; RecID: RecordID): Boolean
    var
        Seq: Integer;
    begin
        DocumentApprovalEntry.RESET;
        DocumentApprovalEntry.SETCURRENTKEY("Document No.", Status, Approver);
        DocumentApprovalEntry.SETRANGE("Document No.", DocNo);
        DocumentApprovalEntry.SETFILTER(Status, '<>%1', DocumentApprovalEntry.Status::Approved);
        IF NOT DocumentApprovalEntry.FINDFIRST THEN
            EXIT(TRUE);
    end;
}

