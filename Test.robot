*** Settings ***
Suite Teardown    Close Browsers
Library           T24WebDriver.py
Library           Selenium2Library

*** Test Cases ***
Menu
    Execute T24 Menu Command    User Menu > Customer > Corporate Customer
    @{testDataFields}=    Create List    NAME.1:1=?AUTO-VALUE    SHORT.NAME:1=?AUTO-VALUE    MNEMONIC=?AUTO-VALUE    ACCOUNT.OFFICER=${g_acct_officer_teller}    STREET:1=LAKESHORE STREET
    ...    NATIONALITY=${g_country_us}    RESIDENCE=${g_country_us}    LANGUAGE=${g_language_eng}    SECTOR=${g_sector_corporate}
    Create Or Amend T24 Record    CUSTOMER,CORP    >>m_corpcust    ${testDataFields}    Accept All    ${EMPTY}

Buy FCY against cash in LCY
    @{testDataFields}=    Create List    CURRENCY.1=GBP    AMOUNT.FCY.1:1=100.50    NARRATIVE.1:1:1=BUY GBP    UNIT:1=1    UNIT:3=3
    ...    UNIT:6=4    UNIT:8=1    UNIT:10=4    UNIT:11=1    DR.UNIT:1=2    DR.UNIT:7=1
    Create Or Amend T24 Record    TELLER,BUYFCY.CASH    >>CurrBuyFCY    ${testDataFields}    Accept All    ${EMPTY}

Internal Account - Manager Checks
    @{testDataFields}=    Create List    ACCOUNT.TITLE.2=?AUTO-VALUE
    Create Or Amend T24 Record    ACCOUNT,INT.AC1    USD${g_categ_int_ac_mng_chq}0001    ${testDataFields}    Accept All    ${EMPTY}
    Authorize T24 Record    ACCOUNT    USD${g_categ_int_ac_mng_chq}0001
    @{validationRules}=    Create List    CATEGORY :EQ:= 15-005    CURRENCY :EQ:= USD
    Check T24 Record    ACCOUNT,INT.AC1    USD${g_categ_int_ac_mng_chq}0001    ${validationRules}
