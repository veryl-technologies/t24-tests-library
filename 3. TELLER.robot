*** Settings ***
Suite Teardown    Close Browsers
Library           T24WebDriver.py
Library           Selenium2Library

*** Test Cases ***
Cash Deposit - Local
    @{validationRules}=    Create List    WORKING.BALANCE >> w.balance
    Check T24 Record    ACCOUNT    ${m_teller_savings_acc_lcy}    ${validationRules}
    @{testDataFields}=    Create List    AMOUNT.LOCAL.1:1=66.5    ACCOUNT.2=${m_teller_savings_acc_lcy}    NARRATIVE.2:1=Deposit cash    DR.UNIT:2=1    DR.UNIT:4=1
    ...    DR.UNIT:5=1    DR.UNIT:7=1    DR.UNIT:8=1
    Create Or Amend T24 Record    TELLER,LCY.CASHIN    >>CashDepLCY    ${testDataFields}    Accept All    ${EMPTY}
    Authorize T24 Record    TELLER,LCY.CASHIN    ${CashDepLCY}
    @{validationRules}=    Create List    WORKING.BALANCE :EQ:= ? ${w.balance} + 66.5
    Check T24 Record    ACCOUNT    ${m_teller_savings_acc_lcy}    ${validationRules}

Cash Deposit - Foreign
    @{validationRules}=    Create List    WORKING.BALANCE >> w.balance
    Check T24 Record    ACCOUNT    ${m_teller_savings_acc_fcy}    ${validationRules}
    @{testDataFields}=    Create List    CURRENCY.1=GBP    AMOUNT.FCY.1:1=10.35    ACCOUNT.2=${m_teller_savings_acc_fcy}    NARRATIVE.2:1=Additional Deposit    DR.UNIT:3=1
    ...    DR.UNIT:8=1    DR.UNIT:9=1    DR.UNIT:11=5
    Create Or Amend T24 Record    TELLER,FCY.CASHIN    >>CashDepFCY    ${testDataFields}    \    ${EMPTY}
    Authorize T24 Record    TELLER,FCY.CASHIN    ${CashDepFCY}
    @{validationRules}=    Create List    WORKING.BALANCE :EQ:= ? ${w.balance} + 10.35
    Check T24 Record    ACCOUNT    ${m_teller_savings_acc_fcy}    ${validationRules}

Cash Deposit - Local - Foreign
    @{validationRules}=    Create List    WORKING.BALANCE >> w.balance
    Check T24 Record    ACCOUNT    ${m_teller_savings_acc_fcy}    ${validationRules}
    @{testDataFields}=    Create List    AMOUNT.LOCAL.1:1=10.00    CURRENCY.2=GBP    ACCOUNT.2=${m_teller_savings_acc_fcy}    NARRATIVE.2:1=Deposit USD into GBP account    DR.UNIT:4=1
    Create Or Amend T24 Record    TELLER,LCY.CASHIN.FCY.ACCT    >>CashDepLcyFcy    ${testDataFields}    \    ${EMPTY}
    Authorize T24 Record    TELLER,LCY.CASHIN.FCY.ACCT    ${CashDepLcyFcy}
    @{validationRules}=    Create List    WORKING.BALANCE :EQ:= ? round (${w.balance} / ${SREUR}, 2)
    Check T24 Record    ACCOUNT    ${m_teller_savings_acc_fcy}    ${validationRules}
