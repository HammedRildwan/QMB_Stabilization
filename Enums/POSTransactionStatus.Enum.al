enum 53610 "POS Transaction Status"
{
    Caption = 'POS Transaction Status';
    Extensible = true;

    value(0; Open)
    {
        Caption = 'Open';
    }
    value(1; Paid)
    {
        Caption = 'Paid';
    }
    value(2; Posted)
    {
        Caption = 'Posted';
    }
    value(3; Voided)
    {
        Caption = 'Voided';
    }
}
