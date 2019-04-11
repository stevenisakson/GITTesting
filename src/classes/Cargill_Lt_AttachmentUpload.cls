/*******
* CreatedDate : 29-06-2018
* Author : Amrish Surve
* Description : Contains method which are used for creating a Account Document record, check existing document records
*******/

public with sharing class Cargill_Lt_AttachmentUpload {
    
    /* Method which gets account details */
    @AuraEnabled
    public static List<Account> getAccountRecord(){
        Id currentAccountID3 =  fetchAccountId();
        return new List<Account>([Select id,Name,Phone,Type,AccountNumber,External_Id__c,Dealer_External_ID__c from Account where Id =:currentAccountID3 LIMIT 1]);
    }
    
    /* Method which gets contact details */
    @AuraEnabled
    public static List<Contact> getContactRecord(){ 
        Id currentAccountID4 =  fetchAccountId();    
        return new List<Contact>([Select id,Name,Phone,Email,firstname,lastname,AccountId,Dealer_Contact__c from Contact where AccountId =:currentAccountID4 and Dealer_Contact__c = True LIMIT 1]);
    }
    
    /* Method which create account document record */
    @AuraEnabled
    public static Id createRecord(Account_Attachments__c monthlyattach, String monthSel, Integer yearSel, String Type){

        if(Schema.sObjectType.Account_Attachments__c.isCreateable()){
         
            Date myDate;
            Map<String,Integer> monthMap = new Map<String,Integer>();
            List<Cargill_MonthYearDropDown__c> listMonthsCal = [Select Seq__c,Name,Type__c from Cargill_MonthYearDropDown__c where Type__c =: Cargill_BaxterUtility.createTypeRecord order by Seq__c ASC];
            for(Cargill_MonthYearDropDown__c mon: listMonthsCal){
                monthMap.put(mon.Name,Integer.valueOf(mon.Seq__c));
            }
            System.debug('$monthMap$'+monthMap);
            Map<String,Id> recordTypeMap = new Map<String,Id>();
            List<RecordType> lstRt = [SELECT DeveloperName,Id,IsActive,Name FROM RecordType where sobjectType =:Cargill_BaxterUtility.getObjectType];
            if(!lstRt.isEmpty()){
                for(RecordType rt : lstRt){
                    recordTypeMap.put(rt.Name,rt.Id);   
                }
            }
            if(monthSel != null && yearSel != null){
                Integer todayDay;
                todayDay = Date.Today().day();
                System.debug('$monthMap after$'+monthMap.get(monthSel));
                DateTime myDateTime = DateTime.newInstance(yearSel, monthMap.get(monthSel), todayDay, 0, 0, 0);
                myDate = myDateTime.date();
            }
            try{
                if(monthlyattach != null){
                    if(myDate != null && !String.isBlank(Type) && Type == Cargill_BaxterUtility.typeDisplay)
                        monthlyattach.Monthly_Uploaded_Date__c = myDate;
                    
                    if(!string.isBlank(Type)){
                        monthlyattach.RecordTypeId = recordTypeMap.get(Type);
                        monthlyattach.Type__c = Type;
                    }
                    monthlyattach.Account__c = fetchAccountId();
                    insert monthlyattach;
                }
                
            }catch(Exception e){}
            
        }
        return monthlyattach.Id;
    }
    
    
    /* Method which gives login user account details*/
    public static Id fetchAccountId(){
        ID userId = UserInfo.getUserId();
        List<User> userList = [Select AccountId,ContactId,Id,Username,Email from user where Id = :userId];
        ID AccountId;
        if(!userList.isEmpty())
            AccountId = userList[0].AccountId;
        
        return AccountId;
    }
    
    /* used for displaying historic display data */
    @AuraEnabled
    public static List<Account_Attachments__c> displayMonthlyList(){
        Id currentAccountID =  fetchAccountId();   
        return [Select Id,Name,Account__c,Account__r.Name,Account__r.AccountNumber,Monthly_Uploaded_Date__c,Type__c,Attachment_Name__c from Account_Attachments__c where Account__c =: currentAccountID and Type__c =: Cargill_BaxterUtility.typeDisplay and Monthly_Uploaded_Date__c >= Last_n_months:2 and Monthly_Uploaded_Date__c <= THIS_MONTH order by CreatedDate DESC]; 
    }
    
    /* used for displaying historic events data */    
    @AuraEnabled
    public static List<Account_Attachments__c> displayQuarterlyList(){
        Id currentAccountID1 =  fetchAccountId(); 
        return [Select Id,Name,Account__c,Account__r.Name,Account__r.AccountNumber,Monthly_Uploaded_Date__c,Type__c,Start_Month_Date__c,Attachment_Name__c from Account_Attachments__c where Account__c =: currentAccountID1 and Type__c =: Cargill_BaxterUtility.typeEvents and Start_Month_Date__c >= LAST_N_QUARTERS:1 and Start_Month_Date__c <= THIS_QUARTER order by CreatedDate DESC];
    }
    
    /* used for displaying historic training data */
    @AuraEnabled
    public static List<Account_Attachments__c> displayTrainingList(){
        Id currentAccountID2 =  fetchAccountId();
        return [Select Id,Name,Account__c,Account__r.Name,Account__r.AccountNumber,Monthly_Uploaded_Date__c,Type__c,Start_Month_Date__c,Training_Date__c,Topic__c,of_Attendees__c,Attendees__c,Attachment_Name__c from Account_Attachments__c where Account__c =: currentAccountID2 and Type__c =: Cargill_BaxterUtility.typeTraining  and Training_Date__c >= LAST_N_MONTHS:5 and Training_Date__c <= THIS_MONTH order by CreatedDate DESC];
    }
    
    /* used for displaying historic prospect data */
    @AuraEnabled
    public static List<Account_Attachments__c> displayProspectList(){
        Id currentAccountID5 =  fetchAccountId();
        return [Select Id,Name,Account__c,Account__r.Name,Account__r.AccountNumber,Monthly_Uploaded_Date__c,Type__c,Start_Month_Date__c,Training_Date__c,Topic__c,of_Attendees__c,Attendees__c,Last_Upload_Date__c,Attachment_Name__c from Account_Attachments__c where Account__c =: currentAccountID5 and Type__c =: Cargill_BaxterUtility.typeProspectList order by CreatedDate DESC];
    }
    
    /* Method used for displaying display dashboard */
    @AuraEnabled
    public static Boolean checkMonthlyList(String currentMonthID){
        Id currentAccountID6;
        if(!String.isBlank(currentMonthID))
            currentAccountID6 = currentMonthID;
        else
            currentAccountID6 =  fetchAccountId();
            
        List<Account_Attachments__c> mattach = [Select Id,Name,Account__c,Account__r.Name,Account__r.AccountNumber,Monthly_Uploaded_Date__c,Type__c from Account_Attachments__c where Account__c =: currentAccountID6 and Type__c =: Cargill_BaxterUtility.typeDisplay and Monthly_Uploaded_Date__c = THIS_MONTH order by CreatedDate ASC];
        
        if(!mattach.isEmpty()){
            Set<Id> parentIdset = new Set<Id>();
            Boolean monthlyFlag;
            for(Account_Attachments__c disAtt : mattach){
                parentIdset.add(disAtt.Id);
            }
            if(!parentIdset.isEmpty())
                   monthlyFlag = checkContentDocument(parentIdset);
                   
            return monthlyFlag;
        }
        return False;
    }
    
    /* common method which checks if record is present or not and return boolean value */
    public static Boolean checkContentDocument(Set<Id> parentID){
        if(parentID != null){
            List<ContentDocumentLink> contentList = [SELECT ContentDocumentId,Id,LinkedEntityId,Visibility FROM ContentDocumentLink where LinkedEntityId IN :parentID];
            if(!contentList.isEmpty())
                return True;
            else    
                return False;
        }
        return False;
    }
    
    /* Method used for displaying events dashboard */
    @AuraEnabled
    public static Boolean checkQuarterlyList(String currentEventID){
        Id currentAccountID7;
        if(!String.isBlank(currentEventID))
            currentAccountID7 =  currentEventID;
        else
            currentAccountID7 =  fetchAccountId();
            
        List<Account_Attachments__c> qattach = [Select Id,Name,Account__c,Account__r.Name,Account__r.AccountNumber,Monthly_Uploaded_Date__c,Type__c,Start_Month_Date__c from Account_Attachments__c where Account__c =: currentAccountID7 and Type__c =:Cargill_BaxterUtility.typeEvents and Start_Month_Date__c = THIS_QUARTER order by CreatedDate ASC];
        if(!qattach.isEmpty()){
            Set<Id> parentId1set = new Set<Id>();
            for(Account_Attachments__c eventdoc : qattach){
                 parentId1set.add(eventdoc.Id);   
            }
            Boolean quarterlyFlag = checkContentDocument(parentId1set);
            return quarterlyFlag;
        }
        return False;
        
    }
    
    /* Method used for displaying training dashboard */
    @AuraEnabled
    public static Boolean checkTrainingList(String currentTrainingID){
        Id currentAccountID8;
        if(!String.isBlank(currentTrainingID))
            currentAccountID8 =  currentTrainingID;
        else
            currentAccountID8 =  fetchAccountId();
        List<Account_Attachments__c> tattach = [Select Id,Name,Account__c,Account__r.Name,Account__r.AccountNumber,Monthly_Uploaded_Date__c,Type__c,Start_Month_Date__c,Training_Date__c,Topic__c,of_Attendees__c,Attendees__c from Account_Attachments__c where Account__c = : currentAccountID8 and Type__c =: Cargill_BaxterUtility.typeTraining and (Training_Date__c = LAST_N_MONTHS:11 OR Training_Date__c = THIS_MONTH) order by CreatedDate ASC];
        Boolean trainFlag;
        if(!tattach.isEmpty())
            trainFlag = True;
        else
            trainFlag = False;
            
        return trainFlag;  
    }
    
    /* Method used for displaying prospect dashboard */
    @AuraEnabled
    public static Boolean checkProspectList(String currentProspectID){
        Id currentAccountID9;
        if(!string.isBlank(currentProspectID))
            currentAccountID9 =  currentProspectID;    
        else
            currentAccountID9 =  fetchAccountId();    
        List<Account_Attachments__c> pattach = [Select Id,Name,Account__c,Account__r.Name,Account__r.AccountNumber,Monthly_Uploaded_Date__c,Type__c,Start_Month_Date__c,Training_Date__c,Topic__c,of_Attendees__c,Attendees__c,Last_Upload_Date__c from Account_Attachments__c where Account__c =: currentAccountID9 and Type__c =: Cargill_BaxterUtility.typeProspectList and Last_Upload_Date__c = THIS_MONTH order by CreatedDate ASC];
        if(!pattach.isEmpty()){
            Set<Id> parentId2set = new Set<Id>();
            for(Account_Attachments__c pLst : pattach){
               parentId2set.add(pLst.Id); 
            }
            Boolean prospectFlag = checkContentDocument(parentId2set);
            return prospectFlag;
        }
        return False;    
    }
    
    
    
    /* used for deleting content document record for update purpose */
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
                            List<Account_Attachments__c> accListUpdate = [Select Id,Attachment_Name__c from Account_Attachments__c where Id =:accid];
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
    
    /* This function provides month values which is being displayed in UI */
    @AuraEnabled
    public static List<String> getMonths(){
        List<String> monthNames = new List<String>();
        List<Cargill_MonthYearDropDown__c> listMonths = [Select Seq__c,Name,Type__c from Cargill_MonthYearDropDown__c where Type__c =: Cargill_BaxterUtility.cargillSettingTypeM order by Seq__c ASC];
        for(Cargill_MonthYearDropDown__c mon: listMonths){
            monthNames.add(mon.Name);
        }
        return monthNames;
    }
    
    /* This function provides year values which is being displayed in UI */
    @AuraEnabled
    public static List<String> getYears(){
        List<String> yearNames = new List<String>();
        List<Cargill_MonthYearDropDown__c> listYears = [Select Seq__c,Name,Type__c from Cargill_MonthYearDropDown__c where Type__c =: Cargill_BaxterUtility.cargillSettingTypeY order by Seq__c ASC];
        for(Cargill_MonthYearDropDown__c year: listYears){
            yearNames.add(year.Name);
        }
        return yearNames;
    }
    
    /* This function is used to display growth Metrics data */
    @AuraEnabled
    public static List<Cargill_Growth_Metrics__c> displayGrowthData(){
        Id dealerID =  fetchAccountId();
        System.debug('$$dealerID$'+dealerID);
        Date fetchDealerChildCrDate = fetchLastCreatedDate(dealerID, Cargill_BaxterUtility.childRecords);
        List<Cargill_Growth_Metrics__c> childList = [Select Id,Name,Growth_Metrics__c,Account__c,Account__r.Name,Account__r.External_Id__c,YTD_Tons__c,Product_Line__c,YTD_Goal__c,Pace__c,Pace_Percent__c from Cargill_Growth_Metrics__c where Account__c =:dealerID order by YTD_Tons__c DESC];
        System.debug('$$childList$'+childList);
        return childList;
    }
    
    /* This function provides last createddate for child Growth data */
    public static Date fetchLastCreatedDate(Id extId, String type){
        Date myDate;
        DateTime maxDate;
        if(String.isnotBlank(extId) && String.isnotBlank(type)){
            //if(type == Cargill_BaxterUtility.parentRecords)
                maxDate= [Select CreatedDate,Account__c from Cargill_Growth_Metrics__c where Account__c =:extId order by CreatedDate DESC limit 1].createdDate;
            /*else if(type == Cargill_BaxterUtility.childRecords)
                maxDate= [Select CreatedDate,Account__c from Cargill_Growth_Metrics__c where Growth_Metrics__c != '' and Account__c =:extId order by CreatedDate DESC limit 1].createdDate;
            */
            if(maxDate != null){
                myDate = date.newinstance(maxDate.year(), maxDate.month(), maxDate.day());
                return myDate;
            }
        }
        return myDate;
    }
    
    /* This function returns account name */
    @AuraEnabled
    public Static String DisplayLoginAccountName(){
        ID userId = UserInfo.getUserId();
        List<User> userList = [Select AccountId,Account.Name,ContactId,Id,Username,Email from user where Id = :userId];
        String AccountName;
        if(!userList.isEmpty())
            AccountName = userList[0].Account.Name;
        
        return AccountName;
    }
    
    /* This function returns Parent growth data */
    @AuraEnabled
    public Static List<Cargill_Growth_Metrics__c> displayParentGrowthData(){
        Id dealerParentID =  fetchAccountId();
        Date fetchDealerCrDate = fetchLastCreatedDate(dealerParentID, Cargill_BaxterUtility.parentRecords);
        List<Cargill_Growth_Metrics__c> parentGrowthList =  [Select Id,Name,Account__c,Account__r.Name,Account__r.External_Id__c,YTD_Tons__c,Full_Year_Tons_Goal__c,Growth_Metrics__c,Product_Line__c,Tons_Needed_to_Hit_Goal__c,YTD_Goal__c,Pace__c from Cargill_Growth_Metrics__c where createdDate >= :fetchDealerCrDate and Account__c =:dealerParentID and Growth_Metrics__c = '' order by YTD_Tons__c ASC NULLS LAST];
        return parentGrowthList;
    }
    
    /* This function sets the boolean value for Growth metrics visual */
    @AuraEnabled
    public Static Boolean checkGrowthMetrix(String currentGrowthID){
        Id dealerID;
        if(!String.isBlank(currentGrowthID))
            dealerID = currentGrowthID;
        else
            dealerID =  fetchAccountId();
        System.debug('@@dealerID@@'+dealerID);   
        List<Cargill_Growth_Metrics__c> growthPercent = [Select Growth_Metrics__c,Id,Name,Account__c,YTD_Goal__c,Pace__c,Pace_Percent__c from Cargill_Growth_Metrics__c where Account__c=:dealerID and Product_Line__c = '' order by Name ASC];
        System.debug('$$$List'+growthPercent);
        Boolean gFlag;
        if(!growthPercent.isEmpty()){
            if(growthPercent[0].Pace_Percent__c >= 3)
                gFlag = True;
            else
                gFlag = False;
        }
        return gFlag;
    }
    
    /* This function is used to fetch latest date */
    @AuraEnabled
    public Static Date fetchLatestLoadedDate(){
        Date fetchDate;
        Id dealerChildID =  fetchAccountId();
        fetchDate = fetchLastCreatedDate(dealerChildID, Cargill_BaxterUtility.childRecords);
        return fetchDate;
    }
    
    @AuraEnabled
    public static String getCommunityDetails(){
        return System.Site.getPathPrefix();
    }
    
    
    /* This function sets the boolean value for Growth metrics visual updated */
    @AuraEnabled
    public Static Boolean checkGrowthMetrixV1(String currentProductGrowthID){
        Id dealerChildID;
        if(!String.isBlank(currentProductGrowthID))
            dealerChildID = currentProductGrowthID;
        else
            dealerChildID =  fetchAccountId(); 
            
        List<Contact> contactLst = [Select Id,Flip_a_switch__c,AccountId,Dealer_Contact__c from contact where AccountId = :dealerChildID and Dealer_Contact__c = True];
        Boolean productFlag;
        if(!contactLst.isEmpty()){
            if(contactLst[0].Flip_a_switch__c == False)
                productFlag = True;
            else
                productFlag = False;
        }
        return productFlag;   
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
}