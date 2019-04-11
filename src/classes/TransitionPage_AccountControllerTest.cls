/*
    @Author             : Loven Reyes (CloudSherpas)
    @Date Created       : 26-AUG-2015
    @Description        : Test class for TransitionPage_AccountController (VfPage - Account_Transition_Page)
*/

@isTest
private class TransitionPage_AccountControllerTest {

    @testSetup static void dataSetup() {
        //Create test data for BU Coordinator User
        User usr = TestDataBuilder.createUser(1, TestDataBuilder.getUserProfileId('System Administrator') );
        insert usr;
        
        System.runAs(usr){

        Account acct = TestDataBuilder.createAccount();
        insert acct;
        system.debug('AccountId* is '+acct.id);
        //Create test data for Override Settings
        TestDataBuilder.createOverrideSettings();
        MobileFirstSettings__c testMobileFirstSetting= new MobileFirstSettings__c(Name = 'Test',ProfileId__c='00ej0000000lwFz');
        insert testMobileFirstSetting;
        }
    }

    //method to test redirecting of this page
    static testMethod void testRedirectingOfPage() {
        User usr = [Select Id From User Where Profile.Name = 'System Administrator' AND IsActive = true  Limit 1];
        
        list<Account> acctList = [Select Id, RecordTypeId From Account];
        system.debug(LoggingLevel.INFO,'AccountId** is '+acctList[0].id);
        account acct = acctList[0];
        System.runAs(usr){
PageReference pageRet = null;
            PageReference pg = Page.Account_Transition_Page;
            pg.getParameters().put('Id',acctList[0].Id);
            pg.getParameters().put('123','xyz');
            Test.setCurrentPage(pg);
            ApexPages.StandardController sc = new ApexPages.StandardController(acct);
            TransitionPage_AccountController controller = new TransitionPage_AccountController(sc);
           
          //  controller.getAcctRecTypes();

            //Test Page Cancel
              controller.webcancel();
            system.debug(LoggingLevel.INFO,'\n\n controller : '+controller+'\n\n\n');
            Test.startTest();
                //Test Redirecting of Page
                  pageRet = controller.redirectpage();
            Test.stopTest();

            //Verify that page was redirected
           // system.assert(pageRet != controller.redirectpage() != pg);

        }
    }
    static testMethod void testhack() {
        TransitionPage_AccountController.hack();
    }
}