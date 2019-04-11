trigger TaskTrigger on Task (before insert) {
Trigger_Settings__c triggerControl = Trigger_Settings__c.getInstance(userinfo.getProfileId());
PreDefaultValues predef = new PreDefaultValues();
     if(triggerControl.Event__c){
      if(trigger.isBefore)
      {
        if(trigger.isInsert)
        {
           predef.setTaskFlagValues(trigger.new); 
           /*Populate Business Unit*/
            Cres_BU_PopulateHelper.populateBU(Trigger.new);
        }
      }
    }
}