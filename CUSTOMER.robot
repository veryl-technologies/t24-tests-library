*** Settings ***
Documentation     Test suite that demonstrates the main functionalities of I,A,S,ENQ commandsfiel
Test Teardown     Close Browsers
Library           T24WebDriver.py
Library           Selenium2Library    run_on_failure=Nothing

*** Test Cases ***
Prerequisites
    @{validationRules}=    Create List    TODAY >> g_today
    Check T24 Record    DATES    BNK    ${validationRules}    # Get today's date
    @{validationRules}=    Create List    LOCAL.COUNTRY >> g_local_country
    Check T24 Record    COMPANY    BNK    ${validationRules}    # Get Local Country
    @{validationRules}=    Create List    @ID >> g_country_us
    Check T24 Record    COUNTRY    US    ${validationRules}    # Check if US country exists - used in CUSTOMER CORP and INPUT
    @{validationRules}=    Create List    CO.CODE >> g_co_code
    Check T24 Record    COUNTRY    ${g_local_country}    ${validationRules}    # Get the country code of the local country
    @{validationRules}=    Create List
    Check T24 Record    SCTR.GROUP.CONDITION    999    ${validationRules}
    @{validationRules}=    Create List    @ID >> g_acct_officer_impl
    Check T24 Record    DEPT.ACCT.OFFICER    1    ${validationRules}    # Account officer is Implementation - used in CUSTOMER,INPUT
    @{validationRules}=    Create List    @ID >> g_acct_officer_teller
    Check T24 Record    DEPT.ACCT.OFFICER    31    ${validationRules}    # Account officer is Teller - used in CUSTOMER,CORP
    @{validationRules}=    Create List    @ID >> g_sector_corporate
    Check T24 Record    SECTOR    2001    ${validationRules}    # Corporate sector - used in CUSTOMER,CORP
    @{validationRules}=    Create List    @ID >> g_sector_centralbank
    Check T24 Record    SECTOR    3002    ${validationRules}    # Sector for cetral bank customer - used in CUSTOMER,CORP
    @{validationRules}=    Create List    @ID >> g_sector_localbank
    Check T24 Record    SECTOR    3001    ${validationRules}    # Sector for local bank customer - used in CUSTOMER,CORP
    @{validationRules}=    Create List    @ID >> g_sector_bankbranch
    Check T24 Record    SECTOR    3005    ${validationRules}    # Sector for bank branch - used in CUSTOMER,CORP
    @{validationRules}=    Create List    @ID >> g_sector_financialcorp
    Check T24 Record    SECTOR    3501    ${validationRules}    # Sector for financial corporations - used in CUSTOMER,CORP
    @{validationRules}=    Create List    @ID >> g_sector_indiv
    Check T24 Record    SECTOR    1001    ${validationRules}    # Individual sector - used in CUSTOMER,INPUT
    @{validationRules}=    Create List    @ID >> g_industry_private_person
    Check T24 Record    INDUSTRY    1000    ${validationRules}    # Get Industry record for private person - used in CUSTOMER,INPUT
    @{validationRules}=    Create List    @ID >> g_industry_other_fin
    Check T24 Record    INDUSTRY    3900    ${validationRules}    # Get industry for financial institutions - used in CU,CORP
    @{validationRules}=    Create List    @ID >> g_industry_banks
    Check T24 Record    INDUSTRY    3100    ${validationRules}    # Get industry for banks - used in CU,CORP
    @{validationRules}=    Create List    @ID >> g_language_eng
    Check T24 Record    LANGUAGE    1    ${validationRules}    # Get language - English - used in CUSTOMER,INPUT
    @{validationRules}=    Create List    @ID >> g_cust_status_private_std
    Check T24 Record    CUSTOMER.STATUS    1    ${validationRules}    # Get CU Status for private standard client - used in CUSTOMER,INPUT
    @{validationRules}=    Create List    @ID >> g_cust_status_large_fin
    Check T24 Record    CUSTOMER.STATUS    23    ${validationRules}    # CU Status for large financial institution - used in Customer,CORP for local bank
    @{validationRules}=    Create List    @ID >> g_cust_status_gvrn
    Check T24 Record    CUSTOMER.STATUS    31    ${validationRules}    # CU Status for governmental institutions - used in CU,CORP for central bank
    @{validationRules}=    Create List    @ID >> g_cust_status_corp_medium
    Check T24 Record    CUSTOMER.STATUS    17    ${validationRules}    # CU Status for medium corporate institutions - used in CU,CORP for bank branch
    @{validationRules}=    Create List    @ID >> g_cust_status_fin_medium
    Check T24 Record    CUSTOMER.STATUS    22    ${validationRules}    # CU Status for financial medium institutions - used in CU,CORP for financial institutions
    @{validationRules}=    Create List    @ID >> g_target_private_std
    Check T24 Record    TARGET    1    ${validationRules}    # Get target for private standard client - used in CUSTOMER,INPUT
    @{validationRules}=    Create List    @ID >> g_target_banks
    Check T24 Record    TARGET    30    ${validationRules}    # Get target for banks - used in CU,CORP
    @{validationRules}=    Create List    @ID >> g_target_other
    Check T24 Record    TARGET    999    ${validationRules}    # Get target for other - used in CU,CORP
    @{validationRules}=    Create List    @ID >> g_target_corp_entity
    Check T24 Record    TARGET    7    ${validationRules}    # Get target for corporate entity - used in CU,CORP for financial institutions

