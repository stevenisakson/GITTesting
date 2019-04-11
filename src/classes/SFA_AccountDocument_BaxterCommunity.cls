/* 
 * Author : Amrish Surve
 * CreatedDate : 06-Sept-2018
 * Description : created for tracking training records upload
*/
public with sharing class SFA_AccountDocument_BaxterCommunity {

    /* Method which is used to update the training flag once training data is uploaded */
    public static void updateTrainingFlag(List<Account_Attachments__c> AccountDocList){
        Set<Id> trainingIds = new Set<Id>();
        Set<Id> accountIdS = new Set<Id>();
        List<Account> accountsToUpdate = new List<Account>();
        for(Account_Attachments__c acType : AccountDocList){
            if(acType.Type__c == 'For Training'){
                trainingIds.add(acType.Id); 
            }
        }
        
        if(!trainingIds.isEmpty()){
            for(Account_Attachments__c trainAttLst1 : [Select Type__c,Id,Account__c,Training_Date__c from Account_Attachments__c where Id IN :trainingIds and (Training_Date__c = LAST_N_MONTHS:5 OR Training_Date__c = THIS_MONTH)]){
                accountIdS.add(trainAttLst1.Account__c);
            }
        }
        
        if(!accountIdS.isEmpty()){
            for(Account acT : [Select Id,Training_Uploaded__c from Account where Id IN :accountIdS]){
                acT.Training_Uploaded__c = True;
                accountsToUpdate.add(acT);
            }
        }
        try{
        	if(!accountsToUpdate.isEmpty())
            	update accountsToUpdate;
        }catch(Exception e){
            System.debug('$$accountsToUpdate$$'+accountsToUpdate);
        }
    }
   
   /* Method which is used to reset the training flag once training data is deleted */
    public static void resetTrainingFlag(List<Account_Attachments__c> AccountDocList){
        Map<Id,Id> idToAccountIdMap = new Map<Id,Id>();
        List<Account> accountToUpdateList = new List<Account>();
        Map<Id,Integer> accountCountMap = new Map<Id,Integer>();
        for(Account_Attachments__c atLst : [Select Type__c,Account__c,Training_Date__c from Account_Attachments__c where ID IN :AccountDocList]){
            if(atLst.Type__c == 'For Training'){
                idToAccountIdMap.put(atLst.Id, atLst.Account__c);
            }
        }
        if(!idToAccountIdMap.isEmpty()){
            List<Account_Attachments__c> currentAccAttLst = [Select Type__c,Account__c,Training_Date__c from Account_Attachments__c where Account__c IN :idToAccountIdMap.values() and (Training_Date__c >= LAST_N_MONTHS:5 and Training_Date__c <= THIS_MONTH)];
            if(!currentAccAttLst.isEmpty()){
                integer numCount = 0;
                for(Account_Attachments__c acT : currentAccAttLst){
                    if(accountCountMap.get(acT.Account__c) == null){
                        numCount = 1;
                        accountCountMap.put(acT.Account__c,numCount);
                        System.debug('inside if map'+accountCountMap);
                    }else if(accountCountMap.get(acT.Account__c) >= 1){
                        numCount = numCount + 1;
                        accountCountMap.put(acT.Account__c,numCount);
                        System.debug('inside else if map'+accountCountMap);
                    }
                }
            }
        }
        
        if(!accountCountMap.isEmpty() && !AccountDocList.isEmpty()){
            List<Account> accLst = [Select Id,Training_Uploaded__c from Account where ID IN :accountCountMap.keySet()];
            System.debug('####Final pre List'+accLst);
            if(!accLst.isEmpty()){
                for(Account acT : accLst){
                    System.debug('################'+accountCountMap.get(acT.Id));
                    if(accountCountMap.get(acT.Id) <= 1){
                     	acT.Training_Uploaded__c = false;   
                        accountToUpdateList.add(acT);
                    }
                }
            }
        }
        try{
            if(!accountToUpdateList.isEmpty())
                update accountToUpdateList;
        }catch(Exception e){
            System.debug('###Error in updates'+e.getMessage());
        }
    }
}