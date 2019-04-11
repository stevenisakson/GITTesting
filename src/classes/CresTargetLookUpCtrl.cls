public with sharing class CresTargetLookUpCtrl {
@AuraEnabled
    public static List <sObject > fetchLookUpValues(String searchKeyWord, String ObjectName) {
        system.debug('ObjectName-->' + ObjectName);
        String searchKey = searchKeyWord+'%';

        String sQuery = Null;
        List < sObject > lstOfRecords = new List < sObject > ();
        List < sObject > returnList = new List < sObject > ();

        lstOfRecords = [select id, Name, TerrEmpName__c,Employee_Link_To__c from Target__c where Name Like: searchKey order by createdDate DESC limit 6];

        for (sObject obj: lstOfRecords){
            returnList.add(obj);
        }
        return returnList;
    }
}