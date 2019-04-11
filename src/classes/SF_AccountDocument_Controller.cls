/* 
 * Author : Amrish Surve
 * CreatedDate : 23-July-2018
 * Description : created for displaying document history in baxter community
*/

public with sharing class SF_AccountDocument_Controller {
    
    /* This function is used for displaying display historic data */
    @AuraEnabled
    Public static List<DocumentWrapper> getAttachmentList(){
        Id currentAccountID =  fetchAccountId();   
        List<DocumentWrapper> displayList = new List<DocumentWrapper>(); 
        List<Account_Attachments__c> toSendAtt = new List<Account_Attachments__c>();
        List<ContentDocumentLink> uniqueContentList = new List<ContentDocumentLink>();
        Set<Id> parentId = new Set<Id>();
        Map<Id,Account_Attachments__c> objMap = new Map<Id,Account_Attachments__c>();
        List<Account_Attachments__c> accList = new List<Account_Attachments__c>();
        for(Account_Attachments__c qc : [Select Id,Name,Account__c,Account__r.Name,Account__r.AccountNumber,of_Attendees__c,Attendees__c,Monthly_Uploaded_Date__c,Type__c,Attachment_Name__c,Last_Upload_Date__c,Start_Month_Date__c,Topic__c,Training_Date__c from Account_Attachments__c where Account__c =: currentAccountID and Type__c =: Cargill_BaxterUtility.typeDisplay and Monthly_Uploaded_Date__c >= LAST_N_MONTHS:12 and Monthly_Uploaded_Date__c <= THIS_MONTH order by Monthly_Uploaded_Date__c DESC]){
            parentId.add(qc.id);
            objMap.put(qc.id, qc);
            accList.add(qc);
        }
        List<ContentDocumentLink> contentLink =  new List<ContentDocumentLink>();
        if(!parentId.isEmpty())
            contentLink = [SELECT ContentDocumentId,ContentDocument.Title,ContentDocument.FileExtension,Id,LinkedEntityId FROM ContentDocumentLink where LinkedEntityId IN :parentId];
        
        System.debug('###ContentLink size'+contentLink);
        Map<Id,ContentDocumentLink> mapParent = new Map<Id,ContentDocumentLink>();
        if(!contentLink.isEmpty()){
            for(ContentDocumentLink cd : contentLink){
                if(!mapParent.containsKey(cd.LinkedEntityId))
                    uniqueContentList.add(cd);  
                    
                mapParent.put(cd.LinkedEntityId,cd);
                System.debug('$$mapParent$'+mapParent+'###uniqueContentList'+uniqueContentList);
            }
            displayList.addAll(sendDocumentList(uniqueContentList,objMap));//get data from contentdocuments
        }
        if(!accList.isEmpty()){
            for(Account_Attachments__c ac : accList){
                if(!mapParent.containsKey(ac.Id)){
                    toSendAtt.add(ac);
                    System.debug('##Called Function'+toSendAtt);
                }
            }
            if(!toSendAtt.isEmpty()){ 
                displayList.addAll(sendAccountAttachmentList(toSendAtt,mapParent));//get data from account-attachments
                
            }
        }
        
        return displayList;
    } 
    
    /* This function is used for displaying Events historic data */
    @AuraEnabled
    Public static List<DocumentWrapper> getAttachmentListEvents(){
        Id currentAccountID =  fetchAccountId();   
        List<DocumentWrapper> eventsList = new List<DocumentWrapper>(); 
        Set<Id> parentId = new Set<Id>();
        List<Account_Attachments__c> toSendAtt = new List<Account_Attachments__c>();
        List<ContentDocumentLink> uniqueContentList = new List<ContentDocumentLink>();
        Map<Id,Account_Attachments__c> objMap = new Map<Id,Account_Attachments__c>();
        List<Account_Attachments__c> accList = new List<Account_Attachments__c>();
        for(Account_Attachments__c qc : [Select Id,Name,Account__c,Account__r.Name,Account__r.AccountNumber,of_Attendees__c,Attendees__c,Monthly_Uploaded_Date__c,Type__c,Attachment_Name__c,Last_Upload_Date__c,Start_Month_Date__c,Topic__c,Training_Date__c from Account_Attachments__c where Account__c =: currentAccountID and Type__c =: Cargill_BaxterUtility.typeEvents and Start_Month_Date__c >= LAST_N_MONTHS:12 and Start_Month_Date__c <= THIS_MONTH order by CreatedDate DESC]){
            parentId.add(qc.id);
            objMap.put(qc.id, qc);
            accList.add(qc);
        }
        List<ContentDocumentLink> contentLink = new List<ContentDocumentLink>();
        if(!parentId.isEmpty())
            contentLink = [SELECT ContentDocumentId,ContentDocument.Title,ContentDocument.FileExtension,Id,LinkedEntityId FROM ContentDocumentLink where LinkedEntityId IN :parentId];
        
        Map<Id,ContentDocumentLink> mapParent = new Map<Id,ContentDocumentLink>();
        if(!contentLink.isEmpty()){
            for(ContentDocumentLink cd : contentLink){
                if(!mapParent.containsKey(cd.LinkedEntityId))
                    uniqueContentList.add(cd);
                    
                mapParent.put(cd.LinkedEntityId,cd);
            }
        
            eventsList.addAll(sendDocumentList(uniqueContentList,objMap));//get data from contentdocuments
        }
        if(!accList.isEmpty()){
            for(Account_Attachments__c ac : accList){
                if(!mapParent.containsKey(ac.Id)){
                    toSendAtt.add(ac);
                    System.debug('##Called Function'+toSendAtt);
                }
            }
            if(!toSendAtt.isEmpty()){ 
                eventsList.addAll(sendAccountAttachmentList(toSendAtt,mapParent));//get data from account-attachments
            }
        }
        
        return eventsList;
    } 
    
    /* This function is used for displaying prospect list historic data */
    @AuraEnabled
    Public static List<DocumentWrapper> getAttachmentListProspect(){
        Id currentAccountID =  fetchAccountId();   
        List<DocumentWrapper> prospectList = new List<DocumentWrapper>(); 
        Set<Id> parentId = new Set<Id>();
        List<Account_Attachments__c> toSendAtt = new List<Account_Attachments__c>();
        List<ContentDocumentLink> uniqueContentList = new List<ContentDocumentLink>();
        Map<Id,Account_Attachments__c> objMap = new Map<Id,Account_Attachments__c>();
        List<Account_Attachments__c> accList = new List<Account_Attachments__c>();
        for(Account_Attachments__c qc : [Select Id,Name,Account__c,Account__r.Name,Account__r.AccountNumber,of_Attendees__c,Attendees__c,Monthly_Uploaded_Date__c,Type__c,Attachment_Name__c,Last_Upload_Date__c,Start_Month_Date__c,Topic__c,Training_Date__c from Account_Attachments__c where Account__c =: currentAccountID and Type__c =: Cargill_BaxterUtility.typeProspectList and Last_Upload_Date__c >= LAST_N_MONTHS:12 and Last_Upload_Date__c <= THIS_MONTH order by CreatedDate DESC]){
            parentId.add(qc.id);
            objMap.put(qc.id, qc);
            accList.add(qc);
        }
        List<ContentDocumentLink> contentLink = new List<ContentDocumentLink>();
        if(!parentId.isEmpty())
            contentLink = [SELECT ContentDocumentId,ContentDocument.Title,ContentDocument.FileExtension,Id,LinkedEntityId FROM ContentDocumentLink where LinkedEntityId IN :parentId];
        
        Map<Id,ContentDocumentLink> mapParent = new Map<Id,ContentDocumentLink>();
        for(ContentDocumentLink cd : contentLink){
            if(!mapParent.containsKey(cd.LinkedEntityId))
                uniqueContentList.add(cd);
        
            mapParent.put(cd.LinkedEntityId,cd);
        }
        if(!contentLink.isEmpty()){
            prospectList.addAll(sendDocumentList(uniqueContentList,objMap));//get data from contentdocuments
        }
        if(!accList.isEmpty()){
            for(Account_Attachments__c ac : accList){
                if(!mapParent.containsKey(ac.Id)){
                    toSendAtt.add(ac);
                    System.debug('##Called Function'+toSendAtt);
                }
            }
            if(!toSendAtt.isEmpty()){ 
                prospectList.addAll(sendAccountAttachmentList(toSendAtt,mapParent));//get data from account-attachments
            }
        }
        
        return prospectList;
    } 
    
    /* This function is used for displaying training historic data */
    @AuraEnabled
    Public static List<DocumentWrapper> getAttachmentListTraining(){
        Id currentAccountID =  fetchAccountId();   
        List<DocumentWrapper> trainingList = new List<DocumentWrapper>(); 
        Set<Id> parentId = new Set<Id>();
        List<Account_Attachments__c> toSendAtt = new List<Account_Attachments__c>();
        List<ContentDocumentLink> uniqueContentList = new List<ContentDocumentLink>();
        Map<Id,Account_Attachments__c> objMap = new Map<Id,Account_Attachments__c>();
        List<Account_Attachments__c> accList = new List<Account_Attachments__c>();
        for(Account_Attachments__c qc : [Select Id,Name,Account__c,Account__r.Name,Account__r.AccountNumber,of_Attendees__c,Attendees__c,Monthly_Uploaded_Date__c,Type__c,Attachment_Name__c,Last_Upload_Date__c,Start_Month_Date__c,Topic__c,Training_Date__c from Account_Attachments__c where Account__c =: currentAccountID and Type__c =: Cargill_BaxterUtility.typeTraining  and Training_Date__c >= LAST_N_MONTHS:12 and Training_Date__c <= THIS_MONTH order by CreatedDate DESC]){
            parentId.add(qc.id);
            objMap.put(qc.id, qc);
            accList.add(qc);
        }
        List<ContentDocumentLink> contentLink = new List<ContentDocumentLink>();
        if(!parentId.isEmpty())
            contentLink = [SELECT ContentDocumentId,ContentDocument.Title,ContentDocument.FileExtension,Id,LinkedEntityId FROM ContentDocumentLink where LinkedEntityId IN :parentId];
        
        Map<Id,ContentDocumentLink> mapParent = new Map<Id,ContentDocumentLink>();
        for(ContentDocumentLink cd : contentLink){
            if(!mapParent.containsKey(cd.LinkedEntityId))
                uniqueContentList.add(cd);
        
            mapParent.put(cd.LinkedEntityId,cd);
        }
        if(!contentLink.isEmpty()){
            trainingList.addAll(sendDocumentList(uniqueContentList,objMap));//get data from contentdocuments
        }
        if(!accList.isEmpty()){
            for(Account_Attachments__c ac : accList){
                if(!mapParent.containsKey(ac.Id)){
                    toSendAtt.add(ac);
                    System.debug('##Called Function'+toSendAtt);
                }
            }
            if(!toSendAtt.isEmpty()){ 
                trainingList.addAll(sendAccountAttachmentList(toSendAtt,mapParent));//get data from account-attachments
            }
        }
        
        return trainingList;
    } 
    
    /* Used for deleting content document record for replace functionality */
    @AuraEnabled
    public static void UpdateDocumentAttachment(String accid){
        Set<Id> documentId = new Set<Id>();
        List<Account_Attachments__c> docListUpdate = new List<Account_Attachments__c>();
        try{
            if(!String.isBlank(accid)){
                List<ContentDocumentLink> contentDocList = [SELECT ContentDocumentId,Id,LinkedEntityId FROM ContentDocumentLink where LinkedEntityId =: accid];    
                if(!contentDocList.isEmpty()){
                    for(ContentDocumentLink doc : contentDocList){
                        documentId.add(doc.ContentDocumentId);   
                    }
                }
                if(!documentId.isEmpty()){
                    Database.DeleteResult[] drList;
                    List<ContentDocument> docList = [Select Id from ContentDocument where Id IN :documentId];
                    if(!docList.isEmpty())
                        drList = Database.delete(docList);
                    for(Database.DeleteResult dr : drList) {

                        if (dr.isSuccess()) {
                            // Operation was successful, so get the ID of the record that was processed
                            System.debug('Successfully deleted account with ID: ' + dr.getId());
                            List<Account_Attachments__c> accListUpdate = [Select Id,Attachment_Name__c,Type__c from Account_Attachments__c where Id =:accid];
                            if(!accListUpdate.isEmpty()){
                                for(Account_Attachments__c acclt : accListUpdate){
                                    acclt.Attachment_Name__c = '';
                                    docListUpdate.add(acclt);
                                }
                            }
                            if(!docListUpdate.isEmpty())
                                update docListUpdate;
                        }
                    }
                }
            }
        }catch(Exception e){
            System.debug('Error in DML'+e.getMessage());
        }
    }
    
    /* Inner function which returns wrapper list which contains document name and account attachment details */
    public static List<DocumentWrapper> sendDocumentList(List<ContentDocumentLink> contentLink1, Map<Id,Account_Attachments__c> objMap1){
        List<DocumentWrapper> documentList1 = new List<DocumentWrapper>(); 
        if(!contentLink1.isEmpty()){
            for(ContentDocumentLink clink : contentLink1){
                if(objMap1.containsKey(clink.LinkedEntityId)){
                    DocumentWrapper obj = new DocumentWrapper();
                    obj.Name = objMap1.get(clink.LinkedEntityId).Name;
                    obj.currentId = objMap1.get(clink.LinkedEntityId).Id;
                    obj.Attendees_Count = Integer.valueOf(objMap1.get(clink.LinkedEntityId).of_Attendees__c);
                    obj.Account = objMap1.get(clink.LinkedEntityId).Account__r.Name;
                    obj.Attachment_Name = clink.ContentDocument.Title + '.' + clink.ContentDocument.FileExtension;
                    obj.Attendee_Name = objMap1.get(clink.LinkedEntityId).Attendees__c;
                    if(objMap1.get(clink.LinkedEntityId).Last_Upload_Date__c != null)
                        obj.UploadDate = Date.newInstance(objMap1.get(clink.LinkedEntityId).Last_Upload_Date__c.year(),objMap1.get(clink.LinkedEntityId).Last_Upload_Date__c.month(),objMap1.get(clink.LinkedEntityId).Last_Upload_Date__c.day());
                    obj.MonthlyUploadDate = objMap1.get(clink.LinkedEntityId).Monthly_Uploaded_Date__c;
                    obj.StartMonthDate = objMap1.get(clink.LinkedEntityId).Start_Month_Date__c; 
                    obj.Topic_Name = objMap1.get(clink.LinkedEntityId).Topic__c;
                    obj.Training_Date = objMap1.get(clink.LinkedEntityId).Training_Date__c;
                    obj.Type = objMap1.get(clink.LinkedEntityId).Type__c;
                    documentList1.add(obj);
                }
            }
        }
        return documentList1;
    }
    
    /* Inner function which returns wrapper list which contains account attachment details only */
    public static List<DocumentWrapper> sendAccountAttachmentList(List<Account_Attachments__c> accList1,Map<Id,ContentDocumentLink> mapParent1){
        List<DocumentWrapper> documentList2 = new List<DocumentWrapper>();
        if(!accList1.isEmpty()){
            for(Account_Attachments__c acp : accList1){
                if(!mapParent1.containsKey(acp.Id)){
                    DocumentWrapper obj = new DocumentWrapper();
                    obj.Name = acp.Name;
                    obj.currentId = acp.Id;
                    obj.Attendees_Count = Integer.valueOf(acp.of_Attendees__c);
                    obj.Account = acp.Account__r.name;
                    obj.Attendee_Name = acp.Attendees__c;
                    if(acp.Last_Upload_Date__c != null)
                        obj.UploadDate = Date.newInstance(acp.Last_Upload_Date__c.year(),acp.Last_Upload_Date__c.month(),acp.Last_Upload_Date__c.day());
                    obj.MonthlyUploadDate = acp.Monthly_Uploaded_Date__c;
                    obj.StartMonthDate = acp.Start_Month_Date__c; 
                    obj.Topic_Name = acp.Topic__c;
                    obj.Training_Date = acp.Training_Date__c;
                    obj.Type = acp.Type__c;
                    documentList2.add(obj);
                }
            }
        }
        return documentList2;
    }
    
    /* Function which returns community name details */
    @AuraEnabled
    public static String getCommunityDetails(){
        return System.Site.getPathPrefix();
    }
    
    /* Function which returns account id from logged in user */
    public static Id fetchAccountId(){
        ID userId = UserInfo.getUserId();
        List<User> userList = [Select AccountId,ContactId,Id,Username,Email from user where Id = :userId];
        ID AccountId;
        if(!userList.isEmpty())
            AccountId = userList[0].AccountId;
        
        return AccountId;
    }
    
    /* This function is used to provide list of picklist values for selection purpose on mobile community*/    
    @AuraEnabled
    public static List<String> FetchDocumentType(){
        List<String> typesNames = new List<String>();
        List<Document_Types__c> listTypes = [Select Name from Document_Types__c];
        for(Document_Types__c ltypes: listTypes){
            typesNames.add(ltypes.Name);
        }
        return typesNames;
    }
    
    /* This function is used to provide list of tabs for which history can be made available*/
    @AuraEnabled
    public static List<String> FetchHistoricType(){
        List<String> historyTypes = new List<String>();
        List<Document_Types__c> listHistoryTypes = [Select Name,Is_History_Available__c from Document_Types__c where Is_History_Available__c = True];
        for(Document_Types__c ltypeshistory: listHistoryTypes){
            historyTypes.add(ltypeshistory.Name);
        }
        return historyTypes;
    }
    
    /* Inner class for wrapper mapping */
    public class DocumentWrapper{
        @AuraEnabled
        public String Name {get;set;}
        @AuraEnabled
        public ID currentId{get; set;}
        @AuraEnabled
        public Integer Attendees_Count {get;set;}
        @AuraEnabled
        public String Account {get;set;}
        @AuraEnabled
        public String Attachment_Name {get;set;}
        @AuraEnabled
        public String Attendee_Name {get;set;}
        @AuraEnabled
        public Date UploadDate {get;set;}
        @AuraEnabled
        public Date MonthlyUploadDate {get;set;}
        @AuraEnabled
        public Date StartMonthDate {get;set;}
        @AuraEnabled
        public String Topic_Name{get; set;}
        @AuraEnabled
        public Date Training_Date{get;set;}
        @AuraEnabled
        public String Type{get;set;}
    }
}