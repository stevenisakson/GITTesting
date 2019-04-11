/******************************************************************
** Author: Anjerico Caburnay (Accenture)
** Date: 08-19-16
** Paramters: RecordTypeId
** Description: Controller class for NewRequest.Page
** Date Last Modified: 08-23-16
** History-----------------------------------------------------
*******************************************************************/

public class NewRequestExtension {
    public Request__c newReq {get;set;}
    public Id getRequestRecordTypeId {get;set;}
    public Account accountSelected;
    //for dynamic fields
    public Set<String> setFields = new Set<String>();
    public List<ProtectedFields__c> csFields {get; set;}
    public List<CompetitorProtectedFields__c> compcsFields {get; set;}
    public Account oldAcc {get; set;}
    public Account newAcc {get; set;}
    public boolean renderDynamicFields {get;set;}
    public String reqRTName {get;set;}
    public boolean canSave;
    public map<string,string> fieldLabelMap;
    
    public NewRequestExtension(ApexPages.StandardController stdController) {
        newReq = new Request__c();
        getRequestRecordTypeId = ApexPages.currentPage().getParameters().get('RecordType');
        
        reqRTName = [SELECT Name FROM RecordType WHERE Id=:getRequestRecordTypeId LIMIT 1].Name;
        Override_Settings__c cs = Override_Settings__c.getOrgDefaults();
        
        if(reqRTName==cs.Commercial_Customer_Update_Record_Type__c || reqRTName==cs.Competitor_Update_Record_Type__c) //Added by Tumish: Competitor Update condition
        {
            renderDynamicFields = true;
        }
    }
    
    /******************************************************************
    ** Author: Anjerico Caburnay (Accenture)
    ** Date: 08-19-16
    ** Parameter: None
    ** Returns: None
    ** Description: Checks then Displays an Error if the Account Lookup Field is Changed
    *******************************************************************/ 
    public void checkRecordType(){
        Override_Settings__c cs = Override_Settings__c.getOrgDefaults();
        accountSelected = [SELECT Id,Account_Type__c, RecordTypeId, Active__c, Status__c, Prospect_Validated__c, Business__c FROM Account WHERE Id=:newReq.Account__c];
        
        Id accountRecordTypeId = [SELECT RecordTypeId FROM Account WHERE Id=:newReq.Account__c LIMIT 1].RecordTypeId;
        String accRTName = [SELECT Name FROM RecordType WHERE Id=:accountRecordTypeId LIMIT 1].Name;
        
        if(reqRTName==cs.Prospect_Validation_Record_Type__c){
            if(accountSelected.Account_Type__c == cs.Standard_Record_Type__c){
                if(!accountSelected.Prospect_Validated__c){
                    
                }
                else{
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, label.Request_Acc_Status_Prospect_New_Invalid));
                }
            }
           
