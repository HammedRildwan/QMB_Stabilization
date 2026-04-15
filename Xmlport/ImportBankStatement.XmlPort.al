xmlport 53011 "Import Bank Statement"
{
    Format = VariableText;
    UseRequestPage = false;

    schema
    {
        textelement(Root)
        {
            tableelement(Table2000000026; 2000000026)
            {
                AutoReplace = false;
                AutoSave = false;
                AutoUpdate = false;
                XmlName = 'Integer';
                SourceTableView = SORTING(Number)
                                  WHERE(Number = CONST(1));
                textelement(transdate)
                {
                    XmlName = 'A';
                }
                textelement(transdescription)
                {
                    XmlName = 'B';
                }
                textelement(transdebitamount)
                {
                    XmlName = 'C';
                }
                textelement(transcreditamount)
                {
                    XmlName = 'D';
                }
                textelement(bankno)
                {
                    XmlName = 'E';
                }
                textelement(stmtno)
                {
                    XmlName = 'F';
                }

                trigger OnAfterInsertRecord()
                begin
                    BankAccReconciliationLine.INIT;
                    BankAccReconciliationLine."Bank Account No." := BankNo;  //BankAccNo;
                    BankAccReconciliationLine."Statement No." := StmtNo;     //StatementNo;
                    BankAccReconciliationLine."Statement Line No." += 10000;
                    EVALUATE(BankAccReconciliationLine."Transaction Date", TransDate);
                    BankAccReconciliationLine.Description := COPYSTR(TransDescription, 1, 50);
                    IF TransDebitAmount = '' THEN
                        EVALUATE(TransDebitAmount, '0');

                    IF TransCreditAmount = '' THEN
                        EVALUATE(TransCreditAmount, '0');

                    IF (TransDebitAmount = '0') THEN
                        EVALUATE(BankAccReconciliationLine."Statement Amount", TransCreditAmount);

                    IF (TransCreditAmount = '0') THEN BEGIN
                        EVALUATE(BankAccReconciliationLine."Statement Amount", TransDebitAmount);
                        BankAccReconciliationLine."Statement Amount" := BankAccReconciliationLine."Statement Amount" * -1
                    END;

                    BankAccReconciliationLine.VALIDATE("Statement Amount");
                    EVALUATE(BankAccReconciliationLine."Debit Amount", TransCreditAmount);
                    EVALUATE(BankAccReconciliationLine."Credit Amount", TransDebitAmount);
                    BankAccReconciliationLine.INSERT;
                end;
            }
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field("Bank Account No."; BankAccNo)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the bank account number for the bank account reconciliation.';
                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        IF PAGE.RUNMODAL(0, BankAccReconciliation) = ACTION::LookupOK THEN BEGIN
                            BankAccNo := BankAccReconciliation."Bank Account No.";
                            StatementNo := BankAccReconciliation."Statement No.";
                        END;
                    end;
                }
                field("Statement No."; StatementNo)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the statement number for the bank account reconciliation.';
                }
            }
        }

        actions
        {
        }
    }

    var
        BankAccReconciliationLine: Record 274;
        LineNo: Integer;
        BankAccNo: Code[10];
        StatementNo: Code[10];
        BankAccReconciliation: Record 273;
        BankAccReconciliationLine2: Record 274;
}

