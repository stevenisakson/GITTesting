/**
 * Helper class for the Contact Trigger. This class takes care of
 * CRUD operations on the Contact object.
 * 
 * @author		Jerome Liwanag, Cloud Sherpas
 * @createddate	20-Jan-2016
 */ 
public class ContactTriggerHandler {
    
    public static void onBeforeInsert(List<Contact> newContactList){
        populateContactFields(newContactList);   
    }
    
    public static void populateContactFields(List<Contact> contactList){
        Set<Id> ownerIds = new Set<Id>();
        Map<Id,User> userMap = new Map<Id,User>();
        
        for(Contact contactLoop : contactList){
            ownerIds.add(contactLoop.OwnerId);
        }
        
        for(User userLoop : [SELECT Id,Business_Unit__c,Country_Code__c,Primary_Contact_Language__c FROM User Where Id IN :ownerIds]){
            userMap.put(userLoop.Id, userLoop);
        }
        
        for(Contact contactLoop : contactList){
            if(userMap.containsKey(contactLoop.OwnerId)){
                contactLoop.Business_Unit__c = userMap.get(contactLoop.OwnerId).Business_Unit__c;
                contactLoop.MailingCountryCode = userMap.get(contactLoop.OwnerId).Country_Code__c;
                contactLoop.Primary_Language__c = userMap.get(contactLoop.OwnerId).Primary_Contact_Language__c;
                contactLoop.OtherCountryCode = userMap.get(contactLoop.OwnerId).Country_Code__c;
            }
        }
    }
}