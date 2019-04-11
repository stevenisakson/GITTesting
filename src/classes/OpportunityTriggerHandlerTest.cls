/*
	@Author				: Loven Reyes (CloudSherpas)
	@Date Created		: 28-AUG-2015
	@Description		: Test class for OpportunityTriggerHandler
	@Modified By		: Jesfer Baculod (CloudSherpas)
*/

@isTest
private class OpportunityTriggerHandlerTest{
	
	@testSetup static void dataSetup(){
	    //Create test data for Data Steward User
		User usr = TestDataBuilder.createUser(1, TestDataBuilder.getUserProfileId('System Administrator') );
	    insert usr;

	    //Create test data for BU Coordinator User
	    User userSF = TestDataBuilder.createUser(2, TestDataBuilder.getUserProfileId('System Administrator') );
		insert userSF;

		//Create test data for Account
		Account acct = TestDataBuilder.createAccount();
		acct.RecordTypeId = TestDataBuilder.getObjectRecordTypeId(Account.SObjectType,'Competitor');
		insert acct;

		List<AccountTeamMember> atmList = new List<AccountTeamMember>();
		AccountTeamMember atm1 = new AccountTeamMember(
				AccountID = acct.Id,
				UserId = userSF.Id,
				TeamMemberRole = 'Account Manager');
		atmList.add(atm1);

		AccountTeamMember atm2 = new AccountTeamMember(
				AccountID = acct.Id,
				UserId = usr.Id,
				TeamMemberRole = 'Sales Manager');
		atmList.add(atm2);
		insert atmList;

		//Enable trigger for Opportunity
		Trigger_Settings__c ts = new Trigger_Settings__c(Opportunity__c = true);
		insert ts;
	}

	static testMethod void testCreateOpportunityTeamMember(){
		//Retrieve account
		Account acct = [Select Id From Account];
		User usr = [Select Id From User Where Profile.Name = 'System Administrator' AND IsActive = true  Limit 1];

		System.runAs(usr){
			//Create test data for Opportunity
			Opportunity oppty = TestDataBuilder.createOpportunity(acct.Id);

			Test.startTest();
				insert oppty;
			Test.stopTest();

			//Verify that Opportunity Team Members where created for Opportunitiy
			list <OpportunityTeamMember> otmlist  = [Select Id, OpportunityId from OpportunityTeamMember where OpportunityId =: oppty.Id];
			system.assertEquals(otmlist.size()>0, true);
		}
	}
}