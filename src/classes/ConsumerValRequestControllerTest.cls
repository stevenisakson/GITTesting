/*********************************************************************
Name:ConsumerValRequestControllerTest
Date:15 Nov 2018
Description: test Class for ConsumerValidationRequestController
             
*********************************************************************/
@isTest
public class ConsumerValRequestControllerTest {


private static testMethod void testNewAccountMethod() {
         
         Override_Settings__c  o=new Override_Settings__c();
         o.Consumer_Validation_Request_RecordTypeID__c=Schema.SObjectType.Request__c.getRecordTypeInfosByName().get(Label.Consumer_Validation_CPN_INDIA).getRecordTypeId();
         insert o;
         
         
          // Insert account
           Account accountInstance = new Account();
           accountInstance = TestDataBuilder.createAccount();
           accountInstance.Business__c = 'CPN - India';
           accountInstance.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(Label.Consumer_Record_Type+' CPN India').getRecordTypeId();
           insert accountInstance;
        // Account accts = PotentialTestDataFactory.Accountcreatemethod('testbuttonclass');
         
          system.debug('Account details-->'+ accountInstance);
        
         Test.startTest();
         ConsumerValidationRequestController.getcreateRecord(accountInstance.id);
         Test.stopTest();
     
     
     
     }
    
    

     private static testMethod void testRejectedAccountMethod() {
     
         Override_Settings__c  o=new Override_Settings__c();
         o.Consumer_Validation_Request_RecordTypeID__c =Schema.SObjectType.Request__c.getRecordTypeInfosByName().get(Label.Consumer_Validation_CPN_INDIA).getRecordTypeId();
         insert o;
         
         // Insert account
           Account accountInstance = new Account();
           accountInstance = TestDataBuilder.createAccount();
           accountInstance.Business__c = 'CPN - India';
           accountInstance.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(Label.Consumer_Record_Type+' CPN India').getRecordTypeId();
           insert accountInstance;
         
           accountInstance.Status__c ='Rejected';
         
           update accountInstance;
         
           Test.startTest();
           ConsumerValidationRequestController.getcreateRecord(accountInstance.id);
           Test.stopTest();

     }
     
     private static testMethod void testApprovedAccountMethod() {
         
         Override_Settings__c  o=new Override_Settings__c();
         o.Consumer_Validation_Request_RecordTypeID__c =Schema.SObjectType.Request__c.getRecordTypeInfosByName().get(Label.Consumer_Validation_CPN_INDIA).getRecordTypeId();
         insert o;
         
         // Insert account
           Account accountInstance = new Account();
           accountInstance = TestDataBuilder.createAccount();
           accountInstance.Business__c = 'CPN - India';
           // accountInstance.Prospect_Validated__c = false;
           accountInstance.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(Label.Consumer_Record_Type+' CPN India').getRecordTypeId();
           insert accountInstance;
         
           //accountInstance.Prospect_Validated__c = false;
          accountInstance.Status__c ='Approved';
         
           update accountInstance;
         
          Test.startTest();
           ConsumerValidationRequestController.getcreateRecord(accountInstance.id);
          Test.stopTest();
     
     }    
    

}