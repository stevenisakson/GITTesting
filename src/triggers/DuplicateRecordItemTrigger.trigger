trigger DuplicateRecordItemTrigger on DuplicateRecordItem (after insert){
   
   Trigger_Settings__c triggerControl = Trigger_Settings__c.getInstance(userinfo.getProfileId());
    //Handler Initialized
   DuplicateRecordItemTriggerHandler handler=new DuplicateRecordItemTriggerHandler();
   
   //Invoke method after insert
     if(trigger.isAfter)
    {
         if(triggerControl.DuplicateRecordItem__c)
           {  
               if(trigger.isinsert)
               {
                   handler.duplicateCheck(Trigger.newMap);
               }
           }
   }
}