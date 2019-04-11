/*******
 * CreatedDate : 19-09-2018
 * Author : Amrish Surve
 * Description : Contains test class for main class SF_UpdateAccountBatch
 *******/

@isTest
public class SF_UpdateAccountBatch_Test {

    static user testUser;
    @testSetup 
    static void callbatchtest(){
        
        Id pId = [select id from profile where name='Customer Community User'].id;
        Account acct = new Account(Name='Test AccountDisplay', Dealer_External_ID__c = '5263'); 
        insert acct;
        Contact con = new Contact(LastName ='Test Contact',AccountId = acct.Id);
        insert con;
        
        testUser = new User(alias = 'test123', email='test123n@noemail.com',
                                 emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
                                 localesidkey='en_US',profileid = pId,country='United States',IsActive =true,
                                 ContactId = con.Id, timezonesidkey='America/Los_Angeles', username='testern@noemail.com');
        insert testUser;
    }
    
    static testmethod void testbatchDisplay() {    
        List<Account> acc = [Select Id,Name from Account where Name = 'Test AccountDisplay'];
        List<Account_Attachments__c> lstD = new List<Account_Attachments__c>();
        Account_Attachments__c accObj = new Account_Attachments__c();
        accObj.Account__c = acc[0].Id;
        accObj.Type__c = 'Display';
        accObj.Start_Month_Date__c = Date.today();
        accObj.Monthly_Uploaded_Date__c=Date.today();
        lstD.add(accObj);
        insert lstD;
        System.assert(lstD.size() > 0);
                
        ContentVersion contentVersion = new ContentVersion(Title = 'Penguins3', PathOnClient = 'Penguins3.jpg', VersionData = Blob.valueOf('Test Content3'), IsMajorVersion = true);
        insert contentVersion;    
        
        List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
        System.assertEquals(documents.size(), 1);
        //create ContentDocumentLink  record 
        ContentDocumentLink cdl = New ContentDocumentLink(LinkedEntityId = lstD[0].id, ContentDocumentId = documents[0].Id, shareType = 'V');
        insert cdl;   
        
        Test.startTest();
        SF_UpdateAccountBatchs uca = new SF_UpdateAccountBatchs();
        Id batchId = Database.executeBatch(uca);
        Test.stopTest();
        
    }
    
    static testmethod void testbatchEvent() {    
        List<Account> acc = [Select Id,Name from Account where Name = 'Test AccountDisplay'];
        List<Account_Attachments__c> lstE = new List<Account_Attachments__c>();
        Account_Attachments__c accObj1 = new Account_Attachments__c();
        accObj1.Account__c = acc[0].Id;
        accObj1.Type__c = 'Events';
        accObj1.Start_Month_Date__c = Date.today();
        accObj1.Monthly_Uploaded_Date__c=Date.today();
        lstE.add(accObj1);
        insert lstE;
        System.assert(lstE.size() > 0);
        
        ContentVersion contentVersion = new ContentVersion(Title = 'Penguins4', PathOnClient = 'Penguins4.jpg', VersionData = Blob.valueOf('Test Content31'), IsMajorVersion = true);
        insert contentVersion;    
        
        List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
        System.assertEquals(documents.size(), 1);
        //create ContentDocumentLink  record 
        ContentDocumentLink cdl = New ContentDocumentLink(LinkedEntityId = lstE[0].id, ContentDocumentId = documents[0].Id, shareType = 'V');
        insert cdl;   
        
        Test.startTest();
        SF_UpdateAccountBatchs uca1 = new SF_UpdateAccountBatchs();
        Id batchId = Database.executeBatch(uca1);
        Test.stopTest();
        
    }
    
    static testmethod void testbatchProspect() {    
        List<Account> acc = [Select Id,Name from Account where Name = 'Test AccountDisplay'];
        List<Account_Attachments__c> lstP = new List<Account_Attachments__c>();
        Account_Attachments__c accObj2 = new Account_Attachments__c();
        accObj2.Account__c = acc[0].Id;
        accObj2.Type__c = 'Prospect Lists and Activities';
        accObj2.Last_Upload_Date__c = Date.today();
        accObj2.Monthly_Uploaded_Date__c=Date.today();
        lstP.add(accObj2);
        insert lstP;
        System.assert(lstP.size() > 0);
        
        ContentVersion contentVersion = new ContentVersion(Title = 'Penguins5', PathOnClient = 'Penguins5.jpg', VersionData = Blob.valueOf('Test Content32'), IsMajorVersion = true);
        insert contentVersion;    
        
        List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
        System.assertEquals(documents.size(), 1);
        //create ContentDocumentLink  record 
        ContentDocumentLink cdl = New ContentDocumentLink(LinkedEntityId = lstP[0].id, ContentDocumentId = documents[0].Id, shareType = 'V');
        insert cdl;   
        
        Test.startTest();
        SF_UpdateAccountBatchs ucaP = new SF_UpdateAccountBatchs();
        Id batchId = Database.executeBatch(ucaP);
        Test.stopTest();
        
    }
    
    
    static testmethod void testbatchTraining() {    
        List<Account> acc = [Select Id,Name from Account where Name = 'Test AccountDisplay'];
        List<Account_Attachments__c> lstT = new List<Account_Attachments__c>();
        Account_Attachments__c accObj3 = new Account_Attachments__c();
        accObj3.Account__c = acc[0].Id;
        accObj3.Type__c = 'For Training';
        accObj3.Training_Date__c = Date.today();
        accObj3.Monthly_Uploaded_Date__c=Date.today();
        lstT.add(accObj3);
        insert lstT;
        System.assert(lstT.size() > 0);
        Test.startTest();
        SF_UpdateAccountBatchs ucat = new SF_UpdateAccountBatchs();
        Id batchId = Database.executeBatch(ucat);
        Test.stopTest();
        
    }
}