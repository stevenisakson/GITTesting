/*******
* CreatedDate : 29-06-2018
* Author : Amrish Surve
* Description : Contains test class for main class SF_AccountDocument_Controller
*******/
@isTest
public class SF_AccountDocument_ControllerTest {
    
    static user testUser;
    @testSetup
    static void dataSetup(){
        Id pId = [select id from profile where name='Customer Community User'].id;
        
        Account acct = new Account(Name='Test Account1GE'); 
        insert acct;
        
        Contact con = new Contact(LastName ='Test Contact1',AccountId = acct.Id);
        insert con;
        
        testUser = new User(alias = 'test1233', email='test1234@noemail.com',
                            emailencodingkey='UTF-8', lastname='Testing3', languagelocalekey='en_US',
                            localesidkey='en_US',profileid = pId,country='United States',IsActive =true,
                            ContactId = con.Id, timezonesidkey='America/Los_Angeles', username='tester33@noemail.com');
        insert testUser;
        
        
        List<Account_Attachments__c> accAttach  = new List<Account_Attachments__c>{
                new Account_Attachments__c (Attachment_Name__c='Test Attachment11', Type__c='Display',Start_Month_Date__c=Date.today(), Monthly_Uploaded_Date__c=Date.today()),
                new Account_Attachments__c (Attachment_Name__c='Test Attachment22', Type__c='For Training',Start_Month_Date__c=Date.today(), Monthly_Uploaded_Date__c=Date.today(),Training_Date__c=Date.today()),
                new Account_Attachments__c (Attachment_Name__c='Test Attachment33', Type__c='Events',Start_Month_Date__c=Date.today(), Monthly_Uploaded_Date__c=Date.today()),
                new Account_Attachments__c (Attachment_Name__c='Test Attachment44', Type__c='Prospect Lists and Activities',Start_Month_Date__c=Date.today(), Monthly_Uploaded_Date__c=Date.today(),Last_Upload_Date__c=Date.today())
        };
        insert accAttach;
        
        
        List<Cargill_MonthYearDropDown__c> months = new List<Cargill_MonthYearDropDown__c>{
                new Cargill_MonthYearDropDown__c(Seq__c=1, Name='January', Type__c='Month'),
                new Cargill_MonthYearDropDown__c(Seq__c=1, Name='2018', Type__c='Year')    
        };
        insert months;
        
        Cargill_Growth_Metrics__c cgmData = new Cargill_Growth_Metrics__c(Account__c=acct.id);
        insert cgmdata;
        
        List<Cargill_Growth_Metrics__c> lstGr = new List<Cargill_Growth_Metrics__c>();
        Cargill_Growth_Metrics__c growthObj = new Cargill_Growth_Metrics__c();
        growthObj.Account__c = acct.Id;

        lstGr.add(growthObj);
        
        Cargill_Growth_Metrics__c growthObjN = new Cargill_Growth_Metrics__c();

        growthObjN.Account__c = acct.Id;
        lstGr.add(growthObjN);
        insert lstGr;
        
        Document_Types__c dtype = new Document_Types__c();
        dtype.name = 'Display';
        dtype.Is_History_Available__c = True;
        insert dtype;
        
        ContentVersion contentVersion = new ContentVersion(Title = 'Penguins1', PathOnClient = 'Penguins1.jpg', VersionData = Blob.valueOf('Test Content1'), IsMajorVersion = true);
        insert contentVersion;    
        
        List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
        System.assertEquals(documents.size(), 1);
        //create ContentDocumentLink  record 
        ContentDocumentLink cdl = New ContentDocumentLink(LinkedEntityId = accAttach[0].id, ContentDocumentId = documents[0].Id, shareType = 'V');
        insert cdl;   
    }
    
    @isTest
    static void testgetAttachmentList(){
        test.startTest();
        List<SF_AccountDocument_Controller.DocumentWrapper> lstWrap = SF_AccountDocument_Controller.getAttachmentList();
        System.assert(lstWrap.size() > 0);
        test.stopTest();
    }
    
    @isTest
    static void testgetAttachmentListEvents(){
        test.startTest();
        SF_AccountDocument_Controller.getAttachmentListEvents();
        test.stopTest();
    }
    
    @isTest
    static void testgetAttachmentListProspect(){
        test.startTest();
        SF_AccountDocument_Controller.getAttachmentListProspect();
        test.stopTest();
    }
    
    @isTest
    static void testgetAttachmentListTraining(){
        test.startTest();
        SF_AccountDocument_Controller.getAttachmentListTraining();
        test.stopTest();
    }
    
    @isTest
    static void testUpdateDocumentAttachment(){
        List<Account_Attachments__c> attachlist1 = [Select Id,Name from Account_Attachments__c where Type__c='Display' limit 1];
        Test.startTest();
        SF_AccountDocument_Controller.getCommunityDetails();
        SF_AccountDocument_Controller.FetchDocumentType();
        SF_AccountDocument_Controller.FetchHistoricType();
        SF_AccountDocument_Controller.UpdateDocumentAttachment(attachlist1[0].id);
        Test.stopTest();
    }
    
    @IsTest
    static void testDeleteContentDocumentLink(){
        List<Account> acd = [Select Id,Name from Account where name = 'Test Account1GE'];
		List<Account_Attachments__c> accAttachDelete  = new List<Account_Attachments__c>{
                new Account_Attachments__c (Attachment_Name__c='Test Attachment22',Account__c = acd[0].Id, Type__c='Events',Start_Month_Date__c=Date.today(), Monthly_Uploaded_Date__c=Date.today(),Training_Date__c=Date.today())
        };
        insert accAttachDelete; 
        System.assert(accAttachDelete.size() > 0);
        ContentVersion contentVersion = new ContentVersion(Title = 'Penguins22', PathOnClient = 'Penguins22.jpg', VersionData = Blob.valueOf('Test Content1'), IsMajorVersion = true);
        insert contentVersion;    
        
        List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
        //create ContentDocumentLink  record 
        Test.startTest();
        ContentDocumentLink cdl = New ContentDocumentLink(LinkedEntityId = accAttachDelete[0].id, ContentDocumentId = documents[0].Id, shareType = 'V');
        insert cdl;
        Test.stopTest();
    }
    
    @IsTest
    static void testDeleteContentDocumentProspectLink(){
        List<Account> acd1 = [Select Id,Name from Account where name = 'Test Account1GE'];
		List<Account_Attachments__c> accAttachDelete  = new List<Account_Attachments__c>{
                new Account_Attachments__c (Attachment_Name__c='Test Attachment2233',Account__c = acd1[0].Id, Type__c='Prospect Lists and Activities',Last_Upload_Date__c=Date.today(), Monthly_Uploaded_Date__c=Date.today(),Training_Date__c=Date.today())
        };
        insert accAttachDelete;     
        System.assert(accAttachDelete.size() > 0);
        ContentVersion contentVersion = new ContentVersion(Title = 'Penguins223', PathOnClient = 'Penguins223.jpg', VersionData = Blob.valueOf('Test Content1'), IsMajorVersion = true);
        insert contentVersion;    
        
        List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
        //create ContentDocumentLink  record 
        Test.startTest();
        ContentDocumentLink cdl = New ContentDocumentLink(LinkedEntityId = accAttachDelete[0].id, ContentDocumentId = documents[0].Id, shareType = 'V');
        insert cdl;
        
        Test.stopTest();
    }
}