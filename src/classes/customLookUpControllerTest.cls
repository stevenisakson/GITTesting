@isTest
public class customLookUpControllerTest {
	@isTest
    static void fetchLookUpValuesTest()
    {
       Test.StartTest();
        
       Profile p = [SELECT Id FROM Profile WHERE Name='Data Steward']; 
       User u = new User(Alias = 'standt', Email='standarduser@testorg.com', 
       				 EmailEncodingKey='UTF-8', LastName='Testing', FirstName='AccTeamDelete', LanguageLocaleKey='en_US', 
       				 LocaleSidKey='en_US', ProfileId = p.Id, 
       				 TimeZoneSidKey='America/Los_Angeles', UserName='AccTeamDelete@testorg.com');
        
       insert u;
       
       customLookUpController.fetchLookUpValues('AccTeamDelete');
        
       Test.StopTest();
    }
}