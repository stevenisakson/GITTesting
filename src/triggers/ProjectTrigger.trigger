/*
    Author              : Erick
    Email               : erick.carle.bower@accenture.com
    Company             : Accenture
    Date Created        : 04-OCT-2016
    Description         : Trigger for Project(Order Line Item) Object/ Story No.64
    Modified By         : -
    Modified Date       : -
*/


trigger ProjectTrigger on Project__c (before insert, after insert, before update, after update) {

   Trigger_Settings__c triggerControl = Trigger_Settings__c.getInstance(userinfo.getProfileId());
    Static Boolean Recurssionflag = true;
    ACN_ProjectTriggerHandler myHandler = new ACN_ProjectTriggerHandler();
    
    if(triggerControl.Project__c){
    if(Trigger.isBefore && Recurssionflag){
        if(trigger.isInsert){
            myHandler.beforeInsert(trigger.new);
            Recurssionflag = false;
          // myHandler.OwnerUpdate(Trigger.new);
        } else if(Trigger.isUpdate && Recurssionflag ){
            //myHandler.OwnerUpdate(Trigger.new,true);
             //myHandler.updateProjectGroupStatus(trigger.new, true);
            Recurssionflag = false; 
            
        } 
        
        
    }
    }
    
     if(triggerControl.Project__c){
        if(Trigger.isAfter && Recurssionflag)
        {
        if(trigger.isInsert){
            myHandler.afterInsert(trigger.new);
            myHandler.updateProjectGroupStatus(trigger.new);
            Recurssionflag = false;
        }
        if(trigger.isUpdate){
            list<Project__c> prjstatusupdlst = new list<Project__c>();
            for(Project__c p:trigger.new){
                if(p.status__c != trigger.oldmap.get(p.id).status__c){
                    prjstatusupdlst.add(p);
                }                
            }
            if(!prjstatusupdlst.isEmpty()){
               myHandler.updateProjectGroupStatus(trigger.new); 
            }
        }
        
    }
    }
}