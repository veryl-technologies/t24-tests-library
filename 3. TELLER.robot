*** Settings ***
Suite Teardown    Close Browsers
Library           T24WebDriver.py
Library           Selenium2Library

*** Test Cases ***
Module Prerequisites
    @{testDataFields}=    Create List    NAME.1:1=?AUTO-VALUE    SHORT.NAME:1=?AUTO-VALUE    MNEMONIC=?AUTO-VALUE    ACCOUNT.OFFICER=${g_acct_officer_teller}    STREET:1=LAKESHORE STREET
    ...    NATIONALITY=${g_country_us}    RESIDENCE=${g_country_us}    LANGUAGE=${g_language_eng}    SECTOR=${g_sector_corporate}
    Create Or Amend T24 Record    CUSTOMER,CORP    >>m_teller_corp_cust    ${testDataFields}    \    ${EMPTY}
    Authorize T24 Record    CUSTOMER    ${m_teller_corp_cust}
    @{testDataFields}=    Create List    CUSTOMER=${m_teller_corp_cust}    CURRENCY=USD
    Create Or Amend T24 Record    ACCOUNT,SB.LCY    >>m_teller_savings_acc_lcy    ${testDataFields}    \    ${EMPTY}
    Authorize T24 Record    ACCOUNT    ${m_teller_savings_acc_lcy}

Cash Deposit - Local
    @{validationRules}=    Create List    WORKING.BALANCE >> w.balance
    Check T24 Record    ACCOUNT    ${m_teller_savings_acc_lcy}    ${validationRules}
    @{testDataFields}=    Create List    AMOUNT.LOCAL.1:1=100.23    ACCOUNT.2=${m_teller_savings_acc_lcy}    NARRATIVE.2:1=Deposit cash    DR.UNIT:1=1
    Create Or Amend T24 Record    TELLER,LCY.CASHIN    >>CashDepLCY    ${testDataFields}    Accept All    ${EMPTY}
    Authorize T24 Record    TELLER,LCY.CASHIN    ${CashDepLCY}
    @{validationRules}=    Create List    WORKING.BALANCE :EQ:= ? ${w.balance} + 100.23
    Check T24 Record    ACCOUNT    ${m_teller_savings_acc_lcy}    ${validationRules}

Cash Deposit - Local - 66
    @{validationRules}=    Create List    WORKING.BALANCE >> w.balance
    Check T24 Record    ACCOUNT    ${m_teller_savings_acc_lcy}    ${validationRules}
    @{testDataFields}=    Create List    AMOUNT.LOCAL.1:1=66.5    ACCOUNT.2=${m_teller_savings_acc_lcy}    NARRATIVE.2:1=Deposit cash    DR.UNIT:2=1    DR.UNIT:4=1
    ...    DR.UNIT:5=1    DR.UNIT:7=1    DR.UNIT:8=1
    Create Or Amend T24 Record    TELLER,LCY.CASHIN    >>CashDepLCY    ${testDataFields}    Accept All    ${EMPTY}
    Authorize T24 Record    TELLER,LCY.CASHIN    ${CashDepLCY}
    @{validationRules}=    Create List    WORKING.BALANCE :EQ:= ? ${w.balance} + 66.5
    Check T24 Record    ACCOUNT    ${m_teller_savings_acc_lcy}    ${validationRules}
