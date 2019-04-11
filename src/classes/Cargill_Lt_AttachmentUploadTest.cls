/*******
 * CreatedDate : 29-06-2018
 * Author : Amrish Surve
 * Description : Contains test class for main class Cargill_Lt_AttachmentUpload
 *******/

@isTest
private class Cargill_Lt_AttachmentUploadTest {
    
    static user testUser;
    @testSetup
    static void dataSetup(){
        Id pId = [select id from profile where name='Customer Community User'].id;
        
        Account acct = new Account(Name='Test Account'); 
        insert acct;
        
        Contact con = new Contact(LastName ='Test Contact',AccountId = acct.Id,Dealer_Contact__c = True);
        insert con;
        
        testUser = new User(alias = 'test123', email='test123@noemail.com',
                                 emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
                                 localesidkey='en_US',profileid = pId,country='United States',IsActive =true,
                                 ContactId = con.Id, timezonesidkey='America/Los_Angeles', username='tester@noemail.com');
        insert testUser;
        
        
        List<Account_Attachments__c> accAttach  = new List<Account_Attachments__c>
        {
                new Account_Attachments__c (Attachment_Name__c='Test Attachment1', Type__c='Display',Start_Month_Date__c=Date.today(), Monthly_Uploaded_Date__c=Date.today()),
                new Account_Attachments__c (Attachment_Name__c='Test Attachment2', Type__c='For Training',Start_Month_Date__c=Date.today(), Monthly_Uploaded_Date__c=Date.today(),Training_Date__c=Date.today()),
                new Account_Attachments__c (Attachment_Name__c='Test Attachment3', Type__c='Events',Start_Month_Date__c=Date.today(), Monthly_Uploaded_Date__c=Date.today()),
                new Account_Attachments__c (Attachment_Name__c='Test Attachment4', Type__c='Prospect Lists and Activities',Start_Month_Date__c=Date.today(), Monthly_Uploaded_Date__c=Date.today(),Last_Upload_Date__c=Date.today())
        };
                insert accAttach;
        
        
        List<Cargill_MonthYearDropDown__c> months = new List<Cargill_MonthYearDropDown__c>
        {
            new Cargill_MonthYearDropDown__c(Seq__c=1, Name='January', Type__c='Month'),
            new Cargill_MonthYearDropDown__c(Seq__c=1, Name='2018', Type__c='Year')    
        };
            insert months;
        
        Cargill_Growth_Metrics__c cgmData = new Cargill_Growth_Metrics__c(Account__c=acct.id);
        insert cgmdata;
        System.debug('@acct@'+acct.Id);
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
        
    }
    
    @isTest 
    static void getAccountRecordTest(){
        Test.startTest();
        Cargill_Lt_AttachmentUpload.getAccountRecord();
        Test.stopTest();
    }
    
    @isTest 
    static void getContactRecordTest(){
        Test.startTest();
        Cargill_Lt_AttachmentUpload.getContactRecord();
        Cargill_Lt_AttachmentUpload.getCommunityDetails();
        Test.stopTest();
    }
    
    @isTest 
    static void getMonthsTest(){
        Test.startTest();
        Cargill_Lt_AttachmentUpload.getMonths();
        Test.stopTest();
    }
    
    @isTest 
    static void getYearsTest(){
        Test.startTest();
        Cargill_Lt_AttachmentUpload.getYears();
        Test.stopTest();
    }
    
    @isTest 
    static void displayGrowthDataTest(){
        Test.startTest();
        Cargill_Lt_AttachmentUpload.displayGrowthData();
        Test.stopTest();
    }
    
    @isTest 
    static void displayParentGrowthDataTest(){
        Test.startTest();
        Cargill_Lt_AttachmentUpload.displayParentGrowthData();
        Test.stopTest();
    }
    
    @isTest
    static void fetchLatestLoadedDate(){
        Test.startTest();
        Cargill_Lt_AttachmentUpload.fetchLatestLoadedDate();
        Test.stopTest();
    }
    
    @isTest 
    static void displayMonthlyListTest(){
        Test.startTest();
        Cargill_Lt_AttachmentUpload.displayMonthlyList();
        Test.stopTest();
    }
    
    @isTest 
    static void displayQuarterlyListTest(){
        Test.startTest();
        Cargill_Lt_AttachmentUpload.displayQuarterlyList();
        Test.stopTest();
    }
    
