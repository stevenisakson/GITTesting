@isTest (SeeAllData=true)

private class DuplicateRecordItemTriggerTest
{
    static testMethod void testduplicateCheck()
    {
     id accountid;   
        Id recordtypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Standard').getRecordTypeId();
        Id recordtypeIdConsumer = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Consumer').getRecordTypeId();
        Profile p = [SELECT Id FROM Profile WHERE Name='Sales Professional - Poland']; 
        User Testuser = new User(Alias = 'standt', Email='standarduser@testorg.com',Business_Unit__c='Poland',CAN_Business__c='CPN', Country_Code__c='AF', DataStewardDL__c='shalu.jadoun@cognizant.com',EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, TimeZoneSidKey='America/Los_Angeles', UserName='standarduser@testorg.com.c360');
        insert Testuser;
        
        System.runAs(Testuser){
        test.startTest();
        Account acc = new Account();
        acc.Name='Test_Account';
        acc.Legal_Name__c='KKKG'; //matching rule condition
        acc.Type='Building';
     //   acc.Segment_Step_1__c='Mila';
     //   acc.X9_Box_Step_2__c='2 - Medium/Extensive';
        acc.Owner=Testuser;
        acc.Business__c='Poland'; 
        acc.recordtypeid=recordtypeId;
        acc.Prospect_Validated__c=True;
        acc.Auto_Validate__c = true;
            acc.Account_Type__c='Standard';
        insert acc;   
        
      
         
        Account acc1 = new Account();
        acc1.Name='Duplicate';
        acc1.Legal_Name__c='KKKG'; //matching rule condition
        acc1.Type='Building';
       // acc1.Segment_Step_1__c='Mila';
      //  acc1.X9_Box_Step_2__c='2 - Medium/Extensive';
        
        acc1.Owner=Testuser;
        acc1.Business__c='Poland';
        acc1.recordtypeid=recordtypeId; 
        acc1.Prospect_Validated__c=True;
        acc1.Auto_Validate__c = true;
            acc1.Account_Type__c='Standard';
       
        Database.DMLOptions dml = new Database.DMLOptions();
        dml.DuplicateRuleHeader.AllowSave = true;
        
        Database.insert(acc1, dml);
       
        accountid = acc1.id;
       
        System.debug('AccountId Is : '+ accountid);
        
        
       DuplicateRule drule = new DuplicateRule();
       drule =[Select id from DuplicateRule where MasterLabel='Same account name'];
       
       DuplicateRecordSet ds= new DuplicateRecordSet();
       ds.DuplicateRuleId=drule.id;
       insert ds;
       
       System.debug('DuplicateRecordSet  inserted :'+ds);
       
       DuplicateRecordItem dr =new DuplicateRecordItem();
       dr.recordid=acc1.Id;
       try{
       dr.DuplicateRecordSetId=ds.Id;
       insert dr;}
       catch(exception ex){}
       
       
       
    }
    
    
  }
  static testMethod void testduplicateCheck1()
    {
     id accountid;   
        Id recordtypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Standard').getRecordTypeId();
        Id recordtypeIdConsumer = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Consumer').getRecordTypeId();
        Profile p = [SELECT Id FROM Profile WHERE Name='Sales Professional - Poland']; 
        User Testuser = new User(Alias = 'standt', Email='standarduser@testorg.com',Business_Unit__c='Poland',CAN_Business__c='CPN', Country_Code__c='AF', DataStewardDL__c='shalu.jadoun@cognizant.com',EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, TimeZoneSidKey='America/Los_Angeles', UserName='standarduser@testorg.com.c360');
        insert Testuser;
        
        System.runAs(Testuser){
        test.startTest();
        Account acc = new Account();
        acc.Name='Test_Account';
        acc.Legal_Name__c='KKKG'; //matching rule condition
        acc.Type='Building';
     //   acc.Segment_Step_1__c='Mila';
     //   acc.X9_Box_Step_2__c='2 - Medium/Extensive';
        acc.Owner=Testuser;
        acc.Business__c='Poland'; 
        acc.recordtypeid=recordtypeId;
        acc.Prospect_Validated__c=True;
        acc.Auto_Validate__c = true;
            acc.Account_Type__c='Standard';
        insert acc;   
        
      
         
        Account acc1 = new Account();
        acc1.Name='Test_Account';
        acc1.Legal_Name__c='KKKG'; //matching rule condition
        acc1.Type='Building';
       // acc1.Segment_Step_1__c='Mila';
      //  acc1.X9_Box_Step_2__c='2 - Medium/Extensive';
        
        acc1.Owner=Testuser;
        acc1.Business__c='Poland';
        acc1.recordtypeid=recordtypeIdConsumer; 
        acc1.Prospect_Validated__c=True;
        acc1.Auto_Validate__c = true;
            acc1.Account_Type__c='Consumer';
       
        Database.DMLOptions dml = new Database.DMLOptions();
        dml.DuplicateRuleHeader.AllowSave = true;
        
        Database.insert(acc1, dml);
       
        accountid = acc1.id;
       
        System.debug('AccountId Is : '+ accountid);
        
        
       DuplicateRule drule = new DuplicateRule();
       drule =[Select id from DuplicateRule where MasterLabel='Same account name'];
       
       DuplicateRecordSet ds= new DuplicateRecordSet();
       ds.DuplicateRuleId=drule.id;
       insert ds;
       
       System.debug('DuplicateRecordSet  inserted :'+ds);
       
       DuplicateRecordItem dr =new DuplicateRecordItem();
       dr.recordid=acc1.Id;
       try{
       dr.DuplicateRecordSetId=ds.Id;
       insert dr;}
       catch(exception ex){}
       
       
       
    }
    
    
  }
  
}