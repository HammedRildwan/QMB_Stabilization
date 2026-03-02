// ------------------------------------------------------------------------------------------------
// Store Requisition Report
// Lists store requisitions with item details and issuance status
// ------------------------------------------------------------------------------------------------
report 70701 "Store Requisition Report"
{
    Caption = 'Store Requisition Report';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    RDLCLayout = 'Layouts/StoreRequisitionReport.rdlc';

    dataset
    {
        dataitem(StoreRequisitionHeader; "Store Requisition Header")
        {
            RequestFilterFields = "No.", "Request Date", Requester, Status, "Store Location", "Request Type";
            PrintOnlyIfDetail = false;

            column(No_; "No.") { }
            column(RequestDate; "Request Date") { }
            column(Requester; Requester) { }
            column(Status; Status) { }
            column(StoreLocation; "Store Location") { }
            column(RequestType; "Request Type") { }
            column(Justification; Justification) { }
            column(AssetNo; "Asset No.") { }
            column(MaintenanceType; "Maintenance Type") { }
            column(Posted; Posted) { }
            column(PostedDateTime; "Posted DateTime") { }
            column(PostedBy; "Posted By") { }
            column(ShortcutDimension1Code; "Shortcut Dimension 1 Code") { }
            column(ShortcutDimension2Code; "Shortcut Dimension 2 Code") { }
            column(CompanyName; CompanyName) { }
            column(ReportTitle; ReportTitleLbl) { }
            column(PrintDate; Format(Today, 0, '<Day,2>/<Month,2>/<Year4>')) { }

            dataitem(StoreRequisitionLine; "Store Requisition Line")
            {
                DataItemLink = "Document No." = field("No.");
                DataItemTableView = sorting("Document No.", "Line No.");

                column(LineNo; "Line No.") { }
                column(ItemNo; "Item No.") { }
                column(Description; Description) { }
                column(UnitOfMeasure; "Unit of Measure") { }
                column(QuantityRequested; "Quantity Requested") { }
                column(QuantityToIssue; "Quantity to Issue") { }
                column(AvailableQuantity; "Available Quantity") { }
                column(UnitPrice; "Unit Price") { }
                column(Amount; Amount) { }
                column(LocationCode; "Location Code") { }
                column(FixedAssetNo; "Fixed Asset No.") { }
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
                        ToolTip = 'Select to show only posted requisitions.';
                    }
                }
            }
        }
    }

    trigger OnPreReport()
    begin
        if ShowPostedOnly then
            StoreRequisitionHeader.SetRange(Posted, true);
    end;

    var
        ShowPostedOnly: Boolean;
        ReportTitleLbl: Label 'Store Requisition Report';
}
