*** Settings ***
Suite Teardown    Close Browsers
Library           T24WebDriver.py
Library           Selenium2Library

*** Test Cases ***
2. ACCOUNT
    @{testDataFields}=    Create List    NAME.1:1=?AUTO-VALUE    SHORT.NAME:1=?AUTO-VALUE    MNEMONIC=?AUTO-VALUE    ACCOUNT.OFFICER=${g_acct_officer_teller}    STREET:1=LAKESHORE STREET
    ...    NATIONALITY=${g_country_us}    RESIDENCE=${g_country_us}    LANGUAGE=${g_language_eng}    SECTOR=${g_sector_corporate}
    Create Or Amend T24 Record    CUSTOMER,CORP    >>m_ac_corp_cust    ${testDataFields}    \    ${EMPTY}
    Authorize T24 Record    CUSTOMER    ${m_ac_corp_cust}
    @{testDataFields}=    Create List    NAME.1:1=?AUTO-VALUE    SHORT.NAME:1=?AUTO-VALUE    MNEMONIC=?AUTO-VALUE    ACCOUNT.OFFICER=${g_acct_officer_teller}    CUSTOMER.STATUS=${g_cust_status_large_fin}
    ...    INDUSTRY=${g_industry_banks}    STREET:1=LAKESHORE STREET    NATIONALITY=${g_country_us}    RESIDENCE=${g_country_us}    LANGUAGE=${g_language_eng}    TARGET=${g_target_banks}
    ...    SECTOR=${g_sector_localbank}
    Create Or Amend T24 Record    CUSTOMER,CORP    >>m_ac_bank_cust    ${testDataFields}    \    ${EMPTY}
    Authorize T24 Record    CUSTOMER    ${m_ac_bank_cust}

3. TELLER
    @{testDataFields}=    Create List    NAME.1:1=?AUTO-VALUE    SHORT.NAME:1=?AUTO-VALUE    MNEMONIC=?AUTO-VALUE    ACCOUNT.OFFICER=${g_acct_officer_teller}    STREET:1=LAKESHORE STREET
    ...    NATIONALITY=${g_country_us}    RESIDENCE=${g_country_us}    LANGUAGE=${g_language_eng}    SECTOR=${g_sector_corporate}
    Create Or Amend T24 Record    CUSTOMER,CORP    >>m_teller_corp_cust    ${testDataFields}    \    ${EMPTY}
    Authorize T24 Record    CUSTOMER    ${m_teller_corp_cust}
    @{testDataFields}=    Create List    CUSTOMER=${m_teller_corp_cust}    CURRENCY=USD
    Create Or Amend T24 Record    ACCOUNT,SB.LCY    >>m_teller_savings_acc_lcy    ${testDataFields}    \    ${EMPTY}
    Authorize T24 Record    ACCOUNT    ${m_teller_savings_acc_lcy}
