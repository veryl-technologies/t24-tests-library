*** Settings ***
Suite Teardown    Close Browsers
Library           T24WebDriver.py
Library           Selenium2Library

*** Test Cases ***
2. ACCOUNT
    @{testDataFields}=    Create List    NAME.1:1=?AUTO-VALUE    SHORT.NAME:1=?AUTO-VALUE    MNEMONIC=?AUTO-VALUE    ACCOUNT.OFFICER=${g_acct_officer_teller}    STREET:1=LAKESHORE STREET
    ...    NATIONALITY=${g_country_us}    RESIDENCE=${g_country_us}    LANGUAGE=${g_language_eng}    SECTOR=${g_sector_corporate}
    Create Or Amend T24 Record    CUSTOMER,CORP    >>m_ac_corp_cust    ${testDataFields}    Accept All    ${EMPTY}
    Authorize T24 Record    CUSTOMER    ${m_ac_corp_cust}
    @{testDataFields}=    Create List    NAME.1:1=?AUTO-VALUE    SHORT.NAME:1=?AUTO-VALUE    MNEMONIC=?AUTO-VALUE    ACCOUNT.OFFICER=${g_acct_officer_teller}    CUSTOMER.STATUS=${g_cust_status_large_fin}
    ...    INDUSTRY=${g_industry_banks}    STREET:1=LAKESHORE STREET    NATIONALITY=${g_country_us}    RESIDENCE=${g_country_us}    LANGUAGE=${g_language_eng}    TARGET=${g_target_banks}
    ...    SECTOR=${g_sector_localbank}
    Create Or Amend T24 Record    CUSTOMER,CORP    >>m_ac_bank_cust    ${testDataFields}    Accept All    ${EMPTY}
    Authorize T24 Record    CUSTOMER    ${m_ac_bank_cust}

3. TELLER
    @{testDataFields}=    Create List    NAME.1:1=?AUTO-VALUE    SHORT.NAME:1=?AUTO-VALUE    MNEMONIC=?AUTO-VALUE    ACCOUNT.OFFICER=${g_acct_officer_teller}    STREET:1=LAKESHORE STREET
    ...    NATIONALITY=${g_country_us}    RESIDENCE=${g_country_us}    LANGUAGE=${g_language_eng}    SECTOR=${g_sector_corporate}
    Create Or Amend T24 Record    CUSTOMER,CORP    >>m_teller_corp_cust    ${testDataFields}    Accept All    ${EMPTY}
    Authorize T24 Record    CUSTOMER    ${m_teller_corp_cust}
    @{testDataFields}=    Create List    CUSTOMER=${m_teller_corp_cust}    CURRENCY=USD
    Create Or Amend T24 Record    ACCOUNT,SB.LCY    >>m_teller_savings_acc_lcy    ${testDataFields}    Accept All    ${EMPTY}
    Authorize T24 Record    ACCOUNT    ${m_teller_savings_acc_lcy}
    @{testDataFields}=    Create List    AMOUNT.LOCAL.1:1=1000.03    ACCOUNT.2=${m_teller_savings_acc_lcy}    NARRATIVE.2:1=Deposit cash    DR.UNIT:1=10    DR.UNIT:12=3
    Create Or Amend T24 Record    TELLER,LCY.CASHIN    >>CashDepLCY    ${testDataFields}    Accept All    ${EMPTY}
    Authorize T24 Record    TELLER,LCY.CASHIN    ${CashDepLCY}
    @{testDataFields}=    Create List    CUSTOMER=${m_teller_corp_cust}    CURRENCY=GBP
    Create Or Amend T24 Record    ACCOUNT,SB.FCY    >>m_teller_savings_acc_fcy    ${testDataFields}    Accept All    \    # Create Savings Account, Category 6001
    Authorize T24 Record    ACCOUNT    ${m_teller_savings_acc_fcy}
    @{testDataFields}=    Create List    CURRENCY.1=GBP    AMOUNT.FCY.1:1=1000.03    ACCOUNT.2=${m_teller_savings_acc_fcy}    NARRATIVE.2:1=Initial Deposit    DR.UNIT:3=20
    ...    DR.UNIT:11=3
    Create Or Amend T24 Record    TELLER,FCY.CASHIN    >>CashDepFCY    ${testDataFields}    \    ${EMPTY}
    Authorize T24 Record    TELLER,FCY.CASHIN    ${CashDepFCY}
    @{validationRules}=    Create List    SELL.RATE >> m_teller_curr_GBP
    Check T24 Record    CURRENCY    GBP    ${validationRules}

