@isTest
private class testDeactivateUser {
   static testmethod void TestdeactiaveUserTrigger(){

    Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
    User u = new User(Alias = 'standt', Email='standarduser@testorg.com', 
    EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
    LocaleSidKey='en_US', ProfileId = p.Id, 
    TimeZoneSidKey='America/Los_Angeles', UserName='standarduser@testorg.com.cargillit.dev');
    
    // added by latha
    E2ERecursiveHandler.isRecursive =true;
    system.debug('####isRecursive =' +E2ERecursiveHandler.isRecursive);
    
    Test.startTest();
    insert u;
    uf__User_Status__c us= new uf__User_Status__c(uf__User__c=u.id, uf__Reason_for_Inactivity__c = 'None');
    insert us;
    us.uf__Reason_for_Inactivity__c = 'No Longer Need Salesforce';
    update us;
    Test.stopTest();  
   }
}