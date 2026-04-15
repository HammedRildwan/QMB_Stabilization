table 53107 "POS Role Center Cue"
{
    Caption = 'POS Role Center Cue';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
            DataClassification = CustomerContent;
        }
        // FlowFilters
        field(10; "Date Filter"; Date)
        {
            Caption = 'Date Filter';
            FieldClass = FlowFilter;
        }
        field(11; "Business Section Filter"; Enum "POS Business Section")
        {
            Caption = 'Business Section Filter';
            FieldClass = FlowFilter;
        }
        field(12; "Terminal Filter"; Code[10])
        {
            Caption = 'Terminal Filter';
            FieldClass = FlowFilter;
        }
        field(13; "User ID Filter"; Code[50])
        {
            Caption = 'User ID Filter';
            FieldClass = FlowFilter;
        }

        // Hypermart Cues
        field(100; "Hypermart Today Sales"; Decimal)
        {
            Caption = 'Hypermart Today Sales';
            FieldClass = FlowField;
            CalcFormula = sum("POS Transaction Header"."Total Amount" where(
                "Business Section" = const(Hypermart),
                "Transaction Date" = field("Date Filter"),
                Status = const(Posted)));
            Editable = false;
        }
        field(101; "Hypermart Open Trans"; Integer)
        {
            Caption = 'Hypermart Open Transactions';
            FieldClass = FlowField;
            CalcFormula = count("POS Transaction Header" where(
                "Business Section" = const(Hypermart),
                Status = const(Open)));
            Editable = false;
        }
        field(102; "Hypermart Active Terminals"; Integer)
        {
            Caption = 'Hypermart Active Terminals';
            FieldClass = FlowField;
            CalcFormula = count("POS Terminal" where(
                "Business Section" = const(Hypermart),
                Active = const(true)));
            Editable = false;
        }
        field(103; "Hypermart Open Shifts"; Integer)
        {
            Caption = 'Hypermart Open Shifts';
            FieldClass = FlowField;
            CalcFormula = count("POS Shift" where(
                "Business Section" = const(Hypermart),
                Status = const(Open)));
            Editable = false;
        }
        field(104; "Hypermart Trans Count"; Integer)
        {
            Caption = 'Hypermart Transaction Count';
            FieldClass = FlowField;
            CalcFormula = count("POS Transaction Header" where(
                "Business Section" = const(Hypermart),
                "Transaction Date" = field("Date Filter"),
                Status = const(Posted)));
            Editable = false;
        }

        // Restaurant Cues
        field(110; "Restaurant Today Sales"; Decimal)
        {
            Caption = 'Restaurant Today Sales';
            FieldClass = FlowField;
            CalcFormula = sum("POS Transaction Header"."Total Amount" where(
                "Business Section" = const(Restaurant),
                "Transaction Date" = field("Date Filter"),
                Status = const(Posted)));
            Editable = false;
        }
        field(111; "Restaurant Open Trans"; Integer)
        {
            Caption = 'Restaurant Open Transactions';
            FieldClass = FlowField;
            CalcFormula = count("POS Transaction Header" where(
                "Business Section" = const(Restaurant),
                Status = const(Open)));
            Editable = false;
        }
        field(112; "Restaurant Active Terminals"; Integer)
        {
            Caption = 'Restaurant Active Terminals';
            FieldClass = FlowField;
            CalcFormula = count("POS Terminal" where(
                "Business Section" = const(Restaurant),
                Active = const(true)));
            Editable = false;
        }
        field(113; "Restaurant Open Shifts"; Integer)
        {
            Caption = 'Restaurant Open Shifts';
            FieldClass = FlowField;
            CalcFormula = count("POS Shift" where(
                "Business Section" = const(Restaurant),
                Status = const(Open)));
            Editable = false;
        }
        field(114; "Restaurant Trans Count"; Integer)
        {
            Caption = 'Restaurant Transaction Count';
            FieldClass = FlowField;
            CalcFormula = count("POS Transaction Header" where(
                "Business Section" = const(Restaurant),
                "Transaction Date" = field("Date Filter"),
                Status = const(Posted)));
            Editable = false;
        }

        // Bar Cues
        field(120; "Bar Today Sales"; Decimal)
        {
            Caption = 'Bar Today Sales';
            FieldClass = FlowField;
            CalcFormula = sum("POS Transaction Header"."Total Amount" where(
                "Business Section" = const(Bar),
                "Transaction Date" = field("Date Filter"),
                Status = const(Posted)));
            Editable = false;
        }
        field(121; "Bar Open Trans"; Integer)
        {
            Caption = 'Bar Open Transactions';
            FieldClass = FlowField;
            CalcFormula = count("POS Transaction Header" where(
                "Business Section" = const(Bar),
                Status = const(Open)));
            Editable = false;
        }
        field(122; "Bar Active Terminals"; Integer)
        {
            Caption = 'Bar Active Terminals';
            FieldClass = FlowField;
            CalcFormula = count("POS Terminal" where(
                "Business Section" = const(Bar),
                Active = const(true)));
            Editable = false;
        }
        field(123; "Bar Open Shifts"; Integer)
        {
            Caption = 'Bar Open Shifts';
            FieldClass = FlowField;
            CalcFormula = count("POS Shift" where(
                "Business Section" = const(Bar),
                Status = const(Open)));
            Editable = false;
        }
        field(124; "Bar Trans Count"; Integer)
        {
            Caption = 'Bar Transaction Count';
            FieldClass = FlowField;
            CalcFormula = count("POS Transaction Header" where(
                "Business Section" = const(Bar),
                "Transaction Date" = field("Date Filter"),
                Status = const(Posted)));
            Editable = false;
        }

        // Laundromat Cues
        field(130; "Laundromat Today Sales"; Decimal)
        {
            Caption = 'Laundromat Today Sales';
            FieldClass = FlowField;
            CalcFormula = sum("POS Transaction Header"."Total Amount" where(
                "Business Section" = const(Laundromat),
                "Transaction Date" = field("Date Filter"),
                Status = const(Posted)));
            Editable = false;
        }
        field(131; "Laundromat Open Trans"; Integer)
        {
            Caption = 'Laundromat Open Transactions';
            FieldClass = FlowField;
            CalcFormula = count("POS Transaction Header" where(
                "Business Section" = const(Laundromat),
                Status = const(Open)));
            Editable = false;
        }
        field(132; "Laundromat Active Terminals"; Integer)
        {
            Caption = 'Laundromat Active Terminals';
            FieldClass = FlowField;
            CalcFormula = count("POS Terminal" where(
                "Business Section" = const(Laundromat),
                Active = const(true)));
            Editable = false;
        }
        field(133; "Laundromat Open Shifts"; Integer)
        {
            Caption = 'Laundromat Open Shifts';
            FieldClass = FlowField;
            CalcFormula = count("POS Shift" where(
                "Business Section" = const(Laundromat),
                Status = const(Open)));
            Editable = false;
        }
        field(134; "Laundromat Trans Count"; Integer)
        {
            Caption = 'Laundromat Transaction Count';
            FieldClass = FlowField;
            CalcFormula = count("POS Transaction Header" where(
                "Business Section" = const(Laundromat),
                "Transaction Date" = field("Date Filter"),
                Status = const(Posted)));
            Editable = false;
        }

        // Totals (All Sections)
        field(200; "Total Today Sales"; Decimal)
        {
            Caption = 'Total Today Sales';
            FieldClass = FlowField;
            CalcFormula = sum("POS Transaction Header"."Total Amount" where(
                "Transaction Date" = field("Date Filter"),
                Status = const(Posted)));
            Editable = false;
        }
        field(201; "Total Open Trans"; Integer)
        {
            Caption = 'Total Open Transactions';
            FieldClass = FlowField;
            CalcFormula = count("POS Transaction Header" where(Status = const(Open)));
            Editable = false;
        }
        field(202; "Total Active Terminals"; Integer)
        {
            Caption = 'Total Active Terminals';
            FieldClass = FlowField;
            CalcFormula = count("POS Terminal" where(Active = const(true)));
            Editable = false;
        }
        field(203; "Total Open Shifts"; Integer)
        {
            Caption = 'Total Open Shifts';
            FieldClass = FlowField;
            CalcFormula = count("POS Shift" where(Status = const(Open)));
            Editable = false;
        }
        field(204; "Total Posted Today"; Integer)
        {
            Caption = 'Total Posted Today';
            FieldClass = FlowField;
            CalcFormula = count("POS Transaction Header" where(
                "Transaction Date" = field("Date Filter"),
                Status = const(Posted)));
            Editable = false;
        }

        // My Cues (filtered by current user's terminal)
        field(300; "My Open Trans"; Integer)
        {
            Caption = 'My Open Transactions';
            FieldClass = FlowField;
            CalcFormula = count("POS Transaction Header" where(
                "Terminal ID" = field("Terminal Filter"),
                Status = const(Open)));
            Editable = false;
        }
        field(301; "My Today Sales"; Decimal)
        {
            Caption = 'My Today Sales';
            FieldClass = FlowField;
            CalcFormula = sum("POS Transaction Header"."Total Amount" where(
                "Terminal ID" = field("Terminal Filter"),
                "Transaction Date" = field("Date Filter"),
                Status = const(Posted)));
            Editable = false;
        }
        field(302; "My Transaction Count"; Integer)
        {
            Caption = 'My Transaction Count';
            FieldClass = FlowField;
            CalcFormula = count("POS Transaction Header" where(
                "Terminal ID" = field("Terminal Filter"),
                "Transaction Date" = field("Date Filter"),
                Status = const(Posted)));
            Editable = false;
        }
    }

    keys
    {
        key(PK; "Primary Key")
        {
            Clustered = true;
        }
    }

    procedure GetCue()
    begin
        if not Get() then begin
            Init();
            "Primary Key" := '';
            Insert();
        end;
    end;

    procedure SetFiltersForToday()
    begin
        SetFilter("Date Filter", '%1', Today);
    end;

    procedure SetFiltersForTerminal(TerminalID: Code[10])
    begin
        SetFilter("Terminal Filter", TerminalID);
    end;
}
