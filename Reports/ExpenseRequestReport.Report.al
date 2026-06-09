// ------------------------------------------------------------------------------------------------
// Expense Request Report
// Lists expense requests with line details, totals, and status information
// ------------------------------------------------------------------------------------------------
report 53500 "Expense Request Report"
{
    Caption = 'Expense Request Report';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    RDLCLayout = 'Layouts/ExpenseRequestReport.rdlc';

    dataset
    {
        dataitem(ExpenseRequestHeader; "Expense Request Header")
        {
            RequestFilterFields = "No.", Date, Requester, Status, "Expense Type";
            PrintOnlyIfDetail = false;

            column(No_; "No.") { }
            column(Date; Date) { }
            column(Requester; Requester) { }
            column(Status; Status) { }
            column(ExpenseType; "Expense Type") { }
            column(PaymentOption; "Payment Option") { }
            column(BankName; "Bank Name") { }
            column(BankNo; "Bank No.") { }
            column(ChequeNo; "Cheque No.") { }
            column(Payee; Payee) { }
            column(PayeeAccountName; "Payee Account Name") { }
            column(PayeeAccountNumber; "Payee Account Number") { }
            column(PayeeBankName; "Payee Bank Name") { }
            column(Purpose; Purpose) { }
            column(TotalLineAmount; "Total Line Amount") { }
            column(Posted; Posted) { }
            column(NotPaid; "Not Paid") { }
            column(ExternalDocumentNo; "External Document No.") { }
            column(ShortcutDimension1Code; "Shortcut Dimension 1 Code") { }
            column(ShortcutDimension2Code; "Shortcut Dimension 2 Code") { }
            column(ShortcutDimension3Code; "Shortcut Dimension 3 Code") { }
            column(LastModifiedBy; "Last Modified By") { }
            column(LastModifiedDateTime; "Last Modified DateTime") { }
            column(CompanyName; CompanyName) { }
            column(ReportTitle; ReportTitleLbl) { }
            column(PrintDate; Format(Today, 0, '<Day,2>/<Month,2>/<Year4>')) { }

            dataitem(ExpenseRequestLine; "Expense Request Line")
            {
                DataItemLink = "Document No." = field("No.");
                DataItemTableView = sorting("Document No.", "Line No.");

                column(LineNo; "Line No.") { }
                column(LineExpenseType; "Expense Type") { }
                column(LinePayeeCode; "Payee Code") { }
                column(LinePayeeName; "Payee Name") { }
                column(ExpenseDescription; "Expense Description") { }
                column(ExpenseAccountNo; "Expense Account No.") { }
                column(AccountName; "Account Name") { }
                column(ApprovedDocumentNo; "Approved Document No.") { }
                column(MaintenanceCode; "Maintenance Code") { }
                column(AssetNo; "Asset No.") { }
                column(Amount; Amount) { }
                column(AmountLCY; "Amount (LCY)") { }
                column(CurrencyCode; "Currency Code") { }
                column(WHTAmount; "WHT Amount") { }
                column(LineRemark; Remark) { }
                column(BudgetedAmount; "Budgeted Amount") { }
                column(BudgetBalance; "Budget Balance") { }
            }

            dataitem(DocumentApprovalEntry; "Document Approval Entry")
            {
                DataItemLink = "Document No." = field("No.");
                DataItemTableView = sorting(Sequence) where("Table No." = const(53001));

                column(ApprovalSequence; Sequence) { }
                column(ApprovalRequester; Sender) { }
                column(ApprovalApprover; Approver) { }
                column(ApprovalStatus; Format(Status)) { }
                column(ApprovalDocumentDate; "Document Date") { }
                column(ApprovalDocumentAmount; "Document Amount") { }
                column(ApprovalStatusChangeDateTime; "Status Change DateTime") { }
            }
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(Content)
            {
                group(Options)
                {
                    Caption = 'Options';

                    field(ShowDetails; ShowDetails)
                    {
                        ApplicationArea = All;
                        Caption = 'Show Line Details';
                        ToolTip = 'Select to show expense line details.';
                    }
                }
            }
        }
    }

    var
        ShowDetails: Boolean;
        ReportTitleLbl: Label 'Expense Request Report';
}
