// ------------------------------------------------------------------------------------------------
// Expense Request Report
// Lists expense requests with line details, totals, and status information
// ------------------------------------------------------------------------------------------------
report 70700 "Expense Request Report"
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
            column(ChequeNo; "Cheque No.") { }
            column(Payee; Payee) { }
            column(Purpose; Purpose) { }
            column(TotalLineAmount; "Total Line Amount") { }
            column(Posted; Posted) { }
            column(ExternalDocumentNo; "External Document No.") { }
            column(ShortcutDimension1Code; "Shortcut Dimension 1 Code") { }
            column(ShortcutDimension2Code; "Shortcut Dimension 2 Code") { }
            column(CompanyName; CompanyName) { }
            column(ReportTitle; ReportTitleLbl) { }
            column(PrintDate; Format(Today, 0, '<Day,2>/<Month,2>/<Year4>')) { }

            dataitem(ExpenseRequestLine; "Expense Request Line")
            {
                DataItemLink = "Document No." = field("No.");
                DataItemTableView = sorting("Document No.", "Line No.");

                column(LineNo; "Line No.") { }
                column(ExpenseDescription; "Expense Description") { }
                column(ExpenseAccountNo; "Expense Account No.") { }
                column(AccountName; "Account Name") { }
                column(Amount; Amount) { }
                column(AmountLCY; "Amount (LCY)") { }
                column(CurrencyCode; "Currency Code") { }
                column(BudgetedAmount; "Budgeted Amount") { }
                column(BudgetBalance; "Budget Balance") { }
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
