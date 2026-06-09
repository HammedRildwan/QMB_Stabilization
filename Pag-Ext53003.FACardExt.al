pageextension 53030 FACardExt extends "Fixed Asset Card"
{
    layout
    {
        addafter(BookValue)
        {
            field(MaintenanceExpense; MaintenanceExpenseValue)
            {
                ApplicationArea = All;
                Caption = 'Maintenance Expense Value';

            }
        }


    }

    trigger OnAfterGetRecord()
    begin
        MaintenanceExpenseValue := GetMaintenanceExpenseValue();
    end;

    var
        MaintenanceLE: Record "Maintenance Ledger Entry";
        MaintenanceExpenseValue: Decimal;

    local procedure GetMaintenanceExpenseValue(): Decimal
    begin
        // Implement the logic to calculate the maintenance expense value


        exit(0);
    end;


}