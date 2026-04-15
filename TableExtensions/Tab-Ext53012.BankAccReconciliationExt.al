tableextension 53012 "BankAcc.ReconciliationExt" extends "Bank Acc. Reconciliation"
{
    fields
    {
        field(53000; "Total Applied Debit Amount"; Decimal)
        {
            Caption = 'Total Applied Debit Amount';
            //DataClassification = ToBeClassified;
            FieldClass = FlowField;
            CalcFormula = Sum("Bank Acc. Reconciliation Line"."Applied Debit Amount" WHERE("Statement Type" = FIELD("Statement Type"),
                                                                                                                                 "Bank Account No." = FIELD("Bank Account No."),
                                                                                                                                 "Statement No." = FIELD("Statement No.")));
        }
        field(50001; "Total Applied Credit Amount"; Decimal)
        {
            Caption = 'Total Applied Credit Amount';
            FieldClass = FlowField;
            CalcFormula = Sum("Bank Acc. Reconciliation Line"."Applied Credit Amount" WHERE("Statement Type" = FIELD("Statement Type"),
                                                                                                                                  "Bank Account No." = FIELD("Bank Account No."),
                                                                                                                                  "Statement No." = FIELD("Statement No.")));
        }
        field(50002; "Total Transaction Debit Amount"; Decimal)
        {
            Caption = 'Total Transaction Debit Amount';
            FieldClass = FlowField;
            CalcFormula = Sum("Bank Acc. Reconciliation Line"."Statement Amount" WHERE("Statement Type" = FIELD("Statement Type"),
                                                                                                                             "Bank Account No." = FIELD("Bank Account No."),
                                                                                                                             "Statement No." = FIELD("Statement No."),
                                                                                                                             "Statement Amount" = FILTER(> 0)));
        }
        field(50003; "Total Transaction Cred. Amount"; Decimal)
        {
            Caption = 'Total Transaction Cred. Amount';
            FieldClass = FlowField;
            CalcFormula = Sum("Bank Acc. Reconciliation Line"."Statement Amount" WHERE("Statement Type" = FIELD("Statement Type"),
                                                                                                                            "Bank Account No." = FIELD("Bank Account No."),
                                                                                                                             "Statement No." = FIELD("Statement No."),
                                                                                                                             "Statement Amount" = FILTER(< 0)));
        }
        field(50004; "Total Unreconciled Ledger Ent."; Decimal)
        {
            Caption = 'Total Unreconciled Ledger Ent.';
            FieldClass = FlowField;
            CalcFormula = Sum("Unrecon. Bank Legder Schedule".Amount WHERE("Locked Reconciliation No." = FIELD("Statement No."),
                                                                                                                 "Bank Account No." = FIELD("Bank Account No."),
                                                                                                                 "Status at Lock" = CONST(Open),
                                                                                                                 Amount = FILTER(< 0)));
        }
    }
}
