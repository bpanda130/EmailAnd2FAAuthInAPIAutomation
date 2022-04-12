Feature: Buyer and Seller Registration Flow

  Background:
    * url baseUrlAWSCognito
    * def UserAuthenticationUtils = Java.type('utils.UserAuthenticationUtils')
    * def userAuthLib = new UserAuthenticationUtils()
    * def CSVFileUtility = Java.type('utils.CSVFileUtility')
    * def csvFileUtil = new CSVFileUtility()

  Scenario Outline: Validate Seller Registration
    * print "==========User Registration Process=========="
    * def ServiceSignUp = read('classpath:/JSON/PROVIDER_SERVICE_SIGNUP.json')
    Given header Host = "cognito-idp.ap-southeast-1.amazonaws.com"
    And header X-Amz-User-Agent = "aws-amplify/5.0.4 js"
    And header Content-Type = "application/x-amz-json-1.1"
    And header X-Amz-Target = "AWSCognitoIdentityProviderService.SignUp"
    And header Origin = "https://qa.dealcierge.io"
    And header Referer = "https://qa.dealcierge.io/"
    * def USERNAME = "<USERNAME>"
    * def PASSWORD = "<PASSWORD>"
    * def COMPANY_TYPE = "<COMPANY_TYPE>"
    * def compType = COMPANY_TYPE == 's' ? 'SELLER' : 'BUYER'
    And request ServiceSignUp
    When method POST
    Then print response
    And header X-Amz-Target = "AWSCognitoIdentityProviderService.ConfirmSignUp"
    And header Host = "cognito-idp.ap-southeast-1.amazonaws.com"
    And header X-Amz-User-Agent = "aws-amplify/5.0.4 js"
    And header Content-Type = "application/x-amz-json-1.1"
    And header Origin = "https://qa.dealcierge.io"
    And header Referer = "https://qa.dealcierge.io/"
    * def EMAIL_OTP = userAuthLib.getEmailAuthCode(USERNAME,compType)
    * def ConfirmSignUp = read('classpath:/JSON/PROVIDER_SERVICE_CONFIRM_SIGNUP.json')
    Then print ConfirmSignUp
    And request ConfirmSignUp
    When method POST
    Then print response
    And header X-Amz-Target = "AWSCognitoIdentityProviderService.InitiateAuth"
    And header Host = "cognito-idp.ap-southeast-1.amazonaws.com"
    And header X-Amz-User-Agent = "aws-amplify/5.0.4 js"
    And header Content-Type = "application/x-amz-json-1.1"
    And header Origin = "https://qa.dealcierge.io"
    And header Referer = "https://qa.dealcierge.io/"
    * def InitiateAuth = read('classpath:/JSON/PROVIDER_SERVICE_INITIATE_AUTH.json')
    And request InitiateAuth
    When method POST
    Then print response
    And print response.AuthenticationResult.AccessToken
    * def accesstoken = response.AuthenticationResult.AccessToken
    And header X-Amz-Target = "AWSCognitoIdentityProviderService.GetUser"
    And header Host = "cognito-idp.ap-southeast-1.amazonaws.com"
    And header X-Amz-User-Agent = "aws-amplify/5.0.4 js"
    And header Content-Type = "application/x-amz-json-1.1"
    And header Origin = "https://qa.dealcierge.io"
    And header Referer = "https://qa.dealcierge.io/"
    * def GetUser = read('classpath:/JSON/PROVIDER_SERRVICE_GETUSER.json')
    And request GetUser
    When method POST
    Then print response
    And header X-Amz-Target = "AWSCognitoIdentityProviderService.AssociateSoftwareToken"
    And header Host = "cognito-idp.ap-southeast-1.amazonaws.com"
    And header X-Amz-User-Agent = "aws-amplify/5.0.4 js"
    And header Content-Type = "application/x-amz-json-1.1"
    And header Origin = "https://qa.dealcierge.io"
    And header Referer = "https://qa.dealcierge.io/"
    * def AssociateSoftwareToken = read('classpath:/JSON/PROVIDER_SERVICE_ASSOCIATE_SOFTWARE_TOKEN.json')
    And request AssociateSoftwareToken
    When method POST
    Then print response
    And print response.SecretCode
    * def secret_code = response.SecretCode
    And csvFileUtil.addUserTokenDetailsToFile(USERNAME,secret_code)
    And header X-Amz-Target = "AWSCognitoIdentityProviderService.VerifySoftwareToken"
    And header Host = "cognito-idp.ap-southeast-1.amazonaws.com"
    And header X-Amz-User-Agent = "aws-amplify/5.0.4 js"
    And header Content-Type = "application/x-amz-json-1.1"
    And header Origin = "https://qa.dealcierge.io"
    And header Referer = "https://qa.dealcierge.io/"
    * def TOTP = userAuthLib.getTwoFactorCode(secret_code)
    * def VerifySoftwareToken = read('classpath:/JSON/PROVIDER_SERVICE_VERIFY_SOFTWARE_TOKEN.json')
    And request VerifySoftwareToken
    When method POST
    Then print response

    Examples:
      | USERNAME                      | PASSWORD    | COMPANY_TYPE  |
      | pegasusapiseller@gmail.com    | Test@1234   | s             |