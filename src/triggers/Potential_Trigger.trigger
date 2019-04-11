trigger Potential_Trigger on Potential__c (before insert, before update, after insert,after update,before delete) {
    
    if(Trigger.isBefore && (Trigger.isInsert || Trigger.isUpdate)){
        Potential_TriggerHandler.populateAccountId(Trigger.new);
        Potential_TriggerHandler.doCalculationsBasedOnEstimationType(Trigger.new);
    }
    
    if(Trigger.isAfter && (Trigger.isInsert || Trigger.isUpdate)){
        Potential_TriggerHandler.Calshare(Trigger.New);
         Potential_TriggerHandler.DuplicateRulePotential(Trigger.new);
    }
    
    if(Trigger.isBefore && Trigger.isDelete)
        Potential_TriggerHandler.RelatedPotentialDelete(Trigger.old);
}