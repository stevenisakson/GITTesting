@istest
public class Cres_RouteCustomerComponentctrl_Test{


  public static testmethod void method1routecust() 
    {  
        
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        
        user u = new user(alias = 'stant5', Email='standarduser123@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing1', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id,User_Type__c='VSA', 
                          TimeZoneSidKey='America/Los_Angeles', UserName='standarduser1235@testorg.com');  
        insert u; 
        
        Userterritory2Association ub = new Userterritory2Association(); 
        ub.UserId = u.id;  
        
        ub.Territory2Id = [select id from territory2 where Name ='AH-DAIRY:BARASAT HQ' limit 1].id;
        insert ub; 
        
       
        
        System.runAs(u){
            target__c t = new target__c();    
            t.Name = 'test1'; 
            t.Territory_Id__c =[select id from territory2 where Name ='AH-DAIRY:BARASAT HQ' limit 1].id; 
            t.Employee_Link_To__c = u.id; 
            
            
            insert t;
            
            Id RecordTypeIdroutecust1 = Schema.SObjectType.Route__c.getRecordTypeInfosByName().get('Route').getRecordTypeId();  
          
            Route__c ro=new Route__c();
            ro.name='test';
            ro.Territory__c=t.id;
            ro.recordtypeid=RecordTypeIdroutecust1;
            insert ro;
            
             Id RecordTypeIdroutecust = Schema.SObjectType.Route__c.getRecordTypeInfosByName().get('Route Customer').getRecordTypeId();  
          
            Route__c r=new Route__c();
            r.name='test';
            r.Territory__c=t.id;
            r.Related_Route__c=ro.id;
            r.recordtypeid=RecordTypeIdroutecust;
            insert r;
            
            Cres_RouteCustomerComponentctrl.getCustomerList(r.id);
            Cres_RouteCustomerComponentctrl.deleteRecord(r.id);
        }
        }
        public static testmethod void method1route() 
    {  
        
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        
        user u = new user(alias = 'stant4', Email='standarduser123@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing1', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id,User_Type__c='VSA', 
                          TimeZoneSidKey='America/Los_Angeles', UserName='standarduser1234@testorg.com');  
        insert u; 
        
        Userterritory2Association ub = new Userterritory2Association(); 
        ub.UserId = u.id;  
        
        ub.Territory2Id = [select id from territory2 where Name ='AH-DAIRY:BARASAT HQ' limit 1].id;
        insert ub; 
        
       
        
        System.runAs(u){
            target__c t = new target__c();    
            t.Name = 'test1'; 
            t.Territory_Id__c =[select id from territory2 where Name ='AH-DAIRY:BARASAT HQ' limit 1].id; 
            t.Employee_Link_To__c = u.id; 
            
            
            insert t;
            
             Id RecordTypeIdroutecust = Schema.SObjectType.Route__c.getRecordTypeInfosByName().get('Route').getRecordTypeId();  
          
            Route__c r=new Route__c();
            r.name='test';
            r.Territory__c=t.id;
            r.recordtypeid=RecordTypeIdroutecust;
            insert r;
            
            Cres_RouteCustomerComponentctrl.getroutedetails(r.id);
        }
        }



}