// ------------------------------------------------------------------------------------------------
// Role Center: Finance Officer
// For accounting and financial operations staff
// Focus: G/L postings, profit recognition, reconciliation, tax compliance
// ------------------------------------------------------------------------------------------------
page 70602 "QMB Stab. Finance Admin RC"
{
    Caption = 'QMB Stab. Finance and Admin Manager';
    PageType = RoleCenter;
    //ApplicationArea = All;

    layout
    {
        area(RoleCenter)
        {
            group(Control1)
            {
                ShowCaption = false;

                part(Headlines; "QMB Stab. RC Headlines")
                {
                    ApplicationArea = All;
                }

            }
            group(Control2)
            {
                ShowCaption = false;

                part(Activities; "QMB Stab. Finance Admin Act.")
                {
                    ApplicationArea = All;
                }
            }
            group(PowerBICharts)
            {
                Caption = 'Analytics';
                ShowCaption = true;

                Visible = false; // Set to true when Power BI integration is ready
            }
        }
    }

    actions
    {
        area(Creation)
        {
            action(NewExpenseRequest)
            {
                ApplicationArea = All;
                Caption = 'New Expense Request';
                Image = NewDocument;
                RunObject = page "Expense Card";
                RunPageMode = Create;
                ToolTip = 'Create a new expense request document.';
            }
            action(NewStoreRequisition)
            {
                ApplicationArea = All;
                Caption = 'New Store Requisition';
                Image = NewDocument;
                RunObject = page "Store Requisition Card";
                RunPageMode = Create;
                ToolTip = 'Create a new store requisition document.';
            }
            action(NewStoreReturn)
            {
                ApplicationArea = All;
                Caption = 'New Store Return';
                Image = NewDocument;
                RunObject = page "Store Return Card";
                RunPageMode = Create;
                ToolTip = 'Create a new store return document.';
            }
        }
        area(Sections)
        {
            group(ExpenseManagement)
            {
                Caption = 'Expense Management';

                action(ExpenseRequests)
                {
                    ApplicationArea = All;
                    Caption = 'Expense Requests';
                    Image = Journals;
                    RunObject = page "Expense List";
                    ToolTip = 'View and manage expense requests.';
                }
                action(ApprovedExpenses)
                {
                    ApplicationArea = All;
                    Caption = 'Approved Expenses';
                    Image = Approve;
                    RunObject = page "Approved Expense List";
                    ToolTip = 'View approved expense requests ready to post.';
                }
                action(PostedExpenses)
                {
                    ApplicationArea = All;
                    Caption = 'Posted Expenses';
                    Image = PostedOrder;
                    RunObject = page "Posted Expense Requsitions";
                    ToolTip = 'View posted expense requests.';
                }
            }
            group(StoreManagement)
            {
                Caption = 'Store Management';

                action(StoreRequisitions)
                {
                    ApplicationArea = All;
                    Caption = 'Store Requisitions';
                    Image = Warehouse;
                    RunObject = page "Store Requisition List";
                    ToolTip = 'View and manage store requisitions.';
                }
                action(StoreReturns)
                {
                    ApplicationArea = All;
                    Caption = 'Store Returns';
                    Image = Return;
                    RunObject = page "Store Return List";
                    ToolTip = 'View and manage store returns.';
                }
            }
            group(ApprovalWorkflows)
            {
                Caption = 'Approval Workflows';

                action(DocumentApprovals)
                {
                    ApplicationArea = All;
                    Caption = 'Document Approval Entries';
                    Image = Approvals;
                    RunObject = page "Document Approval Entries";
                    ToolTip = 'View all document approval entries.';
                }
                action(WorkflowSetup)
                {
                    ApplicationArea = All;
                    Caption = 'Workflow Setup';
                    Image = Workflow;
                    RunObject = page "Doc. Workflow List";
                    ToolTip = 'Configure document approval workflows.';
                }
            }
            group(GLIntegration)
            {
                Caption = 'G/L Integration';

                action(GeneralLedgerEntries)
                {
                    ApplicationArea = All;
                    Caption = 'G/L Entries';
                    Image = GLRegisters;
                    RunObject = page "General Ledger Entries";
                    ToolTip = 'View general ledger entries.';
                }
                action(ChartOfAccounts)
                {
                    ApplicationArea = All;
                    Caption = 'Chart of Accounts';
                    Image = ChartOfAccounts;
                    RunObject = page "Chart of Accounts";
                    ToolTip = 'View the chart of accounts.';
                }
            }
            group(Reports)
            {
                Caption = 'Reports';

                action(ExpenseRequestReport)
                {
                    ApplicationArea = All;
                    Caption = 'Expense Request Report';
                    Image = Report;
                    RunObject = report "Expense Request Report";
                    ToolTip = 'Print expense request report with details and totals.';
                }
                action(StoreRequisitionReport)
                {
                    ApplicationArea = All;
                    Caption = 'Store Requisition Report';
                    Image = Report;
                    RunObject = report "Store Requisition Report";
                    ToolTip = 'Print store requisition report with item details.';
                }
                action(StoreReturnReport)
                {
                    ApplicationArea = All;
                    Caption = 'Store Return Report';
                    Image = Report;
                    RunObject = report "Store Return Report";
                    ToolTip = 'Print store return report with return quantities.';
                }
                action(ApprovalStatusReport)
                {
                    ApplicationArea = All;
                    Caption = 'Approval Status Report';
                    Image = Report;
                    RunObject = report "Approval Status Report";
                    ToolTip = 'Print document approval status report across all entities.';
                }
            }
        }
        area(Embedding)
        {
            action(ExpenseListEmbed)
            {
                ApplicationArea = All;
                Caption = 'Expense Requests';
                RunObject = page "Expense List";
                ToolTip = 'View expense requests.';
            }
            action(StoreRequisitionsEmbed)
            {
                ApplicationArea = All;
                Caption = 'Store Requisitions';
                RunObject = page "Store Requisition List";
                ToolTip = 'View store requisitions.';
            }
            action(ApprovalsEmbed)
            {
                ApplicationArea = All;
                Caption = 'Approval Entries';
                RunObject = page "Document Approval Entries";
                ToolTip = 'View document approval entries.';
            }
        }
        area(Processing)
        {
            action(ApprovalWorkflow)
            {
                ApplicationArea = All;
                Caption = 'Configure Approval Workflow';
                Image = ApprovalSetup;
                RunObject = page "Doc. Workflow List";
                ToolTip = 'Configure Approval Workflow.';
            }
            action(CustomSetup)
            {
                ApplicationArea = All;
                Caption = 'QMB Setup';
                Image = Setup;
                RunObject = page "Custom Setup";
                ToolTip = 'Configure number series, budgets, and other application settings.';
            }
        }
        area(Reporting)
        {
            action(RunExpenseReport)
            {
                ApplicationArea = All;
                Caption = 'Expense Request Report';
                Image = Report;
                RunObject = report "Expense Request Report";
                ToolTip = 'Print expense request report.';
            }
            action(RunStoreReqReport)
            {
                ApplicationArea = All;
                Caption = 'Store Requisition Report';
                Image = Report;
                RunObject = report "Store Requisition Report";
                ToolTip = 'Print store requisition report.';
            }
            action(RunStoreReturnReport)
            {
                ApplicationArea = All;
                Caption = 'Store Return Report';
                Image = Report;
                RunObject = report "Store Return Report";
                ToolTip = 'Print store return report.';
            }
            action(RunApprovalReport)
            {
                ApplicationArea = All;
                Caption = 'Approval Status Report';
                Image = Report;
                RunObject = report "Approval Status Report";
                ToolTip = 'Print approval status report.';
            }
        }
    }
}
