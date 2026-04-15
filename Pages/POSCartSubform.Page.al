page 53304 "POS Cart Subform"
{
    Caption = 'Cart Lines';
    PageType = ListPart;
    SourceTable = "POS Transaction Line";
    AutoSplitKey = true;
    DelayedInsert = true;

    layout
    {
        area(Content)
        {
            repeater(Lines)
            {
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the item number.';

                    trigger OnValidate()
                    begin
                        CurrPage.Update();
                    end;
                }
                field(Barcode; Rec.Barcode)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the barcode scanned.';
                    Visible = false;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the item description.';
                    Editable = false;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the quantity.';
                    BlankZero = true;

                    trigger OnValidate()
                    begin
                        CurrPage.Update();
                    end;
                }
                field("Unit of Measure Code"; Rec."Unit of Measure Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the unit of measure.';
                    Visible = false;
                }
                field("Unit Price"; Rec."Unit Price")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the unit price.';
                    Editable = AllowPriceOverride;

                    trigger OnValidate()
                    begin
                        CurrPage.Update();
                    end;
                }
                field("Discount %"; Rec."Discount %")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the line discount percentage.';
                    BlankZero = true;

                    trigger OnValidate()
                    begin
                        CurrPage.Update();
                    end;
                }
                field("Line Amount"; Rec."Line Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the line amount.';
                    Editable = false;
                    Style = Strong;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(IncrementQty)
            {
                ApplicationArea = All;
                Caption = '+1';
                Image = Add;
                ToolTip = 'Add one to quantity.';

                trigger OnAction()
                begin
                    Rec.Validate(Quantity, Rec.Quantity + 1);
                    Rec.Modify(true);
                    CurrPage.Update();
                end;
            }
            action(DecrementQty)
            {
                ApplicationArea = All;
                Caption = '-1';
                Image = RemoveFilterLines;
                ToolTip = 'Subtract one from quantity.';

                trigger OnAction()
                begin
                    if Rec.Quantity > 1 then begin
                        Rec.Validate(Quantity, Rec.Quantity - 1);
                        Rec.Modify(true);
                    end else
                        Rec.Delete(true);
                    CurrPage.Update();
                end;
            }
            action(RemoveLine)
            {
                ApplicationArea = All;
                Caption = 'Remove';
                Image = Delete;
                ToolTip = 'Remove this line from the cart.';

                trigger OnAction()
                begin
                    Rec.Delete(true);
                    CurrPage.Update();
                end;
            }
        }
    }

    var
        AllowPriceOverride: Boolean;

    trigger OnOpenPage()
    var
        POSSetup: Record "POS Setup";
    begin
        POSSetup.GetSetup();
        AllowPriceOverride := POSSetup."Allow Price Override";
    end;
}
