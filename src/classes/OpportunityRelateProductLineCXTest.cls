/*
    @Author             : Loven Reyes (CloudSherpas)
    @Date Created       : 26-AUG-2015
    @Description        : Test class for OpportunityRelateProductLineCX (VfPage - OpportunityRelateProductLine)
*/

@isTest
private class OpportunityRelateProductLineCXTest {
    
    @testSetup static void dataSetup() {
        //Create test data for BU Coordinator User
        User usr = TestDataBuilder.createUser(1, TestDataBuilder.getUserProfileId('BU Coordinator') );
        insert usr;
    }

    //method to test page if opportunity is created when newid,pId and aId is pass
    static testMethod void testIfOpptyIsCreated(){
        User usr = [Select Id From User Where Profile.Name = 'BU Coordinator' Limit 1];

        System.runAs(usr){
            Account acct = TestDataBuilder.createAccount();
            insert acct;

/* Commented By Shalu Req 4.6
            Customer360__c c360 = TestDataBuilder.createCustomer360(acct.Id, 'US');
            insert c360;*/

            Opportunity oppty = TestDataBuilder.createOpportunity(acct.Id);
            insert oppty;

 /* Commented By Shalu Req 4.6
            Product_Line__c pLine = TestDataBuilder.createProductLine(c360.Id);
            pLine.Related_Account__c = 'Cargill';
            insert  pLine;

            Related_Product_Line__c rpLine = TestDataBuilder.createRelatedProdLine(oppty.Id, pLine.Id);
            insert rpLine;*/

            PageReference pageRet = null;

            PageReference pg = Page.OpportunityRelateProductLine;
            pg.getParameters().put('newid',oppty.Id);
            //pg.getParameters().put('pId',pLine.Id);
            pg.getParameters().put('aId',acct.Id);
            Test.setCurrentPage(pg);
            ApexPages.StandardController sc = new ApexPages.StandardController(oppty);

            Test.startTest();
                OpportunityRelateProductLineCX controller = new OpportunityRelateProductLineCX(sc);
                pageRet = controller.addRelatedProductLine();
            Test.stopTest();

           // System.assert(pageRet.getUrl().contains('/'+acct.Id),pageRet.getUrl());
        }
    }
}