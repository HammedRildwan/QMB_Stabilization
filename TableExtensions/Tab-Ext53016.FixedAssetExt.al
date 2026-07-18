tableextension 53016 "Fixed Asset Ext" extends "Fixed Asset"
{
    fields
    {
        field(53000; "Maintenance Expense Value"; Decimal)
        {
            Caption = 'Maintenance Expense Value';
            FieldClass = FlowField;
            CalcFormula = sum("Maintenance Ledger Entry".Amount where("FA No." = field("No.")));
            Editable = false;
        }
    }
}
