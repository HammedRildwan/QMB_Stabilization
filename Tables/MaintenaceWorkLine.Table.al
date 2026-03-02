table 60010 "Maintenace Work Line"
{

    fields
    {
        field(1; "Document No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Line No."; Integer)
        {
            AutoIncrement = true;
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(3; "Fault Area Code"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Fault Area".Code;
        }
        field(4; "Fault Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Fault Code"."Symptom Code" WHERE ("Fault Area Code"=FIELD("Fault Area Code"));

            trigger OnValidate()
            var
                FaultCodeRec: Record "Fault Code";
            begin
                FaultCodeRec.SETFILTER("Symptom Code",'%1',"Fault Code");
                if FaultCodeRec.FINDFIRST THEN
                  "Fault Description" := FaultCodeRec.Description
                else
                  "Fault Description" := ''; 
            end;
        }
        field(5;"Fault Description";Text[40])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(6;"Estimated Labour Hour";Decimal)
        {
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = Resource;
        }
        field(7;"Additional Details";Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(8;"Spare Parts Needed";Boolean)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(9;"Assigned Technician";Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = Resource."No." WHERE (Type=CONST(Person));

            trigger OnValidate()
            var
                ResourceRec: Record Resource;
            begin
                IF ResourceRec.GET("Assigned Technician") THEN
                  "Technician Name" := ResourceRec.Name
                ELSE
                  "Technician Name" := '';
            end;
        }
        field(10;"Technician Name";Text[80])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(11;"Job Status";Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Started,Paused,Resumed,Completed';
            OptionMembers = " ",Started,Paused,Resumed,Completed;
        }
        field(12;"Job Start Date";Date)
        {
            DataClassification = ToBeClassified;
        }
        field(13;"Job Job Start Time";Time)
        {
            DataClassification = ToBeClassified;
        }
        field(14;"Job Pause Date";Date)
        {
            DataClassification = ToBeClassified;
        }
        field(15;"Job Pause Time";Time)
        {
            DataClassification = ToBeClassified;
        }
        field(16;"Job Resume Date";Date)
        {
            DataClassification = ToBeClassified;
        }
        field(17;"Job Resume Time";Time)
        {
            DataClassification = ToBeClassified;
        }
        field(18;"Job Complete Date";Date)
        {
            DataClassification = ToBeClassified;
        }
        field(19;"Job Complete Time";Time)
        {
            DataClassification = ToBeClassified;
        }
        field(20;"Workshop Supervisor";Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Employee."No." WHERE ("Global Dimension 1 Code"=FIELD("Shortcut Dimension 1 Code"));

            trigger OnValidate()
            begin
                IF Employee.GET("Workshop Supervisor") THEN
                  "Workshop Supervisor Name" := Employee.FullName
                ELSE
                  "Workshop Supervisor Name" := '';
            end;
        }
        field(21;"Workshop Supervisor Name";Text[80])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(22;"Shortcut Dimension 1 Code";Code[20])
        {
            CaptionClass = '1,2,1';
            DataClassification = ToBeClassified;
            Editable = true;
            TableRelation = "Dimension Value".Code WHERE ("Global Dimension No."=CONST(1));
        }
        field(23;"Asset No.";Code[30])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Fixed Asset";
        }
        field(24;"QMB Service Location";Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = Location.Code;
        }
    }

    keys
    {
        key(Key1;"Document No.","Line No.","Fault Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        FaultCodeRec: Record 5918;
        ResourceRec: Record 156;
        Employee: Record 5200;
}

