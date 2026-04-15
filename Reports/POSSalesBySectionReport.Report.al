report 53512 "POS Sales by Section Report"
{
    Caption = 'POS Sales by Section Report';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/POSSalesBySectionReport.rdlc';

    dataset
    {
        dataitem(TransHeader; "POS Transaction Header")
        {
            RequestFilterFields = "Transaction Date", "Business Section", Status;
            DataItemTableView = sorting("Business Section", "Transaction Date") where(Status = const(Posted));

            column(TransactionDate; "Transaction Date") { }
            column(BusinessSection; "Business Section") { }
            column(TotalAmount; "Total Amount") { }
            column(TerminalID; "Terminal ID") { }
            column(CompanyName; CompanyProperty.DisplayName()) { }
            column(ReportTitle; ReportTitleLbl) { }
            column(PrintDate; Format(Today, 0, '<Month Text,3> <Day,2>, <Year4>')) { }
            column(DateFrom; Format(GetFilter("Transaction Date"))) { }

            trigger OnPreDataItem()
            begin
                if GetFilter("Transaction Date") = '' then
                    SetRange("Transaction Date", Today);
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

                    field(GroupByTerminal; GroupByTerminal)
                    {
                        ApplicationArea = All;
                        Caption = 'Group by Terminal';
                        ToolTip = 'Group results by terminal in addition to section.';
                    }
                }
            }
        }
    }

    labels
    {
        SectionLabel = 'Section';
        DateLabel = 'Date';
        TerminalLabel = 'Terminal';
        SalesLabel = 'Sales Amount';
        TransactionsLabel = 'Transactions';
        TotalLabel = 'Total';
        GrandTotalLabel = 'Grand Total';
        HypermartLabel = 'Hypermart';
        RestaurantLabel = 'Restaurant';
        BarLabel = 'Bar';
        LaundromatLabel = 'Laundromat';
    }

    var
        GroupByTerminal: Boolean;
        ReportTitleLbl: Label 'POS Sales by Business Section';
}
