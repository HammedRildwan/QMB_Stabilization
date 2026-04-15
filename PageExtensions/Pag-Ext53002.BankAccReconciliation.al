pageextension 53002 "Bank Acc. Reconciliation " extends "Bank Acc. Reconciliation"
{
    layout
    {
        addafter(ApplyBankLedgerEntries)
        {

            field("Total Applied Credit Amount"; Rec."Total Applied Credit Amount")
            {
                ApplicationArea = All;
                Caption = 'Total Applied Credit Amount';
                ToolTip = 'Total Applied Credit Amount Specifies';
            }

            field("Total Applied Debit Amount"; Rec."Total Applied Debit Amount")
            {
                ApplicationArea = All;
                Caption = 'Total Applied Debit Amount';
                ToolTip = 'Specifies Total Applied Debit Amount';
            }

            field("Total Transaction Cred. Amount"; Rec."Total Transaction Cred. Amount")
            {
                ApplicationArea = All;
                Caption = 'Total Transaction Cred. Amount';
                ToolTip = 'Specifies Total Transaction Cred. Amount';
            }

            field("Total Transaction Debit Amount"; Rec."Total Transaction Debit Amount")
            {
                ApplicationArea = All;
                Caption = 'Total Transaction Debit Amount';
                ToolTip = 'Specifies Total Transaction Debit Amount';
            }

            field("Total Unreconciled Ledger Ent."; Rec."Total Unreconciled Ledger Ent.")
            {
                ApplicationArea = All;
                Caption = 'Total Unreconciled Ledger Ent.';
                ToolTip = 'Specifies Total Unreconciled Ledger Ent.';
            }


        }

    }
    actions
    {
        modify(ImportBankStatement)
        {
            visible = false;
        }
        modify(MatchAutomatically)
        {
            Visible = false;
        }
        addafter(ImportBankStatement)
        {

            action(ImportBankStatement2)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Import Bank Statement';
                RunObject = XmlPort 53011;
                Image = Import;
                ToolTip = 'Import electronic bank statements from your bank to populate with data about actual bank transactions.';
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;

            }
        }
        addafter(MatchAutomatically)
        {
            action(MatchAutomatically_Modified)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Match Automatically';
                Image = MapAccounts;
                ToolTip = 'Automatically search for and match bank statement lines.';
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;


                trigger OnAction()
                begin
                    Rec.SetRange("Statement Type", Rec."Statement Type");
                    Rec.SetRange("Bank Account No.", Rec."Bank Account No.");
                    Rec.SetRange("Statement No.", Rec."Statement No.");
                    REPORT.Run(REPORT::"Match Bank Entries", false, true, Rec);
                end;
            }
        }
        addafter(NotMatched)
        {
            action(LockMatchToPeriod)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Lock Match to Period';
                Image = Lock;
                Promoted = true;
                PromotedCategory = Category5;
                ToolTip = 'Lock the matched records to the reconciliation period.';

                trigger OnAction()
                begin
                    IF CONFIRM('Are you ready to lock Reconciliation Matching for the period?', TRUE) THEN BEGIN
                        UnreconBankLegderSchedule2.SETFILTER("Bank Account No.", '%1', Rec."Bank Account No.");
                        UnreconBankLegderSchedule2.SETFILTER("Rec. Statement No.", '%1', Rec."Statement No.");
                        IF UnreconBankLegderSchedule2.FINDSET THEN
                            UnreconBankLegderSchedule2.DELETEALL;

                        BankAccountLedgerEntry.SETCURRENTKEY("Bank Account No.", "Posting Date");
                        BankAccountLedgerEntry.SETFILTER("Bank Account No.", '%1', Rec."Bank Account No.");
                        BankAccountLedgerEntry.SETFILTER("Posting Date", '<=%1', Rec."Statement Date");
                        BankAccountLedgerEntry.SETFILTER(Reversed, '%1', FALSE);
                        BankAccountLedgerEntry.SETFILTER("Statement Status", '<>%1', BankAccountLedgerEntry."Statement Status"::"Bank Acc. Entry Applied");
                        IF BankAccountLedgerEntry.FINDSET THEN BEGIN
                            REPEAT
                                IF BankAccountLedgerEntry."LockedReconciliationNo." <> '' THEN
                                    BankAccountLedgerEntry."LockedReconciliationNo." := '';
                                IF BankAccountLedgerEntry.StatusatLock <> BankAccountLedgerEntry.StatusatLock::" " THEN
                                    BankAccountLedgerEntry.StatusatLock := BankAccountLedgerEntry.StatusatLock::" ";
                                BankAccountLedgerEntry.MODIFY;

                                //Transfer records to table 50017
                                UnreconBankLegderSchedule.RESET;
                                UnreconBankLegderSchedule.INIT;
                                UnreconBankLegderSchedule."Rec. Statement No." := Rec."Statement No.";
                                UnreconBankLegderSchedule."Bank Account No." := Rec."Bank Account No.";
                                UnreconBankLegderSchedule."Entry No." := BankAccountLedgerEntry."Entry No.";
                                UnreconBankLegderSchedule."Posting Date" := BankAccountLedgerEntry."Posting Date";
                                UnreconBankLegderSchedule."Document No." := BankAccountLedgerEntry."Document No.";
                                UnreconBankLegderSchedule.Description := BankAccountLedgerEntry.Description;
                                UnreconBankLegderSchedule.Amount := BankAccountLedgerEntry.Amount;
                                UnreconBankLegderSchedule."Amount (LCY)" := BankAccountLedgerEntry."Amount (LCY)";
                                UnreconBankLegderSchedule."Transaction No." := BankAccountLedgerEntry."Transaction No.";
                                UnreconBankLegderSchedule."Statement Status" := BankAccountLedgerEntry."Statement Status";
                                UnreconBankLegderSchedule."Statement No." := BankAccountLedgerEntry."Statement No.";
                                UnreconBankLegderSchedule."Statement Line No." := BankAccountLedgerEntry."Statement Line No.";
                                UnreconBankLegderSchedule."Document Date" := BankAccountLedgerEntry."Document Date";
                                UnreconBankLegderSchedule."External Document No." := BankAccountLedgerEntry."External Document No.";
                                UnreconBankLegderSchedule."Locked Reconciliation No." := Rec."Statement No.";
                                IF BankAccountLedgerEntry."Statement Status" = BankAccountLedgerEntry."Statement Status"::Open THEN
                                    UnreconBankLegderSchedule."Status at Lock" := BankAccountLedgerEntry.StatusatLock::Open
                                ELSE
                                    UnreconBankLegderSchedule."Status at Lock" := BankAccountLedgerEntry.StatusatLock::Closed;
                                UnreconBankLegderSchedule.INSERT;

                            UNTIL BankAccountLedgerEntry.NEXT = 0;
                            MESSAGE('Locking Completed!');
                        END;
                    END;
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        BankAccReconciliationLine.SETFILTER("Bank Account No.", '%1', Rec."Bank Account No.");
        BankAccReconciliationLine.SETFILTER("Statement No.", '%1', Rec."Statement No.");
        IF BankAccReconciliationLine.FINDFIRST THEN BEGIN
            REPEAT
                IF BankAccReconciliationLine."Applied Amount" > 0 THEN
                    BankAccReconciliationLine."Applied Debit Amount" := BankAccReconciliationLine."Applied Amount";
                IF BankAccReconciliationLine."Applied Amount" < 0 THEN
                    BankAccReconciliationLine."Applied Credit Amount" := BankAccReconciliationLine."Applied Amount";
                BankAccReconciliationLine.MODIFY;
            UNTIL BankAccReconciliationLine.NEXT = 0;
        END;
        Rec.CALCFIELDS("Total Applied Debit Amount", "Total Applied Credit Amount");
    end;

    var
        BankAccReconciliationLine: Record "Bank Acc. Reconciliation Line";
        BankAccountLedgerEntry: Record "Bank Account Ledger Entry";
        UnreconBankLegderSchedule: Record "Unrecon. Bank Legder Schedule";
        UnreconBankLegderSchedule2: Record "Unrecon. Bank Legder Schedule";
}
