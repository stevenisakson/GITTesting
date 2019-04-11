@isTest
public class AccountDetailsTest {
 	 @testSetup
    static void dataSetup() {
       Profile p = [SELECT Id FROM Profile WHERE Name='Data Steward']; 
       User u = new User(Alias = 'standt', Email='standarduser@testorg.com', 
       				 EmailEncodingKey='UTF-8', LastName='Testing', FirstName='AccTeamDelete', LanguageLocaleKey='en_US', 
       				 LocaleSidKey='en_US', ProfileId = p.Id, 
       				 TimeZoneSidKey='America/Los_Angeles', UserName='AccTeamDelete@testorg.com');
        
       insert u;
        
       List<Account> accounts = new List<Account>();
        
       Account acc1= new Account();
       acc1.name = 'test_Account1';
       acc1.RecordTypeId = TestDataBuilder.getObjectRecordTypeId(Account.SObjectType,'Standard');
       acc1.Account_Type__c='Standard';
       //acc1.OwnerId = u.id;
       insert acc1;
       accounts.add(acc1);
        
       Account acc2= new Account();
       acc2.name = 'test_Account2';
       acc2.RecordTypeId = TestDataBuilder.getObjectRecordTypeId(Account.SObjectType,'Standard');
       acc2.Account_Type__c='Standard';
       acc2.Type = 'Consultant';
       //acc2.OwnerId = u.id;
       insert acc2;        
       
       Trigger_Settings__c t=new Trigger_Settings__c();
       t.Account__c=true;
       t.Name='test';
       insert t;
        
       String teamMemberRole = 'Account Manager';
	   String accountAccessLevel = 'Read', opportunityAccessLevel = 'Read', caseAccessLevel = 'None';
	   List<AccountTeamMember> members = new list<AccountTeamMember>();
       List<AccountShare> sharingRules = new list<AccountShare>();
        
	   for(Account a : accounts) {
    		members.add(New AccountTeamMember(AccountId = a.id, TeamMemberRole = teamMemberRole, UserId= u.Id));
    		sharingRules.add(new AccountShare(AccountAccessLevel = accountAccessLevel, OpportunityAccessLevel = OpportunityAccessLevel, CaseAccessLevel = caseAccessLevel, UserOrGroupId = u.Id, AccountId = a.id));
	 	}

		insert members; 
		insert sharingRules;
        
        RecordType rt=[select id, name from RecordType  WHERE Name = 'Account Team Delete' ];
        
        Override_Settings__c  o=new Override_Settings__c();
        o.Account_Team_Delete_RecordTypeID__c=rt.Id;
        insert o;
    
    } 
    @isTest
    static void fetchAccountDetailsTest()
    {
       Test.StartTest();
        
       List<AccountDetails.accountListWrapper> w;
       Account acc = [select id, name,Account_Type__c,RecordTypeId, Type from Account where name ='test_Account1']; 
       User user = [select id, profile.name from User where name='AccTeamDelete Testing']; 
        
       AccountDetails.accountListWrapper testWrap = new AccountDetails.accountListWrapper(true, acc);
       
       AccountDetails.fetchAccountDetails(user.Id); 
    
       Test.StopTest();
    }
    @isTest
    static void createRequestRecordTest()
    {
        Test.StartTest(); 
        
        Account acc1 = [select id, name,Account_Type__c,RecordTypeId, Type from Account where name ='test_Account1']; 
        Account acc2 = [select id, name,Account_Type__c,RecordTypeId, Type from Account where name ='test_Account2']; 
       
        
        String accid1 = acc1.id;
        String accid2 = acc2.id;
        
        set<String> acctIds = new set<String>{accid1,accid2};
        
        String accIds =JSON.serialize(acctIds);
        
		User u =[select id,name from User where email='standarduser@testorg.com' limit 1];
        
        RecordType rt=[select id, name from RecordType  WHERE Name = 'Account Team Delete' ];
        
        Account_Approval_Process_Settings__c appSettings = new Account_Approval_Process_Settings__c(Name = rt.Id,Approval_Process_Name__c='Account_Team_Update_Approval_Process',Account_Approval_Process_Label_Name__c='Account Team Update Approval Process');
        insert appSettings;
       
        
        AccountDetails.createRequestRecord(accIds, u.Name, u.id);
        
        Test.StopTest();
        
    }      
}