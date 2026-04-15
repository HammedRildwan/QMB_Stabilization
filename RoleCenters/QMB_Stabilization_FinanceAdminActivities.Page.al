// ------------------------------------------------------------------------------------------------
// Finance and Admin Activities
// Cue group page part for relevant KPIs
// ------------------------------------------------------------------------------------------------
page 53217 "QMB Stab. Finance Admin Act."
{
    Caption = 'Finance and Admin Operations';
    PageType = CardPart;
    SourceTable = "QMB Stab. Role Center Cue";
    RefreshOnActivate = true;

    layout
    {
        area(Content)
        {
            cuegroup(PaymentRequests)
            {
                Caption = 'Payment Requests';
                ShowCaption = true;

                field("Open Payment Requests"; Rec."Open Expense Requests")
                {
                    ApplicationArea = All;
                    Caption = 'Open';
                    DrillDownPageId = "Expense List";
                    ToolTip = 'Number of Payment requests awaiting submission.';
                }
                field("Pending Payment Approvals"; Rec."Pending Expense Approvals")
                {
                    ApplicationArea = All;
                    Caption = 'Pending Approval';
                    DrillDownPageId = "Expense List";
                    ToolTip = 'Number of Payment requests pending approval.';
                    Style = Attention;
                    StyleExpr = Rec."Pending Expense Approvals" > 0;
                }
                field("Approved Payment Requests"; Rec."Approved Expense Requests")
                {
                    ApplicationArea = All;
                    Caption = 'Approved';
                    DrillDownPageId = "Approved Expense List";
                    ToolTip = 'Number of approved payment requests ready to post.';
                    Style = Favorable;
                    StyleExpr = Rec."Approved Expense Requests" > 0;
                }
                field("Posted Payment Requests"; Rec."Posted Expense Requests")
                {
                    ApplicationArea = All;
                    Caption = 'Posted';
                    DrillDownPageId = "Posted Expense Requsitions";
                    ToolTip = 'Number of posted payment requests.';
                }

                actions
                {
                    action(NewExpenseRequest)
                    {
                        ApplicationArea = All;
                        Caption = 'New Payment Request';
                        Image = TileNew;
                        RunObject = page "Expense Card";
                        RunPageMode = Create;
                        ToolTip = 'Create a new payment request.';
                    }
                }
            }
            cuegroup(StoreRequisitions)
            {
                Caption = 'Store Requisitions';
                ShowCaption = true;

                field("Open Store Requisitions"; Rec."Open Store Requisitions")
                {
                    ApplicationArea = All;
                    Caption = 'Open';
                    DrillDownPageId = "Store Requisition List";
                    ToolTip = 'Number of store requisitions awaiting submission.';
                }
                field("Pending Store Requisitions"; Rec."Pending Store Requisitions")
                {
                    ApplicationArea = All;
                    Caption = 'Pending Approval';
                    DrillDownPageId = "Store Requisition List";
                    ToolTip = 'Number of store requisitions pending approval.';
                    Style = Attention;
                    StyleExpr = Rec."Pending Store Requisitions" > 0;
                }
                field("Approved Store Requisitions"; Rec."Approved Store Requisitions")
                {
                    ApplicationArea = All;
                    Caption = 'Approved';
                    DrillDownPageId = "Store Requisition List";
                    ToolTip = 'Number of approved store requisitions ready to issue.';
                    Style = Favorable;
                    StyleExpr = Rec."Approved Store Requisitions" > 0;
                }
                field("Posted Store Requisitions"; Rec."Posted Store Requisitions")
                {
                    ApplicationArea = All;
                    Caption = 'Posted';
                    DrillDownPageId = "Store Requisition List";
                    ToolTip = 'Number of posted store requisitions.';
                }

                actions
                {
                    action(NewStoreRequisition)
                    {
                        ApplicationArea = All;
                        Caption = 'New Requisition';
                        Image = TileNew;
                        RunObject = page "Store Requisition Card";
                        RunPageMode = Create;
                        ToolTip = 'Create a new store requisition.';
                    }
                }
            }
            cuegroup(StoreReturns)
            {
                Caption = 'Store Returns';
                ShowCaption = true;

                field("Open Store Returns"; Rec."Open Store Returns")
                {
                    ApplicationArea = All;
                    Caption = 'Open';
                    DrillDownPageId = "Store Return List";
                    ToolTip = 'Number of store returns awaiting submission.';
                }
                field("Pending Store Returns"; Rec."Pending Store Returns")
                {
                    ApplicationArea = All;
                    Caption = 'Pending Approval';
                    DrillDownPageId = "Store Return List";
                    ToolTip = 'Number of store returns pending approval.';
                    Style = Attention;
                    StyleExpr = Rec."Pending Store Returns" > 0;
                }
                field("Approved Store Returns"; Rec."Approved Store Returns")
                {
                    ApplicationArea = All;
                    Caption = 'Approved';
                    DrillDownPageId = "Store Return List";
                    ToolTip = 'Number of approved store returns ready to post.';
                    Style = Favorable;
                    StyleExpr = Rec."Approved Store Returns" > 0;
                }
                field("Posted Store Returns"; Rec."Posted Store Returns")
                {
                    ApplicationArea = All;
                    Caption = 'Posted';
                    DrillDownPageId = "Store Return List";
                    ToolTip = 'Number of posted store returns.';
                }

                actions
                {
                    action(NewStoreReturn)
                    {
                        ApplicationArea = All;
                        Caption = 'New Return';
                        Image = TileNew;
                        RunObject = page "Store Return Card";
                        RunPageMode = Create;
                        ToolTip = 'Create a new store return.';
                    }
                }
            }
            cuegroup(Approvals)
            {
                Caption = 'Approval Workflow';
                ShowCaption = true;

                field("Open Approval Entries"; Rec."Open Approval Entries")
                {
                    ApplicationArea = All;
                    Caption = 'Open Entries';
                    DrillDownPageId = "Document Approval Entries";
                    ToolTip = 'Number of open approval entries.';
                }
                field("Pending Approval Entries"; Rec."Pending Approval Entries")
                {
                    ApplicationArea = All;
                    Caption = 'Pending';
                    DrillDownPageId = "Document Approval Entries";
                    ToolTip = 'Number of entries pending approval.';
                    Style = Attention;
                    StyleExpr = Rec."Pending Approval Entries" > 0;
                }
                field("Approved Entries"; Rec."Approved Entries")
                {
                    ApplicationArea = All;
                    Caption = 'Approved';
                    DrillDownPageId = "Document Approval Entries";
                    ToolTip = 'Number of approved entries.';
                    Style = Favorable;
                    StyleExpr = Rec."Approved Entries" > 0;
                }
                field("Rejected Entries"; Rec."Rejected Entries")
                {
                    ApplicationArea = All;
                    Caption = 'Rejected';
                    DrillDownPageId = "Document Approval Entries";
                    ToolTip = 'Number of rejected entries.';
                    Style = Unfavorable;
                    StyleExpr = Rec."Rejected Entries" > 0;
                }

                actions
                {
                    action(ViewApprovals)
                    {
                        ApplicationArea = All;
                        Caption = 'All Approvals';
                        Image = TileInfo;
                        RunObject = page "Document Approval Entries";
                        ToolTip = 'View all document approval entries.';
                    }
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.GetOrCreate();
    end;
}
