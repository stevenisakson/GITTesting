/*******
 * CreatedDate : 29-06-2018
 * Author : Amrish Surve
 * Description : Contains test class for SFA_AccountDocument_Trigger and test class
 *******/
@isTest
public class SFA_AccountDocument_Test {
    
    static user testUser;
    @TestSetup
    static void dataSetup(){
        Id pId = [select id from profile where name='Customer Community User'].id;
        
        Account acct = new Account(Name='Test AccountTrain'); 
        insert acct;
        
        Contact con = new Contact(LastName ='Test Contact',AccountId = acct.Id);
        insert con;
        
        testUser = new User(alias = 'test123', email='test123@noemail.com',
                                 emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
                                 localesidkey='en_US',profileid = pId,country='United States',IsActive =true,
                                 ContactId = con.Id, timezonesidkey='America/Los_Angeles', username='tester@noemail.com');
        insert testUser;
        
        
        
    }
    
    static testMethod void loadTrainingData(){
        Account chkObj = [Select Id,Name from Account where Name = 'Test AccountTrain'];
        List<Account_Attachments__c> accAttach  = new List<Account_Attachments__c>{new Account_Attachments__c (Attachment_Name__c='Test Attachment2', Type__c='For Training',Start_Month_Date__c=Date.today(),Account__c = chkObj.Id, Monthly_Uploaded_Date__c=Date.today(),Training_Date__c=Date.today())};
        insert accAttach;
        System.assert(accAttach.size() > 0);
    }
    
    static testMethod void removeTrainingData(){
        Account chkObj = [Select Id,Name from Account where Name = 'Test AccountTrain'];
        List<Account_Attachments__c> accAttach1  = new List<Account_Attachments__c>{new Account_Attachments__c (Attachment_Name__c='Test Attachment2', Type__c='For Training',Start_Month_Date__c=Date.today(),Account__c = chkObj.Id, Monthly_Uploaded_Date__c=Date.today(),Training_Date__c=Date.today())};
        insert accAttach1;
        System.assert(accAttach1.size() > 0);
        if(!accAttach1.isEmpty())
            delete accAttach1;
    }
}