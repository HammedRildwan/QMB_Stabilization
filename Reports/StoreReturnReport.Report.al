// ------------------------------------------------------------------------------------------------
// Store Return Report
// Lists store returns with item details and return quantities
// ------------------------------------------------------------------------------------------------
report 53502 "Store Return Report"
{
    Caption = 'Store Return Report';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    RDLCLayout = 'Layouts/StoreReturnReport.rdlc';

    dataset
    {
        dataitem(StoreReturnHeader; "Store Return Header")
        {
            RequestFilterFields = "No.", Date, Requester, Status, "Requisition No.";
            PrintOnlyIfDetail = false;

            column(No_; "No.") { }
            column(Date; Date) { }
            column(Requester; Requester) { }
            column(Status; Status) { }
            column(Location; Location) { }
            column(Justification; Justification) { }
            column(RequisitionNo; "Requisition No.") { }
            column(AssetNo; "Asset No.") { }
            column(Posted; Posted) { }
            column(ShortcutDimension1Code; "Shortcut Dimension 1 Code") { }
            column(ShortcutDimension2Code; "Shortcut Dimension 2 Code") { }
            column(CompanyName; CompanyName) { }
            column(ReportTitle; ReportTitleLbl) { }
            column(PrintDate; Format(Today, 0, '<Day,2>/<Month,2>/<Year4>')) { }

            dataitem(StoreReturnLine; "Store Return Line")
            {
                DataItemLink = "Document No." = field("No.");
                DataItemTableView = sorting("Document No.", "Line No.");

                column(LineNo; "Line No.") { }
                column(ItemNo; "Item No.") { }
                column(Description; Description) { }
                column(UnitOfMeasure; "Unit of Measure") { }
                column(QuantityIssued; "Quantity Issued") { }
                column(QuantityToReturn; "Quantity to Return") { }
                column(UnitPrice; "Unit Price") { }
                column(Amount; Amount) { }
                column(LocationCode; "Location Code") { }
                column(FixedAssetNo; "Fixed Asset No") { }
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

                    field(ShowPostedOnly; ShowPostedOnly)
                    {
                        ApplicationArea = All;
                        Caption = 'Show Posted Only';
                        ToolTip = 'Select to show only posted returns.';
                    }
                }
            }
        }
    }

    trigger OnPreReport()
    begin
        if ShowPostedOnly then
            StoreReturnHeader.SetRange(Posted, true);
    end;

    var
        ShowPostedOnly: Boolean;
        ReportTitleLbl: Label 'Store Return Report';
}
