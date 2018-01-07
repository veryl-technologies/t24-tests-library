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

Menu+COS1
    Execute T24 Menu Command    Unauthorised Customer
    @{enquiryConstraints}=    Create List    Customer No :EQ:= 100226
    @{validationRules}=    Create List
    Execute T24 Enquiry    CUSTOMER.NAU.AMEND    ${enquiryConstraints}    Edit    ${validationRules}
    @{testDataFields}=    Create List    MNEMONIC=COOPERA1
    Create Or Amend T24 Record    CUSTOMER,INPUT    \    ${testDataFields}    Accept All    ${EMPTY}

Menu+COS2
    Execute T24 Menu Command    Home Page - Customer Service Agent
    Execute T24 Menu Command    Create SME Customer
    @{testDataFields}=    Create List    ACCOUNT.OFFICER=4    NATIONALITY=BG
    Create Or Amend T24 Record    CUSTOMER,SME    \    ${testDataFields}    \    ${EMPTY}

tab
    Execute T24 Menu Command    Home Page - Customer Service Agent
    Execute T24 Tab Command    Till Admin > Exchange Rates
    @{enquiryConstraints}=    Create List    Ccy :EQ:= AUD
    @{validationRules}=    Create List
    Execute T24 Enquiry    CURRENCY.RATES    ${enquiryConstraints}    View    ${validationRules}
    @{validationRules}=    Create List    SELL.RATE >> m_bsb
    Check T24 Record    CURRENCY,EXCH.RATES    \    ${validationRules}

Amend Beneficiary using COS
    Execute T24 Menu Command    Home Page - Payments
    Execute T24 Menu Command    Funds Transfers > Beneficiary Details
    Execute T24 Tab Command    Beneficiary List
    @{enquiryConstraints}=    Create List    Transaction Ref :EQ:= BEN1409314000
    @{validationRules}=    Create List
    Execute T24 Enquiry    BENEFICIARY.LIST    ${enquiryConstraints}    Amend    ${validationRules}
    @{testDataFields}=    Create List    HINT.TEXT=?AUTO-VALUE
    Create Or Amend T24 Record    BENEFICIARY,CREATE    \    ${testDataFields}    Accept All    Fail

Validate
    @{testDataFields}=    Create List
    Validate T24 Record    ACCOUNT    \    ${testDataFields}    \    Expect Any Error
    @{testDataFields}=    Create List
    Validate T24 Record    ACCOUNT    \    ${testDataFields}    \    Expect Error for Field:CURRENCY
