/*********************************************************************
Name    : updateAccountfromEvent Trigger
Date    : 28 August 2015
Description: Trigger for Event object 
             after insert/after update - update account
History : Jed canlas - created a handler
Modified: Loven Reyes - additional logic
*********************************************************************/
trigger EventTrigger on Event (before insert, before update, after insert, after update){
    
    Trigger_Settings__c triggerControl = Trigger_Settings__c.getInstance(userinfo.getProfileId());
    EventTriggerHandler handler = new EventTriggerHandler();
PreDefaultValues predef = new PreDefaultValues();
    if(trigger.isBefore){
        if(trigger.isInsert){
            if(triggerControl.Event__c){
                predef.setEventFlagValues(trigger.new);
                handler.onBeforeInsert(trigger.new); 
                  //Added by Tumish Tak: Stamp Account fields value on event record if Related Object is Account
                handler.stampAccountfields(trigger.new); 
               
            }
        } 
        if(trigger.isUpdate){
            if(triggerControl.Event__c){
                handler.onBeforeUpdate(trigger.new);
                  //Added by Tumish Tak: Stamp Account fields value on event record if Related Object is Account
                handler.stampAccountfields(trigger.new); 
               
            }
        }
    }

    if(trigger.isAfter){
        if(trigger.isInsert){
                if(triggerControl.Event__c){
                handler.onAfterInsert(trigger.new);  
            }
            
        } 
        if(trigger.isUpdate){
            if(triggerControl.Event__c){
                handler.onAfterUpdate(trigger.new); 
            }
           
        }
    }
    if(trigger.isInsert && trigger.isBefore){
        /*Populate Business Unit for the Event Record*/
        Cres_BU_PopulateHelper.populateBU(Trigger.new);
    }
}