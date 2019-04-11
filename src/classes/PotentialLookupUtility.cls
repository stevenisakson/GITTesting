public with sharing class PotentialLookupUtility {
 
    @auraenabled
    public static Response getCompetitors(String searchkeyword){
        Boolean hasError=false;
        String errorMsg;
        List<Account> accList;
        String searchKey = searchKeyWord + '%';
        try{
        Id recTypeId=getRecordTypeIDByDevName('Competitor','Account');
        accList=[select Name from Account where recordTypeId=:recTypeId and Name LIKE: searchKey order by createdDate DESC limit 25];
        }catch(Exception e){
            hasError=true;
           // errorMsg=e.getMessage();
        }
        if(hasError){
            return new Response(false,'Failed',null);
        }else{
            return new Response(true,'Success',accList); 
        }
    }
     @auraenabled
    public static Response getSalesPersons(String accName,String searchkeyword){
        Boolean hasError=false;
        String errorMsg;
        List<Contact> contactList;
        String searchKey = searchKeyWord + '%';
        try{
        Id recTypeId=getRecordTypeIDByDevName('Competitor','Account');
        contactList=[select Name from Contact where Account.Name=:accName and Name LIKE: searchKey order by createdDate DESC limit 25];
        }catch(Exception e){
            hasError=true;
           // errorMsg=e.getMessage();
        }
        if(hasError){
            return new Response(false,'Failed',null);
        }else{
            return new Response(true,'Success',contactList); 
        }
    }
    static Id getRecordTypeIDByDevName(String devName,String sObjectName){
        return [select id from RecordType where sObjectType=:sObjectName and DeveloperName=:devName].Id;
    }
   /*  @AuraEnabled
    public static List < sObject > fetchLookUpValues(String searchKeyWord, String ObjectName) {
        system.debug('ObjectName-->' + ObjectName);
        String searchKey = searchKeyWord + '%';
        
       
        List <sObject > returnList = new List <sObject > ();
      
        // Create a Dynamic SOQL Query For Fetch Record List with LIMIT 5   
        String sQuery =  'select id, Name from ' +ObjectName + ' where Name LIKE: searchKey order by createdDate DESC limit 5';
        
     
        List < sObject > lstOfRecords = Database.query(sQuery);
        
       
        return lstOfRecords;
    }*/
}