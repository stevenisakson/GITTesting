@isTest
public class TransitionPage_ContactControllerTest {

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

		//Create test data for Override Settings
		TestDataBuilder.createOverrideSettings();
	}

	//method to test redirecting of this page
	static testMethod void testRedirectingOfPage() {
		User usr = [Select Id From User Where Profile.Name = 'System Administrator' AND IsActive = true Limit 1];

		Contact con = [Select Id, AccountId From Contact];

		System.runAs(usr){

			PageReference pageRet;

			PageReference pg = Page.Contact_Transition_Page;
			pg.getParameters().put('Id',con.Id);
			Test.setCurrentPage(pg);

			ApexPages.StandardController sc = new ApexPages.StandardController(con);

			Test.startTest();
				TransitionPage_ContactController controller = new TransitionPage_ContactController(sc);
				pageRet = controller.redirectpage();
			Test.stopTest();

			System.assert(pageRet != Page.Contact_Transition_Page);
		}
	}
}