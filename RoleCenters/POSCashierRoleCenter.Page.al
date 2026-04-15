page 53313 "POS Cashier Role Center"
{
    Caption = 'QMB Cashier';
    PageType = RoleCenter;

    layout
    {
        area(RoleCenter)
        {
            part(CashierActivities; "POS Cashier Activities")
            {
                ApplicationArea = All;
            }
            part(ShiftInfo; "POS Shift FactBox")
            {
                ApplicationArea = All;
                Caption = 'Current Shift';
            }
        }
    }

    actions
    {
        area(Embedding)
        {
            action(POSCheckout)
            {
                ApplicationArea = All;
                Caption = 'POS Checkout';
                Image = CashFlow;
                RunObject = page "POS Checkout";
                ToolTip = 'Open POS checkout screen.';
            }
            action(MyTransactions)
            {
                ApplicationArea = All;
                Caption = 'My Transactions';
                Image = Sales;
                RunObject = page "POS Transaction List";
                ToolTip = 'View your transactions.';
            }
            action(ShiftManagement)
            {
                ApplicationArea = All;
                Caption = 'Shift Management';
                Image = Timesheet;
                RunObject = page "POS Shift Management";
                ToolTip = 'Manage your shift.';
            }
        }
        area(Sections)
        {
            group(POSOperations)
            {
                Caption = 'POS Operations';
                Image = Sales;

                action(CheckoutAction)
                {
                    ApplicationArea = All;
                    Caption = 'Checkout';
                    RunObject = page "POS Checkout";
                    ToolTip = 'Open POS checkout.';
                }
                action(TransactionListAction)
                {
                    ApplicationArea = All;
                    Caption = 'Transactions';
                    RunObject = page "POS Transaction List";
                    ToolTip = 'View all transactions.';
                }
                action(ShiftAction)
                {
                    ApplicationArea = All;
                    Caption = 'Shift Management';
                    RunObject = page "POS Shift Management";
                    ToolTip = 'Manage shift.';
                }
            }
            group(Lookups)
            {
                Caption = 'Lookups';
                Image = Journals;

                action(ItemsAction)
                {
                    ApplicationArea = All;
                    Caption = 'Items';
                    RunObject = page "Item List";
                    ToolTip = 'View items.';
                }
                action(CustomersAction)
                {
                    ApplicationArea = All;
                    Caption = 'Customers';
                    RunObject = page "Customer List";
                    ToolTip = 'View customers.';
                }
            }
        }
        area(Processing)
        {
            action(NewTransaction)
            {
                ApplicationArea = All;
                Caption = 'New Transaction';
                Image = NewDocument;
                RunObject = page "POS Checkout";
                ToolTip = 'Start a new POS transaction.';
            }
            action(OpenShift)
            {
                ApplicationArea = All;
                Caption = 'Open Shift';
                Image = Start;
                RunObject = page "POS Shift Management";
                ToolTip = 'Open a new shift.';
            }
        }
    }
}
