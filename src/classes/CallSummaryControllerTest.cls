/*
    @Author             : Loven Reyes (CloudSherpas)
    @Date Created       : 26-AUG-2015
    @Description        : Test class for CallSummaryController (VfPage - Visit_Report)
*/

@isTest
private class CallSummaryControllerTest {
    
    @testSetup static void dataSetup() {
        //Create test data for BU Coordinator User
        User usr = TestDataBuilder.createUser(1, TestDataBuilder.getUserProfileId('BU Coordinator') );
        insert usr;
    }

    //method to test refresh and update of events in visit report
    static testMethod void testWithCheck() {
        User usr = [Select Id From User Where Profile.Name = 'System Administrator' and isActive = true and Business_Unit__c = 'Canada' Limit 1];
        TestDataBuilder.createApproval_Process_Settings();

        System.runAs(usr){
            Account acct = TestDataBuilder.createAccount();
            acct.RecordTypeId = TestDataBuilder.getObjectRecordTypeId(Account.SObjectType,'Competitor');
            acct.Business__c = 'Canada';
            insert acct;
            
            Visit_Report__c visitcon = TestDataBuilder.createVisitReport();
            insert visitcon;

            Event eventcon = TestDataBuilder.createEvent(visitcon.Id);
            eventcon.Sales__c = true;
            eventcon.Service__c = false;
            eventcon.Claim_Complaint__c = false;
            eventcon.whatId = acct.id;
            insert eventcon;

            ApexPages.StandardController sc = new ApexPages.StandardController(eventcon);

            Test.startTest();
                CallSummaryController controller = new CallSummaryController(sc);
                controller.external_note = 'try1';
                controller.internal_note = 'try2';
                controller.mobileversion =  true;
                controller.updateTable();
                //controller.sendVisitReport();
            Test.stopTest();

            eventcon = [SELECT Id, Visit_Report__c from Event Where Id =: eventcon.Id];

           // System.assert(eventcon.Visit_Report__c != visitcon.Id);
        }       
    }

    //method to test refresh and update of events in visit report
    static testMethod void testWithoutCheck() {
        User usr = [Select Id From User Where Profile.Name = 'BU Coordinator' Limit 1];

        System.runAs(usr){
            Visit_Report__c visitcon = TestDataBuilder.createVisitReport();
            insert visitcon;

            Event eventcon = TestDataBuilder.createEvent(visitcon.Id);
            eventcon.Sales__c = false;
            eventcon.Service__c = false;
            eventcon.Claim_Complaint__c = false;
            insert eventcon;

            ApexPages.StandardController sc = new ApexPages.StandardController(eventcon);

            Test.startTest();
                CallSummaryController controller = new CallSummaryController(sc);
                controller.external_note = null;
                controller.internal_note = null;
                controller.mobileversion =  false;
                controller.updateTable();
            Test.stopTest();

            eventcon = [SELECT Id, Visit_Report__c from Event Where Id =: eventcon.Id];

            //System.assert(eventcon.Visit_Report__c == visitcon.Id);
        }       
    }
    
    static testmethod void testSendEmail() {
    
            Email_Template_Settings__c candata= new Email_Template_Settings__c();
           candata.Name='Canada External';
           candata.Template_Id__c='00Xq0000000Eepr';
           insert candata;
            
           Email_Template_Settings__c poldata= new Email_Template_Settings__c();
           poldata.Name='Poland External';
           poldata.Template_Id__c='00Xq0000000Eept';
           insert poldata;
              
             Account a= TestDataBuilder.createAccount();
             insert a;
             
             Opportunity op= TestDataBuilder.createOpportunity(a.id);
             insert op;
             
             
             Visit_Report__c visitrpt = TestDataBuilder.createVisitReport();
             insert visitrpt;
             
             Event e = TestDataBuilder.createEvent(visitrpt.Id);
             e.Business_Unit__c = 'Poland';
             e.WhatID=a.id;
             e.Visit_Report__c=visitrpt.id;
             e.Call_Notes_Updated__c=false;
             insert e;
             
             Event oppe = TestDataBuilder.createEvent(visitrpt.Id);
             oppe.Business_Unit__c = 'Canada';
             oppe.WhatID=op.id;
             oppe.Visit_Report__c=visitrpt.id;
             oppe.Call_Notes_Updated__c=false;
             insert oppe;
             
             
             ApexPages.StandardController sc = new ApexPages.StandardController(e);
             ApexPages.StandardController sc1 = new ApexPages.StandardController(oppe);
             Test.startTest();
             
             CallSummaryController con = new CallSummaryController(sc);
             con.sendVisitReportExternal();
             
             
             CallSummaryController con1 = new CallSummaryController(sc1);
             con1.sendVisitReportExternal();
             
             
             Test.stopTest();
    
    
    
    }
    
}