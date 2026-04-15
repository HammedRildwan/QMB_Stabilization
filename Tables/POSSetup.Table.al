table 53100 "POS Setup"
{
    Caption = 'POS Setup';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
            DataClassification = CustomerContent;
        }
        field(10; "Default Location Code"; Code[10])
        {
            Caption = 'Default Location Code';
            DataClassification = CustomerContent;
            TableRelation = Location;
        }
        field(11; "Cash Payment Account"; Code[20])
        {
            Caption = 'Cash Payment Account';
            DataClassification = CustomerContent;
            TableRelation = "G/L Account" where(Blocked = const(false), "Direct Posting" = const(true), "Account Type" = const(Posting));
        }
        field(12; "Sales Invoice Nos."; Code[20])
        {
            Caption = 'Sales Invoice Nos.';
            DataClassification = CustomerContent;
            TableRelation = "No. Series";
        }
        field(13; "Receipt Nos."; Code[20])
        {
            Caption = 'Receipt Nos.';
            DataClassification = CustomerContent;
            TableRelation = "No. Series";
        }
        field(14; "POS Transaction Nos."; Code[20])
        {
            Caption = 'POS Transaction Nos.';
            DataClassification = CustomerContent;
            TableRelation = "No. Series";
        }
        field(15; "POS Shift Nos."; Code[20])
        {
            Caption = 'POS Shift Nos.';
            DataClassification = CustomerContent;
            TableRelation = "No. Series";
        }
        field(20; "Require Shift Open"; Boolean)
        {
            Caption = 'Require Shift Open';
            DataClassification = CustomerContent;
            InitValue = true;
        }
        field(21; "Allow Price Override"; Boolean)
        {
            Caption = 'Allow Price Override';
            DataClassification = CustomerContent;
        }
        field(22; "Allow Negative Inventory"; Boolean)
        {
            Caption = 'Allow Negative Inventory';
            DataClassification = CustomerContent;
        }
        field(30; "Default Cashier Dimension"; Code[20])
        {
            Caption = 'Default Cashier Dimension';
            DataClassification = CustomerContent;
            TableRelation = "Dimension Value".Code where("Dimension Code" = field("Cashier Dimension Code"));
        }
        field(31; "Cashier Dimension Code"; Code[20])
        {
            Caption = 'Cashier Dimension Code';
            DataClassification = CustomerContent;
            TableRelation = Dimension;
        }
        field(32; "Business Section Dimension"; Code[20])
        {
            Caption = 'Business Section Dimension';
            DataClassification = CustomerContent;
            TableRelation = Dimension;
        }
        // Hypermart Section
        field(100; "Hypermart Customer No."; Code[20])
        {
            Caption = 'Hypermart Customer No.';
            DataClassification = CustomerContent;
            TableRelation = Customer;
        }
        field(101; "Hypermart Price Group"; Code[10])
        {
            Caption = 'Hypermart Customer Price Group';
            DataClassification = CustomerContent;
            TableRelation = "Customer Price Group";
        }
        // Restaurant Section
        field(110; "Restaurant Customer No."; Code[20])
        {
            Caption = 'Restaurant Customer No.';
            DataClassification = CustomerContent;
            TableRelation = Customer;
        }
        field(111; "Restaurant Price Group"; Code[10])
        {
            Caption = 'Restaurant Customer Price Group';
            DataClassification = CustomerContent;
            TableRelation = "Customer Price Group";
        }
        // Bar Section
        field(120; "Bar Customer No."; Code[20])
        {
            Caption = 'Bar Customer No.';
            DataClassification = CustomerContent;
            TableRelation = Customer;
        }
        field(121; "Bar Price Group"; Code[10])
        {
            Caption = 'Bar Customer Price Group';
            DataClassification = CustomerContent;
            TableRelation = "Customer Price Group";
        }
        // Laundromat Section
        field(130; "Laundromat Customer No."; Code[20])
        {
            Caption = 'Laundromat Customer No.';
            DataClassification = CustomerContent;
            TableRelation = Customer;
        }
        field(131; "Laundromat Price Group"; Code[10])
        {
            Caption = 'Laundromat Customer Price Group';
            DataClassification = CustomerContent;
            TableRelation = "Customer Price Group";
        }
    }

    keys
    {
        key(PK; "Primary Key")
        {
            Clustered = true;
        }
    }

    procedure GetSetup()
    begin
        if not Get() then begin
            Init();
            "Primary Key" := '';
            "Require Shift Open" := true;
            Insert();
        end;
    end;

    procedure GetCustomerNoBySection(BusinessSection: Enum "POS Business Section"): Code[20]
    begin
        GetSetup();
        case BusinessSection of
            BusinessSection::Hypermart:
                exit("Hypermart Customer No.");
            BusinessSection::Restaurant:
                exit("Restaurant Customer No.");
            BusinessSection::Bar:
                exit("Bar Customer No.");
            BusinessSection::Laundromat:
                exit("Laundromat Customer No.");
            else
                exit('');
        end;
    end;

    procedure GetPriceGroupBySection(BusinessSection: Enum "POS Business Section"): Code[10]
    begin
        GetSetup();
        case BusinessSection of
            BusinessSection::Hypermart:
                exit("Hypermart Price Group");
            BusinessSection::Restaurant:
                exit("Restaurant Price Group");
            BusinessSection::Bar:
                exit("Bar Price Group");
            BusinessSection::Laundromat:
                exit("Laundromat Price Group");
            else
                exit('');
        end;
    end;
}
