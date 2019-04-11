/*
    @Author             : Tumish Tak
    @Date Created       : 06-Dec-2017
    @Description        : Test class for TransitionPage_TaskController (VfPage - Task_Transition_Page)
*/

@isTest
private class TransitionPage_TaskControllerTest {
    
    @testSetup static void dataSetup() {
        //Create test data for User
        User usr = TestDataBuilder.createUser(1, TestDataBuilder.getUserProfileId('System Administrator') );
        insert usr;
        Task tsk = new task(Subject='Test Task Testclass',Mobile_First__c=True);
        insert tsk;
        //Create test data for Override Settings
        TestDataBuilder.createOverrideSettings();
    }

    //method to test redirecting of this page
    static testMethod void testRedirectingOfPage() {
        User usr = [Select Id From User Where Profile.Name = 'System Administrator'  AND IsActive = true  Limit 1];
    
    Task tsk = [Select Id, Subject From Task];
        System.runAs(usr){
            PageReference pageRet = null;

            PageReference pg = Page.Task_Transition_Page;
            pg.getParameters().put('Id',tsk.Id);
            Test.setCurrentPage(pg);

            ApexPages.StandardController sc = new ApexPages.StandardController(tsk);

            Test.startTest();
                TransitionPage_TaskController controller = new TransitionPage_TaskController(sc);
                pageRet = controller.redirectpage();
            Test.stopTest();

            System.assert(pageRet != Page.Task_Transition_Page);
        }
    }
}