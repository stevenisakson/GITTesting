public class customLookUpController {
 @AuraEnabled
    public static List < sObject > fetchLookUpValues(String searchKeyWord) {
        //system.debug('ObjectName-->' + ObjectName);
        String searchKey = searchKeyWord + '%';
       
        List < sObject > returnList = new List < sObject > ();
      
        // Create a Dynamic SOQL Query For Fetch Record List with LIMIT 5   
        String sQuery =  'select id, Name from user where Name LIKE: searchKey and IsActive=true limit 5';
        List < sObject > lstOfRecords = Database.query(sQuery);
        
        for (sObject obj: lstOfRecords) {
            returnList.add(obj);
        }
        return returnList;
    }
}