4. FUNDS TRANSFER
    @{testDataFields}=    Create List    NAME.1:1=?AUTO-VALUE    SHORT.NAME:1=?AUTO-VALUE    MNEMONIC=?AUTO-VALUE    ACCOUNT.OFFICER=${g_acct_officer_teller}    CUSTOMER.STATUS=${g_cust_status_large_fin}
    ...    INDUSTRY=${g_industry_banks}    STREET:1=LAKESHORE STREET    NATIONALITY=${g_country_us}    RESIDENCE=${g_country_us}    LANGUAGE=${g_language_eng}    TARGET=${g_target_banks}
    ...    SECTOR=${g_sector_localbank}
    Create Or Amend T24 Record    CUSTOMER,CORP    >>m_ft_bank_cust    ${testDataFields}    \    ${EMPTY}
    Authorize T24 Record    CUSTOMER    ${m_ft_bank_cust}
    @{testDataFields}=    Create List    CUSTOMER=${m_ft_bank_cust}    CURRENCY=USD    OUR.EXT.ACCT.NO=?AUTO-VALUE
    Create Or Amend T24 Record    ACCOUNT,NOSTRO    >>m_ft_acct_nostro    ${testDataFields}    \    ${EMPTY}
    Authorize T24 Record    ACCOUNT    ${m_ft_acct_nostro}
    @{testDataFields}=    Create List    NAME.1:1=?AUTO-VALUE    SHORT.NAME:1=?AUTO-VALUE    MNEMONIC=?AUTO-VALUE    ACCOUNT.OFFICER=${g_acct_officer_teller}    STREET:1=LAKESHORE STREET
    ...    NATIONALITY=${g_country_us}    RESIDENCE=${g_country_us}    LANGUAGE=${g_language_eng}    SECTOR=${g_sector_corporate}
    Create Or Amend T24 Record    CUSTOMER,CORP    >>m_ft_corp_cust    ${testDataFields}    Accept All    ${EMPTY}
    Authorize T24 Record    CUSTOMER    ${m_ft_corp_cust}
    @{testDataFields}=    Create List    CUSTOMER=${m_ft_corp_cust}    CURRENCY=USD
    Create Or Amend T24 Record    ACCOUNT,SB.LCY    >>m_ft_savings_acc_lcy    ${testDataFields}    Accept All    ${EMPTY}
    Authorize T24 Record    ACCOUNT    ${m_ft_savings_acc_lcy}
    @{testDataFields}=    Create List    AMOUNT.LOCAL.1:1=1000.03    ACCOUNT.2=${m_ft_savings_acc_lcy}    NARRATIVE.2:1=Deposit cash    DR.UNIT:1=10    DR.UNIT:12=3
    Create Or Amend T24 Record    TELLER,LCY.CASHIN    >>CashDepLCY    ${testDataFields}    Accept All    ${EMPTY}
    Authorize T24 Record    TELLER,LCY.CASHIN    ${CashDepLCY}
    @{testDataFields}=    Create List    CUSTOMER=${m_ft_corp_cust}    CURRENCY=USD
    Create Or Amend T24 Record    ACCOUNT,SB.LCY    >>m_ft_savings_acc_lcy2    ${testDataFields}    \    ${EMPTY}
    Authorize T24 Record    ACCOUNT    ${m_ft_savings_acc_lcy2}
    @{testDataFields}=    Create List    AMOUNT.LOCAL.1:1=100.03    ACCOUNT.2=${m_ft_savings_acc_lcy2}    NARRATIVE.2:1=Deposit cash    DR.UNIT:1=1    DR.UNIT:12=3
    Create Or Amend T24 Record    TELLER,LCY.CASHIN    >>CashDepLCY    ${testDataFields}    \    ${EMPTY}
    Authorize T24 Record    TELLER,LCY.CASHIN    ${CashDepLCY}
    @{testDataFields}=    Create List    CUSTOMER=${m_ft_corp_cust}    CURRENCY=GBP
    Create Or Amend T24 Record    ACCOUNT,SB.FCY    >>m_ft_savings_acc_fcy    ${testDataFields}    Accept All    \    # Create Savings Account, Category 6001
    Authorize T24 Record    ACCOUNT    ${m_ft_savings_acc_fcy}
    @{testDataFields}=    Create List    CURRENCY.1=GBP    AMOUNT.FCY.1:1=1000.03    ACCOUNT.2=${m_ft_savings_acc_fcy}    NARRATIVE.2:1=Initial Deposit    DR.UNIT:1=20
    ...    DR.UNIT:11=3
    Create Or Amend T24 Record    TELLER,FCY.CASHIN    >>CashDepFCY    ${testDataFields}    \    ${EMPTY}
    Authorize T24 Record    TELLER,FCY.CASHIN    ${CashDepFCY}
