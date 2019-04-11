@isTest
public class TestUserDeactivationAdoptionMax
{
      public static testMethod void testschedule() 
      {
         Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
         User u = new User(Alias = 'standt', Email='standarduser@testorg.com', 
         EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
         LocaleSidKey='en_US', ProfileId = p.Id, 
         TimeZoneSidKey='America/Los_Angeles', UserName='standarduser@testorg.com.cargillit.dev');
         Test.StartTest();
         insert u;
         uf__User_Status__c us= new uf__User_Status__c(uf__Days_Since_Login__c=67, uf__User__c=u.Id);
         insert us;
         UserDeactivationAdoptionMax.userDeactivate();
         Test.stopTest(); 
      }

}