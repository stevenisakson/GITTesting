/*********************************************************************
Name    : SetOpportunityTeam Trigger
Date    : 28 August 2015
Description: Trigger for Opportunity object
             after insert - set opportunity Team members
History : Jed canlas - created a handler
*********************************************************************/
trigger OpportunityTrigger on Opportunity (before insert,after insert) { 
    
    Trigger_Settings__c triggerControl = Trigger_Settings__c.getInstance(userinfo.getProfileId());
    OpportunityTriggerHandler handler = new OpportunityTriggerHandler();
    PreDefaultValues predef = new PreDefaultValues();
    if(trigger.isAfter){
        if(trigger.isInsert){
            if(triggerControl.Opportunity__c){
                handler.onAfterInsert(trigger.new);
                
            }
        }
    }
    
    if(trigger.isBefore)
    {
        if(trigger.isInsert){
            predef.setOpportunityFlagValues(trigger.new);
            handler.setOpportunityCurrency(trigger.new); 
            /*Populate Business Unit*/
            Cres_BU_PopulateHelper.populateBU(Trigger.new);
        }
    }
   


}