Individual Customer
    @{testDataFields}=    Create List    TITLE=MR    GENDER=MALE    ACCOUNT.OFFICER=${g_acct_officer_impl}    CUSTOMER.STATUS=${g_cust_status_private_std}    FAMILY.NAME=?AUTO-VALUE
    ...    GIVEN.NAMES=?AUTO-VALUE    INDUSTRY=${g_industry_private_person}    LANGUAGE=${g_language_eng}    NAME.1:1=?AUTO-VALUE    SHORT.NAME:1=?AUTO-VALUE    MNEMONIC=?AUTO-VALUE
    ...    SECTOR=${g_sector_indiv}    TARGET=${g_target_private_std}    RESIDENCE=${g_country_us}    MARITAL.STATUS=?SELECT-FIRST
    Create Or Amend T24 Record    CUSTOMER,INPUT    >> IndivCustomer    ${testDataFields}    Accept All    ${EMPTY}
    Authorize T24 Record    CUSTOMER    ${IndivCustomer}
    @{validationRules}=    Create List    SECTOR :EQ:= ${g_sector_indiv}
    Check T24 Record    CUSTOMER,INPUT    ${IndivCustomer}    ${validationRules}

Corporate Customer
    T24 Login    INPUTTER
    @{testDataFields}=    Create List    NAME.1:1=?AUTO-VALUE    SHORT.NAME:1=?AUTO-VALUE    MNEMONIC=?AUTO-VALUE    ACCOUNT.OFFICER=${g_acct_officer_teller}    STREET:1=LAKESHORE STREET
    ...    NATIONALITY=${g_country_us}    RESIDENCE=${g_country_us}    LANGUAGE=${g_language_eng}    SECTOR=${g_sector_corporate}
    Create Or Amend T24 Record    CUSTOMER,CORP    >> CorpCust    ${testDataFields}    Accept All    ${EMPTY}
    Authorize T24 Record    CUSTOMER    ${CorpCust}
    @{validationRules}=    Create List    SECTOR :EQ:= ${g_sector_corporate}
    Check T24 Record    CUSTOMER,CORP    ${CorpCust}    ${validationRules}

Add print addr to corp cust
    T24 Login    INPUTTER
    @{testDataFields}=    Create List    NAME.1:1=?AUTO-VALUE    SHORT.NAME:1=?AUTO-VALUE    MNEMONIC=?AUTO-VALUE    ACCOUNT.OFFICER=${g_acct_officer_teller}    STREET:1=LAKESHORE STREET
    ...    NATIONALITY=${g_country_us}    RESIDENCE=${g_country_us}    LANGUAGE=${g_language_eng}    SECTOR=${g_sector_corporate}    TOWN.COUNTRY:1=NEW YORK    POST.CODE:1=56789
    ...    COUNTRY:1=${g_country_us}    PHONE.1:1=2876483    EMAIL.1:1=MAIL@MAIL.COM
    Create Or Amend T24 Record    CUSTOMER,CORP    >> CorpCust    ${testDataFields}    Accept All    ${EMPTY}    # Create a corporate customer
    Authorize T24 Record    CUSTOMER    ${CorpCust}    # Authorize the customer
    @{validationRules}=    Create List    SECTOR :EQ:= ${g_sector_corporate}    NAME.1 >> c_name1    SHORT.NAME >> c_short_name    STREET >> c_street    TOWN.COUNTRY >> c_town
    ...    POST.CODE >> c_post_code    COUNTRY >> c_country    EMAIL.1 >> c_email    PHONE.1 >> c_phone
    Check T24 Record    CUSTOMER,CORP    ${CorpCust}    ${validationRules}
    @{validationRules}=    Create List    SHORT.NAME :EQ:= ${c_short_name}    NAME.1 :EQ:= ${c_name1}    STREET.ADDR :EQ:= ${c_street}    POST.CODE :EQ:= ${c_post_code}    TOWN.COUNTRY :EQ:= ${C_town}
    ...    COUNTRY :EQ:= ${c_country}    EMAIL.1 :EQ:= ${c_email}    PHONE.1 :EQ:= ${c_phone}
    Check T24 Record    DE.ADDRESS,ADD2    ${g_local_country}0010001.C-${CorpCust}.PRINT.1    ${validationRules}
    @{testDataFields}=    Create List    SHORT.NAME:1=PETER    NAME.1:1=PETER TOMPSON    STREET.ADDR:1=11 SOUTH PARK AVENUE    TOWN.COUNTRY:1=VICTORIA    COUNTRY:1=US
    ...    POST.CODE:1=58476    PHONE.1=293875    SMS.1=02384934    EMAIL.1=PETER@COMP.COM
    Create Or Amend T24 Record    DE.ADDRESS,ADD2    ${g_local_country}0010001.C-${CorpCust}.PRINT.2    ${testDataFields}    Accept All    ${EMPTY}

