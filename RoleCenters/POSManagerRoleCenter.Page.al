page 53315 "POS Manager Role Center"
{
    Caption = 'QMB POS Manager';
    PageType = RoleCenter;

    layout
    {
        area(RoleCenter)
        {
            part(ManagerSummary; "POS Manager Activities")
            {
                ApplicationArea = All;
            }
            part(HypermartCue; "POS Hypermart Activities")
            {
                ApplicationArea = All;
            }
            part(RestaurantCue; "POS Restaurant Activities")
            {
                ApplicationArea = All;
            }
            part(BarCue; "POS Bar Activities")
            {
                ApplicationArea = All;
            }
            part(LaundromatCue; "POS Laundromat Activities")
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        area(Embedding)
        {
            action(AllTransactions)
            {
                ApplicationArea = All;
                Caption = 'All Transactions';
                Image = Sales;
                RunObject = page "POS Transaction List";
                ToolTip = 'View all POS transactions.';
            }
            action(Terminals)
            {
                ApplicationArea = All;
                Caption = 'Terminals';
                Image = TaxSetup;
                RunObject = page "POS Terminal List";
                ToolTip = 'Manage POS terminals.';
            }
            action(POSSetup)
            {
                ApplicationArea = All;
                Caption = 'POS Setup';
                Image = Setup;
                RunObject = page "POS Setup";
                ToolTip = 'Configure POS settings.';
            }
        }
        area(Sections)
        {
            group(SalesOperations)
            {
                Caption = 'Sales Operations';
                Image = Sales;

                action(TransactionsSection)
                {
                    ApplicationArea = All;
                    Caption = 'Transactions';
                    RunObject = page "POS Transaction List";
                    ToolTip = 'View all transactions.';
                }
                action(TerminalsSection)
                {
                    ApplicationArea = All;
                    Caption = 'Terminals';
                    RunObject = page "POS Terminal List";
                    ToolTip = 'View terminals.';
                }
            }
            group(Administration)
            {
                Caption = 'Administration';
                Image = Administration;

                action(SetupSection)
                {
                    ApplicationArea = All;
                    Caption = 'POS Setup';
                    RunObject = page "POS Setup";
                    ToolTip = 'POS configuration.';
                }
                action(ItemsSection)
                {
                    ApplicationArea = All;
                    Caption = 'Items';
                    RunObject = page "Item List";
                    ToolTip = 'View items.';
                }
                action(CustomersSection)
                {
                    ApplicationArea = All;
                    Caption = 'Customers';
                    RunObject = page "Customer List";
                    ToolTip = 'View customers.';
                }
                action(PriceListsSection)
                {
                    ApplicationArea = All;
                    Caption = 'Price Lists';
                    RunObject = page "Sales Price List";
                    ToolTip = 'View price lists.';
                }
            }
            group(ReportsSection)
            {
                Caption = 'Reports';

                action(TransactionReport)
                {
                    ApplicationArea = All;
                    Caption = 'Transaction Report';
                    ToolTip = 'Run POS transaction report.';
                    RunObject = report "POS Transaction Report";
                }
                action(ShiftReport)
                {
                    ApplicationArea = All;
                    Caption = 'Shift Report';
                    ToolTip = 'Run shift report.';
                    RunObject = report "POS Shift Report";
                }
                action(SalesBySection)
                {
                    ApplicationArea = All;
                    Caption = 'Sales by Section';
                    ToolTip = 'Run sales by business section report.';
                    RunObject = report "POS Sales by Section Report";
                }
            }
        }
        area(Processing)
        {
            action(NewCheckout)
            {
                ApplicationArea = All;
                Caption = 'New Checkout';
                Image = NewDocument;
                RunObject = page "POS Checkout";
                ToolTip = 'Start a new checkout.';
            }
        }
    }
}
