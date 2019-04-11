/*********************************************************************
Name    : RouteTrigger 
Date    : 29 August 2018
Description: Trigger for Route__c object,to handle the approval process.
History : Created: Poonam Yadav
*********************************************************************/
trigger RouteTrigger on Route__c (before insert,before update,after insert,after update,after delete,before delete) {
  
  Trigger_Settings__c triggerControl = Trigger_Settings__c.getInstance(userinfo.getProfileId());
  RouteTriggerhandler.RouteUserApproval handler=new RouteTriggerhandler.RouteUserApproval();
  RouteTriggerhandler handler1 = new RouteTriggerhandler(); 
  
   if(triggerControl.Route__c){
       if(trigger.isBefore){
           
           if(trigger.isInsert||trigger.isUpdate){
               
                handler.submitForApproval(Trigger.new);
                
                             
      
       }
                if((trigger.isInsert||trigger.isUpdate) && !RouteTriggerhandler.ranOnce){ 
                    handler1.stampAccountClassicification(trigger.new);
       }
   }
   
   if(trigger.isAfter){
       
       if(trigger.isInsert || trigger.isUpdate){
           if(!RouteTriggerhandler.ranRouteApprovalonce){
           handler.RouteApprovalProcess(Trigger.new);
           } 
       }
   }
   if( Trigger.isAfter){
       if(Trigger.isInsert){
           RouteCustRollUp.RollupRouteCustforRoute(Trigger.new);
       }
       if(Trigger.isUpdate && !RouteCustRollUp.ranOnce ){
           RouteCustRollUp.UpdateRollupRouteCustforRoute(Trigger.newMap,Trigger.oldmap);
          // RouteCustRollUp.ranOnce=true;
           
       }
    }
   if(Trigger.isAfter && Trigger.isDelete){
      RouteCustRollUp.DelRollupRouteCustforRoute(Trigger.Old);
    }
      /* Delete Option we removed form pagelayout
      
       if(Trigger.isBefore && Trigger.isDelete){
           handler1.beforedeletecheckstatus(Trigger.Old);
       }
      */
}

    

}