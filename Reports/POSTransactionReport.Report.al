report 53510 "POS Transaction Report"
{
    Caption = 'POS Transaction Report';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/POSTransactionReport.rdlc';

    dataset
    {
        dataitem(Header; "POS Transaction Header")
        {
            RequestFilterFields = "Transaction No.", "Transaction Date", "Terminal ID", "Business Section", Status;

            column(TransactionNo; "Transaction No.") { }
            column(TransactionDate; "Transaction Date") { }
            column(TransactionTime; "Transaction Time") { }
            column(TerminalID; "Terminal ID") { }
            column(ShiftNo; "Shift No.") { }
            column(CustomerNo; "Customer No.") { }
            column(CustomerName; "Customer Name") { }
            column(BusinessSection; "Business Section") { }
            column(Subtotal; Subtotal) { }
            column(DiscountAmount; "Discount Amount") { }
            column(TotalAmount; "Total Amount") { }
            column(PaidAmount; "Paid Amount") { }
            column(ChangeAmount; "Change Amount") { }
            column(Status; Status) { }
            column(UserID; "User ID") { }
            column(PostedInvoiceNo; "Posted Invoice No.") { }
            column(CompanyName; CompanyProperty.DisplayName()) { }
            column(ReportTitle; ReportTitleLbl) { }
            column(PrintDate; Format(Today, 0, '<Month Text,3> <Day,2>, <Year4>')) { }

            dataitem(Lines; "POS Transaction Line")
            {
                DataItemLink = "Transaction No." = field("Transaction No.");
                DataItemTableView = sorting("Transaction No.", "Line No.");

                column(LineNo; "Line No.") { }
                column(ItemNo; "Item No.") { }
                column(Barcode; Barcode) { }
                column(Description; Description) { }
                column(Quantity; Quantity) { }
                column(UnitOfMeasureCode; "Unit of Measure Code") { }
                column(UnitPrice; "Unit Price") { }
                column(DiscountPct; "Discount %") { }
                column(LineAmount; "Line Amount") { }
            }

            dataitem(Payments; "POS Payment Entry")
            {
                DataItemLink = "Transaction No." = field("Transaction No.");
                DataItemTableView = sorting("Entry No.");

                column(PaymentEntryNo; "Entry No.") { }
                column(PaymentMethod; "Payment Method") { }
                column(PaymentAmount; Amount) { }
                column(PaymentReference; "Reference No.") { }
            }

            trigger OnAfterGetRecord()
            begin
                CalcFields(Subtotal, "Paid Amount");
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

                    field(ShowDetails; ShowDetails)
                    {
                        ApplicationArea = All;
                        Caption = 'Show Line Details';
                        ToolTip = 'Include transaction line details in the report.';
                    }
                }
            }
        }
    }

    labels
    {
        TransactionLabel = 'Transaction No.';
        DateLabel = 'Date';
        TimeLabel = 'Time';
        TerminalLabel = 'Terminal';
        CustomerLabel = 'Customer';
        ItemLabel = 'Item';
        DescriptionLabel = 'Description';
        QtyLabel = 'Qty';
        PriceLabel = 'Unit Price';
        AmountLabel = 'Amount';
        SubtotalLabel = 'Subtotal';
        DiscountLabel = 'Discount';
        TotalLabel = 'Total';
        PaymentLabel = 'Payment';
        ChangeLabel = 'Change';
    }

    var
        ShowDetails: Boolean;
        ReportTitleLbl: Label 'POS Transaction Report';
}
