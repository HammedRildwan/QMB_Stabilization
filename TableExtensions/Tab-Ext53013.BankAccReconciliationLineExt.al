tableextension 53013 "BankAcc.ReconciliationLine Ext" extends "Bank Acc. Reconciliation Line"
{
    fields
    {
        field(50000; "Debit Amount"; Decimal)
        {
            Caption = 'Debit Amount';
            DataClassification = ToBeClassified;
        }
        field(50001; "Credit Amount"; Decimal)
        {
            Caption = 'Credit Amount';
            DataClassification = ToBeClassified;
        }
        field(50002; "Exception Reason"; Option)
        {
            Caption = 'Exception Reason';
            DataClassification = ToBeClassified;
            OptionMembers = " ","Unpresented Cheque","Uncredited Lodgement","Bank Charges","Unrecognized Transfers",Others;
            trigger OnValidate()
            BEGIN
                IF Difference = 0 THEN
                    ERROR('There is no exception here!');
            END;

        }
        field(50003; "Applied Debit Amount"; Decimal)
        {
            Caption = 'Applied Debit Amount';
            DataClassification = ToBeClassified;
        }
        field(50004; "Applied Credit Amount"; Decimal)
        {
            Caption = 'Applied Credit Amount';
            DataClassification = ToBeClassified;
        }

    }
}
