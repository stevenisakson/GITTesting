trigger DCRTrigger on DCR_Day__c (after insert,after update,before insert,before Update) {
  Trigger_Settings__c triggerControl = Trigger_Settings__c.getInstance(userinfo.getProfileId());
  DCRTriggerHaldler handler = new DCRTriggerHaldler();
if(triggerControl.DCRDay__c){  
  if(trigger.isAfter)
  {    
      if(trigger.isInsert){
          handler.afterInsert(trigger.newmap);
      } 
      if(trigger.isUpdate){
          handler.afterUpdate(trigger.newmap,trigger.oldmap);
      }
  }
    if(trigger.isBefore){
        if(trigger.isInsert){
            handler.beforeInsert(trigger.new);
        }
        if(trigger.isUpdate){
            handler.beforeUpdate(trigger.new);
        }
    } 
}
}