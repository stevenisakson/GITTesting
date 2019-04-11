@istest
public  class DCRRouteLookUpCtrl_Test {
    
    public static testmethod void fetchLookUpValuesTest(){
        target__c t = new target__c();    
        t.Name = 'DAIRY:BARASAT HQ'; 
        t.Employee_Link_To__c=UserInfo.getUserId();
        
        insert t;
        Id routeRecordType = Schema.SObjectType.Route__c.getRecordTypeInfosByName().get('Route').getRecordTypeId(); 
        Route__c rt=new Route__c(Name='R001',recordTypeId=routeRecordType,	Territory__c=t.Id);
        insert rt;
        DCRRouteLookUpCtrl.fetchRouteList('', 'Route__c',t.Id);
        
    }
    
    public static testmethod void fetchRouteCustomersTest(){
        target__c t = new target__c();    
        t.Name = 'DAIRY:BARASAT HQ'; 
        t.Employee_Link_To__c=UserInfo.getUserId();
        
        insert t;
        Account accnew=new Account(Name='Cust1',Status__c='Approved');
        insert accnew;
        Id routeRecordType = Schema.SObjectType.Route__c.getRecordTypeInfosByName().get('Route').getRecordTypeId(); 
        Route__c rt=new Route__c(Name='R001',recordTypeId=routeRecordType,	Territory__c=t.Id);
        insert rt;
        routeRecordType = Schema.SObjectType.Route__c.getRecordTypeInfosByName().get('Route Customer').getRecordTypeId();
        Route__c rtcust=new Route__c(Name='R0012',recordTypeId=routeRecordType,Related_Route__c=rt.Id,Account__c=accnew.Id);
        insert rtcust;
        DCRRouteLookUpCtrl.fetchRouteCustomers('', 'Route_Customer__c', rt.Id);
        
    }
    
    public static testmethod void fetchContactListTest(){
        
        Account accnew=new Account(Name='testName');
        insert accnew;
        Contact childCon=new Contact(LastName='Cust',AccountId=accnew.Id);
        insert childCon;
        DCRRouteLookUpCtrl.fetchContactList(accnew.id,'Cust');
         DCRRouteLookUpCtrl.fetchLookUpValues('Cust','accnew');
    }
    
  
    
    

}