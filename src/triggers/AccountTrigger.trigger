trigger AccountTrigger on Account (after insert, after update, before insert,before update) {
    
    Trigger_Settings__c triggerControl = Trigger_Settings__c.getInstance(userinfo.getProfileId());
    AccountTriggerHandler handler = new AccountTriggerHandler();
    PreDefaultValues predef = new PreDefaultValues();
    
    //Before Insert
    if(trigger.isBefore)
    {
       if(trigger.isinsert)
       {
           if(triggerControl.Account__c)
           { 
               //PreDefaultValues class methods should be called first in sequence
               predef.setAccountFlagValues(trigger.new);
               //*************
               handler.onBeforeInsert(Trigger.New);
               handler.setAccountCurrency(trigger.new);
               
                handler.BusinessAutoUpdate(trigger.new);
               
           }
       }  
       
        if (trigger.isupdate){
            predef.setAccountRecordType(trigger.new);
           handler.suspendedAccountUpdate(Trigger.new);
           handler.BusinessAutoUpdate(trigger.new);
        }
     
    }
    
   //After Insert
    if (trigger.isAfter)
    {          
        if(trigger.isUpdate){
            if(triggerControl.Account__c){ 
                handler.onAfterUpdate(Trigger.new,Trigger.OldMap);
                handler.updateChildEvents(trigger.newMap,trigger.oldMap);    
            }
        }
        
        // update the custom last modified by and date @Ashok,4/29/17
        
            if((trigger.isInsert) || (Trigger.isUpdate))
            {
                   if(updation.isfutureupdate!=true)
                    {
                    set<id> ids=new set<id>();
                    for(Account a :Trigger.new)
                    {
                    ids.add(a.id);
                    system.debug('$$$$$$$$$$$'+ids);
                    }
                    
                    UpdateLastModified.proccedaccounts(ids);
                    }
            }
    }    
       
}