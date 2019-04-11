@isTest
public class ConverttoCustomerControllerTest
{
    
     private static testMethod void testPotential_TriggerHandleMethod() {
         
         Override_Settings__c  o=new Override_Settings__c();
         o.Prospect_Conversion_RecordTypeID__c='012j00000010CWoAAM';
         insert o;
         
         Account accts = PotentialTestDataFactory.Accountcreatemethod('testbuttonclass');
         
         ConverttoCustomerController con=new ConverttoCustomerController();
         ConverttoCustomerController.getcreateRecord(accts.id);
     
     
     
     }

     private static testMethod void testPotential_TriggerHandleMethod1() {
     
         Override_Settings__c  o=new Override_Settings__c();
         o.Prospect_Conversion_RecordTypeID__c='012j00000010CWoAAM';
         insert o;
         
         Account accts = PotentialTestDataFactory.Accountcreatemethod('testbuttonclass');
         accts.Status__c ='Conversion In progress';
         
         update accts;
         
         ConverttoCustomerController con=new ConverttoCustomerController();
         ConverttoCustomerController.getcreateRecord(accts.id);
     
     }
     
     private static testMethod void testPotential_TriggerHandleMethod2() {
         
         Override_Settings__c  o=new Override_Settings__c();
         o.Prospect_Conversion_RecordTypeID__c='012j00000010CWoAAM';
         insert o;
         
         Account accts = PotentialTestDataFactory.Accountcreatemethod('testbuttonclass');
         accts.Status__c ='Conversion In progress';
         accts.Prospect_Validated__c = false;
         
         update accts;
         
         ConverttoCustomerController con=new ConverttoCustomerController();
         ConverttoCustomerController.getcreateRecord(accts.id);
     
     
     
     }

}