@isTest
public class AccountTeamDeleteTest {
	@isTest
    static void acctTeamMemberDeleteTest()
    {
         Test.StartTest();
        
         Profile p = [SELECT Id FROM Profile WHERE Name='Data Steward']; 
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com', 
       				 EmailEncodingKey='UTF-8', LastName='Testing', FirstName='AccTeamDelete', LanguageLocaleKey='en_US', 
       				 LocaleSidKey='en_US', ProfileId = p.Id, 
       				 TimeZoneSidKey='America/Los_Angeles', UserName='AccTeamDelete@testorg.com');
        
       insert u;
        
        User user2 = new User(Alias = 'standt', Email='standarduser@testorg.com', 
       				 EmailEncodingKey='UTF-8', LastName='user', FirstName='test', LanguageLocaleKey='en_US', 
       				 LocaleSidKey='en_US', ProfileId = p.Id, 
       				 TimeZoneSidKey='America/Los_Angeles', UserName='AccTeamDeleteuser2@testorg.com');
        
       insert user2;
        
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
    		members.add(New AccountTeamMember(AccountId = a.id, TeamMemberRole = teamMemberRole, UserId= user2.Id));
    		sharingRules.add(new AccountShare(AccountAccessLevel = accountAccessLevel, OpportunityAccessLevel = OpportunityAccessLevel, CaseAccessLevel = caseAccessLevel, UserOrGroupId = u.Id, AccountId = a.id));
	 	}

		insert members; 
		insert sharingRules;
        
        RecordType rt=[select id, name from RecordType  WHERE Name = 'Account Team Delete' ];
        
        Override_Settings__c  o=new Override_Settings__c();
        o.Account_Team_Delete_RecordTypeID__c=rt.Id;
        insert o;
        
        List<Request__c>  reqList = new List<Request__c>();
         
        system.debug('rt id: '+rt.Id);
        
         Request__c  requestRecord = new  Request__c();
     	 requestRecord.Status__c = 'Approved';
         requestRecord.RecordTypeId =rt.Id;
         reqList.add(requestRecord);
         insert reqList;
         system.debug('reqList: '+reqList);
         system.debug('user2 id: '+user2.Id);
        
        
         RequestLineItem__c reqLineItem = new RequestLineItem__c();
         reqLineItem.Field_Label__c     ='Account Name';
         reqLineItem.Field_Name__c      ='Name';
         reqLineItem.Request__c         = requestRecord.Id;
         reqLineItem.Account_Name__c    = acc1.name;
         reqLineItem.Action__c          = Label.Remove_Action_Value_on_Request_Line_Item;
         reqLineItem.Team_Member__c     = 'test user';
         reqLineItem.Status__c = 'Approved';
         reqLineItem.Selected_Account_Id__c =acc1.id;
         reqLineItem.User_Id_To_Be_Removed__c =user2.Id;
         insert reqLineItem; 
        
         RequestLineItem__c reqLineItem2 = new RequestLineItem__c();
         reqLineItem2.Field_Label__c     ='Account Name';
         reqLineItem2.Field_Name__c      ='Name';
         reqLineItem2.Request__c         = requestRecord.Id;
         reqLineItem2.Account_Name__c    = acc2.name;
         reqLineItem2.Action__c          = Label.Remove_Action_Value_on_Request_Line_Item;
         reqLineItem2.Team_Member__c     = 'test user';
         reqLineItem2.Status__c = 'Approved';
         reqLineItem2.Selected_Account_Id__c =acc2.id;
         reqLineItem2.User_Id_To_Be_Removed__c =user2.Id;
         insert reqLineItem2;
         system.debug('reqLineItem2: '+reqLineItem2);
         
         RequestTriggerHandler reqHandler = new RequestTriggerHandler();
         reqHandler.acctTeamMemberDelete(reqList);
        
         Test.StopTest();
    }
}