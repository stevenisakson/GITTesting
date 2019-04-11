/*********************************************************************
Name    : RequestAllTrigger
Date    : 30 July 2015
Description: Trigger for Request__c object
             after insert - if type = Prospect Conversion, add approval process on account
History : David Ragsdale - created
*********************************************************************/
trigger RequestTrigger on Request__c (after insert, after update,after delete) 
{    
    Trigger_Settings__c triggerControl = Trigger_Settings__c.getInstance(userinfo.getProfileId());
    RequestTriggerHandler handler = new RequestTriggerHandler();
    //After Insert
    if (trigger.isAfter)
    {         
        if(trigger.isInsert){
            if(triggerControl.Request__c){
                handler.onAfterInsert(Trigger.new);   
            }
        }
        if(trigger.isUpdate){
            if(triggerControl.Request__c){
                handler.onAfterUpdate(Trigger.new, Trigger.oldMap);
                /*list<Request__c> reqstatusupdlst = new list<Request__c>();
                   for(Request__c r:trigger.new){
                if(r.Status__c != trigger.oldmap.get(r.id).Status__c){
                    reqstatusupdlst.add(r);
                }                
            }
            if(!reqstatusupdlst.isEmpty()){
               handler.acctTeamMemberDelete(trigger.new); 
            }*/
     
            }
        }
        
        if(trigger.isDelete){
            if(triggerControl.Request__c){
                handler.onAfterDelete(Trigger.old);    
            }
        }

    }
}