*** Settings ***
Library           T24WebDriver.py
Library           Selenium2Library

*** Test Cases ***
Today's date
    @{validationRules}=    Create List    TODAY >> g_today
    Check T24 Record    DATES    BNK    ${validationRules}    # Get today's date

Local Country
    @{validationRules}=    Create List    LOCAL.COUNTRY >> g_local_country
    Check T24 Record    COMPANY    BNK    ${validationRules}    # Get Local Country

Country USA
    @{validationRules}=    Create List    @ID >> g_country_us
    Check T24 Record    COUNTRY    US    ${validationRules}    # Check if US country exists - used in CUSTOMER CORP and INPUT

Country code for Local Country
    @{validationRules}=    Create List    CO.CODE >> g_co_code
    Check T24 Record    COUNTRY    ${g_local_country}    ${validationRules}    # Get the country code of the local country

Group Condition
    @{validationRules}=    Create List
    Check T24 Record    SCTR.GROUP.CONDITION    999    ${validationRules}

Account Officer - Implementation
    @{validationRules}=    Create List    @ID >> g_acct_officer_impl
    Check T24 Record    DEPT.ACCT.OFFICER    1    ${validationRules}    # Account officer is Implementation - used in CUSTOMER,INPUT

Account Officer - Teller
    @{validationRules}=    Create List    @ID >> g_acct_officer_teller
    Check T24 Record    DEPT.ACCT.OFFICER    31    ${validationRules}    # Account officer is Teller - used in CUSTOMER,CORP

Account Officer - Branch Operations Manager
    @{validationRules}=    Create List    @ID >> g_acct_officer_branch_mng
    Check T24 Record    DEPT.ACCT.OFFICER    27    ${validationRules}    # Account officer is Branch Operations Manager - used in CUSTOMER,CORP

Sector for Corporate Client
    @{validationRules}=    Create List    @ID >> g_sector_corporate
    Check T24 Record    SECTOR    2001    ${validationRules}    # Corporate sector - used in CUSTOMER,CORP

Sector for Central Bank
    @{validationRules}=    Create List    @ID >> g_sector_centralbank
    Check T24 Record    SECTOR    3002    ${validationRules}    # Sector for cetral bank customer - used in CUSTOMER,CORP

Sector for Local Bank
    @{validationRules}=    Create List    @ID >> g_sector_localbank
    Check T24 Record    SECTOR    3001    ${validationRules}    # Sector for local bank customer - used in CUSTOMER,CORP

Sector for Bank Branch
    @{validationRules}=    Create List    @ID >> g_sector_bankbranch
    Check T24 Record    SECTOR    3005    ${validationRules}    # Sector for bank branch - used in CUSTOMER,CORP

Sector for Financial Corporation
    @{validationRules}=    Create List    @ID >> g_sector_financialcorp
    Check T24 Record    SECTOR    3501    ${validationRules}    # Sector for financial corporations - used in CUSTOMER,CORP

Sector for Individual Customer
    @{validationRules}=    Create List    @ID >> g_sector_indiv
    Check T24 Record    SECTOR    1001    ${validationRules}    # Individual sector - used in CUSTOMER,INPUT

Industry for Private Person
    @{validationRules}=    Create List    @ID >> g_industry_private_person
    Check T24 Record    INDUSTRY    1000    ${validationRules}    # Get Industry record for private person - used in CUSTOMER,INPUT

Industry for Other Financial Institutions
    @{validationRules}=    Create List    @ID >> g_industry_other_fin
    Check T24 Record    INDUSTRY    3900    ${validationRules}    # Get industry for financial institutions - used in CU,CORP

Industry for Banks
    @{validationRules}=    Create List    @ID >> g_industry_banks
    Check T24 Record    INDUSTRY    3100    ${validationRules}    # Get industry for banks - used in CU,CORP

Language - English
    @{validationRules}=    Create List    @ID >> g_language_eng
    Check T24 Record    LANGUAGE    1    ${validationRules}    # Get language - English - used in CUSTOMER,INPUT

CU Status for Standard Client
    @{validationRules}=    Create List    @ID >> g_cust_status_private_std
    Check T24 Record    CUSTOMER.STATUS    1    ${validationRules}    # Get CU Status for private standard client - used in CUSTOMER,INPUT

CU Stutus for Large Fin Institutions
    @{validationRules}=    Create List    @ID >> g_cust_status_large_fin
    Check T24 Record    CUSTOMER.STATUS    23    ${validationRules}    # CU Status for large financial institution - used in Customer,CORP for local bank

CU Status for Gov Institutions
    @{validationRules}=    Create List    @ID >> g_cust_status_gvrn
    Check T24 Record    CUSTOMER.STATUS    31    ${validationRules}    # CU Status for governmental institutions - used in CU,CORP for central bank

CU Status for Medium Corp Institutions
    @{validationRules}=    Create List    @ID >> g_cust_status_corp_medium
    Check T24 Record    CUSTOMER.STATUS    17    ${validationRules}    # CU Status for medium corporate institutions - used in CU,CORP for bank branch

CU Status for Financial Medium Institutions
    @{validationRules}=    Create List    @ID >> g_cust_status_fin_medium
    Check T24 Record    CUSTOMER.STATUS    22    ${validationRules}    # CU Status for financial medium institutions - used in CU,CORP for financial institutions

TARGET for Private standard client
    @{validationRules}=    Create List    @ID >> g_target_private_std
    Check T24 Record    TARGET    1    ${validationRules}    # Get target for private standard client - used in CUSTOMER,INPUT

TARGET for Banks
    @{validationRules}=    Create List    @ID >> g_target_banks
    Check T24 Record    TARGET    30    ${validationRules}    # Get target for banks - used in CU,CORP

TARGET for Other Institutions
    @{validationRules}=    Create List    @ID >> g_target_other
    Check T24 Record    TARGET    999    ${validationRules}    # Get target for other - used in CU,CORP

TARGET for Corporate Entities
    @{validationRules}=    Create List    @ID >> g_target_corp_entity
    Check T24 Record    TARGET    7    ${validationRules}    # Get target for corporate entity - used in CU,CORP for financial institutions
