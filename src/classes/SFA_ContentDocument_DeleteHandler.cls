public class SFA_ContentDocument_DeleteHandler {
    
    public static void resetAccountFlags(List<ContentDocument> contentDocLst){
        Set<ID> idset = new Set<ID>();
        Set<ID> linkEntityIdSet = new Set<ID>();
        Map<Id,Id> eventidToAccountIdMap = new Map<Id,Id>();
        Map<Id,Id> displayidToAccountIdMap = new Map<Id,Id>();
        Map<Id,Id> prospectidToAccountIdMap = new Map<Id,Id>();
        
        for(ContentDocument cd : contentDocLst){
            idset.add(cd.Id);
        }
        
        if(!idset.isEmpty()){
            List<ContentDocumentLink> contentDocumentLst = [Select ContentDocumentId,Id,LinkedEntityId FROM ContentDocumentLink where ContentDocumentId IN :idset];
            if(!contentDocumentLst.isEmpty()){
                for(ContentDocumentLink link : contentDocumentLst){
                    Id linkId = link.LinkedEntityId;
                    if(String.valueOf(linkId.getsobjecttype()) == System.Label.SFA_ObjectAPIName){
                        linkEntityIdSet.add(link.LinkedEntityId);
                    }
                }
            }
        }
        
        if(!linkEntityIdSet.isEmpty()){
            List<Account_Attachments__c> aaLst = [Select Id,Account__c,Type__c from Account_Attachments__c where ID IN :linkEntityIdSet];
            if(!aaLst.isEmpty()){
                for(Account_Attachments__c ap : aaLst){
                    if(ap.Type__c == 'Events')
                        eventidToAccountIdMap.put(ap.Id, ap.Account__c);
                    if(ap.Type__c == 'Display')
                        displayidToAccountIdMap.put(ap.Id, ap.Account__c);
                    if(ap.Type__c == 'Prospect Lists and Activities')
                        prospectidToAccountIdMap.put(ap.Id, ap.Account__c);
                    
                }
            }
        }
        if(!eventidToAccountIdMap.isEmpty())
            updateEventFlag(eventidToAccountIdMap);
            
        if(!displayidToAccountIdMap.isEmpty())
            updateDisplayFlag(displayidToAccountIdMap);
        
        if(!prospectidToAccountIdMap.isEmpty())
            updateProspectFlag(prospectidToAccountIdMap);
        
    }
    
    public static void updateEventFlag(Map<Id,Id> eventidToAccountIdMap1){
        Set<Id> idSet1 = new Set<Id>();
        Map<Id,Id> idAccMap = new Map<Id,Id>();
        List<Account_Attachments__c> lstToCheck = new List<Account_Attachments__c>();
        if(!eventidToAccountIdMap1.isEmpty()){
            List<Account_Attachments__c> attLst = [Select Id,Account__c,Type__c,Start_Month_Date__c from Account_Attachments__c where Account__c IN : eventidToAccountIdMap1.values() and Start_Month_Date__c = THIS_QUARTER];
            if(!attLst.isEmpty()){
                for(Account_Attachments__c apt : attLst){
                    idSet1.add(apt.Id);
                    lstToCheck.add(apt);
                    idAccMap.put(apt.ID, apt.Account__c);
                }
                
            }
        }
        Map<Id,Id> idToidMap = new Map<Id,Id>();
        if(!idSet1.isEmpty()){
            List<ContentDocumentLink> lstContent = [Select ContentDocumentId,Id,IsDeleted,LinkedEntityId FROM ContentDocumentLink where LinkedEntityId IN :idSet1];
            if(!lstContent.isEmpty()){
                for(ContentDocumentLink cdm : lstContent){
                    idToidMap.put(cdm.LinkedEntityId, cdm.LinkedEntityId);
                }
            }
        }
        Set<Id> accountFnSet = new Set<Id>();
        Map<Id,Integer> idToCountMap = new Map<Id,Integer>();
        Map<Id,Integer> accountCountMap = new Map<Id,Integer>();
        integer numCount = 0;
        if(!lstToCheck.isEmpty()){
            for(Account_Attachments__c acr : lstToCheck){
                if(idToidMap.containsKey(acr.Id)){
                    if(accountCountMap.get(acr.Account__c) == null){
                        numCount = 1;
                        accountCountMap.put(acr.Account__c,numCount);
                    }else if(accountCountMap.get(acr.Account__c) >= 1){
                        numCount = numCount + 1;
                        accountCountMap.put(acr.Account__c,numCount);
                    }
                    idToCountMap.put(acr.Id,numCount);
                    
                }
            }
        }
        
        if(!accountCountMap.isEmpty()){
            List<Account> finalAccountToupdate = new List<Account>();
            finalAccountToupdate.addAll(getAccountUpdateList(accountCountMap, 'Events'));
            try{
                if(!finalAccountToupdate.isEmpty())
                    update finalAccountToupdate;
            }catch(Exception e){
                System.debug('Error in Update Events'+e.getMessage());
            }
        }
        
    }
    
    
    public static void updateDisplayFlag(Map<Id,Id> eventidToAccountIdMap2){
        Set<Id> idSet1 = new Set<Id>();
        Map<Id,Id> idAccDisMap = new Map<Id,Id>();
        List<Account_Attachments__c> lstToCheckdis = new List<Account_Attachments__c>();
        if(!eventidToAccountIdMap2.isEmpty()){
            List<Account_Attachments__c> attLstdis = [Select Id,Account__c,Type__c,Monthly_Uploaded_Date__c from Account_Attachments__c where Account__c IN : eventidToAccountIdMap2.values() and Monthly_Uploaded_Date__c = THIS_MONTH];
            if(!attLstdis.isEmpty()){
                for(Account_Attachments__c apt : attLstdis){
                    idSet1.add(apt.Id);
                    lstToCheckdis.add(apt);
                    idAccDisMap.put(apt.ID, apt.Account__c);
                }
                
            }
        }
        Map<Id,Id> idToidMap = new Map<Id,Id>();
        if(!idSet1.isEmpty()){
            List<ContentDocumentLink> lstContent = [Select ContentDocumentId,Id,IsDeleted,LinkedEntityId FROM ContentDocumentLink where LinkedEntityId IN :idSet1];
            if(!lstContent.isEmpty()){
                for(ContentDocumentLink cdm : lstContent){
                    idToidMap.put(cdm.LinkedEntityId, cdm.LinkedEntityId);
                }
            }
        }
        Set<Id> accountFnDisSet = new Set<Id>();
        Map<Id,Integer> idToCountDisMap = new Map<Id,Integer>();
        Map<Id,Integer> accountCountDisMap = new Map<Id,Integer>();
        integer numCount = 0;
        if(!lstToCheckdis.isEmpty()){
            for(Account_Attachments__c acr : lstToCheckdis){
                if(idToidMap.containsKey(acr.Id)){
                    if(accountCountDisMap.get(acr.Account__c) == null){
                        numCount = 1;
                        accountCountDisMap.put(acr.Account__c,numCount);
                    }else if(accountCountDisMap.get(acr.Account__c) >= 1){
                        numCount = numCount + 1;
                        accountCountDisMap.put(acr.Account__c,numCount);
                    }
                    idToCountDisMap.put(acr.Id,numCount);
                    
                }
            }
        }
        if(!accountCountDisMap.isEmpty()){
            List<Account> finalDisplayAccountToupdate = new List<Account>();
            finalDisplayAccountToupdate.addAll(getAccountUpdateList(accountCountDisMap, 'Display'));
            try{
                if(!finalDisplayAccountToupdate.isEmpty())
                    update finalDisplayAccountToupdate;
            }catch(Exception e){
                System.debug('Error in Update Display'+e.getMessage());
            }
        }
    }
    
    public static void updateProspectFlag(Map<Id,Id> eventidToAccountIdMap3){
        Set<Id> idSet1 = new Set<Id>();
        Map<Id,Id> idAccProspectMap = new Map<Id,Id>();
        List<Account_Attachments__c> lstToCheckProspect = new List<Account_Attachments__c>();
        if(!eventidToAccountIdMap3.isEmpty()){
            List<Account_Attachments__c> attLstprospect = [Select Id,Account__c,Type__c,Last_Upload_Date__c from Account_Attachments__c where Account__c IN : eventidToAccountIdMap3.values() and Last_Upload_Date__c = THIS_MONTH];
            if(!attLstprospect.isEmpty()){
                for(Account_Attachments__c apt : attLstprospect){
                    idSet1.add(apt.Id);
                    lstToCheckProspect.add(apt);
                    idAccProspectMap.put(apt.ID, apt.Account__c);
                }
                
            }
        }
        Map<Id,Id> idToidMap = new Map<Id,Id>();
        if(!idSet1.isEmpty()){
            List<ContentDocumentLink> lstContent = [Select ContentDocumentId,Id,IsDeleted,LinkedEntityId FROM ContentDocumentLink where LinkedEntityId IN :idSet1];
            if(!lstContent.isEmpty()){
                for(ContentDocumentLink cdm : lstContent){
                    idToidMap.put(cdm.LinkedEntityId, cdm.LinkedEntityId);
                }
            }
        }
        Set<Id> accountFnProsSet = new Set<Id>();
        Map<Id,Integer> idToCountProsMap = new Map<Id,Integer>();
        Map<Id,Integer> accountCountProsMap = new Map<Id,Integer>();
        integer numCount = 0;
        if(!lstToCheckProspect.isEmpty()){
            for(Account_Attachments__c acr : lstToCheckProspect){
                if(idToidMap.containsKey(acr.Id)){
                    if(accountCountProsMap.get(acr.Account__c) == null){
                        numCount = 1;
                        accountCountProsMap.put(acr.Account__c,numCount);
                    }else if(accountCountProsMap.get(acr.Account__c) >= 1){
                        numCount = numCount + 1;
                        accountCountProsMap.put(acr.Account__c,numCount);
                    }
                    idToCountProsMap.put(acr.Id,numCount);
                }
            }
        }
        
        
        if(!accountCountProsMap.isEmpty()){
            List<Account> finalProspectAccountToupdate = new List<Account>();
            finalProspectAccountToupdate.addAll(getAccountUpdateList(accountCountProsMap, 'Prospect Lists and Activities'));
            try{
                if(!finalProspectAccountToupdate.isEmpty())
                    update finalProspectAccountToupdate;
            }catch(Exception e){
               System.debug('Error in Update Prospect Lists'+e.getMessage());     
            }
        }
    }
    
    public static List<Account> getAccountUpdateList(Map<Id,Integer> accountCountPMap, String Type){
        List<Account> accountToSendList = new List<Account>();
        if(!accountCountPMap.isEmpty()){
            List<Account> accountLstFinal = [Select Id,Prospect_List_Uploaded__c,Display_Uploaded__c,Events_Uploaded__c from Account where ID IN :accountCountPMap.keySet()];
            System.debug('accountLstFinal'+accountLstFinal);
            if(!accountLstFinal.isEmpty()){ 
                for(Account accObj : accountLstFinal){
                    System.debug('accountCountPMap'+accountCountPMap.get(accObj.Id));
                    if(accountCountPMap.get(accObj.Id) <= 1){
                        if(Type == 'Prospect Lists and Activities')
                            accObj.Prospect_List_Uploaded__c = false;   
                        if(Type == 'Display')
                            accObj.Display_Uploaded__c = false; 
                        if(Type == 'Events')
                            accObj.Events_Uploaded__c = false;  
                                
                        System.debug('Account list'+accObj);
                        accountToSendList.add(accObj);
                    }
                }
            }
            if(!accountToSendList.isEmpty())
                return accountToSendList;
        }
        return accountToSendList;
    }
}