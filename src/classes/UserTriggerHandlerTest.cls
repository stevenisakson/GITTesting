@istest(seeAllData = true)
public Class UserTriggerHandlerTest {

    static testmethod void test_insertStandardUserintoUserObj(){
            Profile profileId = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1];
            User stdUserdDta = new User();
            stdUserdDta.Username='testameen123@test.com';
            stdUserdDta.IsActive = FALSE;
            //stdUserdDta.Business_Unit__c = 'CBS';
            stdUserdDta.emailencodingkey = 'UTF-8';
            stdUserdDta.localesidkey = 'en_US';
            stdUserdDta.languagelocalekey = 'en_US';
            stdUserdDta.timezonesidkey = 'America/Los_Angeles';     
            stdUserdDta.Email= 'testameen123@test.com';     
            stdUserdDta.LastName='test';
            stdUserdDta.Alias='tadams1';
            stdUserdDta.ProfileId= profileId.id ;
    Test.StartTest();
            insert  stdUserdDta;           
    Test.StopTest();

    }
    static testmethod void test_updateRelatedCROECustomers(){
    
            Profile profileId = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1];
            User stdUserdDta = new User();
            stdUserdDta.Username='testameen123@test.com';
            stdUserdDta.IsActive = FALSE;
            stdUserdDta.Business_Unit__c = 'CBS';
            stdUserdDta.emailencodingkey = 'UTF-8';
            stdUserdDta.localesidkey = 'en_US';
            stdUserdDta.languagelocalekey = 'en_US';
            stdUserdDta.timezonesidkey = 'America/Los_Angeles';     
            stdUserdDta.Email= 'testameen123@test.com';     
            stdUserdDta.LastName='test';
            stdUserdDta.Alias='tadams1';
            stdUserdDta.ProfileId= profileId.id ;
            insert stdUserdDta;
            
            list<User> usetlist = [select id,Username,Alias from User where LastName = 'test'];
            system.debug('usetlist============' +usetlist );
            
            for(User  userl :usetlist){
                     userl .LastName =  stdUserdDta.LastName;
                     stdUserdDta.Email= 'testameen1234@test.com';
                     stdUserdDta.LastName='test12';
                     stdUserdDta.Business_Unit__c = 'CROE';
                     update userl ;
              }      
                     
    Test.StartTest();
    
       //  system.debug('stdUserdDta=============after insert'+stdUserdDta);        
          update stdUserdDta;
         ///system.debug('stdUserdDta============='+stdUserdDta);
                     
    Test.StopTest();

    }
}