            else{
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, Label.Request_Prospect_Record_Type));
            }
        }
        
        //Added by Tumish: for Account Competitor Record Type
        else if(reqRTName==cs.Competitor_Validation_Record_Type__c){
            if(accountSelected.Account_Type__c == cs.Competitor_Record_Type__c){
                if(!accountSelected.Prospect_Validated__c){
                    
                }
                else{
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, label.Request_Acc_Status_Competitor_New_Invalid));
                }
            }
           
            else{
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, Label.Request_Competitor_Record_Type));
            }
        }
        //Tumish: End
        
        //Added by Shalu: for Account Consumer Record Type
        else if(reqRTName==cs.Consumer_Validation_Record_Type__c){
            if(accountSelected.Account_Type__c == cs.Consumer_Record_Type__c){
                if(!accountSelected.Prospect_Validated__c){
                    
                }
                else{
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, label.Request_Acc_Status_Consumer_New_Invalid));
                }
            }
           
            else{
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, Label.Request_Consumer_Record_Type));
            }
        }
        //Shalu: End
        
        else if(reqRTName==cs.Prospect_Conversion_Record_Type__c){
            if(accountSelected.Account_Type__c == cs.Standard_Record_Type__c){
                if(accountSelected.Prospect_Validated__c){
                    
                }
                else{
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, Label.Request_Acc_Status_Prospect_Validated));
                }
            }
            else{
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, Label.Request_Prospect_Record_Type));
            }
        }
        else if(reqRTName==cs.Commercial_Customer_Update_Record_Type__c){
            if(accountSelected.Account_Type__c != cs.Commercial_Customer_Record_Type__c){
                if(csFields!=null){
                    oldAcc.clear();
                    newAcc.clear();
                    csFields.clear();
                }
               ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, label.Request_Commercial_Request_Record_Type_Error_Message));
            }
            else{
                loadProtectedFields();
                newReq.Business_Unit__c = accountSelected.Business__c;
            }
        }
        
         //Added by Tumish: for Request Competitor Update Record Type
         else if(reqRTName==cs.Competitor_Update_Record_Type__c){
            if(accountSelected.Account_Type__c != cs.Competitor_Record_Type__c){
                if(compcsFields!=null){
                    oldAcc.clear();
                    newAcc.clear();
                    compcsFields.clear();
                }
               ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, label.Request_Competitor_Record_Type));
            }
            else{
            
                if(!accountSelected.Active__c)
                {
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, label.Request_Competitor_Update));        
                }
                else
                {
                    loadCompProtectedFields();
                    newReq.Business_Unit__c = accountSelected.Business__c;
                }
            }
        }
        //Tumish:End
    }
    /******************************************************************/
    
    public PageReference saveRecord(){
        Override_Settings__c cs = Override_Settings__c.getOrgDefaults();
        if(newReq.Account__c != null){
            try{
                if(reqRTName==cs.Commercial_Customer_Update_Record_Type__c || reqRTName==cs.Competitor_Update_Record_Type__c){
                    Savepoint sp = Database.setSavepoint();
                    try{
                        List<RequestLineItem__c> tempRList = new List<RequestLineItem__c>();
                        newReq.RecordTypeId = getRequestRecordTypeId;
                        insert newReq;
                        
                        for(String s : setFields){
                            if(newAcc.get(s) != oldAcc.get(s)){
                                RequestLineItem__c rli = new RequestLineItem__c();
                                rli.Field_Name__c = s;
                                rli.Field_Label__c = fieldLabelMap.get(s);
                                rli.Request__c = newReq.Id;
                                rli.New_Value__c = String.valueOf(newAcc.get(s));
                                rli.Existing_Value__c = String.valueOf(oldAcc.get(s));
                                try{
                                    id myId = String.valueOf(newAcc.get(s));
    
                                    Schema.SObjectType sobjectType = myId.getSObjectType();
                                    String sobjectName = sobjectType.getDescribe().getName();
                                    
                                    SObject record = Database.query('Select Name From ' + sobjectName + ' Where Id = :myId limit 1');
                                    
                                    rli.New_Value_Display__c = String.valueOf(record.get('Name'));
                                }
                                catch(exception e){
                                    rli.New_Value_Display__c = String.valueOf(newAcc.get(s));
                                }
                                
                                
                                try{
                                    id myId = String.valueOf(oldAcc.get(s));
    
                                    Schema.SObjectType sobjectType = myId.getSObjectType();
                                    String sobjectName = sobjectType.getDescribe().getName();
                                    
                                    SObject record = Database.query('Select Name From ' + sobjectName + ' Where Id = :myId limit 1');
                                    
                                    rli.Existing_Value_Display__c = String.valueOf(record.get('Name'));
                                }
                                catch(exception e){
                                    rli.Existing_Value_Display__c = String.valueOf(oldAcc.get(s));
                                }
                                tempRList.add(rli);
                            }
                        }
                        
                        if(tempRList.size()>0){
                            insert tempRList;   
                            system.debug('Request Line Item: ' + tempRList);
                            PageReference home = new PageReference('/'+newReq.Id);
                            home.setRedirect(true);       
                            return home;  
                        }else{
                          Database.rollback(sp);
                          ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Please update at least one field'));
                          return null;
                        }
                    
                    
                     }
                    
                     catch (Exception ex) {
                         ApexPages.addMessages(ex);
                         system.debug(ex);
                         return null;
                    }
                }
                //Added By: Tumish: this is to restrict any validation type of request to be created from Request tab NEW button.
                else if(reqRTName==cs.Consumer_Validation_Record_Type__c || reqRTName==cs.Competitor_Validation_Record_Type__c){
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Validation Request cannot be created through Request Tab'));
                return null;
                }
                //Tumish: End
                
                else{
                    newReq.RecordTypeId = getRequestRecordTypeId;
                    insert newReq;
                    PageReference home = new PageReference('/'+newReq.Id);
                    home.setRedirect(true);       
                    return home; 
                } 
            }
            catch(exception e){
                // ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Error: ' + e));
                return null;  
            }
        }
        else{
           ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Account Cannot Be Null')); 
           return null;  
        }
    }
    
    public void loadProtectedFields(){
        csFields = new List<ProtectedFields__c>([SELECT Field_Name__c,Field_Label__c,Name FROM ProtectedFields__c WHERE Business_Unit__c =: accountSelected.Business__c ORDER BY Order__c]);
        fieldLabelMap = new Map<String,String>();
        system.debug('@@@@csFields' + csFields);
        
        if(!csFields.isEmpty()){
            for(ProtectedFields__c s: csFields){
                setFields.add(s.Field_Name__c);
                fieldLabelMap.put(s.Field_Name__c,s.Field_Label__c);
            }
            
            String soql = 'Select id ';
            for(ProtectedFields__c fieldName : csFields){
              soql = soql + ', ' + fieldName.Field_Name__c;
              setFields.add(fieldName.Field_Name__c);
            }
            id accId = accountSelected.Id;
            soql = soql + ' From Account where id =:accId';
            newAcc = (Account)Database.Query(soql);
            oldAcc = (Account)Database.Query(soql);
        }
        else{
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'No Fields Associated with Account Business Unit: ' + accountSelected.Business__c)); 
        }
    }
    
    //Added by Tumish: For Competitor Update Requests
        public void loadCompProtectedFields(){
        compcsFields = new List<CompetitorProtectedFields__c>([SELECT Field_Name__c,Field_Label__c,Name FROM CompetitorProtectedFields__c WHERE Business_Unit__c =: accountSelected.Business__c ORDER BY Order__c]);
        fieldLabelMap = new Map<String,String>();
        system.debug('@@@@compcsFields' + compcsFields);
        
        if(!compcsFields.isEmpty()){
            for(CompetitorProtectedFields__c s: compcsFields){
                setFields.add(s.Field_Name__c);
                fieldLabelMap.put(s.Field_Name__c,s.Field_Label__c);
            }
            
            String soql = 'Select id ';
            for(CompetitorProtectedFields__c fieldName : compcsFields){
              soql = soql + ', ' + fieldName.Field_Name__c;
              setFields.add(fieldName.Field_Name__c);
            }
            id accId = accountSelected.Id;
            soql = soql + ' From Account where id =:accId';
            newAcc = (Account)Database.Query(soql);
            oldAcc = (Account)Database.Query(soql);
        }
        else{
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'No Fields Associated with Account Business Unit: ' + accountSelected.Business__c)); 
        }
    }
    //Tumish: End
}