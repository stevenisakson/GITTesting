public with sharing class DCRRouteLookUpCtrl {
/*@AuraEnabled
    public static List <sObject > fetchLookUpValues(String searchKeyWord, String ObjectName) {
        system.debug('ObjectName-->' + ObjectName);
        String searchKey = searchKeyWord + '%';
        String loggedInUserId = UserInfo.getUserId();
        
        List < sObject > returnList = new List < sObject > ();

        String sQuery =  'select id, Name from ' +ObjectName + ' where Name LIKE: searchKey order by createdDate DESC limit 6';
        
        //String sQuery =  'select id, Name from ' +ObjectName + ' where Name LIKE: searchKey and Status__c=\'Approved\''+' order by createdDate DESC limit 6';
        List < sObject > lstOfRecords = Database.query(sQuery);
        
        for (sObject obj: lstOfRecords){
            returnList.add(obj);
        }
        return returnList;
    }*/
     @AuraEnabled
     public static List <sObject > fetchRouteList(String searchKeyWord, String ObjectName,String territoryId) {
         
         Id RouteRecTypeId=Schema.SObjectType.Route__c.getRecordTypeInfosByName().get('Route').getRecordTypeId();
         String searchKey ='';
         searchKey = '%'+searchKeyWord + '%';
         List < sObject > returnList = new List < sObject > ();
         String standardTerritoryId='';
         List<Target__c> targetList=[select Territory_Id__c from Target__c where id=:territoryId];
         if(targetList.size()>0){
             standardTerritoryId=targetList[0].Territory_Id__c;
         } 
         String shortName;
         List<String> splitName=new List<String>();
         /*Make sure if the logged in user has selected a valid Territory*/
         if(standardTerritoryId!=''){
            
             List < sObject > lstOfRecords = [select id,Name from Route__c where Name Like:searchKey /*and Standard_Territory_Id__c =: standardTerritoryId*/ and Status__c='Approved'
                                              and recordTypeId=:RouteRecTypeId 
                                              and ( Territory__r.Territory_Id__c =: standardTerritoryId 
                                                   OR Territory__r.Parent_TerritoryId__c =: standardTerritoryId 
                                                   OR Territory__r.Grand_Parent_TerritoryId__c =: standardTerritoryId) 
                                              order by createdDate DESC];
             for (sObject obj: lstOfRecords){
                 shortName=(String)obj.get('Name');
                 splitName=shortName.split('\\:');
                 System.debug('Splited'+splitName);
                 System.debug('SplitedSize'+splitName.size());
                 if(splitName.size()>=2){
                     shortName=splitName[1];
                 }
                     
                 obj.put('Name',shortName);
                 shortName='';
                 returnList.add(obj);
             }
         }
       
        return returnList;
    }
    @AuraEnabled
     public static List <sObject > fetchRouteCustomers(String searchKeyWord, String ObjectName,String RouteId) {
        system.debug('ObjectName-->' + ObjectName);
        String searchKey = searchKeyWord + '%';
        String loggedInUserId = UserInfo.getUserId();
        
        List < sObject > returnList = new List < sObject > ();

        List < Route__c > lstOfRecords = [select id, Account__c,Name,Account__r.Name from Route__c where Account__r.Name LIKE: searchKey and Related_Route__c=:RouteId order by createdDate DESC limit 6];
       
        System.debug(lstOfRecords);
        sObject snewObj;
        for (Route__c obj: lstOfRecords){
            snewObj = Schema.getGlobalDescribe().get('Account').newSObject() ;
            snewObj.put('Id',obj.Account__c);
            snewObj.put('Name',obj.Account__r.Name);
            returnList.add(snewObj);
        }
        return returnList;
    }
     @AuraEnabled
     public static List <sObject > fetchContactList(String accId,String searchkeyword) {
       
        String searchKey = searchkeyword + '%';
        String loggedInUserId = UserInfo.getUserId();
        
        List < sObject > returnList = new List < sObject > ();

        String sQuery =  'select id, Name from Contact where Name LIKE: searchKey and AccountId=:accId order by createdDate DESC limit 6';
        
        //String sQuery =  'select id, Name from ' +ObjectName + ' where Name LIKE: searchKey and Status__c=\'Approved\''+' order by createdDate DESC limit 6';
        List < sObject > lstOfRecords = Database.query(sQuery);
        
        for (sObject obj: lstOfRecords){
            returnList.add(obj);
        }
        return returnList;
    }
     @AuraEnabled
    public static List <sObject > fetchLookUpValues(String searchKeyWord, String ObjectName) {
        system.debug('ObjectName-->' + ObjectName);
        String searchKey = searchKeyWord+'%';
        
        String sQuery = Null;
        List < sObject > lstOfRecords = new List < sObject > ();
        List < sObject > returnList = new List < sObject > ();
        
        lstOfRecords = [select id, Name  from user  where Name Like: searchKey limit 6];
        
        for (sObject obj: lstOfRecords){
            returnList.add(obj);
        }
        return returnList;
    }

}