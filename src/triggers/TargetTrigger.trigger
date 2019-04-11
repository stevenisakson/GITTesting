trigger TargetTrigger on Target__c (before insert,before update,after insert,after update) {
    Trigger_Settings__c triggerControl = Trigger_Settings__c.getInstance(userinfo.getProfileId());
    TargetTriggerHandler handler = new TargetTriggerHandler();
    //Before event
    if(trigger.isBefore){
        if(trigger.isInsert){
            if(triggerControl.Target__c){
                handler.beforeInsert(trigger.new);
            }    
        } 
        if(trigger.isUpdate && TargetTriggerHandler.ranBeforeUpdtOnce==false){
            if(triggerControl.Target__c){
                handler.beforeUpdate(trigger.newMap,trigger.oldMap);
            }    
        } 
    }
    
    //After event
    if(trigger.isAfter){
        if(trigger.isInsert && triggerControl.Target__c){
            
                handler.stampTerritoryId(trigger.newMap);
             
        } 
        if(trigger.isUpdate && triggerControl.Target__c && TargetTriggerHandler.updateRanOnce==false){
            
          //  handler.stampTerritoryId(trigger.newMap); 
           handler.stampTerritoryIdUpdate(trigger.newMap,trigger.oldMap);
            
        }  
   }
}