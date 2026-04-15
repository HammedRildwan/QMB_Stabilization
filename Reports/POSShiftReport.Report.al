report 53511 "POS Shift Report"
{
    Caption = 'POS Shift Report';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/POSShiftReport.rdlc';

    dataset
    {
        dataitem(Shift; "POS Shift")
        {
            RequestFilterFields = "Shift No.", "Terminal ID", Status, "Business Section";

            column(ShiftNo; "Shift No.") { }
            column(TerminalID; "Terminal ID") { }
            column(UserID; "User ID") { }
            column(BusinessSection; "Business Section") { }
            column(Status; Status) { }
            column(OpeningDateTime; "Opening DateTime") { }
            column(ClosingDateTime; "Closing DateTime") { }
            column(OpeningFloat; "Opening Float") { }
            column(ExpectedCash; "Expected Cash") { }
            column(DeclaredCash; "Declared Cash") { }
            column(Variance; Variance) { }
            column(TotalSales; "Total Sales") { }
            column(TotalCashSales; "Total Cash Sales") { }
            column(TransactionCount; "Transaction Count") { }
            column(CompanyName; CompanyProperty.DisplayName()) { }
            column(ReportTitle; ReportTitleLbl) { }
            column(PrintDate; Format(Today, 0, '<Month Text,3> <Day,2>, <Year4>')) { }

            dataitem(Transactions; "POS Transaction Header")
            {
                DataItemLink = "Shift No." = field("Shift No.");
                DataItemTableView = sorting("Transaction No.") where(Status = filter(Posted | Voided));

                column(TransNo; "Transaction No.") { }
                column(TransDate; "Transaction Date") { }
                column(TransTime; "Transaction Time") { }
                column(TransCustomer; "Customer Name") { }
                column(TransTotal; "Total Amount") { }
                column(TransStatus; Status) { }
            }

            trigger OnAfterGetRecord()
            begin
                CalcFields("Total Sales", "Total Cash Sales", "Transaction Count");
            end;
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

                    field(ShowTransactions; ShowTransactions)
                    {
                        ApplicationArea = All;
                        Caption = 'Show Transactions';
                        ToolTip = 'Include transaction list for each shift.';
                    }
                }
            }
        }
    }

    labels
    {
        ShiftNoLabel = 'Shift No.';
        TerminalLabel = 'Terminal';
        CashierLabel = 'Cashier';
        OpenedLabel = 'Opened';
        ClosedLabel = 'Closed';
        FloatLabel = 'Opening Float';
        ExpectedLabel = 'Expected Cash';
        DeclaredLabel = 'Declared Cash';
        VarianceLabel = 'Variance';
        TotalSalesLabel = 'Total Sales';
        CashSalesLabel = 'Cash Sales';
        TransCountLabel = 'Transactions';
        SummaryLabel = 'Shift Summary';
        TransactionsLabel = 'Transactions';
    }

    var
        ShowTransactions: Boolean;
        ReportTitleLbl: Label 'POS Shift Report';
}
