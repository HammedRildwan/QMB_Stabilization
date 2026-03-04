codeunit 60080 "Month-End Closing Mgt."
{

    procedure ValidateTask(var ClosingLine: Record "Month-End Closing Line"; var Passed: Boolean; var Message: Text[250])
    var
        Header: Record "Month-End Closing Header";
    begin
        Passed := true;
        Message := 'Validation passed';

        Header.Get(ClosingLine."Document No.");

        case ClosingLine."Validation Type" of
            ClosingLine."Validation Type"::Manual:
                begin
                    Passed := true;
                    Message := 'Manual validation - marked complete by user';
                end;
            ClosingLine."Validation Type"::"No Open Expenses":
                ValidateNoOpenExpenses(Header, Passed, Message);
            ClosingLine."Validation Type"::"No Open Requisitions":
                ValidateNoOpenRequisitions(Header, Passed, Message);
            ClosingLine."Validation Type"::"No Pending Approvals":
                ValidateNoPendingApprovals(Header, Passed, Message);
            ClosingLine."Validation Type"::"Bank Reconciled":
                ValidateBankReconciled(Header, Passed, Message);
            ClosingLine."Validation Type"::"No Unposted Journals":
                ValidateNoUnpostedJournals(Passed, Message);
            ClosingLine."Validation Type"::"Inventory Adjusted":
                ValidateInventoryAdjusted(Passed, Message);
            ClosingLine."Validation Type"::"Trial Balance Balanced":
                ValidateTrialBalanceBalanced(Passed, Message);
            ClosingLine."Validation Type"::"Budget Reviewed":
                begin
                    Passed := true;
                    Message := 'Budget review is a manual process';
                end;
        end;
    end;

    local procedure ValidateNoOpenExpenses(Header: Record "Month-End Closing Header"; var Passed: Boolean; var Message: Text[250])
    var
        ExpenseHeader: Record "Expense Request Header";
        OpenCount: Integer;
    begin
        ExpenseHeader.SetFilter(Status, '%1|%2', ExpenseHeader.Status::" ", ExpenseHeader.Status::"Pending Approval");
        ExpenseHeader.SetFilter(Date, '<=%1', Header."Period End Date");
        OpenCount := ExpenseHeader.Count;

        if OpenCount > 0 then begin
            Passed := false;
            Message := StrSubstNo('Found %1 open/pending expense requests for period', OpenCount);
        end else begin
            Passed := true;
            Message := 'No open expense requests found';
        end;
    end;

    local procedure ValidateNoOpenRequisitions(Header: Record "Month-End Closing Header"; var Passed: Boolean; var Message: Text[250])
    var
        ReqHeader: Record "Store Requisition Header";
        OpenCount: Integer;
    begin
        ReqHeader.SetFilter(Status, '%1|%2', ReqHeader.Status::" ", ReqHeader.Status::"Pending Approval");
        ReqHeader.SetFilter("Request Date", '<=%1', Header."Period End Date");
        OpenCount := ReqHeader.Count;

        if OpenCount > 0 then begin
            Passed := false;
            Message := StrSubstNo('Found %1 open/pending store requisitions for period', OpenCount);
        end else begin
            Passed := true;
            Message := 'No open store requisitions found';
        end;
    end;

    local procedure ValidateNoPendingApprovals(Header: Record "Month-End Closing Header"; var Passed: Boolean; var Message: Text[250])
    var
        ApprovalEntry: Record "Document Approval Entry";
        PendingCount: Integer;
    begin
        ApprovalEntry.SetRange(Open, true);
        ApprovalEntry.SetFilter("Send for Approval DateTime", '<=%1', CreateDateTime(Header."Period End Date", 235959T));
        PendingCount := ApprovalEntry.Count;

        if PendingCount > 0 then begin
            Passed := false;
            Message := StrSubstNo('Found %1 pending approval entries for period', PendingCount);
        end else begin
            Passed := true;
            Message := 'No pending approvals found';
        end;
    end;

    local procedure ValidateBankReconciled(Header: Record "Month-End Closing Header"; var Passed: Boolean; var Message: Text[250])
    var
        BankAccRecon: Record "Bank Acc. Reconciliation";
        UnreconciledCount: Integer;
    begin
        BankAccRecon.SetRange("Statement Type", BankAccRecon."Statement Type"::"Bank Reconciliation");
        BankAccRecon.SetFilter("Statement Date", '>=%1&<=%2', Header."Period Start Date", Header."Period End Date");
        UnreconciledCount := BankAccRecon.Count;

        if UnreconciledCount > 0 then begin
            Passed := false;
            Message := StrSubstNo('Found %1 unposted bank reconciliations', UnreconciledCount);
        end else begin
            Passed := true;
            Message := 'All bank accounts reconciled';
        end;
    end;

    local procedure ValidateNoUnpostedJournals(var Passed: Boolean; var Message: Text[250])
    var
        GenJnlLine: Record "Gen. Journal Line";
        LineCount: Integer;
    begin
        GenJnlLine.SetFilter(Amount, '<>0');
        LineCount := GenJnlLine.Count;

        if LineCount > 0 then begin
            Passed := false;
            Message := StrSubstNo('Found %1 unposted journal lines', LineCount);
        end else begin
            Passed := true;
            Message := 'No unposted journal lines found';
        end;
    end;

    local procedure ValidateInventoryAdjusted(var Passed: Boolean; var Message: Text[250])
    var
        ItemJnlLine: Record "Item Journal Line";
        LineCount: Integer;
    begin
        ItemJnlLine.SetFilter(Quantity, '<>0');
        LineCount := ItemJnlLine.Count;

        if LineCount > 0 then begin
            Passed := false;
            Message := StrSubstNo('Found %1 unposted item journal lines', LineCount);
        end else begin
            Passed := true;
            Message := 'No pending inventory adjustments';
        end;
    end;

    local procedure ValidateTrialBalanceBalanced(var Passed: Boolean; var Message: Text[250])
    var
        GLEntry: Record "G/L Entry";
        TotalDebit: Decimal;
        TotalCredit: Decimal;
    begin
        GLEntry.CalcSums("Debit Amount", "Credit Amount");
        TotalDebit := GLEntry."Debit Amount";
        TotalCredit := GLEntry."Credit Amount";

        if Abs(TotalDebit - TotalCredit) > 0.01 then begin
            Passed := false;
            Message := StrSubstNo('Trial balance unbalanced by %1', TotalDebit - TotalCredit);
        end else begin
            Passed := true;
            Message := 'Trial balance is balanced';
        end;
    end;

    procedure RunAllValidations(var Header: Record "Month-End Closing Header")
    var
        ClosingLine: Record "Month-End Closing Line";
        Passed: Boolean;
        ValidationMsg: Text[250];
        CompletedCount: Integer;
    begin
        ClosingLine.SetRange("Document No.", Header."No.");
        ClosingLine.SetRange("Auto-Validate", true);
        ClosingLine.SetFilter(Status, '<>%1', ClosingLine.Status::Completed);

        if ClosingLine.FindSet() then
            repeat
                ValidateTask(ClosingLine, Passed, ValidationMsg);
                ClosingLine."Validation Result" := ValidationMsg;
                if Passed then begin
                    ClosingLine.Status := ClosingLine.Status::Completed;
                    ClosingLine."Completed Date" := WorkDate();
                    ClosingLine."Completed By" := CopyStr(UserId, 1, 50);
                    CompletedCount += 1;
                end else
                    ClosingLine."Issue Found" := true;
                ClosingLine.Modify();
            until ClosingLine.Next() = 0;

        Message(StrSubstNo('Auto-validation complete. %1 tasks passed.', CompletedCount));
    end;

    procedure CreateDefaultTemplates()
    var
        SeqNo: Integer;
    begin
        SeqNo := 10;

        // Pre-Closing Tasks
        InsertTemplate('PRE-001', 'Review open documents for the period', "Closing Task Category"::"Pre-Closing", SeqNo, false, "Closing Validation Type"::Manual, true, Page::"Document Approval Entries", 0);
        SeqNo += 10;
        InsertTemplate('PRE-002', 'Process all pending expense requests', "Closing Task Category"::"Pre-Closing", SeqNo, true, "Closing Validation Type"::"No Open Expenses", true, Page::"Expense List", 0);
        SeqNo += 10;
        InsertTemplate('PRE-003', 'Process all pending store requisitions', "Closing Task Category"::"Pre-Closing", SeqNo, true, "Closing Validation Type"::"No Open Requisitions", true, Page::"Store Requisition List", 0);
        SeqNo += 10;
        InsertTemplate('PRE-004', 'Complete all pending approvals', "Closing Task Category"::"Pre-Closing", SeqNo, true, "Closing Validation Type"::"No Pending Approvals", true, Page::"Document Approval Entries", 0);
        SeqNo += 10;

        // Bank Reconciliation
        InsertTemplate('BANK-001', 'Reconcile all bank accounts', "Closing Task Category"::"Bank Reconciliation", SeqNo, true, "Closing Validation Type"::"Bank Reconciled", true, Page::"Bank Acc. Reconciliation List", 0);
        SeqNo += 10;
        InsertTemplate('BANK-002', 'Post bank reconciliations', "Closing Task Category"::"Bank Reconciliation", SeqNo, false, "Closing Validation Type"::Manual, true, 0, 0);
        SeqNo += 10;

        // Expense Processing
        InsertTemplate('EXP-001', 'Review expense postings to G/L', "Closing Task Category"::"Expense Processing", SeqNo, false, "Closing Validation Type"::Manual, false, Page::"General Ledger Entries", 0);
        SeqNo += 10;

        // Inventory
        InsertTemplate('INV-001', 'Post inventory adjustments', "Closing Task Category"::Inventory, SeqNo, true, "Closing Validation Type"::"Inventory Adjusted", false, Page::"Item Journal", 0);
        SeqNo += 10;
        InsertTemplate('INV-002', 'Run inventory valuation report', "Closing Task Category"::Inventory, SeqNo, false, "Closing Validation Type"::Manual, false, 0, Report::"Inventory Valuation");
        SeqNo += 10;

        // Accruals
        InsertTemplate('ACC-001', 'Review and post accruals', "Closing Task Category"::"Accruals & Deferrals", SeqNo, false, "Closing Validation Type"::Manual, false, Page::"General Journal", 0);
        SeqNo += 10;
        InsertTemplate('ACC-002', 'Review and post deferrals', "Closing Task Category"::"Accruals & Deferrals", SeqNo, false, "Closing Validation Type"::Manual, false, Page::"General Journal", 0);
        SeqNo += 10;

        // Journals
        InsertTemplate('JNL-001', 'Post all general journal entries', "Closing Task Category"::"Pre-Closing", SeqNo, true, "Closing Validation Type"::"No Unposted Journals", true, Page::"General Journal", 0);
        SeqNo += 10;

        // Reporting
        InsertTemplate('RPT-001', 'Print Trial Balance', "Closing Task Category"::Reporting, SeqNo, false, "Closing Validation Type"::Manual, false, 0, Report::"Trial Balance");
        SeqNo += 10;
        InsertTemplate('RPT-002', 'Verify Trial Balance is balanced', "Closing Task Category"::Reporting, SeqNo, true, "Closing Validation Type"::"Trial Balance Balanced", true, 0, Report::"Trial Balance");
        SeqNo += 10;
        InsertTemplate('RPT-003', 'Print Income Statement', "Closing Task Category"::Reporting, SeqNo, false, "Closing Validation Type"::Manual, false, 0, Report::"Income Statement");
        SeqNo += 10;
        InsertTemplate('RPT-004', 'Print Balance Sheet', "Closing Task Category"::Reporting, SeqNo, false, "Closing Validation Type"::Manual, false, 0, Report::"Balance Sheet");
        SeqNo += 10;
        InsertTemplate('RPT-005', 'Review Budget vs. Actual', "Closing Task Category"::Reporting, SeqNo, false, "Closing Validation Type"::"Budget Reviewed", false, Page::Budget, Report::Budget);
        SeqNo += 10;

        // Final Review
        InsertTemplate('FIN-001', 'Finance Manager final review', "Closing Task Category"::"Final Review", SeqNo, false, "Closing Validation Type"::Manual, true, 0, 0);
        SeqNo += 10;
        InsertTemplate('FIN-002', 'Sign-off and close period', "Closing Task Category"::"Final Review", SeqNo, false, "Closing Validation Type"::Manual, true, Page::"Accounting Periods", 0);

        Message('Default month-end checklist templates created successfully.');
    end;

    local procedure InsertTemplate(Code: Code[20]; Desc: Text[100]; Category: Enum "Closing Task Category"; SeqNo: Integer; AutoValidate: Boolean; ValidationType: Enum "Closing Validation Type"; Blocking: Boolean; PageID: Integer; ReportID: Integer)
    var
        Template: Record "Month-End Checklist Template";
    begin
        if Template.Get(Code) then
            exit;

        Template.Init();
        Template.Code := Code;
        Template.Description := Desc;
        Template.Category := Category;
        Template."Sequence No." := SeqNo;
        Template."Auto-Validate" := AutoValidate;
        Template."Validation Type" := ValidationType;
        Template.Blocking := Blocking;
        Template."Related Page ID" := PageID;
        Template."Related Report ID" := ReportID;
        Template.Active := true;
        Template."Est. Duration (Minutes)" := 15;
        Template.Insert();
    end;
}
