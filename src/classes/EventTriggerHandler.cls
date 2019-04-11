/*********************************************************************
Name    : updateAccountfromEvent Trigger
Date    : 28 August 2015
Description: Trigger for Event object
             after insert/after update - update account
History : Jed canlas - created a handler
Modified: Loven Reyes - additional logic
*********************************************************************/
public class EventTriggerHandler {
    
    public void onBeforeInsert(list<Event> newListInsert){          
        populateEventFields(newListInsert);
    }

    public void onBeforeUpdate(list<Event> newListUpdate){          
        populateEventFields(newListUpdate);
    }

    public void onAfterInsert(list<Event> newListInsert){           
        updateAccountValues(newListInsert); 
    }   
    
    public void onAfterUpdate(list<Event> newListUpdate){           
        updateAccountValues(newListUpdate);
    }

    public void updateAccountValues(list<Event> newList){
        Map<Id,Account> acc = new Map<Id,Account>();
        Set<Id> oppIds = new Set<Id>();

        for(Event record : newList) {
            if(record.WhatId != null){
                if(record.WhatId.getSObjectType() == account.SObjectType){
                    if(record.Sub_type__c == Label.Site_Visit){
                        acc.put(record.WhatId, new Account(Id = record.WhatId, Date_of_Last_Visit__c = Date.Today()));
                        }
                        else if(record.Sub_type__c == Label.Phone_Call){
                        acc.put(record.WhatId, new Account(Id = record.WhatId, Date_of_Last_Call__c = Date.Today()));
                    }
                }
                else if(record.WhatId.getSObjectType() == opportunity.SObjectType){
                    oppIds.add(record.WhatId);
                }
            } 
        }
        
        Map<Id,Id> oppAccMap = new Map<Id,Id>();
        Map<Id,String> oppNameMap = new Map<Id,String>();
        for(Opportunity oppList : [SELECT Id, Name, AccountId From Opportunity WHERE Id IN :oppIds]){
            oppAccMap.put(oppList.Id, oppList.AccountId);
            oppNameMap.put(oppList.Id,oppList.Name);
        }
        
        for(Event record : newList) {
            if(record.WhatId != null){
                if(record.WhatId.getSObjectType() == opportunity.SObjectType){
                    if(oppAccMap.containsKey(record.WhatId) && oppAccMap.get(record.WhatId) != null){
                        if(record.Sub_type__c == Label.Site_Visit){
                            acc.put(oppAccMap.get(record.WhatId), new Account(Id = oppAccMap.get(record.WhatId), Date_of_Last_Visit__c = Date.Today()));
                            }
                        else if(record.Sub_type__c == Label.Phone_Call){
                        acc.put(oppAccMap.get(record.WhatId), new Account(Id = oppAccMap.get(record.WhatId), Date_of_Last_Call__c = Date.Today()));
                        }
                    } else {
                        record.adderror('Opportunity: ' + oppNameMap.get(record.WhatId)+ ' not linked to any Account');
                    }
                }
            }
        }
        //Added By : Tumish : Update only when list is not empty
        if(!acc.values().isEmpty())
        {
            update acc.values();
        }
    }   

    public void populateEventFields(list<Event> newList){
        
        Set<Id> ownerIds = new Set<Id>();
        Map<Id,User> userMap = new Map<Id,User>();
       // Map<Id,Related_Product_Line__c> rplMap = new Map<Id,Related_Product_Line__c>(); // Commented By Shalu
        Set<Id> whatIds = new Set<Id>();

        for(Event record : newList) {
            ownerIds.add(record.OwnerId);
            if(record.WhatId != null){
                String oppId = record.WhatId;
                if(oppId.startsWith('006')){
                    whatIds.add(oppId);
                }
            } 
        }
        
        
        for(User userLoop : [SELECT Id,Business_Unit__c FROM User Where Id IN :ownerIds]){
            userMap.put(userLoop.Id, userLoop);
        }
        /* // // Commented By Shalu
        for(Related_Product_Line__c rpLine : [Select Id, Segment__c, Product_Line_Text__c, Class__c, Group__c, Product_Function__c, Opportunity__c from Related_Product_Line__c where Opportunity__c IN :whatIds]){
            rplMap.put(rpline.Opportunity__c,rpline);
        } */

        for(Event eve : newList){
           // if(rplMap.get(eve.WhatId)!=null){
                if((eve.Segment__c == '' || eve.Segment__c == null) && 
                   (eve.Class__c == '' || eve.Class__c == null) && 
                   (eve.Group__c == '' || eve.Group__c == null) &&
                   (eve.Product_Function__c == '' || eve.Product_Function__c == null) && 
                   (eve.Product_Line__c == '' || eve.Product_Line__c == null)){
               /*
                    eve.Segment__c = rplMap.get(eve.WhatId).Segment__c;
                    eve.Class__c = rplMap.get(eve.WhatId).Class__c;
                    eve.Group__c = rplMap.get(eve.WhatId).Group__c;
                    eve.Product_Function__c = rplMap.get(eve.WhatId).Product_Function__c;
                    eve.Product_Line__c = rplMap.get(eve.WhatId).Product_Line_Text__c; */ // Commented By Shalu
                }else{
                    
                }           
           // }
            
          /*  if(userMap.containsKey(eve.OwnerId)){
                eve.Business_Unit__c = userMap.get(eve.OwnerId).Business_Unit__c;
            }  */
        }
    }
    
    public void stampAccountfields(List<Event> eveList)
    {
            
            set<Id> accIdset = new set<Id>();
                       
            for(Event eve: eveList)
            {    
                 if(String.isNotBlank(eve.WhatId))
                 {
                     String sobjectType = (eve.whatid).getSObjectType().getDescribe().getName();

                     if(sobjectType == 'Account')
                     {
                         accIdset.add(eve.whatId);
                     } 
                 }  
            }
            
            Map<Id,Account> accMap = new Map<Id,Account>();
            if(!accIdset.isEmpty())
            {
                for(Account a: [select Id,Name,RecordType.Name,Customer_Status__c from Account where Id in: accIdset])
                {
                   accMap.put(a.Id,a); 
                }
                
            }
            
            for(Event eve: eveList)
            {
                if(String.isNotBlank(eve.WhatId))
                 {
                     String sobjectType = (eve.whatid).getSObjectType().getDescribe().getName();

                     if(sobjectType == 'Account' && accMap.containsKey(eve.whatId))
                     {
                          eve.Account_Customer_Status__c = accMap.get(eve.whatId).Customer_Status__c;
                          eve.Account_Name__c = accMap.get(eve.whatId).Name;
                          eve.Account__c = eve.whatId;
                          eve.Account_Type__c = accMap.get(eve.whatId).RecordType.Name;
                          eve.Event_Related_To_Accounts__c = 'Account';
                          
                     }   
                 }
            }
            
    }
}