table 53008 "Store Return Header"
{
    DrillDownPageID = 53204;
    LookupPageID = 53204;

    fields
    {
        field(1; "No."; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(2; Date; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(4; Requester; Text[60])
        {
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = "User Setup"."User ID";
        }
        field(5; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(1, "Shortcut Dimension 1 Code");
            end;
        }
        field(6; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(2, "Shortcut Dimension 2 Code");
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
            Editable = false;
            OptionCaption = ' ,Pending Approval,Approved,Rejected';
            OptionMembers = " ","Pending Approval",Approved,Rejected;
        }
        field(9; Posted; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(10; Location; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(11; Justification; Text[250])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(12; "Sanction No./Allocation Code"; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(13; "Work Order No."; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(15; "Requisition No."; Code[10])
        {
            DataClassification = ToBeClassified;

            trigger OnLookup()
            begin
                StoresRequisition.SETRANGE(Posted, TRUE);
                IF PAGE.RUNMODAL(70091, StoresRequisition) = ACTION::LookupOK THEN BEGIN
                    "Requisition No." := StoresRequisition."No.";
                    Location := StoresRequisition."Store Location";
                    Justification := StoresRequisition.Justification;
                    Requester := StoresRequisition.Requester;
                    "Asset No." := StoresRequisition."Asset No.";


                    StoresRequisitionLine.SETRANGE("Document No.", "Requisition No.");
                    IF StoresRequisitionLine.FINDFIRST THEN BEGIN

                        StoresReturnLine2.SETRANGE("Document No.", "No.");
                        StoresReturnLine2.DELETEALL;

                        REPEAT
                            StoresReturnLine.INIT;
                            StoresReturnLine."Document No." := "No.";
                            StoresReturnLine."Line No." := StoresRequisitionLine."Line No.";
                            StoresReturnLine."Item No." := StoresRequisitionLine."Item No.";
                            StoresReturnLine.Description := StoresRequisitionLine.Description;
                            StoresReturnLine."Unit of Measure" := StoresRequisitionLine."Unit of Measure";
                            StoresReturnLine."Quantity Issued" := StoresRequisitionLine."Quantity Requested";
                            StoresReturnLine."Quantity to Return" := StoresRequisitionLine."Quantity to Issue";
                            StoresReturnLine."Unit Price" := StoresRequisitionLine."Unit Price";
                            StoresReturnLine.Amount := StoresRequisitionLine.Amount;
                            StoresReturnLine."Location Code" := StoresRequisitionLine."Location Code";
                            StoresReturnLine."Fixed Asset No" := StoresRequisitionLine."Fixed Asset No.";
                            StoresReturnLine.INSERT;
                        UNTIL StoresRequisitionLine.NEXT = 0;
                    END;
                END;
            end;
        }
        field(16; "Asset No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = "Fixed Asset"."No.";

            trigger OnValidate()
            begin
                /*IF "Maintenance Type" = "Maintenance Type"::Truck THEN BEGIN
                  IF Truck.GET("Asset No.") THEN
                    "Shortcut Dimension 2 Code" := Truck."Operation Code"
                   ELSE
                    "Shortcut Dimension 2 Code" := '';
                  END;*/

            end;
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

    trigger OnInsert()
    var
        NoSeries: Codeunit "No. Series";
    begin
        IF "No." = '' THEN BEGIN
            CustomSetup.GET;
            CustomSetup.TESTFIELD("Store Return Nos.");
            "No." := NoSeries.GetNextNo(CustomSetup."Store Return Nos.");
            "No. Series" := CustomSetup."Store Return Nos.";
        END;
    end;

    var
        UserSetup: Record 91;
        DimMgt: Codeunit 408;
        PurchasesPayablesSetup: Record 312;
        StoresRequisition: Record 53006;
        StoresRequisitionLine: Record 53007;
        StoresReturnLine: Record 53009;
        StoresReturnLine2: Record 53009;
        ItemJournalLine: Record 83;
        ItemJournalLine2: Record 83;
        ReportPrint: Codeunit 228;
        GLEntry: Record 17;
        CustomSetup: Record 53000;

    local procedure ValidateShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    var
        OldDimSetID: Integer;
    begin
        OldDimSetID := "Dimension Set ID";
        DimMgt.ValidateShortcutDimValues(FieldNumber, ShortcutDimCode, "Dimension Set ID");
        IF "No." <> '' THEN
            MODIFY;
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
        IF OldDimSetID <> "Dimension Set ID" THEN
            MODIFY;
    end;

    // [Scope('Internal')]
    procedure PostReturn()
    begin
        ItemJournalLine2.SETRANGE("Journal Template Name", 'ITEM');
        ItemJournalLine2.SETRANGE("Journal Batch Name", 'RETURN');
        IF ItemJournalLine2.FINDFIRST THEN
            ItemJournalLine2.DELETEALL;

        StoresReturnLine.SETRANGE("Document No.", "No.");
        IF StoresReturnLine.FINDFIRST THEN BEGIN
            REPEAT
                ItemJournalLine."Journal Template Name" := 'ITEM';
                ItemJournalLine."Journal Batch Name" := 'RETURN';
                ItemJournalLine."Line No." := StoresReturnLine."Line No.";
                ItemJournalLine.VALIDATE("Item No.", StoresReturnLine."Item No.");
                ItemJournalLine.VALIDATE("Unit of Measure Code", StoresReturnLine."Unit of Measure");
                IF StoresReturnLine."Variant Code" <> '' THEN
                    ItemJournalLine.VALIDATE("Variant Code", StoresReturnLine."Variant Code");
                ItemJournalLine."Posting Date" := Date;
                ItemJournalLine."Entry Type" := ItemJournalLine."Entry Type"::"Positive Adjmt.";
                ItemJournalLine."Document No." := "No.";
                ItemJournalLine."Document Date" := Date;
                ItemJournalLine."Location Code" := StoresReturnLine."Location Code";
                ItemJournalLine."Gen. Bus. Posting Group" := 'STORE';
                ItemJournalLine.VALIDATE(Quantity, StoresReturnLine."Quantity to Return");
                ItemJournalLine."Dimension Set ID" := "Dimension Set ID";
                ItemJournalLine.INSERT;
            UNTIL StoresReturnLine.NEXT = 0;
            CODEUNIT.RUN(CODEUNIT::"Item Jnl.-Post", ItemJournalLine);
        END;

        CheckPostedJnl;
    end;

    // [Scope('Internal')]
    procedure PostReturnPrint()
    begin
        ItemJournalLine2.SETRANGE("Journal Template Name", 'ITEM');
        ItemJournalLine2.SETRANGE("Journal Batch Name", 'RETURN');
        IF ItemJournalLine2.FINDFIRST THEN
            ItemJournalLine2.DELETEALL;

        StoresReturnLine.SETRANGE("Document No.", "No.");
        IF StoresReturnLine.FINDFIRST THEN BEGIN
            REPEAT
                ItemJournalLine."Journal Template Name" := 'ITEM';
                ItemJournalLine."Journal Batch Name" := 'RETURN';
                ItemJournalLine."Line No." := StoresReturnLine."Line No.";
                ItemJournalLine.VALIDATE("Item No.", StoresReturnLine."Item No.");
                ItemJournalLine.VALIDATE("Unit of Measure Code", StoresReturnLine."Unit of Measure");
                IF StoresReturnLine."Variant Code" <> '' THEN
                    ItemJournalLine.VALIDATE("Variant Code", StoresReturnLine."Variant Code");
                ItemJournalLine."Posting Date" := Date;
                ItemJournalLine."Entry Type" := ItemJournalLine."Entry Type"::"Positive Adjmt.";
                ItemJournalLine."Document No." := "No.";
                ItemJournalLine."Document Date" := Date;
                ItemJournalLine."Location Code" := StoresReturnLine."Location Code";
                ItemJournalLine."Gen. Bus. Posting Group" := 'STORE';
                ItemJournalLine.VALIDATE(Quantity, StoresReturnLine."Quantity to Return");
                ItemJournalLine."Dimension Set ID" := "Dimension Set ID";
                ItemJournalLine.INSERT;
            UNTIL StoresReturnLine.NEXT = 0;
            CODEUNIT.RUN(CODEUNIT::"Item Jnl.-Post+Print", ItemJournalLine);
        END;

        //CheckPostedJnl;
    end;

    // [Scope('Internal')]
    procedure TestReport()
    begin
        ItemJournalLine2.SETRANGE("Journal Template Name", 'ITEM');
        ItemJournalLine2.SETRANGE("Journal Batch Name", 'RETURN');
        IF ItemJournalLine2.FINDFIRST THEN
            ItemJournalLine2.DELETEALL;

        StoresReturnLine.SETRANGE("Document No.", "No.");
        IF StoresReturnLine.FINDFIRST THEN BEGIN
            REPEAT
                ItemJournalLine."Journal Template Name" := 'ITEM';
                ItemJournalLine."Journal Batch Name" := 'RETURN';
                ItemJournalLine."Line No." := StoresReturnLine."Line No.";
                ItemJournalLine.VALIDATE("Item No.", StoresReturnLine."Item No.");
                ItemJournalLine.VALIDATE("Unit of Measure Code", StoresReturnLine."Unit of Measure");
                IF StoresReturnLine."Variant Code" <> '' THEN
                    ItemJournalLine.VALIDATE("Variant Code", StoresReturnLine."Variant Code");
                ItemJournalLine."Posting Date" := Date;
                ItemJournalLine."Entry Type" := ItemJournalLine."Entry Type"::"Positive Adjmt.";
                ItemJournalLine."Document No." := "No.";
                ItemJournalLine."Document Date" := Date;
                ItemJournalLine."Location Code" := StoresReturnLine."Location Code";
                ItemJournalLine."Gen. Bus. Posting Group" := 'STORE';
                ItemJournalLine.VALIDATE(Quantity, StoresReturnLine."Quantity to Return");
                ItemJournalLine."Dimension Set ID" := "Dimension Set ID";
                ItemJournalLine.INSERT;
                COMMIT;
            UNTIL StoresReturnLine.NEXT = 0;
            ReportPrint.PrintItemJnlLine(ItemJournalLine);
        END;
    end;

    // [Scope('Internal')]
    procedure CheckPostedJnl()
    begin
        GLEntry.SETCURRENTKEY("Document No.", "Posting Date");
        GLEntry.SETRANGE("Document No.", "No.");
        IF GLEntry.FINDFIRST THEN BEGIN
            Posted := TRUE;
            MODIFY;
        END;
    end;
}

