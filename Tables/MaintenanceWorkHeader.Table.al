table 60009 "Maintenance Work Header"
{
    DrillDownPageID = 60010;

    fields
    {
        field(1; "No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(2; "Truck No."; Code[30])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Fixed Asset";

            trigger OnValidate()
            var 
                Truck: Record 5600;
                MaintenanceWorkHeader : Record "Maintenance Work Header";
            begin

                MaintenanceWorkHeader.COPYFILTERS(Rec);
                MaintenanceWorkHeader.SETFILTER("No.", '<>%1', '');
                MaintenanceWorkHeader.SETRANGE("Truck No.", "Truck No.");
                //MaintenanceWorkHeader.SETRANGE("Created By ID",USERID);
                MaintenanceWorkHeader.SETRANGE("Delivered By", '');
                IF MaintenanceWorkHeader.FIND('-') THEN
                    ERROR('Work Order %1 not yet delivered!\New Work Order cannot be created', MaintenanceWorkHeader."No.");
            end;
        }
        field(3; "Job Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Repair,Road Work,Maintenance & Repair,Accident,Return Job';
            OptionMembers = " ",Repair,"Road Work","Maintenance & Repair",Accident,"Return Job";
        }
        field(4; Priority; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Low,Medium,High';
            OptionMembers = Low,Medium,High;
        }
        field(5; "Maintenance Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,General Periodic Service,Preventive Maintenance,Corrective Maintenance';
            OptionMembers = " ","General Periodic Service","Preventive Maintenance","Corrective Maintenance";
        }
        field(6; "Approval Status"; Option)
        {
            DataClassification = ToBeClassified;
            Editable = false;
            OptionCaption = ' ,Pending Approval,Approved,Rejected';
            OptionMembers = " ","Pending Approval",Approved,Rejected;
        }
        field(7; "Created By ID"; Code[30])
        {
            DataClassification = ToBeClassified;
        }
        field(8; "Gate In Date and Time"; DateTime)
        {
            DataClassification = ToBeClassified;
        }
        field(9; "Business Unit"; Code[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = Customer;
        }
        field(10; "GPC Service Location"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = Location.Code;
        }
        field(11; "Machine Off"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(12; "Safety Googles"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(13; "Safety Boots"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(14; "Business Unit Contact"; Code[20])
        {
            DataClassification = ToBeClassified;
            ExtendedDatatype = PhoneNo;
        }
        field(15; "Business Unit Contacted"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(16; "Business Unit Email"; Text[30])
        {
            DataClassification = ToBeClassified;
            ExtendedDatatype = EMail;
        }
        field(17; "No. Series"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(18; "Brought-In Condition"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Maintenance Required,Parts Replacement,Part Fixing';
            OptionMembers = "Maintenance Required","Parts Replacement","Part Fixing";
        }
        field(19; "Veh. Inspection Officer No."; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = Resource."No." WHERE (Type=CONST(Person));

            trigger OnValidate()
            var
                Resource: Record 156;
            begin
                IF Resource.GET("Veh. Inspection Officer No.") THEN
                  "Veh. Inspection Officer Name" := Resource.Name
                ELSE
                  "Veh. Inspection Officer Name" := '';
            end;
        }
        field(20;"VIO Observation/Remark";Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(21;"Final Inspection Done";Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(22;Picture;Media)
        {
            DataClassification = ToBeClassified;
            ExtendedDatatype = Person;
        }
        field(23;"Gate-Out Time";Time)
        {
            DataClassification = ToBeClassified;
        }
        field(24;"Awaiting Part";Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(25;"Part Requested DateTime";DateTime)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(26;"Part Received DateTime";DateTime)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(27;"Driving Test Feedback";Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(28;"Part(s) Reqested";Boolean)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(29;"Veh. Inspection Officer Name";Text[30])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(30;"Brought In Odometer Reading";Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(31;"WAC - Engine Oil Level";Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Replaced,Topped Up,Bled,Blown,Checked,Yes,No';
            OptionMembers = " ",Replaced,"Topped Up",Bled,Blown,Checked,Yes,No;
        }
        field(32;"WAC - Electrical System";Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Replaced,Topped Up,Bled,Blown,Checked,Yes,No';
            OptionMembers = " ",Replaced,"Topped Up",Bled,Blown,Checked,Yes,No;
        }
        field(33;"WAC - Air Cleaner";Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Replaced,Topped Up,Bled,Blown,Checked,Yes,No';
            OptionMembers = " ",Replaced,"Topped Up",Bled,Blown,Checked,Yes,No;
        }
        field(34;"WAC - Air Tank";Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Replaced,Topped Up,Bled,Blown,Checked,Yes,No';
            OptionMembers = " ",Replaced,"Topped Up",Bled,Blown,Checked,Yes,No;
        }
        field(35;"WAC - Engine Noises";Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(36;"WAC - Leaks";Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(37;"WAC - Tyre Pressue";Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Replaced,Topped Up,Bled,Blown,Checked,Yes,No';
            OptionMembers = " ",Replaced,"Topped Up",Bled,Blown,Checked,Yes,No;
        }
        field(38;"WAC - Windshield and Wipers";Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(39;"WAC - Battery";Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(40;"WAC - Transmission Oil Level";Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Replaced,Topped Up,Bled,Blown,Checked,Yes,No';
            OptionMembers = " ",Replaced,"Topped Up",Bled,Blown,Checked,Yes,No;
        }
        field(41;"WAC - Steering";Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(42;"WAC - Engine Belts and Hoses";Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(43;"WAC - Brakes";Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(44;"WAC - Vehicle Papers";Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(45;"WAC - Water Filter";Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Replaced,Topped Up,Bled,Blown,Checked,Yes,No';
            OptionMembers = " ",Replaced,"Topped Up",Bled,Blown,Checked,Yes,No;
        }
        field(46;"WAC - Gas Filter";Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Replaced,Topped Up,Bled,Blown,Checked,Yes,No';
            OptionMembers = " ",Replaced,"Topped Up",Bled,Blown,Checked,Yes,No;
        }
        field(47;"WAC - Axle Hub Lubricant";Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Replaced,Topped Up,Bled,Blown,Checked,Yes,No';
            OptionMembers = " ",Replaced,"Topped Up",Bled,Blown,Checked,Yes,No;
        }
        field(48;"WAC - Coolant Level";Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Replaced,Topped Up,Bled,Blown,Checked,Yes,No';
            OptionMembers = " ",Replaced,"Topped Up",Bled,Blown,Checked,Yes,No;
        }
        field(49;"Job done satisfactorily";Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50;"Overall Status";Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Open,Undergoing Maintenance,Awaiting Parts,Awaiting Driver,Awaiting Tyre,Awaiting Diesel,Closed';
            OptionMembers = " ",Open,"Undergoing Maintenance","Awaiting Parts","Awaiting Driver","Awaiting Tyre","Awaiting Diesel",Closed;
        }
        field(51;"WAC - Fan belt tension";Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(52;"WAC - Pulley for clearance";Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(53;"WAC -  Tie Rod clearance";Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(54;"WAC - Oil Leakage";Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(55;"WAC - Fuel Leakage";Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(56;"WAC - Coolant Spill/Leaks";Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(57;"WAC - Air Cleaner Housing";Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(58;"WAC- Air Leakage";Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(59;"WAC - Dashboard Functions";Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(60;"WAC - Air Pressure";Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(61;"WAC - Oil Pressure";Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(62;"WAC - Water Temperature";Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(63;"WAC - Exhaust Leakage";Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(64;"WAC - Front Shock Absorber";Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(65;"WAC - Cab Barrel";Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(66;"WAC - Cab Shocks";Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(67;"WAC - Cabin Locks";Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(68;"WAC - Bushings for Clearance";Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(69;"WAC - Battery Terminals";Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(70;"WAC - Chassis Beams";Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(71;"WAC - Kingpin";Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(72;"WAC - Trailer Connecting Hose";Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(73;"WAC - Hydrometer & Diesel Tank";Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(74;"WAC - Tractor Brake";Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(75;"WAC - Transmission Fluid Level";Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(76;"WAC - Gearbox Oil Level";Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(77;"WAC Axle Oil Level";Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(78;"WAC - Propeller";Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(79;"WAC - Air Tank & Disch. Water";Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(80;"WAC -Trailer Air Valve Leakage";Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(81;"WAC - Wheel Studs";Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(82;"WAC - Brake Lining";Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(83;"WAC - Hub Covers";Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(84;"WAC - Spring/Center Bolt";Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(85;"WAC - Equalizer";Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(86;"WAC - Shock Absorbers";Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(87;"WAC - Shackle Pins";Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(88;"WAC - Overall Trailer Appearan";Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(89;Delivered;Boolean)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                TESTFIELD("Overall Status","Overall Status"::Closed);
                TESTFIELD("Approval Status","Approval Status"::Approved);
                "Delivered By" := USERID;
                "Delivery Date/Time" := CURRENTDATETIME;
            end;
        }
        field(90;"Delivered By";Code[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(91;"Delivery Date/Time";DateTime)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(92;"Fault Reported";Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(93;"Supervisor Assesment";Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(94;"Return Job Description";Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(95;"Refrence Job";Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Maintenance Work Header" WHERE ("Overall Status"=FILTER(Closed),
                                                             "Truck No."=FIELD("Truck No."));
        }
        field(96;"Cause fo Return";Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ',Part Failure,Technician Negligence,Driver Negligence,Others';
            OptionMembers = ,"Part Failure","Technician Negligence","Driver Negligence",Others;
        }
    }

    keys
    {
        key(Key1;"No.")
        {
            Clustered = true;
        }
        key(Key2;"Truck No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        IF "Approval Status" = "Approval Status"::Approved THEN
          ERROR('Sorry, you can not delete an approved record!');
    end;

    trigger OnInsert()
    begin
        TESTFIELD("Truck No.");
        IF "No." = '' THEN BEGIN
          CustomSetup.GET;
          NoSeriesMgt.InitSeries(CustomSetup."Work Order Header Nos.",xRec."No. Series",0D,"No.","No. Series");
        END;

        "Created By ID" :=  USERID;
        "Gate In Date and Time" := CURRENTDATETIME;
    end;

    var
        CustomSetup: Record 60005;
        NoSeriesMgt: Codeunit 396;
        FaultCode: Record 5918;
        Resource: Record 156;
        Truck: Record 5600;
        MaintenanceWorkHeader: Record 60009;
}

