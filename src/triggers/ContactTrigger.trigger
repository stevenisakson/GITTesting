trigger ContactTrigger on Contact (before insert,after insert,after update, before delete) 
{
   /* List<Account> accList = new List<Account>();
    Set<Account> accSet = new set<Account>();
    set<Id> accIDset = new set<Id>();  
    datetime d = NULL;*/
    PreDefaultValues predef = new PreDefaultValues();
    Trigger_Settings__c triggerControl = Trigger_Settings__c.getInstance(userinfo.getProfileId());
if(trigger.isAfter)
{
    if(trigger.isInsert || trigger.isUpdate)
    {  
         if(triggerControl.Contact__c)
         {
            updateDateAfterEvent(trigger.newmap);
         }
    }
    
    if(trigger.isUpdate)
    {  
         if(triggerControl.Contact__c)
         {
            updateDateAfterAccountChange(trigger.newmap,trigger.oldmap);
         }
    }
    
    
}


if(trigger.isBefore)
{
    if(trigger.isDelete)
    {    
         if(triggerControl.Contact__c)
         {
            updateDateAfterEvent(trigger.oldmap);
         }
    }
    
    if(trigger.isInsert)
    {
        if(triggerControl.Contact__c)
        {    
           predef.setContactFlagValues(trigger.new); 
           setContactCurrency(trigger.new);
        }
       
    }
    if(trigger.isInsert && trigger.isBefore){
        /*Populate Business Unit for the Contact Record*/
         Cres_BU_PopulateHelper.populateBU(Trigger.new);
    }

}

// To be fired if Account association is changed on contact record.
public void updateDateAfterAccountChange(Map<Id,Contact> contactNewMap,Map<Id,Contact> contactOldMap)
{
        List<Account> accList = new List<Account>();
        Set<Account> accSet = new set<Account>();
        set<Id> accIDset = new set<Id>();  
        datetime d = NULL;

      
      for(Contact con : contactOldMap.values())
      {
            if(con.AccountId <> null && contactNewMap.get(con.Id).AccountId <> null)
            {
                if(contactNewMap.get(con.Id).AccountId <> contactOldMap.get(con.Id).AccountId)
                {
                    accIDset.add(con.AccountId);
                }
            }
      }  
      
      System.debug('********accIDset :'+accIDset);

      Map<Id,Account> accmap;
        
      if(!accIDset.isEmpty())
      {
         system.debug('@@@@@@@@@@@@@@@@@@@@@@@@@test');
         accmap = new Map<Id,Account>([select Id, Contact_Last_Modified_Date__c 
                       from Account 
                       where Id IN : accIDset]);
      }
      
          if(accmap<>NULL)
          {
           system.debug('@@@@@@@@@@@@@@@@@@@@@@@@@testmap');
            for(Contact con : contactOldMap.values())
            { 
                    if(accmap.containskey(con.AccountId))
                    {                    
                        Account acc = new Account();
                        acc = accmap.get(con.AccountId);
                        acc.Contact_Last_Modified_Date__c = contactNewMap.get(con.Id).LastModifiedDate;
                        accSet.add(acc);
                    }                   
             }
             for(Account aSet : accSet)
             {
                 accList.add(aSet);
             }  
             
            
                try{
                      if(!accList.isempty())
                      {
                        system.debug('@@@@@accList'+accList);
                        Update accList;
                      }
                   } 
                   
                catch(DMLException e)
                {
                    for(Contact c : contactNewMap.values())
                    {
                        if(e.getMessage().contains('Correspondence_County_Community__c'))
                        {
                            c.addError('The Correspondence/County Community field value for the related Account does not exists. Please correct the respective Account\'s Correspondence/County Community field value before creating a new or updating Contact record for this Account');
                        }
                        else if(e.getMessage().contains('Physical_County_Community__c'))
                        {
                            c.addError('The Physical County/Community field value for the related Account does not exists. Please correct the respective Account\'s Physical County/Community field value before creating a new or updating Contact record for this Account');
                        }
                        else
                        {
                            c.addError(e.getMessage());
                        }
                    }
                }
          } 
      
}
//Update New Accounts Only on insert,update and delete events
    public void updateDateAfterEvent(Map<id,Contact> ContactMap)
    {
        List<Account> accList = new List<Account>();
        Set<Account> accSet = new set<Account>();
        set<Id> accIDset = new set<Id>();  
        datetime d = NULL;

        System.debug('********ContactMap :'+ContactMap);
        for(Contact con : ContactMap.values())
        {
            if(con.AccountId <> null)
            {
                accIDset.add(con.AccountId);
            }
        }
       // System.debug('********accIDset :'+accIDset);
        Map<Id,Account> accmap;
        if(!accIDset.isEmpty()){
            accmap = new Map<Id,Account>([select Id, Contact_Last_Modified_Date__c 
                       from Account 
                       where Id IN : accIDset]);
        }
     if(accmap<>NULL){
            for(Contact ap : ContactMap.values())
                { 
                    
                    if(accmap.containskey(ap.AccountId))
                    {                    
                        Account acc = new Account();
                        acc = accmap.get(ap.AccountId);

                        //On before delete event
                        if(trigger.isDelete)
                        {
                           acc.Contact_Last_Modified_Date__c = System.now(); 
                        }
                         
                        //On After Insert or Update event    
                        else
                        {
                            acc.Contact_Last_Modified_Date__c = ap.LastModifiedDate;
                        }
                        accSet.add(acc);
                    }                   
                    
                }
             for(Account aSet : accSet)
             {
                 accList.add(aSet);
             }  
             
            
                try{
                      if(!accList.isempty())
                      {
                        system.debug('@@@@@accList'+accList);
                        Update accList;
                      }
                   } 
                   
                catch(DMLException e)
                {
                    for(Contact c : ContactMap.values())
                    {
                        if(e.getMessage().contains('Correspondence_County_Community__c'))
                        {
                            c.addError('The Correspondence/County Community field value for the related Account does not exists. Please correct the respective Account\'s Correspondence/County Community field value before creating a new or updating Contact record for this Account');
                        }
                        else if(e.getMessage().contains('Physical_County_Community__c'))
                        {
                            c.addError('The Physical County/Community field value for the related Account does not exists. Please correct the respective Account\'s Physical County/Community field value before creating a new or updating Contact record for this Account');
                        }
                        else
                        {
                            c.addError(e.getMessage());
                        }
                    }
                }
          }               
    }
    
    public void setContactCurrency(list<Contact> contactList)
    {
        set<Id> ownerIdset = new set<Id>();
        
        for(Contact con: contactList)
        {
            ownerIdset.add(con.OwnerId);
        }
        
      //  List<Contact> conList= [select Id,CurrencyISOCode,OwnerId from Contact where Id In : conIdset];
        
        Map<string,string> ownerCurrencyMap = new Map<string,string>();
        
        for(User usr: [Select Id,DefaultCurrencyISOCode from User where Id In : ownerIdset])   
        {
           ownerCurrencyMap.put(usr.Id,usr.DefaultCurrencyISOCode);
        }
        
        for(Contact con: contactList)
        {
            if(ownerCurrencyMap.containsKey(con.OwnerId))
            {
                con.CurrencyISOCode = ownerCurrencyMap.get(con.OwnerId);
            }
        }  
        
    }
}