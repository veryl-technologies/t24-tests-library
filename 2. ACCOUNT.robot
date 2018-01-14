*** Settings ***
Library           T24WebDriver.py    #Test Teardown    Close Browsers
Library           Selenium2Library

*** Test Cases ***
Savings Account - LCY
    T24 Login    INPUTTER
    @{testDataFields}=    Create List    CUSTOMER=${m_ac_corp_cust}    CURRENCY=USD
    Create Or Amend T24 Record    ACCOUNT,SB.LCY    >>SavingsAccount    ${testDataFields}    Accept All    \    # Create Savings Account, Category 6001
    Authorize T24 Record    ACCOUNT    ${SavingsAccount}
    @{validationRules}=    Create List    CATEGORY :EQ:= 6-001
    Check T24 Record    ACCOUNT,SB.LCY    ${SavingsAccount}    ${validationRules}

Savings Account - FCY
    T24 Login    INPUTTER
    @{testDataFields}=    Create List    CUSTOMER=${m_ac_corp_cust}    CURRENCY=GBP
    Create Or Amend T24 Record    ACCOUNT,SB.FCY    >>SavingsAccount    ${testDataFields}    Accept All    \    # Create Savings Account, Category 6001
    Authorize T24 Record    ACCOUNT    ${SavingsAccount}
    @{validationRules}=    Create List    CATEGORY :EQ:= 6-001    CURRENCY :EQ:= GBP
    Check T24 Record    ACCOUNT,SB.FCY    ${SavingsAccount}    ${validationRules}

Current Account
    T24 Login    INPUTTER
    @{testDataFields}=    Create List    CUSTOMER=${m_ac_corp_cust}    CURRENCY=USD
    Create Or Amend T24 Record    ACCOUNT,CA.OPEN    >>CurrentAccount    ${testDataFields}    Accept All    \    # Create Savings Account, Category 6001
    Authorize T24 Record    ACCOUNT    ${CurrentAccount}
    @{validationRules}=    Create List    CURRENCY :EQ:= USD    CATEGORY :EQ:= 1-001
    Check T24 Record    ACCOUNT,CA.OPEN    ${CurrentAccount}    ${validationRules}

Nostro Account
    T24 Login    INPUTTER
    @{testDataFields}=    Create List    CUSTOMER=${m_ac_bank_cust}    CURRENCY=USD    OUR.EXT.ACCT.NO=?AUTO-VALUE
    Create Or Amend T24 Record    ACCOUNT,NOSTRO    >>AcctNostro    ${testDataFields}    Accept All    ${EMPTY}
    Authorize T24 Record    ACCOUNT    ${AcctNostro}
    @{validationRules}=    Create List    CATEGORY :EQ:= 5-001    CURRENCY :LK:= USD
    Check T24 Record    ACCOUNT,NOSTRO    ${AcctNostro}    ${validationRules}

Vostro Account
    T24 Login    INPUTTER
    @{testDataFields}=    Create List    CUSTOMER=${m_ac_bank_cust}    CURRENCY=USD
    Create Or Amend T24 Record    ACCOUNT,VOSTRO    >>AcctVostro    ${testDataFields}    Accept All    ${EMPTY}
    Authorize T24 Record    ACCOUNT    ${AcctVostro}
    @{validationRules}=    Create List    CATEGORY :EQ:= 2-001    CURRENCY :EQ:= USD
    Check T24 Record    ACCOUNT,VOSTRO    ${AcctVostro}    ${validationRules}

ACCOUNT CLOSURE
    T24 Login    INPUTTER
    @{testDataFields}=    Create List    CUSTOMER=${m_ac_corp_cust}    CURRENCY=USD
    Create Or Amend T24 Record    ACCOUNT,CA.OPEN    >>CurrentAccountClose    ${testDataFields}    Accept All    \    # Create Savings Account, Category 6001
    Authorize T24 Record    ACCOUNT    ${CurrentAccountClose}
    T24 Login    INPUTTER
    @{testDataFields}=    Create List    CUSTOMER=${m_ac_corp_cust}    CURRENCY=USD
    Create Or Amend T24 Record    ACCOUNT,CA.OPEN    >>CurrentAccountSettle    ${testDataFields}    Accept All    ${EMPTY}
    Authorize T24 Record    ACCOUNT    ${CurrentAccountSettle}
    T24 Login    INPUTTER
    @{testDataFields}=    Create List    SETTLEMENT.ACCT=${CurrentAccountSettle}    CLO.CHARGE.TYPE=ACCTCLOSE    CLO.CHARGE.AMT=5.00
    Create Or Amend T24 Record    ACCOUNT.CLOSURE,INPUT    ${CurrentAccountClose}    ${testDataFields}    Accept All    ${EMPTY}
    @{validationRules}=    Create List    ONLINE.ACTUAL.BAL :EQ:= -5.00
    Check T24 Record    ACCOUNT    ${CurrentAccountSettle}    ${validationRules}

Validate Nostro Account - External Acct No
    T24 Login    INPUTTER
    @{testDataFields}=    Create List    CUSTOMER=${m_ac_bank_cust}    CURRENCY=USD
    Validate T24 Record    ACCOUNT,NOSTRO    >>AcctNostro    ${testDataFields}    Accept All    Expect Error for Field:External Acct No

Validate Nostro Account - Customer ID
    T24 Login    INPUTTER
    @{testDataFields}=    Create List    CURRENCY=USD    OUR.EXT.ACCT.NO=?AUTO-VALUE
    Validate T24 Record    ACCOUNT,NOSTRO    >>AcctNostro    ${testDataFields}    Accept All    Expect Error for Field:Customer ID

Validate Nostro Account - Currency
    T24 Login    INPUTTER
    @{testDataFields}=    Create List    CUSTOMER=${m_ac_bank_cust}    OUR.EXT.ACCT.NO=?AUTO-VALUE
    Validate T24 Record    ACCOUNT,NOSTRO    >>AcctNostro    ${testDataFields}    Accept All    Expect Error for Field:Currency

Validate Nostro Account - SUCCESS
    T24 Login    INPUTTER
    @{testDataFields}=    Create List    CUSTOMER=${m_ac_bank_cust}    CURRENCY=USD    OUR.EXT.ACCT.NO=?AUTO-VALUE
    Validate T24 Record    ACCOUNT,NOSTRO    >>AcctNostro    ${testDataFields}    Accept All    ${EMPTY}
