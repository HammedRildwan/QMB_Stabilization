table 53101 "POS Terminal"
{
    Caption = 'POS Terminal';
    DataClassification = CustomerContent;
    LookupPageId = "POS Terminal List";
    DrillDownPageId = "POS Terminal List";

    fields
    {
        field(1; "Terminal ID"; Code[10])
        {
            Caption = 'Terminal ID';
            DataClassification = CustomerContent;
            NotBlank = true;
        }
        field(2; "Name"; Text[50])
        {
            Caption = 'Name';
            DataClassification = CustomerContent;
        }
        field(10; "Location Code"; Code[10])
        {
            Caption = 'Location Code';
            DataClassification = CustomerContent;
            TableRelation = Location;
        }
        field(11; "Business Section"; Enum "POS Business Section")
        {
            Caption = 'Business Section';
            DataClassification = CustomerContent;

            trigger OnValidate()
            var
                POSSetup: Record "POS Setup";
            begin
                POSSetup.GetSetup();
                "Customer Price Group" := POSSetup.GetPriceGroupBySection("Business Section");
                "Default Customer No." := POSSetup.GetCustomerNoBySection("Business Section");
            end;
        }
        field(12; "Customer Price Group"; Code[10])
        {
            Caption = 'Customer Price Group';
            DataClassification = CustomerContent;
            TableRelation = "Customer Price Group";
        }
        field(13; "Default Customer No."; Code[20])
        {
            Caption = 'Default Customer No.';
            DataClassification = CustomerContent;
            TableRelation = Customer;
        }
        field(20; "Active"; Boolean)
        {
            Caption = 'Active';
            DataClassification = CustomerContent;
            InitValue = true;
        }
        field(21; "Current Shift No."; Code[20])
        {
            Caption = 'Current Shift No.';
            DataClassification = CustomerContent;
            TableRelation = "POS Shift";
            Editable = false;
        }
        field(22; "Assigned User ID"; Code[50])
        {
            Caption = 'Assigned User ID';
            DataClassification = CustomerContent;
            TableRelation = "User Setup";
        }
        field(30; "Receipt Printer Name"; Text[100])
        {
            Caption = 'Receipt Printer Name';
            DataClassification = CustomerContent;
        }
        field(31; "Last Transaction No."; Code[20])
        {
            Caption = 'Last Transaction No.';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(40; "Dimension 1 Code"; Code[20])
        {
            Caption = 'Shortcut Dimension 1 Code';
            DataClassification = CustomerContent;
            CaptionClass = '1,2,1';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));
        }
        field(41; "Dimension 2 Code"; Code[20])
        {
            Caption = 'Shortcut Dimension 2 Code';
            DataClassification = CustomerContent;
            CaptionClass = '1,2,2';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));
        }
    }

    keys
    {
        key(PK; "Terminal ID")
        {
            Clustered = true;
        }
        key(Key2; "Business Section", "Active")
        {
        }
        key(Key3; "Assigned User ID")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Terminal ID", "Name", "Business Section")
        {
        }
    }

    procedure HasOpenShift(): Boolean
    begin
        exit("Current Shift No." <> '');
    end;

    procedure GetTerminalForCurrentUser(): Boolean
    begin
        SetRange("Assigned User ID", UserId);
        SetRange(Active, true);
        exit(FindFirst());
    end;
}
