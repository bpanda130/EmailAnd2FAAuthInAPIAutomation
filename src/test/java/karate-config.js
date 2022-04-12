function(){
    var System = Java.type('java.lang.System')
    var env = karate.env;
    karate.log('karate.env system property was:', env);
    if (!env){
        env = 'QA';
    }
   var config = {
  ymlFile : karate.read('classpath:config/pegasus-config-'+env+'.yml')
    }
      config.baseUrlAWSCognito = config.ymlFile.baseUrlAWSCognito
      config.baseUrlDealcierge = config.ymlFile.baseUrlDealcierge
        karate.callSingle("classpath:Features/Registration/UserRegistration.feature",config);
    return config;
}
