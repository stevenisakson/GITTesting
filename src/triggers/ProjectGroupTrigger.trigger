/*
    Author              : Loven Reyes
    Email               : loven.reyes@accenture.com
    Company             : Accenture
    Date Created        : 11-OCT-2016
    Description         : Trigger for Project Group to get the Frontline Marketing Coordinator from Account
    Modified By         : -
    Modified Date       : -
*/

trigger ProjectGroupTrigger on Project_Group__c (before insert, after insert, before update, after update) 
{
    Trigger_Settings__c triggerControl = Trigger_Settings__c.getInstance(userinfo.getProfileId());

    ACN_ProjectGroupTriggerHandler handler = new ACN_ProjectGroupTriggerHandler();
    Static Boolean Recurssionflag = true;
    
    if(triggerControl.Project_Group__c){
    
     if(Trigger.isBefore && Recurssionflag)
     {
        //if(trigger.isInsert || trigger.isUpdate)
        if(trigger.isInsert)        
        {
            //handler.beforeInsert(trigger.new);
            handler.projectOwnerUpdate(Trigger.new,false);
            Recurssionflag = false;
        }
    }
    
    }
// Added by Poonam to Update Project Owner 
    
    if(triggerControl.Project_Group__c){
 
    if(Trigger.isAfter && Recurssionflag)
     {
        if(trigger.isInsert)
        {
           //handler.projectOwnerUpdate(trigger.new,trigger.oldMap);
        }
        
        if(trigger.isUpdate)
        
        {
        list <Project_Group__c> prgList = new list<Project_Group__c>();
            for(Project_Group__c pg: trigger.newmap.values()){
                if(pg.Assigned_To__c != trigger.oldmap.get(pg.id).Assigned_To__c){
                    prgList.add(pg);
                }
            }
            
            //handler.projectOwnerUpdate(prgList,false); 
        } 
         Recurssionflag = false; 
    }
    
   
   } 
    
    
     
}