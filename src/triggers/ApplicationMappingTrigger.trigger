trigger ApplicationMappingTrigger on Application_Mapping__c (after insert, after update, before delete, after delete)
{
     
    list<Account> accList = new list<Account>();
    Set<Account> accSet = new set<Account>();
    set<Id> accIDset = new set<Id>();     
     Trigger_Settings__c triggerControl = Trigger_Settings__c.getInstance(userinfo.getProfileId());
    if(triggerControl.Application_Mapping__c){
     If(trigger.isAfter)
     {
        if(trigger.isInsert)
        {
            ApplicationMappingTriggerHandler amObj = new  ApplicationMappingTriggerHandler();
            amObj.onAfterInsert(Trigger.new);
            
            system.debug('Inside After insert');
            updateDateAfterEvent(trigger.newmap);
        }
        
        if(trigger.isUpdate)
        {
            ApplicationMappingTriggerHandler amObj = new  ApplicationMappingTriggerHandler();
            amObj.onAfterUpdate(Trigger.oldmap,Trigger.newmap);
            
            system.debug('Inside After insert');
            updateDateAfterEvent(trigger.newmap);
        }
        
        if(trigger.isDelete)
        {
           ApplicationMappingTriggerHandler amObj = new  ApplicationMappingTriggerHandler();
           amObj.onAfterDelete(Trigger.old); 
        }
     }
     
     if(trigger.isBefore)
    {
        if(trigger.isDelete)
        {   
            system.debug('Inside Before delete'); 
            updateDateAfterDeleteEvent(trigger.oldmap);
        }
    }  
  }  
    public void updateDateAfterEvent(Map<id,Application_Mapping__c> Applicationmap)
    {
        system.debug('New list size'+Trigger.new);    
        for(Application_Mapping__c app : Applicationmap.values())
        {
            accIDset.add(app.Account__c);
        }
        
        Map<Id,Account> accmap;
        if(!accIDset.isEmpty()){
            accmap = new Map<Id,Account>([select Id, Application_Mapping_Last_Modified_Date__c, Application_Mapping_Created__c 
                       from Account 
                       where Id IN : accIDset]);
        }
        
        if(!accmap.isEmpty()){
            for(Application_Mapping__c ap : Applicationmap.values())
                { 
                    
                    if(accmap.containskey(ap.Account__c))
                    {                    
                        Account acc = new Account();
                        acc = accmap.get(ap.Account__c);
                        acc.Application_Mapping_Last_Modified_Date__c = ap.LastModifiedDate;
                        acc.Application_Mapping_Created__c = true;
                        accSet.add(acc);
                    }                   
                    
                }
                
                for(Account aSet : accSet)
                 {
                     accList.add(aSet);
                 } 
                try{
                if(!accList.isempty()){
                    Update accList;
                
                } 
                }
                
                catch(DMLException e)
                {
                    for(Application_Mapping__c am : Applicationmap.values())
                    {
                        if(e.getMessage().contains('Correspondence_County_Community__c'))
                        {
                            am.addError('The Correspondence/County Community field value for the related Account does not exists. Please correct the respective Account\'s Correspondence/County Community field value before creating a new or updating Application Mapping record for this Account');
                        }
                        else if(e.getMessage().contains('Physical_County_Community__c'))
                        {
                            am.addError('The Physical County/Community field value for the related Account does not exists. Please correct the respective Account\'s Physical County/Community field value before creating a new or updating Application Mapping record for this Account');
                        }
                        else
                        {
                            am.addError(e.getMessage());
                        }
                    }
                }
          }               
    
    }  
    
    public void updateDateAfterDeleteEvent(Map<id,Application_Mapping__c> Applicationmap)
    {
        system.debug('New list size'+Trigger.new);    
        for(Application_Mapping__c app : Applicationmap.values())
        {
            accIDset.add(app.Account__c);
        }
        
        Map<Id,Account> accmap;
        if(!accIDset.isEmpty()){
            accmap = new Map<Id,Account>([select Id, Application_Mapping_Last_Modified_Date__c,Application_Mapping_Created__c 
                       from Account 
                       where Id IN : accIDset]);
        }
        
        if(!accmap.isEmpty()){
            for(Application_Mapping__c ap : Applicationmap.values())
                { 
                    
                    if(accmap.containskey(ap.Account__c))
                    {                    
                        Account acc = new Account();
                        acc = accmap.get(ap.Account__c);
                        acc.Application_Mapping_Last_Modified_Date__c = ap.LastModifiedDate;
                        acc.Application_Mapping_Created__c =true;
                        accSet.add(acc);
                    }                   
                    
                }
                
                for(Account aSet : accSet)
                 {
                     accList.add(aSet);
                 } 
                try{
                if(!accList.isempty()){
                    Update accList;
                
                } 
                }
                
                catch(DMLException e)
                {
                    for(Application_Mapping__c am : Applicationmap.values())
                    {
                        if(e.getMessage().contains('Correspondence_County_Community__c'))
                        {
                            am.addError('The Correspondence/County Community field value for the related Account does not exists. Please correct the respective Account\'s Correspondence/County Community field value before creating a new or updating Application Mapping record for this Account');
                        }
                        else if(e.getMessage().contains('Physical_County_Community__c'))
                        {
                            am.addError('The Physical County/Community field value for the related Account does not exists. Please correct the respective Account\'s Physical County/Community field value before creating a new or updating Application Mapping record for this Account');
                        }
                        else
                        {
                            am.addError(e.getMessage());
                        }
                    }
                }
          }               
    
    }  
}