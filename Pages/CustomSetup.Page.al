// ------------------------------------------------------------------------------------------------
// Custom Setup Page
// Setup page for configuring number series and other application settings
// ------------------------------------------------------------------------------------------------
page 70604 "Custom Setup"
{
    Caption = 'QMB Stab. Setup';
    PageType = Card;
    SourceTable = "Custom Setup";
    UsageCategory = Administration;
    ApplicationArea = All;
    InsertAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';
                ShowCaption = true;

                field("Primary Key"; Rec."Primary Key")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the primary key for the setup record.';
                    Visible = false;
                }
                field("Budget Code"; Rec."Budget Code")
                {
                    Caption = 'Default Budget Code';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the default budget code for budget checking.';
                }
                field("Default Approval Due Days"; Rec."Default Approval Due Days")
                {
                    ApplicationArea = All;
                    Caption = 'Default Approval Due Days';
                    ToolTip = 'Specifies the default number of days until approval requests are due.';
                }
                field("WHT Payable Account"; Rec."WHT Payable Account")
                {
                    ApplicationArea = All;
                    Caption = 'WHT Payable Account';
                    ToolTip = 'Specifies the default G/L account for withholding tax payable.';
                }
            }
            group(NumberSeries)
            {
                Caption = 'Number Series';
                ShowCaption = true;
                Visible = true;

                field("Expense Nos."; Rec."Expense Nos.")
                {
                    Caption = 'Payment Request Nos.';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number series for payment requests.';
                }
                field("Store Requisition Nos."; Rec."Store Requisition Nos.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number series for store requisitions.';
                }
                field("Store Return Nos."; Rec."Store Return Nos.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number series for store returns.';
                }
                field("Requisition Nos."; Rec."Requisition Nos.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number series for requisitions.';
                }
                field("Retirement Nos."; Rec."Retirement Nos.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number series for retirements.';
                }
            }
            group(WorkOrders)
            {
                Caption = 'Work Orders & Maintenance';
                ShowCaption = true;
                Visible = false; // Hidden until work order and maintenance features are enabled

                field("Work Order Header Nos."; Rec."Work Order Header Nos.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number series for work order headers.';
                }
                field("Maintenance Schedule No."; Rec."Maintenance Schedule No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number series for maintenance schedules.';
                }
            }
            group(Budgeting)
            {
                Caption = 'Budgeting';
                ShowCaption = true;
                Visible = false; // Hidden until budgeting features are enabled

            }
        }
    }

    actions
    {
        area(Navigation)
        {
            action(NoSeries)
            {
                ApplicationArea = All;
                Caption = 'No. Series';
                Image = SerialNo;
                RunObject = page "No. Series";
                ToolTip = 'View or edit the number series for documents.';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
            }
            action(GLBudgets)
            {
                ApplicationArea = All;
                Caption = 'G/L Budgets';
                Image = LedgerBudget;
                RunObject = page "G/L Budget Names";
                ToolTip = 'View or edit G/L budget names.';
                Promoted = true;
                PromotedCategory = Process;
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.Reset();
        if not Rec.Get() then begin
            Rec.Init();
            Rec.Insert();
        end;
    end;
}
