/*
    @Author             : Loven Reyes (CloudSherpas)
    @Date Created       : 28-AUG-2015
    @Description        : Test class for EventTriggerHandler
*/

@isTest
private class EventTriggerHandlerTest {
    
    @testSetup static void dataSetup() {
        //Create test data for BU Coordinator User
        User usr = TestDataBuilder.createUser(1, TestDataBuilder.getUserProfileId('System Administrator') );
        insert usr;
        
        System.runAs(usr){
        //Create test data for Account
        Account acct = TestDataBuilder.createAccount();
        acct.RecordTypeId = TestDataBuilder.getObjectRecordTypeId(Account.SObjectType,'Competitor');
        insert acct;

        Visit_Report__c visitreport = TestDataBuilder.createVisitReport();
        insert visitreport;

        //Enable trigger for Opportunity
        Trigger_Settings__c ts = new Trigger_Settings__c(Opportunity__c = true);
        insert ts;
        
       
        }
    }

    static testMethod void testEventRefreshAndUpdate() {
        Test.startTest();
        TestDataBuilder.createApproval_Process_Settings();
        Account acct = [Select Id From Account];
        User usr = [Select Id From User Where isActive=True and Profile.Name = 'System Administrator' and Business_Unit__c = 'Canada' Limit 1];
        Visit_Report__c visitreport = [Select Id From Visit_Report__c];

        System.runAs(usr){
            Event events = TestDataBuilder.createEvent(visitreport.Id);

                events.IsPrivate=TRUE;
                insert events;

                acct.Type = 'Prospect';
                events.WhatId = acct.Id;
                events.IsPrivate = FALSE;
                update acct;            
                update events;
            

            events = [Select Id, WhatId from Event WHERE Id =: events.Id];

            System.assert(events.WhatId == acct.Id);
            Account acct1 = TestDataBuilder.createAccount();
            acct.RecordTypeId = TestDataBuilder.getObjectRecordTypeId(Account.SObjectType,'Commercial Customer');
            acct.Request_Approved__c = false;
            try{
            insert acct1;
            Contact c = TestDataBuilder.createContact(acct1.id, 1);
            insert c;
            }
            catch(exception ex)
            {
            }
        }
       Test.stopTest();
    }
    
    

    static testMethod void testOpportunity() {
        Test.startTest();
        TestDataBuilder.createApproval_Process_Settings();
        Account acct = [Select Id From Account];
        User usr = [Select Id From User Where isActive=True and Profile.Name = 'System Administrator' and Business_Unit__c = 'Canada' Limit 1];
        Visit_Report__c visitreport = [Select Id From Visit_Report__c];

        System.runAs(usr){
  /*Commented By Shalu Req 4.6
            Customer360__c c360 = TestDataBuilder.createCustomer360(acct.Id, 'US');
            insert c360;

            Product_Line__c pl = TestDataBuilder.createProductLine(c360.Id);
            insert pl;

            Opportunity opp = TestDataBuilder.createOpportunity(acct.Id);
            insert opp;
/* Commented By Shalu Req 4.6
            Related_Product_line__c rpline = TestDataBuilder.createRelatedProdLine(opp.Id, pl.Id);
            insert rpline;*/

            Event events = TestDataBuilder.createEvent(visitreport.Id);
                events.IsPrivate=TRUE;
                insert events;
             //   events.WhatId = opp.Id;

                events.Segment__c = '';
                events.Class__c  = '';
                events.Group__c  = '';
                events.Product_Function__c  = '';
                events.Product_Line__c  = '';

                update events;
        

            events = [Select Id, WhatId from Event WHERE Id =: events.Id];

         //   System.assert(events.WhatId == opp.Id);
        }
        Test.stopTest();
    }
}