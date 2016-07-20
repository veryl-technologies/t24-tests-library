*** Settings ***
Suite Teardown    Close Browsers
Library           T24WebDriver.py
Library           Selenium2Library

*** Test Cases ***
Account Transfer - LCY to LCY
    @{validationRules}=    Create List    WORKING.BALANCE >> w_balance
    Check T24 Record    ACCOUNT    ${m_ft_savings_acc_lcy}    ${validationRules}    # Check the account balance before the transaction
    @{testDataFields}=    Create List    DEBIT.ACCT.NO=${m_ft_savings_acc_lcy}    DEBIT.CURRENCY=USD    DEBIT.AMOUNT=10.05    CREDIT.ACCT.NO=${m_ft_savings_acc_lcy2}    CREDIT.CURRENCY=USD
    Create Or Amend T24 Record    FUNDS.TRANSFER,ACTR.FTHP    >>ft_lcy_lcy    ${testDataFields}    \    ${EMPTY}
    Authorize T24 Record    FUNDS.TRANSFER    ${ft_lcy_lcy}
    @{validationRules}=    Create List    WORKING.BALANCE :EQ:= ? ${w_balance} - 10.05
    Check T24 Record    ACCOUNT    ${m_ft_savings_acc_lcy}    ${validationRules}    # Check the balance of the first account
    @{validationRules}=    Create List    WORKING.BALANCE :EQ:= ? ${w_balance} + 10.05
    Check T24 Record    ACCOUNT    ${m_ft_savings_acc_lcy2}    ${validationRules}

Account Transfer - LCY to FCY
    @{validationRules}=    Create List    WORKING.BALANCE >> w_balance_lcy
    Check T24 Record    ACCOUNT    ${m_ft_savings_acc_lcy}    ${validationRules}
    @{validationRules}=    Create List    WORKING.BALANCE >> w_balance_fcy
    Check T24 Record    ACCOUNT    ${m_ft_savings_acc_fcy}    ${validationRules}
    @{testDataFields}=    Create List    DEBIT.ACCT.NO=${m_ft_savings_acc_lcy}    DEBIT.CURRENCY=USD    DEBIT.AMOUNT=10.05    CREDIT.ACCT.NO=${m_ft_savings_acc_fcy}    CREDIT.CURRENCY=GBP
    Create Or Amend T24 Record    FUNDS.TRANSFER,ACTR.FTHP    >>ft    ${testDataFields}    \    ${EMPTY}
    Authorize T24 Record    FUNDS.TRANSFER    ${ft}
    @{validationRules}=    Create List    WORKING.BALANCE :EQ:= ? ${w_balance_lcy} - 10.05
    Check T24 Record    ACCOUNT    ${m_ft_savings_acc_lcy}    ${validationRules}    # Check the balance of the first account
    @{validationRules}=    Create List    WORKING.BALANCE :EQ:= ? round (${w_balance_fcy} + (10.05 / 1.6812), 2)
    Check T24 Record    ACCOUNT    ${m_ft_savings_acc_fcy}    ${validationRules}

Account Transfer - FCY to LCY
    @{validationRules}=    Create List    WORKING.BALANCE >> w_balance_lcy
    Check T24 Record    ACCOUNT    ${m_ft_savings_acc_lcy}    ${validationRules}
    @{validationRules}=    Create List    WORKING.BALANCE >> w_balance_fcy
    Check T24 Record    ACCOUNT    ${m_ft_savings_acc_fcy}    ${validationRules}
    @{testDataFields}=    Create List    DEBIT.ACCT.NO=${m_ft_savings_acc_fcy}    DEBIT.CURRENCY=GBP    DEBIT.AMOUNT=10.05    CREDIT.ACCT.NO=${m_ft_savings_acc_lcy}    CREDIT.CURRENCY=USD
    Create Or Amend T24 Record    FUNDS.TRANSFER,ACTR.FTHP    >>ft    ${testDataFields}    \    ${EMPTY}
    Authorize T24 Record    FUNDS.TRANSFER    ${ft}
    @{validationRules}=    Create List    WORKING.BALANCE :EQ:= ? round(${w_balance_lcy} + (10.05 * 1.6812),2)
    Check T24 Record    ACCOUNT    ${m_ft_savings_acc_lcy}    ${validationRules}    # Check the balance of the first account
    @{validationRules}=    Create List    WORKING.BALANCE :EQ:= ? ${w_balance_fcy} - 10.05
    Check T24 Record    ACCOUNT    ${m_ft_savings_acc_fcy}    ${validationRules}

Outward Remittance - OT102
    @{testDataFields}=    Create List    DEBIT.ACCT.NO=${m_ft_savings_acc_lcy}    DEBIT.CURRENCY=USD    DEBIT.AMOUNT=10.05    BEN.CUSTOMER:1=Customer X    CREDIT.CURRENCY=USD
    ...    CREDIT.ACCT.NO=${m_ft_acct_nostro}
    Create Or Amend T24 Record    FUNDS.TRANSFER,OT102    >>ft    ${testDataFields}    \    ${EMPTY}
    Authorize T24 Record    FUNDS.TRANSFER    ${ft}

Outward Remittance - OT103
    @{testDataFields}=    Create List    DEBIT.ACCT.NO=${m_ft_savings_acc_lcy}    DEBIT.CURRENCY=USD    DEBIT.AMOUNT=10.05    BEN.CUSTOMER:1=Customer X    CREDIT.CURRENCY=USD
    ...    CREDIT.ACCT.NO=${m_ft_acct_nostro}
    Create Or Amend T24 Record    FUNDS.TRANSFER,OT103.SERIAL.FTHP    >>ft    ${testDataFields}    \    ${EMPTY}
    Authorize T24 Record    FUNDS.TRANSFER    ${ft}
    @{enquiryConstraints}=    Create List    TRANSACTION.REF :EQ:= FT14112TJCDP    Message type :EQ:= 103
    @{validationRules}=    Create List
    Execute T24 Enquiry    %DE.O.HEADER    ${enquiryConstraints}    1    ${validationRules}

Outward Remittance - OT103 - TEST
    @{enquiryConstraints}=    Create List    TRANSACTION.REF :EQ:= FT14112TJCDP    Message type :EQ:= 103
    @{validationRules}=    Create List
    Execute T24 Enquiry    %DE.O.HEADER    ${enquiryConstraints}    1    ${validationRules}
    @{validationRules}=    Create List    ACCOUNT.NUMBER :EQ:= 76015
    Check T24 Record    DE.O.HEADER    \    ${validationRules}

Menu
    Execute T24 Menu Command    User Menu > Customer > Corporate Customer
    @{testDataFields}=    Create List    NAME.1:1=?AUTO-VALUE    SHORT.NAME:1=?AUTO-VALUE    MNEMONIC=?AUTO-VALUE    ACCOUNT.OFFICER=${g_acct_officer_teller}    STREET:1=LAKESHORE STREET
    ...    NATIONALITY=${g_country_us}    RESIDENCE=${g_country_us}    LANGUAGE=${g_language_eng}    SECTOR=${g_sector_corporate}
    Create Or Amend T24 Record    CUSTOMER,CORP    \    ${testDataFields}    \    ${EMPTY}