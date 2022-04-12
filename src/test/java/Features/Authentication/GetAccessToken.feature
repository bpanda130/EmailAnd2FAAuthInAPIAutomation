Feature: This feature enable us to get access token

  Background:
    * url baseUrlAWSCognito
    * def UserAuthenticationUtils = Java.type('utils.UserAuthenticationUtils')
    * def userAuthLib = new UserAuthenticationUtils()
    * def CSVFileUtility = Java.type('utils.CSVFileUtility')
    * def csvFileUtil = new CSVFileUtility()


  Scenario: Get User Token
    Given header Host = "cognito-idp.ap-southeast-1.amazonaws.com"
    And header X-Amz-Target = "AWSCognitoIdentityProviderService.InitiateAuth"
    And header X-Amz-User-Agent = "aws-amplify/5.0.4 js"
    And header Content-Type = "application/x-amz-json-1.1"
    And header Origin = "https://qa.dealcierge.io"
    And header Referer = "https://qa.dealcierge.io/"
    * def InitiateAuth = read('classpath:/JSON/PROVIDER_SERVICE_INITIATE_AUTH.json')
    And request InitiateAuth
    When method POST
    Then print response
    * def sessionID = response.Session
    * print "sessionID = " + sessionID
    * def accesstoken = sessionID == null ? response.AuthenticationResult.AccessToken : null
    * print "accesstoken = " + accesstoken
    * def check2Abort = (sessionID === null ? karate.abort() : 'not null' )
    And header Host = "cognito-idp.ap-southeast-1.amazonaws.com"
    And header X-Amz-Target = "AWSCognitoIdentityProviderService.RespondToAuthChallenge"
    And header X-Amz-User-Agent = "aws-amplify/5.0.4 js"
    And header Content-Type = "application/x-amz-json-1.1"
    And header Origin = "https://qa.dealcierge.io"
    And header Referer = "https://qa.dealcierge.io/"
    * def RespondToAuthChallenge = read('classpath:/JSON/PROVIDER_SERVICE_RESPOND_TO_AUTH_CHALLENGE.json')
    And request RespondToAuthChallenge
    When method POST
    * def accesstoken = response.AuthenticationResult.AccessToken