@isTest
private class ExternalReportControllerTest {

	private static testMethod void testMethod1() {
        PageReference pg = Page.RequestPDF;
        Test.setCurrentPage(pg);
        
        ExternalReportController controller = new ExternalReportController();
	}

}