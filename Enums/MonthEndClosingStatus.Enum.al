enum 53602 "Month-End Closing Status"
{
    Caption = 'Month-End Closing Status';
    Extensible = true;

    value(0; Open)
    {
        Caption = 'Open';
    }
    value(1; "In Progress")
    {
        Caption = 'In Progress';
    }
    value(2; Completed)
    {
        Caption = 'Completed';
    }
    value(3; Cancelled)
    {
        Caption = 'Cancelled';
    }
}
