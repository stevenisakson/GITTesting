@isTest
private class TestDataBuilder_Test {
   
    static testMethod void testgetUserProfileId(){
        Id profileID = TestDataBuilder.getUserProfileId('System Administrator');
    }
    
    static testMethod void testcreateUser(){
        User testUser = TestDataBuilder.createUser(1, UserInfo.getprofileid());
        User testUser1 = TestDataBuilder.createUser2(UserInfo.getprofileid());
    }
    
    static testMethod void testcreateAccount(){
        Account testAccount = TestDataBuilder.createAccount();
        Contact testContact = TestDataBuilder.createContact(testAccount.Id,1);
        List<Contact> conatctList = new List<Contact>(TestDataBuilder.createListContact(testAccount.Id));
        Opportunity testOpportunity= TestDataBuilder.createOpportunity(testAccount.Id);
        Competitors__c testCompetitor= TestDatabuilder.createCompetitor(testAccount.Id, testOpportunity.Id);
        Visit_Report__c testVisitReport= TestDatabuilder.createVisitReport();
        Request__c testRequest= TestDataBuilder.createRequest(testAccount.Id);
        Event testEvent= TestDataBuilder.createEvent(testVisitReport.Id);
    }
    
    static testMethod void testcreateListAccount(){
        Id RecordTypeId = TestDataBuilder.getObjectRecordTypeId(Account.SObjectType,'Commercial Customer');
        List<Account> AccList = new List<Account> (TestDataBuilder.createListAccount(recordTypeId));
    }
    
    static testMethod void testcreateListCampaign(){
        List<Campaign> testCampaignlist = new List<Campaign>(TestDataBuilder.createListCampaign());
    }
    
    static testMethod void testcreateListProjectGroup(){
        User testUser = TestDataBuilder.createUser(1, UserInfo.getprofileid());
        Id recordTypeId = TestDataBuilder.getObjectRecordTypeId(Account.SObjectType,'Commercial Customer');
        Account testAccount = TestDataBuilder.createAccount();
        Contact testContact = TestDataBuilder.createContact(testAccount.Id,1);
        List<Campaign> testCampaignlist = new List<Campaign>(TestDataBuilder.createListCampaign());
        Campaign testCampaign=testCampaignlist[0];
        List<Project_Group__c> testProjectGroupList= new List<Project_Group__c>(TestDataBuilder.createListProjectGroup( testAccount.Id, testCampaign.Id, testContact.Id, testUser.Id));
        Project_Group__c testProjectGroup= testProjectGroupList[0];
    	List<Project__c> testProjectList= new List<Project__c>(TestDataBuilder.createListProject(testProjectGroup.Id, 'Account', 'Commercial Customer', recordTypeId));
    }
    
    static testMethod void testcreateOverrideSettings(){
        TestDataBuilder.createOverrideSettings();
    }
    
    static testMethod void testcreateFieldSets(){
        TestDataBuilder.createFieldSets();
    }
}