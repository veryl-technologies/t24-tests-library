*** Settings ***
Documentation     AA demo test cases
Library           T24WebDriver.py    #Test Teardown    Close Browsers
Library           Selenium2Library

*** Test Cases ***
Fixed Term 6M - Bond
    Execute T24 Menu Command    Product Catalog
    @{enquiryConstraints}=    Create List    Category :EQ:= Deposits    Group :EQ:= Bonds
    @{validationRules}=    Create List
    Execute T24 Enquiry    AA.PRODUCT.CATALOG-PRODUCT.GROUPS    ${enquiryConstraints}    Products    ${validationRules}
    @{enquiryConstraints}=    Create List    Description :EQ:= Fixed Term 6M - Bond
    @{validationRules}=    Create List
    Execute T24 Enquiry    AA.PRODUCT.CATALOG-PRODUCTS    ${enquiryConstraints}    New Arrangement    ${validationRules}
    @{testDataFields}=    Create List    CUSTOMER=129330    CURRENCY=USD    [Commitment]AMOUNT=500    [Settlement Instructions]PAYIN.ACCOUNT:1:1=71811    [Settlement Instructions]PAYIN.ACTIVITY:1:1=LENDING-ADJUST.BALANCE-BALANCE.MAINTENANCE
    ...    [Settlement Instructions]PAYOUT.ACCOUNT:1=58904
    Create Or Amend T24 Record    AA.ARRANGEMENT.ACTIVITY,AA.NEW    >> aa_transaction_id    ${testDataFields}    \    ${EMPTY}
    Authorize T24 Record    AA.ARRANGEMENT.ACTIVITY    ${aa_transaction_id}
    @{validationRules}=    Create List    CUSTOMER :EQ:= 129330    PRODUCT :EQ:= BONDS.A.6M    [Commitment]AMOUNT :EQ:= 500.00
    Check T24 Record    AA.ARRANGEMENT.ACTIVITY    ${aa_transaction_id}    ${validationRules}
