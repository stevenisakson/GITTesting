/*******
* CreatedDate : 17-09-2018
* Author : Amrish Surve
* Description : This batch class is used for checking/unchecking Account flags based on content document record is present on account document 
*******/
public class SF_UpdateAccountBatchs implements Database.Batchable<sObject>, Database.Stateful{
    
    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator('Select Id,Name,Dealer_External_ID__c,Display_Uploaded__c,Events_Uploaded__c,Prospect_List_Uploaded__c,Training_Uploaded__c from Account where Dealer_External_ID__c != null');
        /*ID ID1 = '001j0000015xldPAAQ';
String query = 'Select Id,Name,Dealer_External_ID__c,Display_Uploaded__c,Events_Uploaded__c,Prospect_List_Uploaded__c,Training_Uploaded__c from Account where ID =: ID1 limit 1';
return Database.getQueryLocator(query);*/
        
    }
    
    public void execute(Database.BatchableContext bc, List<Account> scope){
        Integer numCount = 0;
        Integer numCountEvent = 0;
        Integer numCountPros = 0;
        Set<Id> AccountIDSet = new Set<Id>();
        Set<Id> AccountDocumentIDSet = new Set<Id>();
        Set<Id> AccountDocumentEventIDSet = new Set<Id>();
        Set<Id> AccountDocumentProsIDSet = new Set<Id>();
        Set<Id> allIdSet = new Set<Id>();
        Map<Id,Id> linkIdTolinkIdMap = new Map<Id,Id>();
        //Map<Id,Id> linkIdTolinkIdEventMap = new Map<Id,Id>();
        //Map<Id,Id> linkIdTolinkIdProsMap = new Map<Id,Id>();
        Map<Id,Id> accountIdToDocumentIdMap = new Map<Id,Id>();
        Map<Id,String> idToTypeMap = new Map<Id,String>();
        Map<Id,String> idToTypeEventMap = new Map<Id,String>();
        Map<Id,String> idToTypeProsMap = new Map<Id,String>();
        Map<Id,String> idToTypeTrainMap = new Map<Id,String>();
        Map<Id,Id> accountIdToDocIdMap = new Map<Id,Id>();
        Map<Id,Integer> accountCountMap = new Map<Id,Integer>();
        Map<Id,Integer> accountCountEventMap = new Map<Id,Integer>();
        Map<Id,Integer> accountCountProsMap = new Map<Id,Integer>();
        Map<Id,Id> accountIdToDocIdEventMap = new Map<Id,Id>();
        Map<Id,Id> accountIdToDocIdProspectMap = new Map<Id,Id>();
        Map<Id,Account> toCheckMap = new Map<Id,Account>();
        List<Account_Attachments__c> AccountDocumentListDisplay;
        List<Account_Attachments__c> AccountDocumentListEvent;
        List<Account_Attachments__c> AccountDocumentListProspect;
        List<Account_Attachments__c> AccountDocumentListTrain;
        
        List<Account_Attachments__c> AllAccountDocToCheckLst = new List<Account_Attachments__c>();
        List<Account_Attachments__c> AccountDocumentList = new List<Account_Attachments__c>();
        List<Account_Attachments__c> AccountDocumentEventList = new List<Account_Attachments__c>();
        List<Account_Attachments__c> AccountDocumentProspectList = new List<Account_Attachments__c>();
        
        
        if(!scope.isEmpty()){
            for(Account acObj : scope){
                AccountIDSet.add(acObj.Id);
                
            }
        }
        
        if(!AccountIDSet.isEmpty()){
            System.debug('##accountIdSet01##'+AccountIDSet);
            AccountDocumentListDisplay = [Select Id,Account__c,Type__c,Attachment_Name__c,Last_Upload_Date__c,Monthly_Uploaded_Date__c,Start_Month_Date__c,Training_Date__c from Account_Attachments__c where Account__c IN :AccountIDSet AND ((Type__c = 'Display' AND Monthly_Uploaded_Date__c = This_Month) OR (Type__c = 'Events' AND Start_Month_Date__c = THIS_QUARTER) OR (Type__c = 'Prospect Lists and Activities' AND Last_Upload_Date__c = This_Month) OR (Type__c = 'For Training' AND (Training_Date__c = LAST_N_MONTHS:11 OR Training_Date__c = THIS_MONTH)))];
            
            if(!AccountDocumentListDisplay.isEmpty()){
                for(Account_Attachments__c acdocObj : AccountDocumentListDisplay){
                    if(acdocObj.Type__c == 'Display'){
                        AccountDocumentIDSet.add(acdocObj.Id);
                        accountIdToDocIdMap.put(acdocObj.Account__c,acdocObj.Id);
                        AccountDocumentList.add(acdocObj);
                    }
                    if(acdocObj.Type__c == 'Events'){
                        AccountDocumentEventIDSet.add(acdocObj.Id);
                        accountIdToDocIdEventMap.put(acdocObj.Account__c,acdocObj.Id);
                        AccountDocumentEventList.add(acdocObj);
                    }
                    if(acdocObj.Type__c == 'Prospect Lists and Activities'){
                        AccountDocumentProsIDSet.add(acdocObj.Id);
                        accountIdToDocIdProspectMap.put(acdocObj.Account__c,acdocObj.Id);
                        AccountDocumentProspectList.add(acdocObj);
                    }
                    if(acdocObj.Type__c == 'For Training'){
                        accountIdToDocumentIdMap.put(acdocObj.Account__c,acdocObj.Id);
                        idToTypeTrainMap.put(acdocObj.Account__c,acdocObj.Type__c);
                    }
                }
                
            }
            
            
            System.debug('##objIdSet1##'+AccountDocumentIDSet);
        }
        
        if(!AccountDocumentIDSet.isEmpty())
            allIdSet.addAll(AccountDocumentIDSet);
        if(!AccountDocumentEventIDSet.isEmpty())
            allIdSet.addAll(AccountDocumentEventIDSet);
        if(!AccountDocumentProsIDSet.isEmpty())
            allIdSet.addAll(AccountDocumentProsIDSet);
        
        if(!AccountDocumentList.isEmpty())
            AllAccountDocToCheckLst.addAll(AccountDocumentList);
        if(!AccountDocumentEventList.isEmpty())
            AllAccountDocToCheckLst.addAll(AccountDocumentEventList);
        if(!AccountDocumentProspectList.isEmpty())
            AllAccountDocToCheckLst.addAll(AccountDocumentProspectList);
        
        if(!allIdSet.isEmpty()){
            List<ContentDocumentLink> lstContent = [Select ContentDocumentId,Id,IsDeleted,LinkedEntityId FROM ContentDocumentLink where LinkedEntityId IN :allIdSet];
            System.debug('##lstContent##'+lstContent);
            if(!lstContent.isEmpty()){
                for(ContentDocumentLink cdm : lstContent){
                    linkIdTolinkIdMap.put(cdm.LinkedEntityId, cdm.LinkedEntityId);
                    System.debug('##linkIdTolinkIdMap##'+linkIdTolinkIdMap);
                }
            }
        }
        
        
        if(!AllAccountDocToCheckLst.isEmpty()){
            for(Account_Attachments__c acr : AllAccountDocToCheckLst){
                if(acr.Type__c == 'Display'){
                    System.debug('$$$Inside ACR');
                    if(linkIdTolinkIdMap.containsKey(acr.Id)){
                        System.debug('$$$$Map check'+accountCountMap.get(acr.Account__c));
                        if(accountCountMap.get(acr.Account__c) == null || accountCountMap.get(acr.Account__c) == 0){
                            numCount = 1;
                            accountCountMap.put(acr.Account__c,numCount);
                            System.debug('$$Find Map if'+accountCountMap);
                        }else if(accountCountMap.get(acr.Account__c) >= 1){
                            numCount = numCount + 1;
                            accountCountMap.put(acr.Account__c,numCount);
                            System.debug('$$Find Map else'+accountCountMap);
                        }
                    }else if(!linkIdTolinkIdMap.containsKey(acr.Id) && accountCountMap.get(acr.Account__c) == null){
                        accountCountMap.put(acr.Account__c,0);
                        System.debug('$$Find Map else if '+accountCountMap);
                    }
                    idToTypeMap.put(acr.Account__c,acr.Type__c);
                    System.debug('##accountCountMap###'+accountCountMap);
                }
                if(acr.Type__c == 'Events'){
                    System.debug('$$$Inside acr1');
                    if(linkIdTolinkIdMap.containsKey(acr.Id)){
                        System.debug('$$$$Map check'+accountCountEventMap.get(acr.Account__c));
                        if(accountCountEventMap.get(acr.Account__c) == null || accountCountEventMap.get(acr.Account__c) == 0){
                            numCountEvent = 1;
                            accountCountEventMap.put(acr.Account__c,numCountEvent);
                            System.debug('$$Find Map if event'+accountCountEventMap);
                        }else if(accountCountEventMap.get(acr.Account__c) >= 1){
                            numCountEvent = numCountEvent + 1;
                            accountCountEventMap.put(acr.Account__c,numCountEvent);
                            System.debug('$$Find Map else event'+accountCountEventMap);
                        }
                    }else if(!linkIdTolinkIdMap.containsKey(acr.Id) && accountCountEventMap.get(acr.Account__c) == null){
                        accountCountEventMap.put(acr.Account__c,0);
                        System.debug('$$Find Map else if '+accountCountEventMap);
                    }
                    idToTypeEventMap.put(acr.Account__c,acr.Type__c);
                    System.debug('##accountCountEventMap###'+accountCountEventMap);
                }
                
                if(acr.Type__c == 'Prospect Lists and Activities'){
                    System.debug('$$$Inside ACR3');
                    if(linkIdTolinkIdMap.containsKey(acr.Id)){
                        System.debug('$$$$Map check'+accountCountProsMap.get(acr.Account__c));
                        if(accountCountProsMap.get(acr.Account__c) == null || accountCountProsMap.get(acr.Account__c) == 0){
                            numCountPros = 1;
                            accountCountProsMap.put(acr.Account__c,numCountPros);
                            System.debug('$$Find Map if'+accountCountProsMap);
                        }else if(accountCountProsMap.get(acr.Account__c) >= 1){
                            numCountPros = numCountPros + 1;
                            accountCountProsMap.put(acr.Account__c,numCountPros);
                            System.debug('$$Find Map else'+accountCountProsMap);
                        }
                    }else if(!linkIdTolinkIdMap.containsKey(acr.Id) && accountCountProsMap.get(acr.Account__c) == null){
                        accountCountProsMap.put(acr.Account__c,0);
                        System.debug('$$Find Map else if '+accountCountProsMap);
                    }
                    idToTypeProsMap.put(acr.Account__c,acr.Type__c);
                    System.debug('##accountCountProsMap###'+accountCountProsMap);
                    
                }
                
            }
        }
        
        
        
        List<Account> accountLstFinal = [Select Id,Prospect_List_Uploaded__c,Display_Uploaded__c,Events_Uploaded__c,Training_Uploaded__c from Account where ID IN :AccountIDSet];
        if(!accountLstFinal.isEmpty()){ 
            for(Account accObj : accountLstFinal){
                System.debug('##accountCountMap1111###'+idToTypeMap.containsKey(accObj.Id)+'##idToTypeMap333##'+accountCountMap.get(accObj.Id));
                toCheckMap.put(accObj.Id, accObj);
                if(idToTypeMap.containsKey(accObj.Id) && idToTypeMap.get(accObj.Id) == 'Display'){
                    if(accountCountMap.get(accObj.Id) == 0){
                        accObj.Display_Uploaded__c = false; 
                        toCheckMap.get(accObj.Id).Display_Uploaded__c = false;
                    }else if(accountCountMap.get(accObj.Id) >= 1){
                        accObj.Display_Uploaded__c = True;  
                        toCheckMap.get(accObj.Id).Display_Uploaded__c = True;
                    }
                }
                if(idToTypeEventMap.containsKey(accObj.Id) && idToTypeEventMap.get(accObj.Id) == 'Events'){
                    if(accountCountEventMap.get(accObj.Id) == 0){
                        accObj.Events_Uploaded__c = false;  
                        toCheckMap.get(accObj.Id).Events_Uploaded__c = false;
                        
                    }else if(accountCountEventMap.get(accObj.Id) >= 1){
                        accObj.Events_Uploaded__c = True;
                        toCheckMap.get(accObj.Id).Events_Uploaded__c = True;
                        
                    }
                }
                if(idToTypeProsMap.containsKey(accObj.Id) && idToTypeProsMap.get(accObj.Id) == 'Prospect Lists and Activities'){
                    if(accountCountProsMap.get(accObj.Id) == 0){
                        accObj.Prospect_List_Uploaded__c = false;   
                        toCheckMap.get(accObj.Id).Prospect_List_Uploaded__c = false;
                        
                    }else if(accountCountProsMap.get(accObj.Id) >= 1){
                        accObj.Prospect_List_Uploaded__c = True;
                        toCheckMap.get(accObj.Id).Prospect_List_Uploaded__c = True;
                        
                    }
                }
                if(idToTypeTrainMap.containsKey(accObj.Id) && idToTypeTrainMap.get(accObj.Id) == 'For Training'){
                    System.debug('###toCheckMap before firt##'+accountIdToDocumentIdMap.containsKey(accObj.Id));
                    if(accountIdToDocumentIdMap.containsKey(accObj.Id)){
                        accObj.Training_Uploaded__c = True;
                        toCheckMap.get(accObj.Id).Training_Uploaded__c = True;
                        System.debug('###toCheckMap before ##'+toCheckMap);
                    }
                }
                
                
            }
        }
        system.debug('###toCheckMap#'+toCheckMap);
        try{
            if(!toCheckMap.isEmpty())
                update toCheckMap.values();
            
        }catch(Exception e){
            System.debug('##exception in update'+e.getMessage());
        }
        
        
        
        Map<Id,Account> incorrectIdToAccountMap = new Map<Id,Account>();
        for(Account acToCheck : [Select Id,Prospect_List_Uploaded__c,Display_Uploaded__c,Events_Uploaded__c,Training_Uploaded__c from Account where ID IN :AccountIDSet]){
            System.debug('##acToCheck##'+accountIdToDocIdEventMap.containsKey(acToCheck.Id));
            incorrectIdToAccountMap.put(acToCheck.Id,acToCheck);
            if(!accountIdToDocIdEventMap.containsKey(acToCheck.Id)){
                acToCheck.Events_Uploaded__c = False;
                incorrectIdToAccountMap.get(acToCheck.Id).Events_Uploaded__c = False;
            }
            if(!accountIdToDocIdMap.containskey(acToCheck.Id)){
                acToCheck.Display_Uploaded__c = False;
                incorrectIdToAccountMap.get(acToCheck.Id).Display_Uploaded__c = False;
            }
            if(!accountIdToDocIdProspectMap.containskey(acToCheck.Id)){
                acToCheck.Prospect_List_Uploaded__c = False;
                incorrectIdToAccountMap.get(acToCheck.Id).Prospect_List_Uploaded__c = False;
            }
            if(!accountIdToDocumentIdMap.containsKey(acToCheck.Id)){
                acToCheck.Training_Uploaded__c = False;
                incorrectIdToAccountMap.get(acToCheck.Id).Training_Uploaded__c = False;
            }
            
        }
        System.debug('$$$Final incorrectIdToAccountMap'+incorrectIdToAccountMap);
        try{
            if(!incorrectIdToAccountMap.isEmpty())
                update incorrectIdToAccountMap.values();
        }catch(Exception e){
            System.debug('Error in update'+e.getMessage());
        }
    }
    
    public void finish(Database.BatchableContext bc){
        
    }
}