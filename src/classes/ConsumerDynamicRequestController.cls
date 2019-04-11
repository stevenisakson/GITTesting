/******************************************************************
** Author: Poonam Yadav
** Date: 27-Sep-2018
** Paramters: Id (AccountId)
** Description: Controller class for newReq.Page for Consumer account type CPN INDIA
** History-----------------------------------------------------
*******************************************************************/

public with sharing class ConsumerDynamicRequestController{

    public string pageStatus;
    public String newPageStatus;
    public string accountBusinessUnit;
    public Id getRequestId {get;set;}
    public Id getAccountId {get;set;}
    public boolean renderNew {get;set;}
    public boolean renderEdit {get;set;}
    public String getAccountName {get;set;}
    public String reqDescription {get;set;}
    public List<Consumer_Protected_Fields__c> tpFields {get; set;}
    public List<wFieldWrapper> wrapperList {get; set;}
    public Set<String> setFields = new Set<String>();
    public Request__c getRequestInfo {get;set;}
    public boolean renderCloned {get;set;}
    public map<string, string> fieldLabelMap;
    public String business {get;set;}
   
    public ConsumerDynamicRequestController() {
        
        pageStatus = ApexPages.currentPage().getParameters().get('status');
        getAccountId = ApexPages.currentPage().getParameters().get('AccId');
        getRequestId = ApexPages.currentPage().getParameters().get('ReqId');
        
        accountBusinessUnit = [SELECT Business__c FROM Account WHERE Id =: getAccountId LIMIT 1].Business__c;
        
        //Checks if the Page Status from parameters if NEW
        if(pageStatus=='New'){
            renderNew = true;
            renderEdit = false;
        }
         //Checks if the Page Status from parameters if Edit/Clone
        else{
            Id userProfileId = UserInfo.getProfileId();
            Id dataStewardId = [SELECT Id FROM Profile WHERE Name LIKE '%Data Steward%' LIMIT 1].Id;
            Id sysAdminId = [SELECT Id FROM Profile WHERE Name LIKE '%System Administrator%' LIMIT 1].Id;
            getRequestInfo = [select Id, Status__c, Description__c,cloned__c from Request__c where Id =: getRequestId];
            
            Set<String> dataStewardIdSet = new Set<String>();
            for(Profile s: [SELECT Id FROM Profile WHERE Name LIKE '%Data Steward%']){
                dataStewardIdSet.add(s.Id);
            }
            
            if(getRequestInfo.Status__c == 'Submitted'){
                if(dataStewardIdSet.contains(userProfileId) || userProfileId == sysAdminId || getRequestInfo.cloned__c == true) {
                    renderNew = false;
                    renderEdit = true;
                }
                else{
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Cannot edit, Record has been Submitted'));
                    renderNew = false;
                    renderEdit = false;
                }
            }
            
            else if((getRequestInfo.Status__c == 'Approved' || getRequestInfo.Status__c == 'Rejected') ){
                if(userProfileId == sysAdminId){
                    renderNew = false;
                    renderEdit = true;
                }
                else{
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Cannot Edit, Record has been Approved/Rejected'));
                    renderNew = false;
                    renderEdit = false;
                }
            }
            
            else if(getRequestInfo.Status__c == 'Draft'){
                renderNew = false;
                renderEdit = true;
            }
            
            if(pageStatus != 'Clone'){
                renderCloned = false;
            }
            else{
                renderCloned = true;
            }
        }
        
       tpFields = new List<Consumer_Protected_Fields__c>([SELECT Field_Name__c,Field_Label__c,Name FROM Consumer_Protected_Fields__c WHERE Business_Unit__c =: accountBusinessUnit ORDER BY Order__c]);
        fieldLabelMap = new Map<String,String>();
        system.debug('@@@@csFields' + tpFields);
        
        if(!tpFields.isEmpty()){
            for(Consumer_Protected_Fields__c s: tpFields){
                setFields.add(s.Field_Name__c);
                fieldLabelMap.put(s.Field_Name__c,s.Field_Label__c);
            }
            
            system.debug('@@@@setFields' + setFields);
        }
        else{
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'No Fields Associated with Account Business Unit: ' + accountBusinessUnit)); 
        }  
        
    }
    
   
    /******************************************************************
    ** Parameter: None
    ** Returns: List<wFieldWrapper>
    ** Description: Return Field values to be displayed on VF Page
    *******************************************************************/  
    public list<wFieldWrapper> getFields(){
        if(wrapperList == null){
            wrapperList = new List<wFieldWrapper>();
            if(pageStatus=='New'){
                 wrapperList.Add(new wFieldWrapper(getAccount(), getAccount()));
            }
            else{
                wrapperList.Add(new wFieldWrapper(getAccount(), assignValues()));
            }
        }
        
        System.Debug('Wrapper Contains: ' + wrapperList);
        
        return wrapperList;
    }
    /******************************************************************/ 
    /******************************************************************
    ** Parameter: None
    ** Returns: SOQL for Account.
    ** Description: Method that queries field from Account based on the Request Account.
    *******************************************************************/ 
    public Account getAccountInfo(){
        return [select Id, Name, Legal_Name__c,Status__c, Business__c from account where Id =: getAccountId];
    }
    /******************************************************************/
    
    /******************************************************************
    ** Parameter: None
    ** Returns: SOQL for Account.
    ** Description: Method that queries field from Account based on the custom setting.
    *******************************************************************/    
    public Account getAccount(){
        String soql = 'Select id,Parent.Name ';
        for(Consumer_Protected_Fields__c fieldName : [SELECT Field_Name__c,Field_Label__c,Name FROM Consumer_Protected_Fields__c WHERE Business_Unit__c =: accountBusinessUnit ORDER BY Order__c]){
          soql = soql + ', ' + fieldName.Field_Name__c;
          setFields.add(fieldName.Field_Name__c);
        }
        soql = soql + ' From Account where id = :getAccountId';
        System.Debug('getAccount: ' +(Account)Database.Query(soql));
        return (Account)Database.Query(soql);
    }
    /******************************************************************/
    
    /******************************************************************
    ** Parameter: None
    ** Returns: account record.
    ** Description: Method that returns to the record page.
    *******************************************************************/     
    public PageReference cancel(){
        if(pageStatus=='New'){
            PageReference home = new PageReference('/'+getAccountId);
            home.setRedirect(true);       
            return home;
        }
        else if(pageStatus=='Clone'){
          
            Request__c urq = new Request__c();
            urq.Id = getRequestId;
            urq.Status__c = 'Draft';
            update urq;
         
            
            Request__c rq = new Request__c();
            rq.Id = getRequestId;
            delete rq;
            
            Account[] accts = [SELECT Id from Account WHERE ID =: getAccountId];
            Approval.UnlockResult[] ulrList = Approval.unlock(accts, false);
            
            for(Approval.UnlockResult ulr : ulrList) {
                if (ulr.isSuccess()) {
                    System.debug('Successfully unlocked account with ID: ' + ulr.getId());
                }
                else {               
                    for(Database.Error err : ulr.getErrors()) {
                        System.debug('The following error has occurred.');                    
                        System.debug(err.getStatusCode() + ': ' + err.getMessage());
                        System.debug('Account fields that affected this error: ' + err.getFields());
                    }
                }
            }
            //end update
            
            id oldReqId = ApexPages.currentPage().getParameters().get('oldReqId');
            PageReference home = new PageReference('/'+oldReqId);
            home.setRedirect(true);       
            return home;
        }
        else
        {
            PageReference home = new PageReference('/'+getRequestId);
            home.setRedirect(true);       
            return home;
        }
    }
    /******************************************************************/ 
      /******************************************************************
    ** Parameter: None
    ** Returns: Account Values
    ** Description: Set Accounts Values based on the RequestLineItem values
    *******************************************************************/  
    public Account assignValues(){
        Account accOld = getAccount();
        Account acc = new Account();
        
        Map<String,String> valueMap = new Map<String, String>();
        for(RequestLineItem__c rli: [SELECT Field_Name__c, New_Value__c, Existing_Value__c FROM RequestLineItem__c WHERE Request__c =: getRequestId]){
            valueMap.put(rli.Field_Name__c, rli.New_Value__c);
        }
        system.debug('Temp Account: ' + valueMap);
        for(String rl: valueMap.keySet()){
            try{
                accOld.put(rl, Decimal.valueOf(valueMap.get(rl)));
            }
            catch (exception e) {
                if(valueMap.get(rl)=='true'){
                    accOld.put(rl, true);
                }
                else if(valueMap.get(rl)=='false'){
                    accOld.put(rl, false);
                }
                else{
                    accOld.put(rl, valueMap.get(rl));
                }
            }
        }
        system.debug('Temp Account: ' + accOld);
        
        return accOld;
    }
    /******************************************************************/ 
    
     /******************************************************************
    ** Parameter: None
    ** Returns: none
    ** Description: Save RequestLineItem Values on the vf page
    *******************************************************************/     
    public PageReference save(){
        
        if(pageStatus=='New'){
            System.Debug('#####OLD: ' + wrapperList[0].accOld);
            System.Debug('#####NEW: ' + wrapperList[0].accNew);
            
            Savepoint sp = Database.setSavepoint();
            try{  
                Request__c req = new Request__c();
                id consumerUpdateRecordTypeId = [Select Id From RecordType Where SobjectType = 'Request__c' AND DeveloperName = 'Consumer_Update'].Id;
               // id prospectconvertRTId =  [Select Id From RecordType Where SobjectType = 'Request__c' AND DeveloperName = 'Prospect_Conversion'].Id;
                List<RequestLineItem__c> tempRList = new List<RequestLineItem__c>();
                
                req.Account__c = getAccountId;
                req.Status__c = 'Draft';
                req.RecordTypeId = consumerUpdateRecordTypeId;
                req.Description__c = reqDescription;
                system.debug('Request Record: ' + req);
                insert req;    
                
                for(wFieldWrapper rl: wrapperList){
                    for(String s : setFields){
                        if(rl.accNew.get(s) != rl.accOld.get(s)){
                            RequestLineItem__c rli = new RequestLineItem__c();
                            rli.Field_Name__c = s;
                            rli.Field_Label__c = fieldLabelMap.get(s);
                            rli.request__c = req.Id;
                            rli.New_Value__c = String.valueOf(rl.accNew.get(s));
                            rli.Existing_Value__c = String.valueOf(rl.accOld.get(s));
                            try{
                                id myId = String.valueOf(rl.accNew.get(s));

                                Schema.SObjectType sobjectType = myId.getSObjectType();
                                String sobjectName = sobjectType.getDescribe().getName();
                                
                                SObject record = Database.query('Select Name From ' + sobjectName + ' Where Id = :myId limit 1');
                                
                                rli.New_Value_Display__c = String.valueOf(record.get('Name'));
                            }
                            catch(exception e){
                                rli.New_Value_Display__c = String.valueOf(rl.accNew.get(s));
                            }
                            
                            
                            try{
                                id myId = String.valueOf(rl.accOld.get(s));

                                Schema.SObjectType sobjectType = myId.getSObjectType();
                                String sobjectName = sobjectType.getDescribe().getName();
                                
                                SObject record = Database.query('Select Name From ' + sobjectName + ' Where Id = :myId limit 1');
                                
                                rli.Existing_Value_Display__c = String.valueOf(record.get('Name'));
                            }
                            catch(exception e){
                                rli.Existing_Value_Display__c = String.valueOf(rl.accOld.get(s));
                            }
                            tempRList.add(rli);
                        }
                    }
                }
                
                if(tempRList.size()>0){
                    insert tempRList;   
                    system.debug('Request Line Item: ' + tempRList);
                    PageReference home = new PageReference('/'+req.Id);
                    home.setRedirect(true);       
                    return home;  
                }else{
                  Database.rollback(sp);
                  ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Please update at least one field')); 
                }

    
             }
        
             catch (Exception ex) {
                 ApexPages.addMessages(ex);
                 system.debug(ex);
                 return null;
            }
        }
        else{
            
            System.Debug('#####NEW: ' + wrapperList[0].accNew);
            
            try{
                List<RequestLineItem__c> tempRList = new List<RequestLineItem__c>();
                for(wFieldWrapper rl: wrapperList){
                    for(String s : setFields){
                        if(rl.accNew.get(s) != rl.accOld.get(s)){
                            RequestLineItem__c rli = new RequestLineItem__c();
                            rli.Field_Name__c = s;
                            rli.Field_Label__c = fieldLabelMap.get(s);
                            rli.request__c = getRequestId;
                            rli.New_Value__c = String.valueOf(rl.accNew.get(s));
                            rli.Existing_Value__c = String.valueOf(rl.accOld.get(s));
                            try{
                                id myId = String.valueOf(rl.accNew.get(s));

                                Schema.SObjectType sobjectType = myId.getSObjectType();
                                String sobjectName = sobjectType.getDescribe().getName();
                                
                                SObject record = Database.query('Select Name From ' + sobjectName + ' Where Id = :myId limit 1');
                                
                                rli.New_Value_Display__c = String.valueOf(record.get('Name'));
                            }
                            catch(exception e){
                                rli.New_Value_Display__c = String.valueOf(rl.accNew.get(s));
                            }
                            
                            
                            try{
                                id myId = String.valueOf(rl.accOld.get(s));

                                Schema.SObjectType sobjectType = myId.getSObjectType();
                                String sobjectName = sobjectType.getDescribe().getName();
                                
                                SObject record = Database.query('Select Name From ' + sobjectName + ' Where Id = :myId limit 1');
                                
                                rli.Existing_Value_Display__c = String.valueOf(record.get('Name'));
                            }
                            catch(exception e){
                                rli.Existing_Value_Display__c = String.valueOf(rl.accOld.get(s));
                            }
                            tempRList.add(rli);
                        }
                    }
                }
                
                system.debug('######' + tempRList);
                
                if(tempRList.size()>0){
                    List<RequestLineItem__c> deleteRList = new List<RequestLineItem__c>([select id from RequestLineItem__c where Request__c =: getRequestId]);
                    delete deleteRList;
                    insert tempRList;
                    
                    if(pageStatus=='Clone'){
                        Request__c rq = new Request__c();
                        rq.Id = getRequestId;
                        rq.Status__c = 'Draft';
                        rq.Description__c = getRequestInfo.Description__c;
                        update rq;
                        
                      /* String accBU = [SELECT Business__c FROM Account WHERE Id =: getAccountId LIMIT 1].Business__c;
                        Approval_Process_Settings__c apSetting =  Approval_Process_Settings__c.getValues(accBU);*/
                        
                       List<Approval.ProcessSubmitRequest> lstProcess = new List<Approval.ProcessSubmitRequest>();
                        
                        Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
                        req1.setComments('Automatic record lock.');
                        req1.setObjectId(getAccountId);
                        req1.setProcessDefinitionNameOrId(Label.Consumer_Update_Approval_Request);
                        lstProcess.add(req1);
                        
                        // Create an approval request for the request
                        Approval.ProcessSubmitRequest req2 = new Approval.ProcessSubmitRequest();
                        req2.setObjectId(getRequestId);
                        lstProcess.add(req2);
                        
                        try{
                            List<Approval.ProcessResult> lstResult = Approval.process(lstProcess);
                        }
                        catch(exception e){
                            system.debug('Approval Process Error: ' + e);
                        }
                    }
                    
                    system.debug('Request Line Item: ' + tempRList);
                    PageReference home = new PageReference('/'+getRequestId);
                    home.setRedirect(true);       
                    return home;  
                }else{
                  ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Please update at least one field')); 
                }
             }
        
             catch (Exception ex) {
                 ApexPages.addMessages(ex);
                 system.debug(ex);
                 return null;
            }
        }
     
        return null;
    }
 /******************************************************************/ 
    
 /******************************************************************
    ** Parameter: None
    ** Returns: none
    ** Description: Wrapper class for accounts
 *******************************************************************/ 
    public class wFieldWrapper {
        public Account accOld {get; set;}
        public Account accNew {get; set;}

        public wFieldWrapper(Account acc, Account oldAcc) {
            if(oldAcc != null){
                accNew = oldAcc;
            }
            else{
                accNew = new Account();
            }
            accOld = acc;
        }
    }


}