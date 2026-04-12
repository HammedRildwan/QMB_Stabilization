table 70018 "Store Requisition Header"
{
    DataCaptionFields = "No.", Requester, "Store Location", "Request Type";
    //DrillDownPageID = 60119;
    //LookupPageID = 60119;

    fields
    {
        field(1; "No."; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Request Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(4; Requester; Text[60])
        {
            DataClassification = ToBeClassified;
            Editable = true;
            TableRelation = "User Setup"."User ID";
        }
        field(5; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));

            trigger OnValidate()
            begin
                //ValidateShortcutDimCode(1,"Shortcut Dimension 1 Code");
            end;
        }
        field(6; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));

            trigger OnValidate()
            begin
                //ValidateShortcutDimCode(2,"Shortcut Dimension 2 Code");
            end;
        }
        field(7; "No. Series"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series".Code;
        }
        field(8; Status; Option)
        {
            DataClassification = ToBeClassified;
            Editable = true;
            OptionCaption = ' ,Pending Approval,Approved,Rejected';
            OptionMembers = " ","Pending Approval",Approved,Rejected;
        }
        field(9; Posted; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(10; "Store Location"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = Location.Code;
        }
        field(11; Justification; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(12; "Posted DateTime"; DateTime)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(14; "Request Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Internal Consumption,Maintenance';
            OptionMembers = " ","Internal Consumption",Maintenance;
        }
        field(15; "Posted By"; Code[30])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(16; "Asset No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = IF ("Maintenance Type" = FILTER("Other Assets")) "Fixed Asset"."No.";

            trigger OnValidate()
            begin
                // IF "Maintenance Type" = "Maintenance Type"::Truck THEN BEGIN
                //  IF Truck.GET("Asset No.") THEN
                //    "Shortcut Dimension 2 Code" := Truck."Operation Code"
                //   ELSE
                //    "Shortcut Dimension 2 Code" := '';
                //  END;
            end;
        }
        field(17; "Shortcut Dimension 4 Code"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(4));
        }
        field(18; "Not Issued"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(19; "Maintenance Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Vehicle,Other Assets';
            OptionMembers = " ",Vehicle,"Other Assets";
        }
        field(20; "Refurbishment Vendor"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Vendor;
        }
        field(480; "Dimension Set ID"; Integer)
        {
            Caption = 'Dimension Set ID';
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = "Dimension Set Entry";

            trigger OnLookup()
            begin
                ShowDocDim;
            end;
        }
    }

    keys
    {
        key(Key1; "No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        //IF NOT UserSetup."Delete Store Req." THEN
        ERROR('You can not delete this record!');
    end;

    trigger OnInsert()
    begin
        IF "No." = '' THEN BEGIN
            CustomSetup.GET;
            CustomSetup.TESTFIELD("Store Requisition Nos.");
            NoSeriesMgt.InitSeries(CustomSetup."Store Requisition Nos.", xRec."No. Series", 0D, "No.", "No. Series");
        END;

        "Request Date" := TODAY;
        Requester := USERID;
        // IF UserSetup.GET(USERID) THEN BEGIN
        //  VALIDATE("Shortcut Dimension 1 Code",UserSetup."Shortcut Dimension 1 Code");
        //  VALIDATE("Shortcut Dimension 2 Code",UserSetup."Shortcut Dimension 2 Code");
        // END;
    end;

    trigger OnModify()
    begin
        // IF ("NO." <> '') AND (REQUESTER = '') THEN BEGIN
        //  REQUESTER := USERID;
        //  IF USERSETUP.GET(USERID) THEN BEGIN
        //   VALIDATE("SHORTCUT DIMENSION 1 CODE",USERSETUP."SHORTCUT DIMENSION 1 CODE");
        //   VALIDATE("SHORTCUT DIMENSION 2 CODE",USERSETUP."SHORTCUT DIMENSION 2 CODE");
        //  END;
        // END;
        //
        // IF ("NO." <> '') AND ("STORE LOCATION" <> XREC."STORE LOCATION") THEN BEGIN
        //  IF (STATUS = STATUS::APPROVED) OR POSTED THEN
        //    ERROR(TEXT001);
        //  STOREREQLINE.SETFILTER("DOCUMENT NO.","NO.");
        //  IF STOREREQLINE.FINDSET THEN BEGIN
        //    REPEAT
        //      STOREREQLINE."LOCATION CODE" := "STORE LOCATION";
        //      STOREREQLINE.MODIFY;
        //    UNTIL STOREREQLINE.NEXT = 0;
        //  END;
        // END;
        //
        // IF ("NO." <> '') AND ("APPROVED WORK ORDER NO." <> XREC."APPROVED WORK ORDER NO.") THEN BEGIN
        //  IF (STATUS = STATUS::APPROVED) OR POSTED THEN
        //    ERROR(TEXT002);
        //  STOREREQLINE.SETFILTER("DOCUMENT NO.","NO.");
        //  IF STOREREQLINE.FINDSET THEN BEGIN
        //    REPEAT
        //      STOREREQLINE."FIXED ASSET NO." := "TRUCK NO.";
        //      STOREREQLINE.MODIFY;
        //    UNTIL STOREREQLINE.NEXT = 0;
        //  END;
        // END;
    end;

    var
        UserSetup: Record 91;
        DimMgt: Codeunit 408;
        PurchasesPayablesSetup: Record 312;
        ItemJournalLine: Record 83;
        ItemJournalLine2: Record 83;
        ReportPrint: Codeunit 228;
        GLEntry: Record 17;
        ItemRec: Record 27;
        StoreRequisitionLine: Record 70019;
        CustomSetup: Record 60005;
        NoSeriesMgt: Codeunit 396;
        ItemLedgEntry: Record 32;
        StoreReqLine: Record 70019;
        MaintenanceLedgEntry: Record 5625;
        LineNo: Integer;
        Text001: Label 'Sorry, you can not change Store Location for a Posted or Approved Store Requisition!';
        Text002: Label 'Sorry, you can not change Approved Work Order for a Posted or Approved Store Requisition!';
        Text003: Label 'Maintenance Fault Code %1 on %2';
        Truck: Record 5600;

    local procedure ValidateShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    var
        OldDimSetID: Integer;
    begin
        OldDimSetID := "Dimension Set ID";
        DimMgt.ValidateShortcutDimValues(FieldNumber, ShortcutDimCode, "Dimension Set ID");
        //IF "No." <> '' THEN MODIFY;
    end;

    // [Scope('Internal')]
    procedure ShowDocDim()
    var
        OldDimSetID: Integer;
    begin
        OldDimSetID := "Dimension Set ID";
        "Dimension Set ID" :=
          DimMgt.EditDimensionSet(
            "Dimension Set ID", STRSUBSTNO('%1', "No."),
            "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code");
        //IF OldDimSetID <> "Dimension Set ID" THEN MODIFY;
    end;

    //[Scope('Internal')]
    procedure PostIssue()
    begin
        ItemLedgEntry.SETCURRENTKEY("Document No.", "Document Type", "Document Line No.");
        ItemLedgEntry.SETRANGE("Document No.", "No.");
        IF ItemLedgEntry.FINDFIRST THEN BEGIN
            MESSAGE('This document has been posted!');
            Posted := TRUE;
            //"Posted By" := USERID;
            //"Posted DateTime" := CURRENTDATETIME;
            MODIFY;
        END ELSE BEGIN


            IF "Request Type" = "Request Type"::" " THEN
                ERROR('You must select a Request Type');
            ItemJournalLine2.SETRANGE("Journal Template Name", 'ITEM');
            ItemJournalLine2.SETRANGE("Journal Batch Name", 'ISSUE');
            IF ItemJournalLine2.FINDSET THEN
                ItemJournalLine2.DELETEALL;

            StoreRequisitionLine.SETRANGE("Document No.", "No.");
            IF StoreRequisitionLine.FINDSET THEN BEGIN
                REPEAT
                    ItemJournalLine.INIT;
                    ItemJournalLine."Journal Template Name" := 'ITEM';
                    ItemJournalLine."Journal Batch Name" := 'ISSUE';
                    ItemJournalLine."Line No." := StoreRequisitionLine."Line No.";
                    ItemJournalLine.VALIDATE("Item No.", StoreRequisitionLine."Item No.");
                    ItemJournalLine.VALIDATE("Unit of Measure Code", StoreRequisitionLine."Unit of Measure");
                    IF StoreRequisitionLine."Variant Code" <> '' THEN
                        ItemJournalLine.VALIDATE("Variant Code", StoreRequisitionLine."Variant Code");
                    ItemJournalLine."Posting Date" := "Request Date";
                    ItemJournalLine."Entry Type" := ItemJournalLine."Entry Type"::"Negative Adjmt.";
                    ItemJournalLine."Document No." := "No.";
                    ItemJournalLine."Document Date" := StoreRequisitionLine."Posting Date";
                    ItemJournalLine.VALIDATE("Shortcut Dimension 1 Code", StoreRequisitionLine."Shortcut Dimension 1 Code");
                    ItemJournalLine.VALIDATE("Shortcut Dimension 2 Code", StoreRequisitionLine."Shortcut Dimension 2 Code");
                    //    ItemJournalLine.VALIDATE("Shortcut Dimension 3 Code",StoreRequisitionLine."Shortcut Dimension 3 Code");
                    //    IF (("Maintenance Type" = "Maintenance Type"::Truck) OR ("Asset No." <> '')) THEN
                    //      ItemJournalLine.VALIDATE("Shortcut Dimension 4 Code","Asset No.");
                    ItemJournalLine."Location Code" := StoreRequisitionLine."Location Code";
                    IF "Request Type" = "Request Type"::"Internal Consumption" THEN
                        ItemJournalLine."Gen. Bus. Posting Group" := 'STORE';
                    IF "Request Type" = "Request Type"::Maintenance THEN
                        ItemJournalLine."Gen. Bus. Posting Group" := 'MTCE';

                    ItemJournalLine.VALIDATE(Quantity, StoreRequisitionLine."Quantity to Issue");
                    //ItemJournalLine."Dimension Set ID" := "Dimension Set ID";
                    ItemJournalLine.INSERT;
                UNTIL StoreRequisitionLine.NEXT = 0;
                CODEUNIT.RUN(CODEUNIT::"Item Jnl.-Post", ItemJournalLine);

                Posted := TRUE;
                "Posted DateTime" := CURRENTDATETIME;
                MODIFY;

                CheckPostedJnl;

            END;

        END;
    end;

    //[Scope('Internal')]
    procedure PostIssuePrint()
    begin
        IF "Request Type" = "Request Type"::" " THEN
            ERROR('You must select a Request Type');
        ItemJournalLine2.SETRANGE("Journal Template Name", 'ITEM');
        ItemJournalLine2.SETRANGE("Journal Batch Name", 'ISSUE');
        IF ItemJournalLine2.FINDSET THEN
            ItemJournalLine2.DELETEALL;

        StoreRequisitionLine.SETRANGE("Document No.", "No.");
        IF StoreRequisitionLine.FINDSET THEN BEGIN
            REPEAT
                ItemJournalLine.INIT;
                ItemJournalLine."Journal Template Name" := 'ITEM';
                ItemJournalLine."Journal Batch Name" := 'ISSUE';
                ItemJournalLine."Line No." := StoreRequisitionLine."Line No.";
                ItemJournalLine.VALIDATE("Item No.", StoreRequisitionLine."Item No.");
                ItemJournalLine.VALIDATE("Unit of Measure Code", StoreRequisitionLine."Unit of Measure");
                IF StoreRequisitionLine."Variant Code" <> '' THEN
                    ItemJournalLine.VALIDATE("Variant Code", StoreRequisitionLine."Variant Code");
                ItemJournalLine."Posting Date" := "Request Date";
                ItemJournalLine."Entry Type" := ItemJournalLine."Entry Type"::"Negative Adjmt.";
                ItemJournalLine."Document No." := "No.";
                ItemJournalLine."Document Date" := StoreRequisitionLine."Posting Date";
                ItemJournalLine.VALIDATE("Shortcut Dimension 1 Code", StoreRequisitionLine."Shortcut Dimension 1 Code");
                ItemJournalLine.VALIDATE("Shortcut Dimension 2 Code", StoreRequisitionLine."Shortcut Dimension 2 Code");
                //    ItemJournalLine.VALIDATE("Shortcut Dimension 3 Code",StoreRequisitionLine."Shortcut Dimension 3 Code");
                //    IF (("Maintenance Type" = "Maintenance Type"::Truck) OR ("Asset No." <> '')) THEN
                //      ItemJournalLine.VALIDATE("Shortcut Dimension 4 Code","Asset No.");
                ItemJournalLine."Location Code" := StoreRequisitionLine."Location Code";
                IF "Request Type" = "Request Type"::"Internal Consumption" THEN
                    ItemJournalLine."Gen. Bus. Posting Group" := 'STORE';
                IF "Request Type" = "Request Type"::Maintenance THEN
                    ItemJournalLine."Gen. Bus. Posting Group" := 'MTCE';

                ItemJournalLine.VALIDATE(Quantity, StoreRequisitionLine."Quantity to Issue");
                //ItemJournalLine."Dimension Set ID" := "Dimension Set ID";
                ItemJournalLine.INSERT;
            UNTIL StoreRequisitionLine.NEXT = 0;
            CODEUNIT.RUN(CODEUNIT::"Item Jnl.-Post+Print", ItemJournalLine);
        END;

        Posted := TRUE;
        "Posted DateTime" := CURRENTDATETIME;
        MODIFY;
        //Maintenance Ledger
        // IF "Request Type" = "Request Type"::Maintenance THEN
        //  InsertMaintJournal;
        CheckPostedJnl;
    end;

    //[Scope('Internal')]
    procedure TestReport()
    begin
        IF "Request Type" = "Request Type"::" " THEN
            ERROR('You must select a Request Type');
        ItemJournalLine2.SETRANGE("Journal Template Name", 'ITEM');
        ItemJournalLine2.SETRANGE("Journal Batch Name", 'ISSUE');
        IF ItemJournalLine2.FINDSET THEN
            ItemJournalLine2.DELETEALL;

        StoreRequisitionLine.SETRANGE("Document No.", "No.");
        IF StoreRequisitionLine.FINDSET THEN BEGIN
            REPEAT
                ItemJournalLine.INIT;
                ItemJournalLine."Journal Template Name" := 'ITEM';
                ItemJournalLine."Journal Batch Name" := 'ISSUE';
                ItemJournalLine."Line No." := StoreRequisitionLine."Line No.";
                ItemJournalLine.VALIDATE("Item No.", StoreRequisitionLine."Item No.");
                ItemJournalLine.VALIDATE("Unit of Measure Code", StoreRequisitionLine."Unit of Measure");
                IF StoreRequisitionLine."Variant Code" <> '' THEN
                    ItemJournalLine.VALIDATE("Variant Code", StoreRequisitionLine."Variant Code");
                ItemJournalLine."Posting Date" := StoreRequisitionLine."Posting Date";
                ItemJournalLine."Entry Type" := ItemJournalLine."Entry Type"::"Negative Adjmt.";
                ItemJournalLine."Document No." := "No.";
                ItemJournalLine."Document Date" := "Request Date";
                ItemJournalLine.VALIDATE("Shortcut Dimension 1 Code", StoreRequisitionLine."Shortcut Dimension 1 Code");
                ItemJournalLine.VALIDATE("Shortcut Dimension 2 Code", StoreRequisitionLine."Shortcut Dimension 2 Code");
                //    ItemJournalLine.VALIDATE("Shortcut Dimension 3 Code",StoreRequisitionLine."Shortcut Dimension 3 Code");

                //    IF "Maintenance Type" = "Maintenance Type"::Truck THEN
                //      ItemJournalLine.VALIDATE("Shortcut Dimension 4 Code","Asset No.");


                ItemJournalLine."Location Code" := StoreRequisitionLine."Location Code";
                IF "Request Type" = "Request Type"::"Internal Consumption" THEN
                    ItemJournalLine."Gen. Bus. Posting Group" := 'STORE';
                IF "Request Type" = "Request Type"::Maintenance THEN
                    ItemJournalLine."Gen. Bus. Posting Group" := 'MTCE';
                ItemJournalLine.VALIDATE(Quantity, StoreRequisitionLine."Quantity to Issue");
                ItemJournalLine."Dimension Set ID" := "Dimension Set ID";
                ItemJournalLine.INSERT;
            UNTIL StoreRequisitionLine.NEXT = 0;
            COMMIT;

            ReportPrint.PrintItemJnlLine(ItemJournalLine);
        END;
    end;

    // [Scope('Internal')]
    procedure CheckPostedJnl()
    begin
        StoreReqLine.SETFILTER("Document No.", "No.");
        IF StoreReqLine.FINDSET THEN BEGIN
            REPEAT
                StoreReqLine."Posting Date" := "Request Date";
                StoreReqLine.Posted := TRUE;
                StoreReqLine."Quantity Issued" := StoreReqLine."Quantity to Issue";
                StoreReqLine.MODIFY;
            UNTIL StoreReqLine.NEXT = 0;
        END;
    end;

    // [Scope('Internal')]
    procedure Navigate()
    var
        NavigateForm: Page 344;
    begin
        NavigateForm.SetDoc("Request Date", "No.");
        NavigateForm.RUN;
    end;

    // [Scope('Internal')]
    procedure InsertMaintJournal()
    var
        ItemLedgEntry2: Record 32;
        MaintenanceLedgEntry: Record 5625;
        MaintenanceLedgEntry2: Record 5625;
    begin
        MaintenanceLedgEntry2.SETRANGE("Entry No.");
        MaintenanceLedgEntry2.FINDLAST;
        LineNo := MaintenanceLedgEntry2."Entry No.";

        ItemLedgEntry2.SETCURRENTKEY("Document No.");
        ItemLedgEntry2.SETRANGE("Document No.", "No.");
        IF ItemLedgEntry2.FINDSET THEN BEGIN
            REPEAT
                MaintenanceLedgEntry.INIT;
                MaintenanceLedgEntry."Entry No." := LineNo + 1;
                MaintenanceLedgEntry."Document No." := ItemLedgEntry2."Document No.";
                MaintenanceLedgEntry."Posting Date" := ItemLedgEntry2."Posting Date";
                MaintenanceLedgEntry."Document Date" := ItemLedgEntry2."Posting Date";
                MaintenanceLedgEntry."FA Posting Date" := ItemLedgEntry2."Posting Date";
                MaintenanceLedgEntry."Depreciation Book Code" := 'GPC';
                MaintenanceLedgEntry."User ID" := USERID;
                MaintenanceLedgEntry.Quantity := ItemLedgEntry2.Quantity;
                MaintenanceLedgEntry.VALIDATE("Global Dimension 1 Code", ItemLedgEntry2."Global Dimension 1 Code");
                MaintenanceLedgEntry.VALIDATE("Global Dimension 2 Code", ItemLedgEntry2."Global Dimension 2 Code");
                MaintenanceLedgEntry."Dimension Set ID" := ItemLedgEntry2."Dimension Set ID";
                StoreRequisitionLine.SETRANGE("Document No.", ItemLedgEntry2."Document No.");
                StoreRequisitionLine.SETRANGE("Line No.", ItemLedgEntry2."Document Line No.");

                IF StoreRequisitionLine.FINDFIRST THEN BEGIN
                    MaintenanceLedgEntry."FA No." := StoreRequisitionLine."Fixed Asset No.";
                    MaintenanceLedgEntry."Maintenance Code" := StoreRequisitionLine."Maintenance Code";
                    MaintenanceLedgEntry.Description := ('Maintenance for ' + StoreRequisitionLine."Fixed Asset No.");
                END;

                ItemLedgEntry2.CALCFIELDS("Cost Amount (Actual)");
                MaintenanceLedgEntry."Debit Amount" := ABS(ItemLedgEntry2."Cost Amount (Actual)");
                MaintenanceLedgEntry.Amount := ABS(ItemLedgEntry2."Cost Amount (Actual)");
                MaintenanceLedgEntry."Dimension Set ID" := ItemLedgEntry2."Dimension Set ID";
                MaintenanceLedgEntry.INSERT;
                LineNo += 1
            UNTIL ItemLedgEntry2.NEXT = 0;
        END;
    end;

    local procedure PreventDublePosting()
    begin
    end;
}

