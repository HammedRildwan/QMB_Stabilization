// ------------------------------------------------------------------------------------------------
// Document Approval Status Report
// Provides overview of document approval workflow status across all entities
// ------------------------------------------------------------------------------------------------
report 70703 "Approval Status Report"
{
    Caption = 'Document Approval Status Report';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    RDLCLayout = 'Layouts/ApprovalStatusReport.rdlc';

    dataset
    {
        dataitem(DocumentApprovalEntry; "Document Approval Entry")
        {
            RequestFilterFields = "Document No.", Status, Sender, Approver, "Document Date";

            column(Sequence; Sequence) { }
            column(TableNo; "Table No.") { }
            column(DocumentNo; "Document No.") { }
            column(Sender; Sender) { }
            column(Approver; Approver) { }
            column(Status; Status) { }
            column(DocumentDate; "Document Date") { }
            column(DocumentAmount; "Document Amount") { }
            column(DocumentDescription; "Document Description") { }
            column(Open; Open) { }
            column(StatusChangeDateTime; "Status Change DateTime") { }
            column(SendForApprovalDateTime; "Send for Approval DateTime") { }
            column(DocumentType; GetDocumentTypeName()) { }
            column(CompanyName; CompanyName) { }
            column(ReportTitle; ReportTitleLbl) { }
            column(PrintDate; Format(Today, 0, '<Day,2>/<Month,2>/<Year4>')) { }

            trigger OnAfterGetRecord()
            begin
                // Calculate turnaround time if approved/rejected
                if Status in [Status::Approved, Status::Rejected] then begin
                    if ("Send for Approval DateTime" <> 0DT) and ("Status Change DateTime" <> 0DT) then
                        TurnaroundHours := Round(("Status Change DateTime" - "Send for Approval DateTime") / 3600000, 0.01);
                end else
                    TurnaroundHours := 0;
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

                    field(ShowOpenOnly; ShowOpenOnly)
                    {
                        ApplicationArea = All;
                        Caption = 'Show Open Entries Only';
                        ToolTip = 'Select to show only open approval entries.';
                    }
                    field(FilterByApprover; FilterByApprover)
                    {
                        ApplicationArea = All;
                        Caption = 'My Approvals Only';
                        ToolTip = 'Select to show only entries where you are the approver.';
                    }
                }
            }
        }
    }

    trigger OnPreReport()
    begin
        if ShowOpenOnly then
            DocumentApprovalEntry.SetRange(Open, true);
        if FilterByApprover then
            DocumentApprovalEntry.SetRange(Approver, UserId);
    end;

    var
        ShowOpenOnly: Boolean;
        FilterByApprover: Boolean;
        TurnaroundHours: Decimal;
        ReportTitleLbl: Label 'Document Approval Status Report';

    local procedure GetDocumentTypeName(): Text
    begin
        case DocumentApprovalEntry."Table No." of
            Database::"Expense Request Header":
                exit('Expense Request');
            Database::"Store Requisition Header":
                exit('Store Requisition');
            Database::"Store Return Header":
                exit('Store Return');
            else
                exit(Format(DocumentApprovalEntry."Table No."));
        end;
    end;
}
