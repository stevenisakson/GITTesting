@isTest
public class TransitionPage_OpportunityControllerTest {
	
	@testSetup static void dataSetup() {
	    //Create test data for BU Coordinator User
	    User usr = TestDataBuilder.createUser(1, TestDataBuilder.getUserProfileId('System Administrator') );
		insert usr;

		//Create test data for Account
		Account acc = TestDataBuilder.createAccount();
		insert acc;

		//Create test data for COntact
		Contact con = TestDataBuilder.createContact(acc.Id, 1);
		insert con;

		//Create test data for Opportunity
		Opportunity opp = TestDataBuilder.createOpportunity(acc.Id);
		insert opp;

		//Create test data for Override Settings
		TestDataBuilder.createOverrideSettings();
	}

	//method to test redirecting of this page
	static testMethod void testRedirectingOfPage() {
		User usr = [Select Id From User Where Profile.Name = 'System Administrator' AND IsActive = true  Limit 1];

		Opportunity opp = [Select Id, Name From Opportunity];

		System.runAs(usr){

			PageReference pageRet = null;

			PageReference pg = Page.Opportunity_Transition_Page;
			pg.getParameters().put('Id',opp.Id);
			Test.setCurrentPage(pg);

			ApexPages.StandardController sc = new ApexPages.StandardController(opp);

			Test.startTest();
				TransitionPage_OpportunityController controller = new TransitionPage_OpportunityController(sc);
				pageRet = controller.redirectpage();
			Test.stopTest();

			System.assert(pageRet != Page.Opportunity_Transition_Page);
		}
	}
}