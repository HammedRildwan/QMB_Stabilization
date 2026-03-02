// ------------------------------------------------------------------------------------------------
// Role Center Headlines Provider
// Displays dynamic headline messages for EthicalDynamics365 Role Centers
// ------------------------------------------------------------------------------------------------
page 70600 "QMB Stab. RC Headlines"
{
    Caption = 'Headlines';
    PageType = HeadlinePart;
    //ApplicationArea = All;

    layout
    {
        area(Content)
        {
            group(Control1)
            {
                ShowCaption = false;

                field(GreetingText; GreetingText)
                {
                    ApplicationArea = All;
                    Caption = 'Greeting';
                    ShowCaption = false;
                    Editable = false;
                }
                field(PaymentHeadline; PaymentHeadline)
                {
                    ApplicationArea = All;
                    Caption = 'Payments';
                    ShowCaption = false;
                    Editable = false;
                    Visible = ShowPaymentHeadline;

                    trigger OnDrillDown()
                    begin
                        Page.Run(Page::"Expense List");
                    end;
                }
                field(ApprovalHeadline; ApprovalHeadline)
                {
                    ApplicationArea = All;
                    Caption = 'Approvals';
                    ShowCaption = false;
                    Editable = false;
                    Visible = ShowApprovalHeadline;

                    trigger OnDrillDown()
                    begin
                        Page.Run(Page::"Document Approval Entries");
                    end;
                }
                field(StoreRequisitionHeadline; StoreRequisitionHeadline)
                {
                    ApplicationArea = All;
                    Caption = 'Store Requisitions';
                    ShowCaption = false;
                    Editable = false;
                    Visible = ShowStoreRequisitionHeadline;

                    trigger OnDrillDown()
                    begin
                        Page.Run(Page::"Store Requisition List");
                    end;
                }
                field(StoreReturnHeadline; StoreReturnHeadline)
                {
                    ApplicationArea = All;
                    Caption = 'Store Returns';
                    ShowCaption = false;
                    Editable = false;
                    Visible = ShowStoreReturnHeadline;

                    trigger OnDrillDown()
                    begin
                        Page.Run(Page::"Store Return List");
                    end;
                }
                field(BudgetHeadline; BudgetHeadline)
                {
                    ApplicationArea = All;
                    Caption = 'Budget';
                    ShowCaption = false;
                    Editable = false;
                    Visible = ShowBudgetHeadline;

                    trigger OnDrillDown()
                    begin
                        Page.Run(Page::"Approved Expense List");
                    end;
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        ComputeHeadlines();
    end;

    var
        GreetingText: Text;
        PaymentHeadline: Text;
        ApprovalHeadline: Text;
        StoreRequisitionHeadline: Text;
        StoreReturnHeadline: Text;
        BudgetHeadline: Text;
        ShowPaymentHeadline: Boolean;
        ShowApprovalHeadline: Boolean;
        ShowStoreRequisitionHeadline: Boolean;
        ShowStoreReturnHeadline: Boolean;
        ShowBudgetHeadline: Boolean;

    local procedure ComputeHeadlines()
    var
        RCCue: Record "QMB Stab. Role Center Cue";
        ActivePayments: Integer;
        PendingApprovals: Integer;
        OpenStoreRequisitions: Integer;
        PendingStoreReturns: Integer;
        ApprovedExpenseAmount: Decimal;
        TimeOfDay: Integer;
        GreetingLbl: Label 'Good %1, %2!', Comment = '%1 = morning/afternoon/evening, %2 = user name';
        MorningLbl: Label 'morning';
        AfternoonLbl: Label 'afternoon';
        EveningLbl: Label 'evening';
        PaymentHeadlineLbl: Label 'You have <emphasize>%1 active payment requests</emphasize> awaiting processing.', Comment = '%1 = count';
        ApprovalHeadlineLbl: Label 'There are <emphasize>%1 pending approvals</emphasize> waiting for your attention.', Comment = '%1 = count';
        StoreRequisitionHeadlineLbl: Label '<emphasize>%1 store requisitions</emphasize> are open and need attention.', Comment = '%1 = count';
        StoreReturnHeadlineLbl: Label '<emphasize>%1 store returns</emphasize> are pending approval.', Comment = '%1 = count';
        BudgetHeadlineLbl: Label '<emphasize>%1</emphasize> in approved expenses ready to post.', Comment = '%1 = amount';
    begin
        // Compute greeting based on time of day
        TimeOfDay := Time2Int(Time);
        if TimeOfDay < 43200000 then // Before 12:00
            GreetingText := StrSubstNo(GreetingLbl, MorningLbl, GetUserGreetingName())
        else if TimeOfDay < 64800000 then // Before 18:00
            GreetingText := StrSubstNo(GreetingLbl, AfternoonLbl, GetUserGreetingName())
        else
            GreetingText := StrSubstNo(GreetingLbl, EveningLbl, GetUserGreetingName());

        // Get or create cue record
        RCCue.GetOrCreate();

        // Compute payment headline
        RCCue.CalcFields("Open Expense Requests", "Pending Expense Approvals");
        ActivePayments := RCCue."Open Expense Requests" + RCCue."Pending Expense Approvals";

        ShowPaymentHeadline := ActivePayments > 0;
        if ShowPaymentHeadline then
            PaymentHeadline := StrSubstNo(PaymentHeadlineLbl, ActivePayments);

        // Compute approvals headline
        RCCue.SetFilter("User ID Filter", UserId);
        RCCue.CalcFields("My Pending Approvals");
        PendingApprovals := RCCue."My Pending Approvals";

        ShowApprovalHeadline := PendingApprovals > 0;
        if ShowApprovalHeadline then
            ApprovalHeadline := StrSubstNo(ApprovalHeadlineLbl, PendingApprovals);

        // Compute store requisition headline
        RCCue.CalcFields("Open Store Requisitions", "Pending Store Requisitions");
        OpenStoreRequisitions := RCCue."Open Store Requisitions" + RCCue."Pending Store Requisitions";

        ShowStoreRequisitionHeadline := OpenStoreRequisitions > 0;
        if ShowStoreRequisitionHeadline then
            StoreRequisitionHeadline := StrSubstNo(StoreRequisitionHeadlineLbl, OpenStoreRequisitions);

        // Compute store return headline
        RCCue.CalcFields("Pending Store Returns");
        PendingStoreReturns := RCCue."Pending Store Returns";

        ShowStoreReturnHeadline := PendingStoreReturns > 0;
        if ShowStoreReturnHeadline then
            StoreReturnHeadline := StrSubstNo(StoreReturnHeadlineLbl, PendingStoreReturns);

        // Compute budget headline
        RCCue.CalcFields("Total Expense Amount");
        ApprovedExpenseAmount := RCCue."Total Expense Amount";

        ShowBudgetHeadline := ApprovedExpenseAmount > 0;
        if ShowBudgetHeadline then
            BudgetHeadline := StrSubstNo(BudgetHeadlineLbl, Format(ApprovedExpenseAmount, 0, '<Precision,2><Standard Format,0>'));
    end;

    local procedure GetUserGreetingName(): Text
    var
        User: Record User;
    begin
        if User.Get(UserSecurityId()) then begin
            if User."Full Name" <> '' then
                exit(User."Full Name");
        end;
        exit(UserId);
    end;

    local procedure Time2Int(TimeValue: Time): Integer
    begin
        // Convert time to milliseconds since midnight
        exit((TimeValue - 000000T) div 1);
    end;
}
