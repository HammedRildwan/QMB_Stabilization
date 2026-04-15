// ------------------------------------------------------------------------------------------------
// Role Center: Finance Officer
// For accounting and financial operations staff
// Focus: G/L postings, profit recognition, reconciliation, tax compliance
// ------------------------------------------------------------------------------------------------
page 53218 "QMB Stab. Finance Admin RC"
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
                Caption = 'New Payment Request';
                Image = NewDocument;
                RunObject = page "Expense Card";
                RunPageMode = Create;
                ToolTip = 'Create a new payment request document.';
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
            group(PaymentManagement)
            {
                Caption = 'Payment Management';

                action(ExpenseRequests)
                {
                    ApplicationArea = All;
                    Caption = 'Expense Requests';
                    Image = Journals;
                    RunObject = page "Expense List";
                    ToolTip = 'View and manage payment requests.';
                }
                action(ApprovedExpenses)
                {
                    ApplicationArea = All;
                    Caption = 'Approved Payments';
                    Image = Approve;
                    RunObject = page "Approved Expense List";
                    ToolTip = 'View approved payment requests ready to post.';
                }
                action(PostedExpenses)
                {
                    ApplicationArea = All;
                    Caption = 'Posted Payments';
                    Image = PostedOrder;
                    RunObject = page "Posted Expense Requsitions";
                    ToolTip = 'View posted payment requests.';
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
                    ToolTip = 'View the simplified chart of accounts (~150 accounts).';
                }
                action(AccountSchedules)
                {
                    ApplicationArea = All;
                    Caption = 'Account Schedules';
                    Image = Report;
                    RunObject = page "Account Schedule Names";
                    ToolTip = 'View and manage account schedule definitions for P&L, Balance Sheet, and custom analysis.';
                }
                action(GLAccountCategories)
                {
                    ApplicationArea = All;
                    Caption = 'G/L Account Categories';
                    Image = Category;
                    RunObject = page "G/L Account Categories";
                    ToolTip = 'Manage account categories to standardize reporting and simplify COA structure.';
                }
            }

            group(PostingValidation)
            {
                Caption = 'Posting & Validation';

                action(PostingGroups)
                {
                    ApplicationArea = All;
                    Caption = 'General Posting Setup';
                    Image = PostingEntries;
                    RunObject = page "General Posting Setup";
                    ToolTip = 'Configure posting groups for consistent and validated postings.';
                }
                action(GenJournalTemplates)
                {
                    ApplicationArea = All;
                    Caption = 'Journal Templates';
                    Image = JournalSetup;
                    RunObject = page "General Journal Templates";
                    ToolTip = 'Manage journal templates with validation rules.';
                }
                action(GenJournals)
                {
                    ApplicationArea = All;
                    Caption = 'General Journals';
                    Image = Journals;
                    RunObject = page "General Journal";
                    ToolTip = 'Post validated journal entries.';
                }
                action(PostedGenJournals)
                {
                    ApplicationArea = All;
                    Caption = 'G/L Registers';
                    Image = GLRegisters;
                    RunObject = page "G/L Registers";
                    ToolTip = 'View posted G/L registers for audit trail.';
                }
            }
            group(Reports)
            {
                Caption = 'Document Reports';

                action(ExpenseRequestReport)
                {
                    ApplicationArea = All;
                    Caption = 'Payment Request Report';
                    Image = Report;
                    RunObject = report "Expense Request Report";
                    ToolTip = 'Print payment request report with details and totals.';
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
                Caption = 'Payment Requests';
                RunObject = page "Expense List";
                ToolTip = 'View payment requests.';
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
                Caption = 'Finance and Admin Setup';
                Image = Setup;
                RunObject = page "Custom Setup";
                ToolTip = 'Configure number series, budgets, and other application settings.';
            }
            action(StartMonthEndClosing)
            {
                ApplicationArea = All;
                Caption = 'Start Month-End Closing';
                Image = Period;
                RunObject = page "Month-End Closing Card";
                RunPageMode = Create;
                ToolTip = 'Start a new month-end closing process with checklist.';
            }
            group(MonthEndClosing)
            {
                Caption = 'Month-End Closing';

                action(MonthEndClosings)
                {
                    ApplicationArea = All;
                    Caption = 'Month-End Closings';
                    Image = Period;
                    RunObject = page "Month-End Closing List";
                    ToolTip = 'View and manage month-end closing processes.';
                }
                action(NewMonthEndClosing)
                {
                    ApplicationArea = All;
                    Caption = 'New Month-End Closing';
                    Image = NewDocument;
                    RunObject = page "Month-End Closing Card";
                    RunPageMode = Create;
                    ToolTip = 'Start a new month-end closing process.';
                }
                action(ChecklistTemplates)
                {
                    ApplicationArea = All;
                    Caption = 'Checklist Templates';
                    Image = CheckList;
                    RunObject = page "Month-End Checklist Templates";
                    ToolTip = 'Configure month-end checklist templates.';
                }
                action(AccountingPeriods)
                {
                    ApplicationArea = All;
                    Caption = 'Accounting Periods';
                    Image = AccountingPeriods;
                    RunObject = page "Accounting Periods";
                    ToolTip = 'View and manage accounting periods.';
                }
            }
        }
        area(Reporting)
        {
            group(FinancialReports)
            {
                Caption = 'Financial Reports';

                action(RunTrialBalance)
                {
                    ApplicationArea = All;
                    Caption = 'Trial Balance';
                    Image = Report;
                    RunObject = report "Trial Balance";
                    ToolTip = 'Print trial balance for month-end processing.';
                }
                action(RunIncomeStatement)
                {
                    ApplicationArea = All;
                    Caption = 'Income Statement';
                    Image = Report;
                    RunObject = report "Income Statement";
                    ToolTip = 'Print P&L aligned with strategic goals.';
                }
                action(RunBalanceSheet)
                {
                    ApplicationArea = All;
                    Caption = 'Balance Sheet';
                    Image = Report;
                    RunObject = report "Balance Sheet";
                    ToolTip = 'Print balance sheet report.';
                }
                action(RunDetailedTrialBal)
                {
                    ApplicationArea = All;
                    Caption = 'Detailed Trial Balance';
                    Image = Report;
                    RunObject = report "Detail Trial Balance";
                    ToolTip = 'Print detailed trial balance.';
                }
            }
            group(ManagementReports)
            {
                Caption = 'Management Reports';

                action(DetailedTrialBalance)
                {
                    ApplicationArea = All;
                    Caption = 'Detailed Trial Balance';
                    Image = Report;
                    RunObject = report "Detail Trial Balance";
                    ToolTip = 'Print detailed trial balance for comprehensive analysis.';
                }
                action(DimensionDetail)
                {
                    ApplicationArea = All;
                    Caption = 'Dimensions - Detail';
                    Image = Report;
                    RunObject = report "Dimensions - Detail";
                    ToolTip = 'Print detailed dimension analysis for strategic reporting.';
                }
                action(DimensionTotal)
                {
                    ApplicationArea = All;
                    Caption = 'Dimensions - Total';
                    Image = Report;
                    RunObject = report "Dimensions - Total";
                    ToolTip = 'Print dimension totals for high-level strategic overview.';
                }
                action(ConsolidatedTrialBalance)
                {
                    ApplicationArea = All;
                    Caption = 'Consolidated Trial Balance';
                    Image = Report;
                    RunObject = report "Consolidated Trial Balance";
                    ToolTip = 'Print consolidated trial balance across business units.';
                }
            }
            group(InventoryRevenue)
            {
                Caption = 'Inventory & Revenue';

                action(ItemCategories)
                {
                    ApplicationArea = All;
                    Caption = 'Item Categories';
                    Image = ItemGroup;
                    RunObject = page "Item Categories";
                    ToolTip = 'Manage item categories for inventory and revenue reporting.';
                }
                action(InventoryValuation)
                {
                    ApplicationArea = All;
                    Caption = 'Inventory Valuation';
                    Image = Report;
                    RunObject = report "Inventory Valuation";
                    ToolTip = 'View inventory valuation by item category and dimensions.';
                }
                action(InventoryAnalysis)
                {
                    ApplicationArea = All;
                    Caption = 'Inventory Analysis';
                    Image = InventoryJournal;
                    RunObject = page "Invt. Analysis by Dimensions";
                    ToolTip = 'Analyze inventory by dimensions instead of G/L accounts.';
                }
                action(SalesAnalysis)
                {
                    ApplicationArea = All;
                    Caption = 'Sales Analysis';
                    Image = Sales;
                    RunObject = page "Sales Analysis by Dimensions";
                    ToolTip = 'Analyze revenue by dimensions and item categories.';
                }
                action(ItemSalesStatistics)
                {
                    ApplicationArea = All;
                    Caption = 'Item Sales Statistics';
                    Image = Statistics;
                    RunObject = report "Inventory - Sales Statistics";
                    ToolTip = 'View sales statistics by item for revenue analysis.';
                }
            }
            group(FinancialAnalysis)
            {
                Caption = 'Financial Analysis';

                action(PLByVertical)
                {
                    ApplicationArea = All;
                    Caption = 'P&L by Business Vertical';
                    Image = AnalysisView;
                    RunObject = page "Analysis View List";
                    ToolTip = 'View real-time Profit & Loss analysis by business verticals using dimension-based views.';
                }
                action(TrialBalance)
                {
                    ApplicationArea = All;
                    Caption = 'Trial Balance';
                    Image = Report;
                    RunObject = report "Trial Balance";
                    ToolTip = 'Print trial balance for month-end closing and validation.';
                }
                action(IncomeStatement)
                {
                    ApplicationArea = All;
                    Caption = 'Income Statement';
                    Image = Report;
                    RunObject = report "Income Statement";
                    ToolTip = 'Print income statement aligned with QMB strategic goals.';
                }
                action(BalanceSheet)
                {
                    ApplicationArea = All;
                    Caption = 'Balance Sheet';
                    Image = Report;
                    RunObject = report "Balance Sheet";
                    ToolTip = 'Print balance sheet for financial position analysis.';
                }
                action(ClosingTrialBalance)
                {
                    ApplicationArea = All;
                    Caption = 'Closing Trial Balance';
                    Image = Report;
                    RunObject = report "Closing Trial Balance";
                    ToolTip = 'Print closing trial balance for faster month-end processing.';
                }
            }
            group(BudgetMonitoring)
            {
                Caption = 'Budget Monitoring';

                action(GLBudgets)
                {
                    ApplicationArea = All;
                    Caption = 'G/L Budgets';
                    Image = LedgerBudget;
                    RunObject = page "G/L Budget Names";
                    ToolTip = 'Manage G/L budgets by Category, Business Unit, and Department dimensions.';
                }
                action(BudgetMatrix)
                {
                    ApplicationArea = All;
                    Caption = 'Budget Analysis';
                    Image = CalculateCost;
                    RunObject = page Budget;
                    ToolTip = 'View and edit budget entries with dimension filtering.';
                }
                action(BudgetVsActual)
                {
                    ApplicationArea = All;
                    Caption = 'Budget vs. Actual';
                    Image = Report;
                    RunObject = report "Budget";
                    ToolTip = 'Compare budgeted amounts against actual G/L entries by dimension.';
                }
                action(DimensionAnalysis)
                {
                    ApplicationArea = All;
                    Caption = 'Dimension Analysis';
                    Image = Dimensions;
                    RunObject = page "Analysis View List";
                    ToolTip = 'Analyze G/L entries by Business Unit, Department, and other dimensions.';
                }
            }

            group(DimensionReports)
            {
                Caption = 'Dimension Reports';

                action(RunDimensionsDetail)
                {
                    ApplicationArea = All;
                    Caption = 'Dimensions - Detail';
                    Image = Report;
                    RunObject = report "Dimensions - Detail";
                    ToolTip = 'Analyze by Business Unit + Department.';
                }
                action(RunDimensionsTotal)
                {
                    ApplicationArea = All;
                    Caption = 'Dimensions - Total';
                    Image = Report;
                    RunObject = report "Dimensions - Total";
                    ToolTip = 'View dimension totals for verticals.';
                }
                action(RunBudgetReport)
                {
                    ApplicationArea = All;
                    Caption = 'Budget vs. Actual';
                    Image = Report;
                    RunObject = report "Budget";
                    ToolTip = 'Compare budget to actual by dimensions.';
                }
            }
            group(InventoryReports)
            {
                Caption = 'Inventory Reports';

                action(RunInventoryValuation)
                {
                    ApplicationArea = All;
                    Caption = 'Inventory Valuation';
                    Image = Report;
                    RunObject = report "Inventory Valuation";
                    ToolTip = 'View inventory valuation by category.';
                }
                action(RunSalesStatistics)
                {
                    ApplicationArea = All;
                    Caption = 'Sales Statistics';
                    Image = Report;
                    RunObject = report "Inventory - Sales Statistics";
                    ToolTip = 'View revenue by item categories.';
                }
            }
            group(DocumentReports)
            {
                Caption = 'Document Reports';

                action(RunExpenseReport)
                {
                    ApplicationArea = All;
                    Caption = 'Payment Request Report';
                    Image = Report;
                    RunObject = report "Expense Request Report";
                    ToolTip = 'Print payment request report.';
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

}