    @isTest 
    static void displayTrainingListTest(){
        Test.startTest();
        Cargill_Lt_AttachmentUpload.displayTrainingList();
        Test.stopTest();
    }
    
    @isTest 
    static void displayProspectListTest(){
        Test.startTest();
        Cargill_Lt_AttachmentUpload.displayProspectList();
        Test.stopTest();
    }
    
    @isTest 
    static void checkMonthlyListTest(){
        Test.startTest();
        Cargill_Lt_AttachmentUpload.checkMonthlyList(null);
        Test.stopTest();
    }
    
    @isTest 
    static void checkQuarterlyListTest(){
        Test.startTest();
        Cargill_Lt_AttachmentUpload.checkQuarterlyList(null);
        Test.stopTest();
    }
    
    @isTest 
    static void checkTrainingListTest(){
        Test.startTest();
        Cargill_Lt_AttachmentUpload.checkTrainingList(null);
        Test.stopTest();
    }
    
    @isTest 
    static void checkProspectListTest(){
        Test.startTest();
        Cargill_Lt_AttachmentUpload.checkProspectList(null);
        Test.stopTest();
    }
    
    @isTest 
    static void UpdateDocumentAttachmentTest(){
        Id accId = [Select Id from Account where Name = 'Test Account'].Id;
        //  String accId = String.valueOf(acc);
        Test.startTest();
        Cargill_Lt_AttachmentUpload.UpdateDocumentAttachment(accId);
        Test.stopTest();
    }
    
    @isTest 
    static void DisplayLoginAccountNameTest(){
        Test.startTest();
        Cargill_Lt_AttachmentUpload.DisplayLoginAccountName();
        Test.stopTest();
    }
    
    @isTest 
    static void checkContentDocumentTest(){
        Test.startTest();
        Id accAttachId =[Select Id from Account_Attachments__c where Attachment_Name__c = 'Test Attachment1'].Id;
        System.debug('#accAttachId##'+accAttachId);
        Set<Id> idSet = new Set<ID>{accAttachId};
        Cargill_Lt_AttachmentUpload.checkContentDocument(idSet);
        Test.stopTest();
    }
    
    @isTest 
    static void checkcreateRecordTest(){
        Test.startTest();
        Account_Attachments__c accAttach  = new Account_Attachments__c( Attachment_Name__c='Test Attachment1', Type__c='Display');
        Id latestCreatedID = Cargill_Lt_AttachmentUpload.createRecord(accAttach, 'January', 2018, 'Display');
        System.assertNotEquals(latestCreatedID, null);
        Test.stopTest();
    }
    
    @isTest
    static void createGrowthDataTest(){
        List<Account> accID = [Select Id,Name from Account where Name = 'Test Account'];
        
        user comuser = [Select Id,username,email from user where username = 'tester@noemail.com'];
        System.debug('$$communityUser$'+comuser);
        Test.startTest();
        System.runAs(comuser){
            Date fetchDate =Cargill_Lt_AttachmentUpload.fetchLastCreatedDate(accID[0].id,'Parent');
            Cargill_Lt_AttachmentUpload.checkGrowthMetrix(null);
            System.assertNotEquals(fetchDate, null);
        }
        Test.stopTest();
    }
    
    @isTest
    static void createGrowthDataNegativeTest(){
        Test.startTest();
        Cargill_Lt_AttachmentUpload.checkGrowthMetrix(null);
        Cargill_Lt_AttachmentUpload.checkGrowthMetrixV1(null);
        Cargill_Lt_AttachmentUpload.FetchDocumentType();
        Cargill_Lt_AttachmentUpload.FetchHistoricType();
        Test.stopTest();
    }
    
    @isTest
    static void createContentData(){
        List<Account_Attachments__c> attachlist1 = [Select Id,Name from Account_Attachments__c where Type__c='Display' limit 1];
        
        ContentVersion contentVersion = new ContentVersion(Title = 'Penguins', PathOnClient = 'Penguins.jpg', VersionData = Blob.valueOf('Test Content'), IsMajorVersion = true);
        insert contentVersion;    
        
        List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
        System.assertEquals(documents.size(), 1);
        //create ContentDocumentLink  record 
        ContentDocumentLink cdl = New ContentDocumentLink(LinkedEntityId = attachlist1[0].id, ContentDocumentId = documents[0].Id, shareType = 'V');
        insert cdl;   
        Test.startTest();
        Cargill_Lt_AttachmentUpload.UpdateDocumentAttachment(attachlist1[0].Id);
        Test.stopTest();
    }
    
}