Feature: Buyer and Seller Registration Flow

  Background:
    * url baseUrlAWSCognito
    * def UserAuthenticationUtils = Java.type('utils.UserAuthenticationUtils')
    * def userAuthLib = new UserAuthenticationUtils()
    * def CSVFileUtility = Java.type('utils.CSVFileUtility')
    * def csvFileUtil = new CSVFileUtility()
    * print "==========Get Access Token for Admin=========="
    * def secretKey = csvFileUtil.getUserTokenDetailsFromFile('pegasusapprover@gmail.com')
    * def TOTP = userAuthLib.getTwoFactorCode(secretKey)
    * print TOTP
    * def authToken = call read('../Authentication/GetAccessToken.feature') {USERNAME:'pegasusapprover@gmail.com', PASSWORD:'Test@1234'}
    * def adminToken = authToken.accesstoken
    And print adminToken

  Scenario Outline: Validate Seller Registration
    * def USERNAME = "<USERNAME>"
    * def PASSWORD = "<PASSWORD>"
    * def COMPANY_TYPE = "<COMPANY_TYPE>"

    * def COMPANY_NAME = "<COMPANY_NAME>"
    * def firstName = "<firstName>"
    * def lastName = "<lastName>"
    * def linkedin = "<linkedin>"
    * def position = "<position>"
    * def taxRegistrationNumber = "<taxRegistrationNumber>"
    * def UEN = "<UEN>"
    * def compType = COMPANY_TYPE == 's' ? 'SELLER' : 'BUYER'
    * print "==========Get Access Token for User=========="
    * call read('../Authentication/GetAccessToken.feature')

    * print "==========AWSCognitoIdentityProviderService.GetUser=========="
    And header X-Amz-Target = "AWSCognitoIdentityProviderService.GetUser"
    And header Host = "cognito-idp.ap-southeast-1.amazonaws.com"
    And header X-Amz-User-Agent = "aws-amplify/5.0.4 js"
    And header Content-Type = "application/x-amz-json-1.1"
    And header Origin = "https://qa.dealcierge.io"
    And header Referer = "https://qa.dealcierge.io/"
    * def GetUser = read('classpath:/JSON/PROVIDER_SERRVICE_GETUSER.json')
    And request GetUser
    When method POST
    * def userID = response.Username

    * print "==========COMPANY CONTROLLER POST FULL=========="
    * url baseUrlDealcierge
    Given path "/api/serv-core/v1/companies/full"
    And header Host = "api.qa.dealcierge.io"
    And header Accept = "application/json, text/plain, */*"
    And header Content-Type = "application/json"
    And header Origin = "https://qa.dealcierge.io"
    And header Referer = "https://qa.dealcierge.io/"
    And header authorization = "Bearer " + accesstoken
    * def companyControllerPost = read('classpath:/JSON/COMPANY_CONTROLLER_POST_FULL.json')
    And request companyControllerPost
    When method POST
    Then print response
    And match response.companyStatus == "DRAFT"
    And match response.role == "POWERUSER"
    * def companyID = response.companyId

    * print "==========COMPANY CONTROLLER UPDATE FULL=========="
    Given path "/api/serv-core/v1/companies/full"
    And header Host = "api.qa.dealcierge.io"
    And header Accept = "application/json, text/plain, */*"
    And header Content-Type = "multipart/form-data"
    And header Origin = "https://qa.dealcierge.io"
    And header Referer = "https://qa.dealcierge.io/"
    And header authorization = "Bearer " + accesstoken
    * string companyControllerUPDATE = read('classpath:/JSON/COMPANY_CONTROLLER_UPDATE_FULL.json')
    * multipart field updateUserAndCompanyDto = companyControllerUPDATE
    When method PUT
    Then print response

    * print "==========COMPANY CONTROLLER STATUS UPDATE TO REVIEW=========="
    Given path "/api/serv-core/v1/companies/status"
    And header Host = "api.qa.dealcierge.io"
    And header Accept = "application/json, text/plain, */*"
    And header Content-Type = "application/json"
    And header Origin = "https://qa.dealcierge.io"
    And header Referer = "https://qa.dealcierge.io/"
    And header authorization = "Bearer " + accesstoken
    * def companyStatus = "REVIEW"
    * def companyStatusPost = read('classpath:/JSON/COMPANY_CONTROLLER_COMPANY_STATUS.json')
    And request companyStatusPost
    When method POST
    Then print response

    * print "==========COMPANY CONTROLLER STATUS UPDATE TO APPROVED=========="
    Given path "/api/serv-core/v1/companies/status"
    And header Host = "api.qa.dealcierge.io"
    And header Accept = "application/json, text/plain, */*"
    And header Content-Type = "application/json"
    And header Origin = "https://qa.dealcierge.io"
    And header Referer = "https://qa.dealcierge.io/"
    And header authorization = "Bearer " + adminToken
    * def companyStatus = "APPROVED"
    * def companyStatusPost = read('classpath:/JSON/COMPANY_CONTROLLER_COMPANY_STATUS.json')
    And request companyStatusPost
    When method POST
    Then print response

    * print "==========GET COMPANY CONTROLLER STATUS=========="

    Examples:
      | USERNAME                      | PASSWORD    | COMPANY_TYPE  | COMPANY_NAME        | firstName         | lastName  | linkedin    | position    | taxRegistrationNumber | UEN   |
      | pegasusapiseller@gmail.com    | Test@1234   | s             | API TEST AUTOMATION | Automation User   | Seller    | Test_Linked | QA Analyst  | TestTaxReg123         | 45321 |