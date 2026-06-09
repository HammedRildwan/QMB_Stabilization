tableextension 53014 "Purch. Inv. Header Ext" extends "Purch. Inv. Header"
{
    fields
    {
        field(50000; "Expense Remaining Balance"; Decimal)
        {
            Caption = 'Expense Remaining Balance';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50001; "Expense Balance Initialized"; Boolean)
        {
            Caption = 'Expense Balance Initialized';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50002; "Expense Fully Paid"; Boolean)
        {
            Caption = 'Expense Fully Paid';
            DataClassification = ToBeClassified;
            Editable = false;
        }
    }
}