Amend a corporate customer - change name
    @{testDataFields}=    Create List    NAME.1:1=?AUTO-VALUE    SHORT.NAME:1=?AUTO-VALUE    MNEMONIC=?AUTO-VALUE    ACCOUNT.OFFICER=${g_acct_officer_teller}    STREET:1=LAKESHORE STREET
    ...    NATIONALITY=${g_country_us}    RESIDENCE=${g_country_us}    LANGUAGE=${g_language_eng}    SECTOR=${g_sector_corporate}    TOWN.COUNTRY:1=NEW YORK    POST.CODE:1=56789
    ...    COUNTRY:1=${g_country_us}    PHONE.1:1=2876483    EMAIL.1:1=MAIL@MAIL.COM
    Create Or Amend T24 Record    CUSTOMER,CORP    >>CorpCust2    ${testDataFields}    Accept All    \    # Create a new corporate customer
    Authorize T24 Record    CUSTOMER    ${CorpCust2}
    @{testDataFields}=    Create List    NAME.1:1=?AUTO-VALUE
    Create Or Amend T24 Record    CUSTOMER,CORP    ${CorpCust2}    ${testDataFields}    Accept All    ${EMPTY}    # Change the value in the field NAME.1
    Authorize T24 Record    CUSTOMER    ${CorpCust2}

Corporate Customer - Local Bank
    @{testDataFields}=    Create List    NAME.1:1=?AUTO-VALUE    SHORT.NAME:1=?AUTO-VALUE    MNEMONIC=?AUTO-VALUE    ACCOUNT.OFFICER=${g_acct_officer_teller}    CUSTOMER.STATUS=${g_cust_status_large_fin}
    ...    INDUSTRY=${g_industry_banks}    STREET:1=LAKESHORE STREET    NATIONALITY=${g_country_us}    RESIDENCE=${g_country_us}    LANGUAGE=${g_language_eng}    TARGET=${g_target_banks}
    ...    SECTOR=${g_sector_localbank}
    Create Or Amend T24 Record    CUSTOMER,CORP    >>CorpCust3    ${testDataFields}    Accept All    \    # Create a bank customer - sector 3001
    Authorize T24 Record    CUSTOMER    ${CorpCust3}
    @{validationRules}=    Create List    SECTOR :EQ:= ${g_sector_localbank}
    Check T24 Record    CUSTOMER,CORP    ${CorpCust3}    ${validationRules}    # Verify that the sector is 3001 - \ Local Bank

Corporate Customer - Central Bank
    @{testDataFields}=    Create List    NAME.1:1=?AUTO-VALUE    SHORT.NAME:1=?AUTO-VALUE    MNEMONIC=?AUTO-VALUE    ACCOUNT.OFFICER=${g_acct_officer_branch_mng}    CUSTOMER.STATUS=${g_cust_status_gvrn}
    ...    INDUSTRY=${g_industry_banks}    STREET:1=LAKESHORE STREET    NATIONALITY=${g_country_us}    RESIDENCE=${g_country_us}    LANGUAGE=${g_language_eng}    TARGET=${g_target_other}
    ...    SECTOR=${g_sector_centralbank}
    Create Or Amend T24 Record    CUSTOMER,CORP    >>CorpCust4    ${testDataFields}    \    \    # Create a central bank customer - sector 3002
    Authorize T24 Record    CUSTOMER    ${CorpCust4}
    @{validationRules}=    Create List    SECTOR :EQ:= ${g_sector_centralbank}
    Check T24 Record    CUSTOMER,CORP    ${CorpCust4}    ${validationRules}    # Verify that the sector is 3002 - \ Central Bank

