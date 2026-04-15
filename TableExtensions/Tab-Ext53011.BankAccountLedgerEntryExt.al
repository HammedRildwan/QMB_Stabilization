tableextension 53011 BankAccountLedgerEntryExt extends "Bank Account Ledger Entry"
{
    fields
    {
        field(50000; "LockedReconciliationNo."; Code[20])
        {
            Caption = 'Locked Reconciliation No.';
            DataClassification = ToBeClassified;
            tableRelation = "Bank Acc. Reconciliation Line"."Statement No." WHERE("Bank Account No." = FIELD("Bank Account No."));
            ValidateTableRelation = false;
        }
        field(50001; StatusatLock; Option)
        {
            Caption = 'Status at Lock';
            DataClassification = ToBeClassified;
            OptionMembers = " ",Open,Closed;
        }
    }
}
