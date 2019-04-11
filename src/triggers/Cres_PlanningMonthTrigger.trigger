trigger Cres_PlanningMonthTrigger on Planning_Month__c (before update,before insert,after insert,after delete, before delete) {

    private static Boolean ranOnce=false;
    if(Trigger.isUpdate && Trigger.isBefore){
        Cres_PlanMonthTriggerHelper.validateApprovers(Trigger.oldMap,Trigger.newMap);
        Cres_PlanMonthTriggerHelper.populateUniqueKeysOnUpdate(Trigger.new,Trigger.oldMap);
       /* Cres_PlanMonthTriggerHelper.validateDuplicateOnUpdate(Trigger.new,Trigger.oldMap);*/
    }
    if(Trigger.isInsert && Trigger.isBefore){
      //  Cres_PlanMonthTriggerHelper.validateDuplicateOnInsert(Trigger.new);
        Cres_PlanMonthTriggerHelper.validateTerritorySelection(Trigger.new);
        Cres_PlanMonthTriggerHelper.populatePlanMonthOnInsert(Trigger.new);
        Cres_PlanMonthTriggerHelper.populateUniqueKeysOnInsert(Trigger.new);
    }
  
    if(Trigger.isInsert && Trigger.isAfter){
      Cres_PlanMonthTriggerHelper.RollupPlandayforMonth(Trigger.new,false);
      
    }
    if(Trigger.isInsert && Trigger.isAfter && !ranOnce){
        Cres_PlanMonthTriggerHelper.createHolidayRecordsOnInsert(Trigger.new);
        Cres_PlanMonthTriggerHelper.updatePlanMonthStatus(Trigger.new);
        ranOnce=true;
    }
    if(Trigger.isBefore && Trigger.isDelete){
      Cres_PlanMonthTriggerHelper.RollupPlandayforMonth(Trigger.old, true);
    }
  
}