Corporate Customer - Bank Branch
    @{testDataFields}=    Create List    NAME.1:1=?AUTO-VALUE    SHORT.NAME:1=?AUTO-VALUE    MNEMONIC=?AUTO-VALUE    ACCOUNT.OFFICER=${g_acct_officer_branch_mng}    CUSTOMER.STATUS=${g_cust_status_corp_medium}
    ...    INDUSTRY=${g_industry_banks}    STREET:1=LAKESHORE STREET    NATIONALITY=${g_country_us}    RESIDENCE=${g_country_us}    LANGUAGE=${g_language_eng}    TARGET=${g_target_banks}
    ...    SECTOR=${g_sector_bankbranch}
    Create Or Amend T24 Record    CUSTOMER,CORP    >>CorpCust5    ${testDataFields}    \    \    # Create a bank branch customer - sector 3005
    Authorize T24 Record    CUSTOMER    ${CorpCust5}
    @{validationRules}=    Create List    SECTOR :EQ:= ${g_sector_bankbranch}
    Check T24 Record    CUSTOMER,CORP    ${CorpCust5}    ${validationRules}    # Verify that the sector is 3005 - \ Bank Branch

Corporate Customer - Financial Corporation
    @{testDataFields}=    Create List    NAME.1:1=?AUTO-VALUE    SHORT.NAME:1=?AUTO-VALUE    MNEMONIC=?AUTO-VALUE    ACCOUNT.OFFICER=${g_acct_officer_teller}    CUSTOMER.STATUS=${g_cust_status_fin_medium}
    ...    INDUSTRY=${g_industry_other_fin}    STREET:1=LAKESHORE STREET    NATIONALITY=${g_country_us}    RESIDENCE=${g_country_us}    LANGUAGE=${g_language_eng}    TARGET=${g_target_corp_entity}
    ...    SECTOR=${g_sector_financialcorp}
    Create Or Amend T24 Record    CUSTOMER,CORP    >>CorpCust6    ${testDataFields}    \    \    # Create a financial corporation customer - sector 3501
    Authorize T24 Record    CUSTOMER    ${CorpCust6}
    @{validationRules}=    Create List    SECTOR :EQ:= ${g_sector_financialcorp}
    Check T24 Record    CUSTOMER,CORP    ${CorpCust6}    ${validationRules}

KYC
    @{testDataFields}=    Create List    RELATIONSHIP.NAME=Technology Products    REL.MANAGER=1    FURTHER.MANAGERS:1=31    RELATIONSHIP.UPDATE:1=PERIODIC.UPDATE    REL.START.DATE=${g_today}
    Create Or Amend T24 Record    CR.RELATIONSHIP,KYC.INPUT    >>KYCTechProd    ${testDataFields}    Accept All    ${EMPTY}
    @{validationRules}=    Create List
    Check T24 Record    CR.RELATIONSHIP    ${KYCTechProd}    ${validationRules}
    @{testDataFields}=    Create List    NAME.1:1=?AUTO-VALUE    SHORT.NAME:1=?AUTO-VALUE    MNEMONIC=?AUTO-VALUE    ACCOUNT.OFFICER=${g_acct_officer_teller}    STREET:1=LAKESHORE STREET
    ...    NATIONALITY=${g_country_us}    RESIDENCE=${g_country_us}    LANGUAGE=${g_language_eng}    CUSTOMER.TYPE=ACTIVE    SECTOR=${g_sector_corporate}
    Create Or Amend T24 Record    CUSTOMER,CORP    >>CorpCust7    ${testDataFields}    Accept All    ${EMPTY}
    Authorize T24 Record    CUSTOMER    ${CorpCust7}
    @{testDataFields}=    Create List    CONTACT.DATE=14 APR 2011    INTRODUCER=COLLEAGUE    KYC.RELATIONSHIP=${KYCTechProd}
    Create Or Amend T24 Record    CUSTOMER,KYC.INPUT    ${CorpCust7}    ${testDataFields}    \    ${EMPTY}
