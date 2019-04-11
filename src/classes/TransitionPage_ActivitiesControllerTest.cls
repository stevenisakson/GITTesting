/*
	@Author				: Loven Reyes (CloudSherpas)
	@Date Created		: 26-AUG-2015
	@Description		: Test class for TransitionPage_ActivitiesController (VfPage - Activities_Transition_Page)
*/

@isTest
private class TransitionPage_ActivitiesControllerTest {
	
	@testSetup static void dataSetup() {
	    //Create test data for BU Coordinator User
	    User usr = TestDataBuilder.createUser(1, TestDataBuilder.getUserProfileId('System Administrator') );
		insert usr;

		Visit_Report__c visitcon = TestDataBuilder.createVisitReport();
		insert visitcon;

		//Create test data for Override Settings
		TestDataBuilder.createOverrideSettings();
	}

	//method to test redirecting of this page
	static testMethod void testRedirectingOfPage() {
		User usr = [Select Id From User Where Profile.Name = 'System Administrator'  AND IsActive = true  Limit 1];

		Visit_Report__c visitcon = [Select Id from Visit_Report__c];

		System.runAs(usr){
			Event eventcon = TestDataBuilder.createEvent(visitcon.Id);
			insert eventcon;

			PageReference pageRet = null;

			PageReference pg = Page.Activities_Transition_Page;
			pg.getParameters().put('cargill',eventcon.Id);
			Test.setCurrentPage(pg);

			ApexPages.StandardController sc = new ApexPages.StandardController(eventcon);

			Test.startTest();
				TransitionPage_ActivitiesController controller = new TransitionPage_ActivitiesController(sc);
				pageRet = controller.redirectpage();
			Test.stopTest();

			System.assert(pageRet != Page.Activities_Transition_Page);
		}
	}
}