enum 53611 "POS Payment Method"
{
    Caption = 'POS Payment Method';
    Extensible = true;

    value(0; Cash)
    {
        Caption = 'Cash';
    }
    value(1; Card)
    {
        Caption = 'Card';
    }
    value(2; Voucher)
    {
        Caption = 'Voucher';
    }
    value(3; "Mobile Money")
    {
        Caption = 'Mobile Money';
    }
    value(4; "Bank Transfer")
    {
        Caption = 'Bank Transfer';
    }
}
