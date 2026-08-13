pageextension 53030 FACardExt extends "Fixed Asset Card"
{
    layout
    {
        addafter(BookValue)
        {
            field(MaintenanceExpense; Rec."Maintenance Expense Value")
            {
                ApplicationArea = All;
                Caption = 'Maintenance Expense Value';
                Editable = false;
            }
        }


    }
}