/*
    @Author             : Loven Reyes (CloudSherpas)
    @Date Created       : 16-SEP-2015
    @Description        : Test class for AccountTriggerHandler
*/

@isTest
private class AccountTriggerHandlerTest {
    
    
    static testMethod void AccountTriggerHandler1()
    {
        User usr = [Select Id From User Where isActive=True and (NOT Name like '%Master%') and Profile.Name = 'Data Steward - Canada' and Business_Unit__c = 'Canada' Limit 1];
        
        ProfileSettingDataSteward__c pf=new ProfileSettingDataSteward__c();
        pf.Profile_ID__c ='2F00e21000000Hqnb';
        pf.ProfileName__c='Data Steward - Canada';
        pf.Name='Canada';
        insert pf;
        
        SuspendedAccountSettings__c susSettings = new SuspendedAccountSettings__c();
        susSettings.Account_Team_Delete__c = true;
        susSettings.Name = 'Canada';
        insert susSettings;
        
        System.runAs(usr){
            Account acc=new account();
            acc.name='AccountTriggerHandler1';
            acc.RecordTypeId = TestDataBuilder.getObjectRecordTypeId(Account.SObjectType,'Standard CFN Canada');
            acc.Account_Type__c='Standard';
            // acc.Customer_Status__c='Suspended';
            insert acc;
            system.debug('acc='+acc);
            try{
                acc.Customer_Status__c='Suspended';
                update acc;
                system.debug('acc='+acc);
            }
            catch(exception ex){
                system.debug('ex='+ex);
            }
           
        }
        
    }
    
     static testMethod void AccountTriggerHandler2()
    {
        
        Trigger_Settings__c t=new Trigger_Settings__c();
        t.Account__c=true;
        t.Name='test';
        insert t;  
        
        User usr = [Select Id From User Where isActive=True and Profile.Name = 'Sales Professional - Canada' and Business_Unit__c = 'Canada' Limit 1];
       
        System.runAs(usr){
            Account acc=new account();
            acc.name='AccountTriggerHandler2';
            acc.RecordTypeId = TestDataBuilder.getObjectRecordTypeId(Account.SObjectType,'Standard CFN Canada');
            acc.Account_Type__c='Standard';
            acc.Is_Duplicate__c=false;
            acc.Prospect_Validated__c=false;
            acc.Auto_Validate__c=true;
            
            insert acc;
            
            list<account> acclist=new list<account>();
            acclist.add(acc);
            system.debug('acclist='+acclist);
           
        }
        
    }
    
     static testMethod void AccountTriggerHandler3()
    {
        
        Trigger_Settings__c t=new Trigger_Settings__c();
        t.Account__c=true;
        t.Name='test';
        insert t;  
        
        User usr = [Select Id From User Where isActive=True and Profile.Name = 'Sales Professional - Canada' and Business_Unit__c = 'Canada' Limit 1];
       
        System.runAs(usr){
            Account acc=new account();
            acc.name='AccountTriggerHandler3';
            acc.RecordTypeId = TestDataBuilder.getObjectRecordTypeId(Account.SObjectType,'Consumer CFN Canada');
            acc.Account_Type__c='Consumer';
            acc.Is_Duplicate__c=false;
            acc.Prospect_Validated__c=false;
            acc.Auto_Validate__c=true;
            acc.Source_System__c = 'LM';
            
            insert acc;
            
            list<account> acclist=new list<account>();
            acclist.add(acc);
            system.debug('acclist='+acclist);
           
        }
        
    }
    
    static testMethod void AccountTriggerHandler4()
    {
         
        Trigger_Settings__c t=new Trigger_Settings__c();
        t.Account__c=true;
        t.Name='test';
        insert t;          
        User usr = [Select Id From User Where isActive=True and Profile.Name = 'Sales Professional - Canada' and Business_Unit__c = 'Canada' Limit 1];
        
              
        System.runAs(usr){
            Account acc=new account();
            acc.name='AccountTriggerHandler4';
            acc.RecordTypeId = TestDataBuilder.getObjectRecordTypeId(Account.SObjectType,'Standard CFN Canada');
            acc.Account_Type__c='Standard';
            acc.Is_Duplicate__c=false;
            acc.Prospect_Validated__c=false;
            acc.Auto_Validate__c=false;
            acc.Source_System__c = 'LM';
            acc.Approval_Status__c='Draft';
            
            insert acc;
            system.debug('acclist******='+acc);
            
            try{
                acc.Approval_Status__c='Approved';
                acc.Request_Approved__c=true;
                update acc;
            }
            catch(exception ex){
                system.debug('ex='+ex);
            }
            
         
        }
        
    }
    
    static testMethod void AccountTriggerHandler5()
    {
         
        Trigger_Settings__c t=new Trigger_Settings__c();
        t.Account__c=true;
        t.Name='test';
        insert t;          
        User usr = [Select Id From User Where isActive=True and Profile.Name = 'Sales Professional - Canada' and Business_Unit__c = 'Canada' Limit 1];
        
              
        System.runAs(usr){
            Account acc=new account();
            acc.name='AccountTriggerHandler5';
            acc.RecordTypeId = TestDataBuilder.getObjectRecordTypeId(Account.SObjectType,'Standard CFN Canada');
            acc.Account_Type__c='Standard';
            acc.Is_Duplicate__c=false;
            acc.Prospect_Validated__c=false;
            acc.Auto_Validate__c=false;
            acc.Source_System__c = 'LM';
            acc.Approval_Status__c='Draft';
            
            insert acc;
            system.debug('acclist******='+acc);
            
            try{
                acc.Approval_Status__c='Recalled';
                acc.Request_Approved__c=false;
                update acc;
            }
            catch(exception ex){
                system.debug('ex='+ex);
            }
            
         
        }
        
    }
    
    static testMethod void AccountTriggerHandler6()
    {
         
        Trigger_Settings__c t=new Trigger_Settings__c();
        t.Account__c=true;
        t.Name='test';
        insert t;          
        User usr = [Select Id From User Where isActive=True and Profile.Name = 'Sales Professional - Canada' and Business_Unit__c = 'Canada' Limit 1];
        
              
        System.runAs(usr){
            Account acc=new account();
            acc.name='AccountTriggerHandler6';
            acc.RecordTypeId = TestDataBuilder.getObjectRecordTypeId(Account.SObjectType,'Standard CFN Canada');
            acc.Account_Type__c='Standard';
            acc.Is_Duplicate__c=false;
            acc.Prospect_Validated__c=false;
            acc.Auto_Validate__c=false;
            acc.Source_System__c = 'LM';
            acc.Approval_Status__c='Draft';
            
            insert acc;
            system.debug('acclist******='+acc);
            
            try{
                acc.Approval_Status__c='Rejected';
                acc.Request_Approved__c=false;
                update acc;
            }
            catch(exception ex){
                system.debug('ex='+ex);
            }
            
         
        }
        
    }
    
     
    
}