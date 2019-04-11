/*
    @Author             : Loven Reyes (CloudSherpas)
    @Date Created       : 26-AUG-2015
    @Description        : Test class for CustomAccountLookupController ()
*/

@isTest
private class CustomAccountLookupControllerTest {
    
    @testSetup static void dataSetup() {
        //Create test data for BU Coordinator User
        User usr = TestDataBuilder.createUser(1, TestDataBuilder.getUserProfileId('BU Coordinator') );
        insert usr;
    }

    //method to test string search
    static testMethod void testStringSearch(){
        User usr = [Select Id From User Where Profile.Name = 'BU Coordinator' Limit 1];

        System.runAs(usr){
            String search = 'cargill';

            Account acct = TestDataBuilder.createAccount();
            insert acct;

 /* Commented By Shalu Req 4.6
            Customer360__c c360 = TestDataBuilder.createCustomer360(acct.Id, 'US');
            insert c360;

            Product_Line__c pLine = TestDataBuilder.createProductLine(c360.Id);

            List<Product_Line__c> pLineList = new List<Product_Line__c>();
            pLineList.add(pLine);
            insert pLineList;
*/
            PageReference pageRet = null;

            Test.startTest();
                CustomAccountLookupController controller = new CustomAccountLookupController();
                controller.getFormTag();
                controller.getTextBox();
                pageRet = controller.search();
              //  controller.performSearch(search);
            Test.stopTest();

            System.assert(pageRet == null);
        }
    }
}