/*******
* CreatedDate : 19-09-2018
* Author : Amrish Surve
* Description : Contains test class for handler class SFA_ContentDocument_DeleteHandler
*******/
@isTest
public class SFA_ContentDocument_DeleteHandlerTest {
    
    static user testUser;
    @testSetup
    static void dataSetup(){
        Id pId = [select id from profile where name='Customer Community User'].id;
        
        Account acct = new Account(Name='Test Account1BE'); 
        insert acct;
        
        Contact con = new Contact(LastName ='Test Contact1',AccountId = acct.Id);
        insert con;
        
        testUser = new User(alias = 'test1233', email='test1234BE@noemail.com',
                            emailencodingkey='UTF-8', lastname='Testing3', languagelocalekey='en_US',
                            localesidkey='en_US',profileid = pId,country='United States',IsActive =true,
                            ContactId = con.Id, timezonesidkey='America/Los_Angeles', username='tester33BE@noemail.com');
        insert testUser;
        
        
        List<Account_Attachments__c> accAttach  = new List<Account_Attachments__c>{
                new Account_Attachments__c (Attachment_Name__c='Test Attachment11', Type__c='Display',Start_Month_Date__c=Date.today(), Monthly_Uploaded_Date__c=Date.today()),
                new Account_Attachments__c (Attachment_Name__c='Test Attachment22', Type__c='For Training',Start_Month_Date__c=Date.today(), Monthly_Uploaded_Date__c=Date.today(),Training_Date__c=Date.today()),
                new Account_Attachments__c (Attachment_Name__c='Test Attachment33', Type__c='Events',Start_Month_Date__c=Date.today(), Monthly_Uploaded_Date__c=Date.today()),
                new Account_Attachments__c (Attachment_Name__c='Test Attachment44', Type__c='Prospect Lists and Activities',Start_Month_Date__c=Date.today(), Monthly_Uploaded_Date__c=Date.today(),Last_Upload_Date__c=Date.today())
        };
        insert accAttach;
    }
    
    @IsTest
    static void testDeleteContentDocument(){
        List<Account> acd = [Select Id,Name from Account where name = 'Test Account1BE'];
        List<Account_Attachments__c> accAttachDelete  = new List<Account_Attachments__c>{
                new Account_Attachments__c (Attachment_Name__c='Test Attachment22BE',Account__c = acd[0].Id, Type__c='Events',Start_Month_Date__c=Date.today(), Monthly_Uploaded_Date__c=Date.today(),Training_Date__c=Date.today())
        };
        insert accAttachDelete; 
        System.assert(accAttachDelete.size() > 0);
        ContentVersion contentVersion = new ContentVersion(Title = 'Penguins22', PathOnClient = 'Penguins22.jpg', VersionData = Blob.valueOf('Test Content1'), IsMajorVersion = true);
        insert contentVersion;    
        
        List<ContentDocument> Cdocuments = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
        //create ContentDocumentLink  record 
        ContentDocumentLink cdl = New ContentDocumentLink(LinkedEntityId = accAttachDelete[0].id, ContentDocumentId = Cdocuments[0].Id, shareType = 'V');
        insert cdl;   
        Test.startTest();
            if(!Cdocuments.isEmpty())
                delete Cdocuments;
        Test.stopTest();
    }
    
    @IsTest
    static void testDeleteContentDisDocument(){
        List<Account> acd = [Select Id,Name from Account where name = 'Test Account1BE'];
        List<Account_Attachments__c> accAttachDelete  = new List<Account_Attachments__c>{
                new Account_Attachments__c (Attachment_Name__c='Test Attachment22BE1',Account__c = acd[0].Id, Type__c='Display',Start_Month_Date__c=Date.today(), Monthly_Uploaded_Date__c=Date.today(),Training_Date__c=Date.today())
        };
        insert accAttachDelete; 
        System.assert(accAttachDelete.size() > 0);
        ContentVersion contentVersion = new ContentVersion(Title = 'Penguins223', PathOnClient = 'Penguins223.jpg', VersionData = Blob.valueOf('Test Content1'), IsMajorVersion = true);
        insert contentVersion;    
        
        List<ContentDocument> Cdocuments = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
        //create ContentDocumentLink  record 
        ContentDocumentLink cdl = New ContentDocumentLink(LinkedEntityId = accAttachDelete[0].id, ContentDocumentId = Cdocuments[0].Id, shareType = 'V');
        insert cdl;   
        Test.startTest();
            if(!Cdocuments.isEmpty())
                delete Cdocuments;
        Test.stopTest();
    }
    
    @IsTest
    static void testDeleteContentProsDocument(){
        List<Account> acd = [Select Id,Name from Account where name = 'Test Account1BE'];
        List<Account_Attachments__c> accAttachDelete  = new List<Account_Attachments__c>{
                new Account_Attachments__c (Attachment_Name__c='Test Attachment22BE12',Account__c = acd[0].Id, Type__c='Prospect Lists and Activities',Last_Upload_Date__c=Date.today(), Monthly_Uploaded_Date__c=Date.today(),Training_Date__c=Date.today())
        };
        insert accAttachDelete; 
        System.assert(accAttachDelete.size() > 0);
        ContentVersion contentVersion = new ContentVersion(Title = 'Penguins2233', PathOnClient = 'Penguins2233.jpg', VersionData = Blob.valueOf('Test Content1'), IsMajorVersion = true);
        insert contentVersion;    
        
        List<ContentDocument> Cdocuments = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
        //create ContentDocumentLink  record 
        ContentDocumentLink cdl = New ContentDocumentLink(LinkedEntityId = accAttachDelete[0].id, ContentDocumentId = Cdocuments[0].Id, shareType = 'V');
        insert cdl;   
        Test.startTest();
            if(!Cdocuments.isEmpty())
                delete Cdocuments;
        Test.stopTest();
    }
}