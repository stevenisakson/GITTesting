/*******
 * CreatedDate : 18-09-2018
 * Author : Amrish Surve
 * Description : Contains test class for main class SF_AccountDocument_DashboardController
 *******/
@isTest
public class SF_AccountDocument_Test {

    static user testUser;
    
    @isTest
    static void callPositive(){
        Id pId = [select id from profile where name='Customer Community User'].id;
        
        Account acct = new Account(Name='Test Account'); 
        insert acct;
        
        Contact con = new Contact(LastName ='Test Contact',AccountId = acct.Id);
        insert con;
        
        testUser = new User(alias = 'test121', email='test1234@noemail.com',
                                 emailencodingkey='UTF-8', lastname='Testing2', languagelocalekey='en_US',
                                 localesidkey='en_US',profileid = pId,country='United States',IsActive =true,
                                 ContactId = con.Id, timezonesidkey='America/Los_Angeles', username='tester33@noemail.com');
        insert testUser;
        
        ApexPages.StandardController sc = new ApexPages.StandardController(acct);
        SF_AccountDocument_DashboardController sc1 = new SF_AccountDocument_DashboardController(sc);
    }
}