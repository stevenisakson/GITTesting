/* 
Owner : Amrish Surve  
Created Date : 28 Sept 2019 
Name : SF_UpdateContactController_Test
Description : Test class for main class SF_UpdateContactController */

@isTest
public class SF_UpdateContactController_Test {

    static testMethod void updateContactDataTest() {
        //Create test data for Account
        Account acct = TestDataBuilder.createAccount();
        acct.RecordTypeId = TestDataBuilder.getObjectRecordTypeId(Account.SObjectType,'Commercial Customer');
        acct.Request_Approved__c = false;
        acct.Account_Type__c='Commercial Customer';
        insert acct;
        
        Contact con = new Contact(LastName ='Test Contact',AccountId = acct.Id);
        insert con;
        test.startTest();
        SF_UpdateContactController.updateContactData(con.Id);
        SF_UpdateContactController.checkContactValues(con.Id);
        test.stopTest();
    }

}