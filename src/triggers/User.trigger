trigger User on User (after delete, after insert, after undelete, after update, before delete, before insert, before update) {
    Trigger_Settings__c triggerControl = Trigger_Settings__c.getInstance(userinfo.getProfileId());
     if(triggerControl.User__c)
     { 
        UserTriggerHandler handler = new UserTriggerHandler(Trigger.isExecuting, Trigger.size);
    
        if(Trigger.isInsert && Trigger.isAfter){
        handler.insertStandardUserintoUserObj(Trigger.new,Trigger.old,Trigger.oldMap,Trigger.newMap,trigger.isInsert, trigger.isUpdate);        
        }
        if(Trigger.isUpdate && Trigger.isAfter){
        handler.insertStandardUserintoUserObj(Trigger.new,Trigger.old,Trigger.oldMap,Trigger.newMap,trigger.isInsert, trigger.isUpdate);       
        }
     }
}