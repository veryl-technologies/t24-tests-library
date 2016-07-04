*** Settings ***
Test Teardown     Close Browsers
Library           T24WebDriver.py
Library           Selenium2Library

*** Test Cases ***
Module Prerequisites
    @{testDataFields}=    Create List    NAME.1:1=?AUTO-VALUE    SHORT.NAME:1=?AUTO-VALUE    MNEMONIC=?AUTO-VALUE    ACCOUNT.OFFICER=${g_acct_officer_teller}    STREET:1=LAKESHORE STREET
    ...    NATIONALITY=${g_country_us}    RESIDENCE=${g_country_us}    LANGUAGE=${g_language_eng}    SECTOR=${g_sector_corporate}
    Create Or Amend T24 Record    CUSTOMER,CORP    >>m_ac_corp_cust    ${testDataFields}    \    ${EMPTY}
    Authorize T24 Record    CUSTOMER    ${m_ac_corp_cust}
    @{testDataFields}=    Create List    NAME.1:1=?AUTO-VALUE    SHORT.NAME:1=?AUTO-VALUE    MNEMONIC=?AUTO-VALUE    ACCOUNT.OFFICER=${g_acct_officer_teller}    CUSTOMER.STATUS=${g_cust_status_large_fin}
    ...    INDUSTRY=${g_industry_banks}    STREET:1=LAKESHORE STREET    NATIONALITY=${g_country_us}    RESIDENCE=${g_country_us}    LANGUAGE=${g_language_eng}    TARGET=${g_target_banks}
    ...    SECTOR=${g_sector_localbank}
    Create Or Amend T24 Record    CUSTOMER,CORP    >>m_ac_bank_cust    ${testDataFields}    \    ${EMPTY}
    Authorize T24 Record    CUSTOMER    ${m_ac_bank_cust}

Savings Account - LCY
    @{testDataFields}=    Create List    CUSTOMER=${m_ac_corp_cust}    CURRENCY=USD
    Create Or Amend T24 Record    ACCOUNT,SB.LCY    >>SavingsAccount    ${testDataFields}    Accept All    \    # Create Savings Account, Category 6001
    Authorize T24 Record    ACCOUNT    ${SavingsAccount}
    @{validationRules}=    Create List    CATEGORY :EQ:= 6-001
    Check T24 Record    ACCOUNT,SB.LCY    ${SavingsAccount}    ${validationRules}

Savings Account - FCY
    @{testDataFields}=    Create List    CUSTOMER=${m_ac_corp_cust}    CURRENCY=GBP
    Create Or Amend T24 Record    ACCOUNT,SB.FCY    >>SavingsAccount    ${testDataFields}    Accept All    \    # Create Savings Account, Category 6001
    Authorize T24 Record    ACCOUNT    ${SavingsAccount}
    @{validationRules}=    Create List    CATEGORY :EQ:= 6-001    CURRENCY :EQ:= GBP
    Check T24 Record    ACCOUNT,SB.FCY    ${SavingsAccount}    ${validationRules}

Current Account
    @{testDataFields}=    Create List    CUSTOMER=${m_ac_corp_cust}    CURRENCY=USD
    Create Or Amend T24 Record    ACCOUNT,CA.OPEN    >>CurrentAccount    ${testDataFields}    Accept All    \    # Create Savings Account, Category 6001
    Authorize T24 Record    ACCOUNT    ${CurrentAccount}
    @{validationRules}=    Create List    CURRENCY :EQ:= USD    CATEGORY :EQ:= 1-001
    Check T24 Record    ACCOUNT,CA.OPEN    ${CurrentAccount}    ${validationRules}

Nostro Account
    @{testDataFields}=    Create List    CUSTOMER=${m_ac_bank_cust}    CURRENCY=USD    OUR.EXT.ACCT.NO=?AUTO-VALUE
    Create Or Amend T24 Record    ACCOUNT,NOSTRO    >>AcctNostro    ${testDataFields}    Accept All    ${EMPTY}
    Authorize T24 Record    ACCOUNT    ${AcctNostro}
    @{validationRules}=    Create List    CATEGORY :EQ:= 5-001    CURRENCY :LK:= USD
    Check T24 Record    ACCOUNT,NOSTRO    ${AcctNostro}    ${validationRules}

Vostro Account
    @{testDataFields}=    Create List    CUSTOMER=${m_ac_bank_cust}    CURRENCY=USD
    Create Or Amend T24 Record    ACCOUNT,VOSTRO    >>AcctVostro    ${testDataFields}    Accept All    ${EMPTY}
    Authorize T24 Record    ACCOUNT    ${AcctVostro}
    @{validationRules}=    Create List    CATEGORY :EQ:= 2-001    CURRENCY :EQ:= USD
    Check T24 Record    ACCOUNT,VOSTRO    ${AcctVostro}    ${validationRules}

Internal Account - Manager Checks
    @{testDataFields}=    Create List    ACCOUNT.TITLE.2=?AUTO-VALUE
    Create Or Amend T24 Record    ACCOUNT,INT.AC1    USD${g_categ_int_ac_mng_chq}0001    ${testDataFields}    Accept All    ${EMPTY}
    Authorize T24 Record    ACCOUNT    USD${g_categ_int_ac_mng_chq}0001
    @{validationRules}=    Create List    CATEGORY :EQ:= 15-005    CURRENCY :EQ:= USD
    Check T24 Record    ACCOUNT,INT.AC1    USD${g_categ_int_ac_mng_chq}0001    ${validationRules}

ACCOUNT CLOSURE
    @{testDataFields}=    Create List    CUSTOMER=${m_ac_corp_cust}    CURRENCY=USD
    Create Or Amend T24 Record    ACCOUNT,CA.OPEN    >>CurrentAccountClose    ${testDataFields}    Accept All    \    # Create Savings Account, Category 6001
    Authorize T24 Record    ACCOUNT    ${CurrentAccountClose}
    @{testDataFields}=    Create List    CUSTOMER=${m_ac_corp_cust}    CURRENCY=USD
    Create Or Amend T24 Record    ACCOUNT,CA.OPEN    >>CurrentAccountSettle    ${testDataFields}    Accept All    ${EMPTY}
    Authorize T24 Record    ACCOUNT    ${CurrentAccountSettle}
    @{testDataFields}=    Create List    SETTLEMENT.ACCT=${CurrentAccountSettle}    CLO.CHARGE.TYPE=ACCTCLOSE    CLO.CHARGE.AMT=5.00
    Create Or Amend T24 Record    ACCOUNT.CLOSURE,INPUT    ${CurrentAccountClose}    ${testDataFields}    Accept All    ${EMPTY}
    @{validationRules}=    Create List    ONLINE.ACTUAL.BAL :EQ:= -5.00
    Check T24 Record    ACCOUNT    ${CurrentAccountSettle}    ${validationRules}
