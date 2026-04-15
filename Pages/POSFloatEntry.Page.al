page 53309 "POS Float Entry"
{
    Caption = 'Opening Float';
    PageType = StandardDialog;
    SourceTable = "POS Shift";
    Editable = true;

    layout
    {
        area(Content)
        {
            group(FloatGroup)
            {
                Caption = 'Enter Opening Float';
                ShowCaption = false;

                field(OpeningFloatEntry; Rec."Opening Float")
                {
                    ApplicationArea = All;
                    Caption = 'Opening Float Amount';
                    ToolTip = 'Enter the opening cash float for this shift.';
                    BlankZero = true;
                }
                field(Notes; OpeningNotes)
                {
                    ApplicationArea = All;
                    Caption = 'Notes';
                    ToolTip = 'Optional notes about the shift opening.';
                    MultiLine = true;
                }
            }
        }
    }

    var
        OpeningNotes: Text[250];

    procedure GetOpeningFloat(): Decimal
    begin
        exit(Rec."Opening Float");
    end;
}
