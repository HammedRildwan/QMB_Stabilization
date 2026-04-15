page 53305 "POS Payment Dialog"
{
    Caption = 'Payment';
    PageType = StandardDialog;
    Editable = true;

    layout
    {
        area(Content)
        {
            group(PaymentInfo)
            {
                Caption = 'Payment Information';
                ShowCaption = false;

                field(AmountDueDisplay; AmountDue)
                {
                    ApplicationArea = All;
                    Caption = 'Amount Due';
                    ToolTip = 'Specifies the amount remaining to pay.';
                    Editable = false;
                    Style = Strong;
                }
                field(TenderedAmountField; TenderedAmount)
                {
                    ApplicationArea = All;
                    Caption = 'Tendered Amount';
                    ToolTip = 'Enter the amount tendered by customer.';
                    BlankZero = true;

                    trigger OnValidate()
                    begin
                        CalculateChange();
                    end;
                }
                field(ChangeAmountField; ChangeAmount)
                {
                    ApplicationArea = All;
                    Caption = 'Change';
                    ToolTip = 'Specifies the change to give back.';
                    Editable = false;
                    Style = Favorable;
                    StyleExpr = ChangeAmount > 0;
                }
            }
            group(QuickAmounts)
            {
                Caption = 'Quick Amounts';
                ShowCaption = true;

                field(QuickAmount1; QuickAmountCaption1)
                {
                    ApplicationArea = All;
                    Caption = '';
                    Editable = false;
                    ShowCaption = false;

                    trigger OnDrillDown()
                    begin
                        TenderedAmount := RoundToNearest(AmountDue, 100);
                        CalculateChange();
                    end;
                }
                field(QuickAmount2; QuickAmountCaption2)
                {
                    ApplicationArea = All;
                    Caption = '';
                    Editable = false;
                    ShowCaption = false;

                    trigger OnDrillDown()
                    begin
                        TenderedAmount := RoundToNearest(AmountDue, 500);
                        CalculateChange();
                    end;
                }
                field(QuickAmount3; QuickAmountCaption3)
                {
                    ApplicationArea = All;
                    Caption = '';
                    Editable = false;
                    ShowCaption = false;

                    trigger OnDrillDown()
                    begin
                        TenderedAmount := RoundToNearest(AmountDue, 1000);
                        CalculateChange();
                    end;
                }
                field(ExactAmount; ExactAmountCaption)
                {
                    ApplicationArea = All;
                    Caption = '';
                    Editable = false;
                    ShowCaption = false;

                    trigger OnDrillDown()
                    begin
                        TenderedAmount := AmountDue;
                        CalculateChange();
                    end;
                }
            }
        }
    }

    var
        AmountDue: Decimal;
        TenderedAmount: Decimal;
        ChangeAmount: Decimal;
        QuickAmountCaption1: Text[50];
        QuickAmountCaption2: Text[50];
        QuickAmountCaption3: Text[50];
        ExactAmountCaption: Text[50];

    procedure SetAmountDue(NewAmount: Decimal)
    begin
        AmountDue := NewAmount;
        TenderedAmount := AmountDue;
        CalculateChange();
        SetQuickAmountCaptions();
    end;

    procedure GetTenderedAmount(): Decimal
    begin
        exit(TenderedAmount);
    end;

    local procedure CalculateChange()
    begin
        if TenderedAmount >= AmountDue then
            ChangeAmount := TenderedAmount - AmountDue
        else
            ChangeAmount := 0;
    end;

    local procedure RoundToNearest(Amount: Decimal; RoundTo: Decimal): Decimal
    begin
        exit(Round(Amount / RoundTo, 1, '>') * RoundTo);
    end;

    local procedure SetQuickAmountCaptions()
    begin
        QuickAmountCaption1 := StrSubstNo('Nearest 100: %1', Format(RoundToNearest(AmountDue, 100), 0, '<Precision,2><Standard Format,0>'));
        QuickAmountCaption2 := StrSubstNo('Nearest 500: %1', Format(RoundToNearest(AmountDue, 500), 0, '<Precision,2><Standard Format,0>'));
        QuickAmountCaption3 := StrSubstNo('Nearest 1000: %1', Format(RoundToNearest(AmountDue, 1000), 0, '<Precision,2><Standard Format,0>'));
        ExactAmountCaption := StrSubstNo('Exact: %1', Format(AmountDue, 0, '<Precision,2><Standard Format,0>'));
    end;
}
