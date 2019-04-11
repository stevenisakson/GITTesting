/*********************************************************************
Name:ThirdpartyValRequestControllerTest
Date:11 Nov 2018
Description: test Class for ThirdpartyValidationRequestController
             
*********************************************************************/
@isTest
public class ThirdpartyValRequestControllerTest {
    
     private static testMethod void testNewAccountMethod() {
         
         Override_Settings__c  o=new Override_Settings__c();
         o.Third_Party_Record_Type_ID__c=Schema.SObjectType.Request__c.getRecordTypeInfosByName().get('Third Party Validation').getRecordTypeId();
         o.Third_Party_Record_Type_ID_CPN_INDIA__c=Schema.SObjectType.Request__c.getRecordTypeInfosByName().get('Third Party Validation').getRecordTypeId();
         insert o;
         
         
          // Insert account
           Account accountInstance = new Account();
           accountInstance = TestDataBuilder.createAccount();
           accountInstance.Business__c = 'CPN - India';
           accountInstance.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Third Party CPN India').getRecordTypeId();
           insert accountInstance;
        // Account accts = PotentialTestDataFactory.Accountcreatemethod('testbuttonclass');
         
          system.debug('Account details-->'+ accountInstance);
        // ThirdpartyValidationRequestController con=new ThirdpartyValidationRequestController();
         Test.startTest();
         ThirdpartyValidationRequestController.getcreateRecord(accountInstance.id);
         Test.stopTest();
     
     
     
     }
    
    

     private static testMethod void testRejectedAccountMethod() {
     
         Override_Settings__c  o=new Override_Settings__c();
         o.Third_Party_Record_Type_ID__c=Schema.SObjectType.Request__c.getRecordTypeInfosByName().get('Third Party Validation').getRecordTypeId();
         o.Third_Party_Record_Type_ID_CPN_INDIA__c=Schema.SObjectType.Request__c.getRecordTypeInfosByName().get('Third Party Validation').getRecordTypeId();
         insert o;
         
         // Insert account
           Account accountInstance = new Account();
           accountInstance = TestDataBuilder.createAccount();
           accountInstance.Business__c = 'CPN - India';
           accountInstance.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Third Party CPN India').getRecordTypeId();
           insert accountInstance;
         
           accountInstance.Status__c ='Rejected';
         
           update accountInstance;
         
           Test.startTest();
           ThirdpartyValidationRequestController.getcreateRecord(accountInstance.id);
           Test.stopTest();

     }
     
     private static testMethod void testApprovedAccountMethod() {
         
         Override_Settings__c  o=new Override_Settings__c();
         o.Third_Party_Record_Type_ID__c=Schema.SObjectType.Request__c.getRecordTypeInfosByName().get('Third Party Validation').getRecordTypeId();
         o.Third_Party_Record_Type_ID_CPN_INDIA__c=Schema.SObjectType.Request__c.getRecordTypeInfosByName().get('Third Party Validation').getRecordTypeId();
         insert o;
         
         // Insert account
           Account accountInstance = new Account();
           accountInstance = TestDataBuilder.createAccount();
           accountInstance.Business__c = 'CPN - India';
           // accountInstance.Prospect_Validated__c = false;
           accountInstance.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Third Party CPN India').getRecordTypeId();
           insert accountInstance;
         
           //accountInstance.Prospect_Validated__c = false;
          accountInstance.Status__c ='Approved';
         
           update accountInstance;
         
          Test.startTest();
           ThirdpartyValidationRequestController.getcreateRecord(accountInstance.id);
          Test.stopTest();
     
     }

}