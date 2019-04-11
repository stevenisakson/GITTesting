/*********************************************************************
Name    : RequestAllTriggerHandler
Description: TriggerHandler for Request__c object
             after insert - if type = Prospect Conversion, add approval process on account
History : Jed Canlas - created
*********************************************************************/
public class RequestTriggerHandler {
    
    string customerRecordTypeId = [Select Id From RecordType Where SobjectType = 'Request__c' AND DeveloperName = 'Commercial_Customer_Update'].Id;
    string conversionRecordTypeId = [Select Id From RecordType Where SobjectType = 'Request__c' AND DeveloperName = 'Prospect_Conversion'].Id;
    string newAccountRecordTypeId = [Select Id From RecordType Where SobjectType = 'Request__c' AND DeveloperName = 'Prospect_Validation'].Id;
   // string CommercialCustomerId = [Select Id From RecordType Where SobjectType = 'Account' AND DeveloperName = 'Commercial_Customer'].Id;
   
    /**Added by Tumish*************/
    string newCompetitorRecordTypeId = [Select Id From RecordType Where SobjectType = 'Request__c' AND DeveloperName = 'Competitor_Validation'].Id;
    string competitorUpdateRecordTypeId = [Select Id From RecordType Where SobjectType = 'Request__c' AND DeveloperName = 'Competitor_Update'].Id;
    
    /***********************/
   /**Added by Shalu*************/
    string newConsumerRecordTypeId = [Select Id From RecordType Where SobjectType = 'Request__c' AND DeveloperName = 'Consumer_Validation'].Id;
   /***********************/
   
   /** Added by Poonam*****/
   string thirdPartyRecordTypeId = [Select Id From RecordType Where SobjectType = 'Request__c' AND DeveloperName = 'Third_Party_Validation'].Id;
  // string thirdPartyReadOnlyRecordTypeId = [Select Id From RecordType Where SobjectType = 'Account' AND DeveloperName = 'Third_Party_Read_Only_CPN_India'].Id;
   string thirdPartyUpdateRecordTypeId = [Select Id From RecordType Where SobjectType = 'Request__c' AND DeveloperName = 'Third_Party_Update'].Id;
  // string consumerRecordTypeIdCPNIndia = [Select Id From RecordType Where SobjectType = 'Request__c' AND DeveloperName = 'Consumer_Validation_CPN_INDIA'].Id;
   string consumerUpdateRecordTypeId = [Select Id From RecordType Where SobjectType = 'Request__c' AND DeveloperName = 'Consumer_Update'].Id;
  /// string consumerReadOnlyRecordTypeId = [Select Id From RecordType Where SobjectType = 'Account' AND DeveloperName = 'Consumer_Read_Only_CPN_India'].Id;
   /***********************/ 
    public void onAfterInsert(list<Request__c> newList){   
        List<Approval.ProcessSubmitRequest> lstProcess = new List<Approval.ProcessSubmitRequest>();
        system.debug('@@@Competitor RecordType ID is'+newCompetitorRecordTypeId );
        for (Request__c request : newList){
            
            //Added by Tumish: fetching Approval process names for the corresponding BU
            Auto_Populate_Settings__c apSetting =  Auto_Populate_Settings__c.getValues(request.Account_Business__c);           
             Account_Approval_Process_Settings__c accAppSettings = Account_Approval_Process_Settings__c.getValues(request.RecordTypeId);
             
            //Tumish: End
            
               /**** Dipendra Shrestha (Accenture) Added below 8-10-2016*********/  
               /**** Description: Trigger a new approval process for the new Prospect creation  ***/
               /*****************************************************************/  
                        
              if (request.RecordTypeId==newAccountRecordTypeId && request.Status__c=='Draft')
               {
               // Create an approval request for the account
                    Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
                    req1.setComments('Automatic record lock.');
                    req1.setObjectId(request.Account__c);
                    req1.setProcessDefinitionNameOrId(accAppSettings.Approval_Process_Name__c);
                    lstProcess.add(req1);
                   
                // Create an approval request for the request
                    Approval.ProcessSubmitRequest req2 = new Approval.ProcessSubmitRequest();
                    req2.setObjectId(request.Id);
                    req2.setSubmitterId(UserInfo.getUserId());
                    lstProcess.add(req2);               
               }
               /*** Dipendra end****/
               
               
               //Added by Tumish for competitor Validation Process
               else if (request.RecordTypeId==newCompetitorRecordTypeId && request.Status__c=='Draft')
               {
               // Create an approval request for the account
               system.debug('inside Tumish defined Loop');
                    Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
                    req1.setComments('Automatic record lock.');
                    req1.setObjectId(request.Account__c);
                    req1.setProcessDefinitionNameOrId(accAppSettings.Approval_Process_Name__c);
                    lstProcess.add(req1);
                  
                
                // Create an approval request for the request
                    Approval.ProcessSubmitRequest req2 = new Approval.ProcessSubmitRequest();
                    req2.setObjectId(request.Id);
                    lstProcess.add(req2);               
               }
              //Tumish End************* 
              
               //Added by Shalu for Consumer Validation Process
               else if (request.RecordTypeId==newConsumerRecordTypeId && request.Status__c=='Draft')
               {
               // Create an approval request for the account
              // system.debug('inside Tumish defined Loop');
                    Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
                    req1.setComments('Automatic record lock.');
                    req1.setObjectId(request.Account__c);
                    req1.setProcessDefinitionNameOrId(accAppSettings.Approval_Process_Name__c);
                    lstProcess.add(req1);
                  
                
                // Create an approval request for the request
                    Approval.ProcessSubmitRequest req2 = new Approval.ProcessSubmitRequest();
                    req2.setObjectId(request.Id);
                    lstProcess.add(req2);               
               }
              //Shalu End************* 
              
              
               else if (request.RecordTypeId == conversionRecordTypeId && request.Status__c =='Draft'){
                
                // Create an approval request for the account
                    Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
                    req1.setComments('Automatic record lock.');
                    req1.setObjectId(request.Account__c);
                    req1.setProcessDefinitionNameOrId(accAppSettings.Approval_Process_Name__c);
                    lstProcess.add(req1);
                
                // Create an approval request for the request
                    Approval.ProcessSubmitRequest req2 = new Approval.ProcessSubmitRequest();
                    req2.setObjectId(request.Id);
                    lstProcess.add(req2);
            }
            
          //  else if (request.RecordTypeId == customerRecordTypeId && request.Status__c=='Draft' && request.Cloned__c == FALSE)
            else if (request.RecordTypeId == customerRecordTypeId && request.Status__c=='Draft' ){
                
                // Create an approval request for the account
                    Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
                    req1.setComments('Automatic record lock.');
                    req1.setObjectId(request.Account__c);
                    req1.setProcessDefinitionNameOrId(accAppSettings.Approval_Process_Name__c);
                    lstProcess.add(req1);
                
                // Create an approval request for the request
                    Approval.ProcessSubmitRequest req2 = new Approval.ProcessSubmitRequest();
                    req2.setObjectId(request.Id);
                    lstProcess.add(req2);
            }
            
            //Added by Tumish: for Competitor Update Request Process
            else if (request.RecordTypeId == competitorUpdateRecordTypeId && request.Status__c=='Draft' ){
                
                // Create an approval request for the account
                    Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
                    req1.setComments('Automatic record lock.');
                    req1.setObjectId(request.Account__c);
                    req1.setProcessDefinitionNameOrId(accAppSettings.Approval_Process_Name__c);
                    lstProcess.add(req1);
                
                // Create an approval request for the request
                    Approval.ProcessSubmitRequest req2 = new Approval.ProcessSubmitRequest();
                    req2.setObjectId(request.Id);
                    lstProcess.add(req2);
            }            
            //Tumish: End
            
            // Added by Poonam for Third party validation request for account 
            else if (request.RecordTypeId == thirdPartyRecordTypeId && request.Status__c=='Draft' ){
                
                // Create an approval request for the account
                    Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
                    req1.setComments('Automatic record lock.');
                    req1.setObjectId(request.Account__c);
                    req1.setProcessDefinitionNameOrId(accAppSettings.Approval_Process_Name__c);
                    lstProcess.add(req1);
                
                // Create an approval request for the request
                    Approval.ProcessSubmitRequest req2 = new Approval.ProcessSubmitRequest();
                    req2.setObjectId(request.Id);
                    lstProcess.add(req2);
            }
            
            // Added by Poonam for Third party update request for account 
            else if (request.RecordTypeId == thirdPartyUpdateRecordTypeId && request.Status__c=='Draft' ){
                
                // Create an approval request for the account
                    Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
                    req1.setComments('Automatic record lock.');
                    req1.setObjectId(request.Account__c);
                    req1.setProcessDefinitionNameOrId(accAppSettings.Approval_Process_Name__c);
                    lstProcess.add(req1);
                
                // Create an approval request for the request
                    Approval.ProcessSubmitRequest req2 = new Approval.ProcessSubmitRequest();
                    req2.setObjectId(request.Id);
                    lstProcess.add(req2);
            }
            
            // Added by Poonam for Consumer update request for account CPN INDIA 
            else if (request.RecordTypeId == consumerUpdateRecordTypeId && request.Status__c=='Draft' ){
                
                // Create an approval request for the account
                    Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
                    req1.setComments('Automatic record lock.');
                    req1.setObjectId(request.Account__c);
                    req1.setProcessDefinitionNameOrId(accAppSettings.Approval_Process_Name__c);
                    lstProcess.add(req1);
                
                // Create an approval request for the request
                    Approval.ProcessSubmitRequest req2 = new Approval.ProcessSubmitRequest();
                    req2.setObjectId(request.Id);
                    lstProcess.add(req2);
            }
            else if(request.RecordTypeId == Schema.SObjectType.Request__c.getRecordTypeInfosByName().get('CFR Contact Approval').getRecordTypeId() && request.Contact__c != null && request.Status__c=='Submitted'){
                System.debug('Call approval process of Contact Request');
                Approval.ProcessSubmitRequest reqContact = new Approval.ProcessSubmitRequest();
                reqContact.setComments('Automatic record lock.');
                reqContact.setObjectId(request.Id);
                reqContact.setProcessDefinitionNameOrId(Label.CFR_Contact_Request_Process_Name);
                lstProcess.add(reqContact);
                
            }
           
        }    
        
        // Submit the approval request for the account
        if (lstProcess.size() > 0)
        {
            try{
                List<Approval.ProcessResult> lstResult = Approval.process(lstProcess);
                System.debug('$$$$$$$$$$$$$ Approval Process Result ' + lstResult);
            }catch (exception e){
                System.debug('Exception occured &&&&&&&&&&&&&&&&&& ' + e);
                if(e.getMessage().contains('MANAGER_NOT_DEFINED')){
                    newList[0].addError(label.Error_Manager_not_defined);   
                }else{
                    if(e.getMessage().contains('ALREADY_IN_PROCESS')){
                        newList[0].addError(label.Error_Cannot_Submit_Already_in_Process);  
                    }
                }
            }    
        } 
           
    }
    
    public void onAfterUpdate(list<Request__c> newList, Map<Id, Request__c> oldRequestMap){  
        //for testing
        System.debug('####After Update Trigger fire on Request Trigger Handler');
        
               
        set<Id> accIds = new set<Id>();
        Set<Id> contactIds = new Set<Id>();
        Set<Id> contactRejectedIds = new Set<Id>();
        List<Contact> updateContactList = new List<Contact>();
        List<Contact> updateContactRejectList = new List<Contact>();
        
        
        list<Request__c> reqstatusupdlst = new list<Request__c>();
        
        for(Request__c req: newList){
        
            //Logic to delete account team member when request status changed to Approve starts.
             Override_Settings__c os = Override_Settings__c.getInstance();
             string recordTypeId = os.Account_Team_Delete_RecordTypeID__c;
            
             if(req.Status__c != oldRequestMap.get(req.id).Status__c && req.RecordTypeId == recordTypeId){
                reqstatusupdlst.add(req);
            }
            //Logic to delete account team member when request status changed to Approve ends.
             if(req.RecordTypeId !=recordTypeId){
                system.debug('in record type check');
                accIds.Add(req.Account__c);
             }
            system.debug('outside of record type check');
            
            if(req.Status__c == 'Approved' && req.Contact__c != null)
                contactIds.add(req.Contact__c);
            else if(req.Status__c == 'Rejected' && req.Contact__c != null)
                contactRejectedIds.add(req.Contact__c); 
        } 
        
        if(!reqstatusupdlst.isEmpty()){
             acctTeamMemberDelete(newList); //this method takes request list for which request status is changed to approved.
          }
       system.debug('reqstatusupdlst in update---->'+reqstatusupdlst);
        
        List<Account> accList = new List<Account>();
        if(accIds.size()>0){
            accList = [select id,Account_Type__c,RecordTypeId,Request_Approved__c,Region__c, Approval_Status__c from account where Id IN: accIds];
        }     
        map<id,Account> reqAccMap = new map<Id,Account>();
        for(Request__c req: newList){
            for(Account acc: accList){
                if(acc.Id == req.Account__c){
                    reqAccmap.put(req.Id,acc);
                }
            }
        }

        List<Account> accUpdate = new List<Account>();
        Map<id,list<id>> reqSet = new Map<id,list<id>>();
        Map<id,id> reqSetCompetitor = new Map<id,id>();  //Added by Tumish for Competitor Update Request
        Map<id,id> reqSetthirdparty = new Map<id,id>(); // Added by Poonam for third party update request
        Map<id,id> reqSetconsumer = new Map<id,id>(); // Added by Poonam for consumer update request
        for(Request__c req: newList){ 
            //Added by Tumish: fetching Approval process names for the corresponding BU
            Auto_Populate_Settings__c apSetting =  Auto_Populate_Settings__c.getValues(req.Account_Business__c);
            Account_Approval_Process_Settings__c accAppSettings = Account_Approval_Process_Settings__c.getValues(req.RecordTypeId);
            //Tumish: End     
            Account tempAcc = new Account();
            if(reqAccMap.containsKey(req.Id)){  
                tempAcc = reqAccmap.get(req.Id);           
                if(req.Status__c != 'Approved'){                   
                        tempAcc.Request_Approved__c = false;
                        if (req.Status__c == 'Draft' && req.Account_Approval_Status__c == 'Pending') 
                            { 
                             system.debug('####ACN Inside the Draft');
                             tempAcc.Approval_Status__c = 'Recalled';
                            }
                        else if (req.Status__c == 'Submitted' && req.Account_Approval_Status__c <> 'Draft')
                        {   //call the account approval
                             system.debug('####ACN inside the submitted check'+ req.Account_Approval_Status__c);
                            List<Approval.ProcessSubmitRequest> lstProcess = new List<Approval.ProcessSubmitRequest>();
                            Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
                            req1.setComments('Automatic record lock.');
                            req1.setObjectId(req.Account__c);
                            if (req.RecordTypeId == newAccountRecordTypeId) 
                                req1.setProcessDefinitionNameOrId(accAppSettings.Approval_Process_Name__c);
                            
                            // added By Tumish: condition "req.RecordTypeId == newCompetitorRecordTypeId"  for Competitor Validation
                            else if (req.RecordTypeId == newCompetitorRecordTypeId) 
                                req1.setProcessDefinitionNameOrId(accAppSettings.Approval_Process_Name__c);
                            //Tumish: End
                                
                            // Added by Shalu for Consumer Validation
                            else if (req.RecordTypeId == newConsumerRecordTypeId) // 
                                req1.setProcessDefinitionNameOrId(accAppSettings.Approval_Process_Name__c);    
                                //Shalu : End
                            else if (req.RecordTypeId == competitorUpdateRecordTypeId) // Added by Tumish for Competitor Update Record Type
                                req1.setProcessDefinitionNameOrId(accAppSettings.Approval_Process_Name__c);
                            else if (req.RecordTypeId == customerRecordTypeId)
                                req1.setProcessDefinitionNameOrId(accAppSettings.Approval_Process_Name__c);
                            else if (req.RecordTypeId == conversionRecordTypeId)   
                                req1.setProcessDefinitionNameOrId(accAppSettings.Approval_Process_Name__c);
                            else if (req.RecordTypeId == thirdPartyUpdateRecordTypeId)
                                req1.setProcessDefinitionNameOrId(accAppSettings.Approval_Process_Name__c);
                            else if (req.RecordTypeId == consumerUpdateRecordTypeId)   
                                req1.setProcessDefinitionNameOrId(accAppSettings.Approval_Process_Name__c);
                            lstProcess.add(req1);
                            
                            try{
                                List<Approval.ProcessResult> lstResult = Approval.process(lstProcess);
                            }
                            catch(exception e){
                                system.debug('Approval Process Error: ' + e);
                            }
                        }
                    }
                   else{
                    system.debug('####Account Update Triggered'); //for testing
                    tempAcc.Request_Approved__c = true;
                    tempAcc.Approval_Status__c = 'Approved';
                    /*********************************************************                                                                                                   
                    ** Author: Anjerico Caburnay (Accenture)
                    ** Date: 08-03-2016
                    ** Description: Fix for CCEB-83 (For the prospect conversion request types, the approval action needs to flip the account record type to Customer on approval.)
                    ***********************************************************/                                                                                       
                    system.debug('@@ Req RecordTypeId ' + req.RecordTypeId);
                    //system.debug( '@@ ' + Schema.SObjectType.Request__c.getRecordTypeInfosByName().get('Prospect Conversion').getRecordTypeId());
                     system.debug('@@ Req tempAcc.Region__c ' + tempAcc.Region__c);
                    system.debug('@@ conversionRecordTypeId ' + conversionRecordTypeId );
                    //if(req.RecordTypeId == Schema.SObjectType.Request__c.getRecordTypeInfosByName().get('Prospect Conversion').getRecordTypeId())
                    if(req.RecordTypeId == conversionRecordTypeId ){ 
                       
                          /*Modified Due to NullPointer Exception-Schema Issue*/          
                      // tempAcc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(Label.Commercial_Customer_Record_Type+' '+String.valueof(tempAcc.Region__c)).getRecordTypeId();
                        tempAcc.RecordTypeId =[select id from RecordType where sObjectType='Account' and Name=:Label.Commercial_Customer_Record_Type+' '+String.valueof(tempAcc.Region__c)].Id;//'0122100000093mwAAA'; //Schema.SObjectType.Account.getRecordTypeInfosByName().get('Commercial Customer CFN Vietnam').getRecordTypeId();

                        tempAcc.Account_Type__c = Label.Commercial_Customer_Record_Type;
                    }   
                       // Added by Poonam to update third party record type
                    
                    if(req.RecordTypeId == thirdPartyRecordTypeId){ 
                        tempAcc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(Label.Third_Party_Acc_Record_Type+' '+String.valueof(tempAcc.Region__c)).getRecordTypeId();
                        tempAcc.Account_Type__c = Label.Third_Party_Acc_Record_Type;
                    }
                    
                    // Added by Poonam to update consumer record type to read only for CPN INDIA
                    
                    if(req.RecordTypeId == newConsumerRecordTypeId){ 
                        
                     tempAcc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(Label.Consumer_Read_Only_Acc_Type+' '+String.valueof(tempAcc.Region__c)).getRecordTypeId();
                     tempAcc.Account_Type__c = Label.Consumer_Read_Only_Acc_Type;
                    }
                    /*********************************************************
                    ** Author: Regina Ligan (Accenture)
                    ** Date: 08-09-2016
                    ** Description: Update of Account fields based on request line items
                    ***********************************************************/
                    if (req.RecordTypeId == conversionRecordTypeId){
                        tempAcc.Status__c = 'Approved';
                    }
                    //if(req.RecordTypeId == Schema.SobjectType.Request__c.getRecordTypeInfosByName().get('Commercial Customer Update').getRecordTypeId())
                    if(req.RecordTypeId == customerRecordTypeId)
                    {
                        System.debug('Inline Update');
                        System.debug('DBG: req >>> ' + req);
                        System.debug('DBG: acc >>> ' + tempAcc);
                        
                        if(reqSet.containsKey(req.id)){
                            reqSet.get(req.id).add(req.account__c);
                        }else{
                            reqSet.put(req.id, new List<id>{req.account__c});
                        }
                    }
                 
                 //Added by Tumish: For competitor Update Request   
                 if(req.RecordTypeId ==competitorUpdateRecordTypeId)
                    {
                        System.debug('Inline Update');
                        System.debug('DBG: req >>> ' + req);
                        System.debug('DBG: acc >>> ' + tempAcc);
                       
                        reqSetCompetitor.put(req.id, req.account__c);
                        
                    }
                  //Tumish :End  
                 //Added by Poonam: For thirdparty Update Request   
                 if(req.RecordTypeId ==thirdPartyUpdateRecordTypeId)
                    {
                        System.debug('Inline Update');
                        System.debug('DBG: req >>> ' + req);
                        System.debug('DBG: acc >>> ' + tempAcc);
                       
                        reqSetthirdparty.put(req.id, req.account__c);
                        
                    }                  
                     // end
                     
                   //Added by Poonam: For consumer Update Request
                   if(req.RecordTypeId ==consumerUpdateRecordTypeId)
                    {
                        System.debug('Inline Update');
                        System.debug('DBG: req >>> ' + req);
                        System.debug('DBG: acc >>> ' + tempAcc);
                       
                        reqSetconsumer.put(req.id, req.account__c);
                        
                    }                  
                     // end
                  
                  
                  
                  //Added by Tumish: To Change the Competitor Account Owner to Approver(DS) of the request
                 if(req.RecordTypeId == newCompetitorRecordTypeId && apSetting.Owner_Change__c && req.Status__c == 'Approved')   
                  {
                      tempAcc.OwnerId = req.LastModifiedById;
                  } 
                  //Tumish: End                   
                }
                if(req.Status__c == 'Rejected'){
                    tempAcc.Approval_Status__c = 'Rejected';
                }
                if(req.Status__c == 'Recalled'){
                    tempAcc.Approval_Status__c = 'Recalled';
                }
               if(req.Status__c == 'Submitted'){
                    tempAcc.Approval_Status__c = 'Pending';
                }
              
               //Added by Tumish: To update the Account Status
                if(req.Status__c == 'Submitted' && req.RecordTypeId == conversionRecordTypeId){
                    tempAcc.Approval_Status__c = 'Pending';
                    tempAcc.Status__c = 'Conversion In progress';
                }
                
                if(req.Status__c == 'Submitted' && req.RecordTypeId == customerRecordTypeId){
                    tempAcc.Approval_Status__c = 'Pending';
                    tempAcc.Status__c = 'In Progress';
                }
                
                if(req.Status__c == 'Submitted' && req.RecordTypeId == competitorUpdateRecordTypeId){
                    tempAcc.Approval_Status__c = 'Pending';
                    tempAcc.Status__c = 'In Progress';
                }
                
                     // Added by Poonam for third party update
                if(req.Status__c == 'Submitted' && req.RecordTypeId == thirdPartyUpdateRecordTypeId){
                    tempAcc.Approval_Status__c = 'Pending';
                    tempAcc.Status__c = 'In Progress';
                }
                
                // Added by Poonam for consumer update CPN INDIA
                if(req.Status__c == 'Submitted' && req.RecordTypeId == consumerUpdateRecordTypeId){
                    tempAcc.Approval_Status__c = 'Pending';
                    tempAcc.Status__c = 'In Progress';
                }
                //Tumish : End
                accUpdate.add(tempAcc);
            }
        }
        
        //Call approve method for the Account update based on Request. Added by Tumish for competitor update request. 
        //Passing reqsetCompetitor to competitorApprove class
        if(!reqSetCompetitor.isEmpty())
        {
           system.debug('@@@ reqset' + reqSetCompetitor); 
           CompetitorUpdateRequest compUpt = new CompetitorUpdateRequest();
           compUpt.competitorApprove(reqSetCompetitor);
        }
        //Tumish: End
        
        //Call approve method for the Account update based on Request. Added by Poonam for third party update request. 
        //Passing reqSetthirdparty to ThirdPartyUpdateRequest class
        if(!reqSetthirdparty.isEmpty())
        {
           system.debug('@@@ reqset' + reqSetthirdparty); 
           ThirdPartyUpdateRequest tpUpt = new ThirdPartyUpdateRequest();
           tpUpt.thirdPartyApprove(reqSetthirdparty);
        }
        // end 
        
        //Call approve method for the Account update based on Request. Added by Poonam for consumer update request. 
        //Passing reqSetconsumer to ConsumerUpdateRequest class
        if(!reqSetconsumer.isEmpty())
        {
           system.debug('@@@ reqset' + reqSetconsumer); 
           ConsumerUpdateRequest conUpt = new ConsumerUpdateRequest();
           conUpt.consumerApprove(reqSetconsumer);
        }
        // end        
        
        //Call approve method for the Account update based on Request
        if(!reqset.isEmpty()){
            system.debug('@@@ reqset' + reqSet);
            approve(reqSet);
        }
        system.debug('accUpdate     ' + accUpdate);
        if(accUpdate.size()>0){
            AccountTriggerhandler.runOnAfterUpdate = true;
            system.debug('@@@@@@@@@@@@acc' + accUpdate);
            update accUpdate;
        }    

        /* Update Contact Status based on Request one */
        System.debug('####contactIds'+contactIds);
        if(!contactIds.isEmpty()){
            for(Contact conObj : [Select ID,Request_Status__c,CFR_In_Submission__c from Contact where ID IN :contactIds]){
                conObj.Request_Status__c = 'Approved';
                conObj.CFR_In_Submission__c = False;
                updateContactList.add(conObj);
            }
        }
        try{
            if(!updateContactList.isEmpty()){
                update updateContactList;
                Approval.UnlockResult[] unlockedRersult = Approval.unlock(updateContactList);
            }
                
        }catch(Exception e){
            System.debug('The following exception has occurred while approving a record: ' + e.getMessage());
        }
        
        System.debug('####contactRejectedIds'+contactRejectedIds);
        if(!contactRejectedIds.isEmpty()){
            for(Contact conObjR : [Select ID,Request_Status__c,CFR_In_Submission__c from Contact where ID IN :contactRejectedIds]){
                conObjR.Request_Status__c = 'Rejected';
                conObjR.CFR_In_Submission__c = False;
                updateContactRejectList.add(conObjR);
            }
        }
        try{
            if(!updateContactRejectList.isEmpty()){
                update updateContactRejectList;
                Approval.UnlockResult[] unlockedRersult1 = Approval.unlock(updateContactRejectList);
            }
                
        }catch(Exception e){
            System.debug('The following exception has occurred while rejecting a record: ' + e.getMessage());
        }        
    }
    
    public void onAfterDelete(list<Request__c> newList){   
        
        set<Id> accIds = new set<Id>();
        for(Request__c req: newList){
            accIds.Add(req.Account__c);
        } 
        
        List<Account> accList = new List<Account>();
        if(accIds.size()>0){
            accList = [select id, Request_Approved__c, Approval_Status__c from account where Id IN: accIds];
        } 

        map<id,Account> reqAccMap = new map<Id,Account>();
        for(Request__c req: newList){
            for(Account acc: accList){
                if(acc.Id == req.Account__c){
                    reqAccmap.put(req.Id,acc);
                }
            }
        }

        List<Account> accUpdate = new List<Account>();
        for(Request__c req: newList){  
            Account tempAcc = new Account();
            if(reqAccMap.containsKey(req.Id)){  
                tempAcc = reqAccmap.get(req.Id);                            
                tempAcc.Request_Approved__c = false;
                tempAcc.Approval_Status__c = 'Recalled';
                
                accUpdate.add(tempAcc);
            }
        }
        
        system.debug('accUpdate     ' + accUpdate); 
        if(accUpdate.size()>0){
            AccountTriggerhandler.runOnAfterUpdate = false;
            update accUpdate;
        }
    }
    
     
     /*********************************************************
      ** Author: Regina Ligan (Accenture)
      ** Date: 08-09-2016
      ** Description: Method for updating account with the approved request line items
      ***********************************************************/
     
     public static void  approve(Map<id,List<id>> listReq){
        List<RequestLineItem__c> csFields = new List<RequestLineItem__c>();
        Account updateAcc;
        String query;
        csFields = [SELECT Field_Name__c,Existing_Value__c,New_Value__c,Status__c,Account_Id__c FROM RequestLineItem__c WHERE Request__c =: listReq.keySet()];
        Set<id> idSet = new Set<Id>();
        for(Id ids: listReq.keySet()){
            
            list<id>  tempList = listReq.get(ids);
            for(id idLoop: templist){
                idSet.add(idLoop);
                
            }
            
        }
        
        set<String> filteredAccountFields = new set<string>();
        system.debug('@@ idSet '+ idSet);
        String BUnit = [SELECT Business__c from Account where id IN: idSet].Business__c;
        system.debug('@@ business unit ' + BUnit);
        for(ProtectedFields__c fieldName : [SELECT Field_Name__c,Field_Label__c,Name FROM ProtectedFields__c WHERE Business_Unit__c =: BUnit] ){
          filteredAccountFields.add(fieldName.Field_Name__c);
        }
        
        //construct the soql for the fields to be updated on the account
        string soql = 'select ';
        for (string fld :filteredAccountFields){
            soql += fld +',';          
        }
        soql = soql.substring(0, soql.length() - 1);        
        soql += ' from account WHERE Id IN:idSet ';
        system.debug('#####SOQL: ' + soql);
        //Map the id to its respective account for each account that is to be update based on the result of the constructed soql
        Map<id,Account> mapAcc = new Map<id,Account>();
        List<Account> accountResults = database.query(soql);
        for(Account accLoop: accountResults){
            mapAcc.put(accLoop.id, accLoop);
        }
                map<id,list<RequestLineItem__c>> AccountRequestMap = new map<id,list<RequestLineItem__c>> ();
        
        for(RequestLineItem__c rl : csFields){
            if(!AccountRequestMap.containskey(rl.Account_Id__c)){                
                list<RequestLineItem__c> temp = new list<RequestLineItem__c>();
                temp.add(rl);
                AccountRequestMap.put(rl.Account_Id__c,temp);
            } else{
                   list<RequestLineItem__c> temp = new list<RequestLineItem__c>(); 
                   temp=AccountRequestMap.get(rl.Account_Id__c);
                   temp.add(rl);
                   AccountRequestMap.put(rl.Account_Id__c,temp);
            }
        }
        List <Account> updateAccReq= new list<Account>();
        for(id rid : AccountRequestMap.keyset()){
            updateAcc = mapAcc.get(rid);
            
            for(RequestLineItem__c rli:AccountRequestMap.get(rid)){
                 if(rli.Status__c == 'Approved'){                
                    
                    Map<String, Schema.SObjectField> M  = Schema.SObjectType.Account.fields.getMap();
                    Schema.SObjectField field = M.get(rli.Field_Name__c);
                    Schema.DisplayType FldType = field.getDescribe().getType();
                    
                    system.debug('type ===== ' + rli.Field_Name__c + ' = ' + FldType + '@New Value ' + rli.New_Value__c);
                    
                    if(FldType == Schema.DisplayType.Boolean){
                        updateAcc.put(rli.Field_Name__c, Boolean.valueOf(rli.New_Value__c));                                           
                    }else{
                        if (rli.Field_Name__c == 'Account_Owner__c')
                        updateAcc.OwnerId = rli.New_Value__c;
                        //updated 9-13-2016 by Anjerico Caburnay
                        try{
                            updateAcc.put(rli.Field_Name__c, rli.New_Value__c);
                        }
                        catch(exception e){
                             updateAcc.put(rli.Field_Name__c, Decimal.valueOf(rli.New_Value__c));
                        }
                        //end of update                        
                    }                                     
                    
                    }
                }
                updateAccReq.add(updateAcc);
                system.debug('Update Account --> ' +  updateAcc);
             }
             if(!updateAccReq.isEmpty()){
                    try{
                        update updateAccReq;
                    }catch(DMLException e){                                  
                        System.debug('The following exception has occurred: ' + e.getMessage());
                    } 
             }
       
    }
    
    //method for account team member delete
  public void acctTeamMemberDelete(list<Request__c> newList){
    
    set<id> reqIds = new set<id>();
    //set<string> accnameSet = new  set<string>();
    set<Id> selectedAccountIds = new  set<Id>();
    set<Id> selectedUserId = new  set<Id>();
    //set<string> usernameSet = new  set<string>();
    List<RequestLineItem__c> reqLineItemList = new List<RequestLineItem__c>();
    List<AccountTeamMember>  accntmblst = new List<AccountTeamMember>();
    List<AccountTeamMember> removeTeam = new List<AccountTeamMember>();
    List<Account> acctsToUpdates= new List<Account>();
    
      
    Override_Settings__c os= Override_Settings__c.getInstance();
    string recordTypeId= os.Account_Team_Delete_RecordTypeID__c;
    system.debug('recordTypeId:::::::::'+recordTypeId);
    RecordType recordType = [select id,name from RecordType  where ID =: recordTypeId];
    
    for(Request__c req:newList){
       if(req.RecordTypeId == recordType.id && req.Status__c == 'Approved'){
            reqIds.add(req.id);
        }
    }
    
    system.debug('reqIds: '+reqIds);
    
    if(!reqIds.isEmpty()){
        reqLineItemList =[select id, Account_Name__c, Action__c, Request__c, Status__c, Team_Member__c,Selected_Account_Id__c,User_Id_To_Be_Removed__c from RequestLineItem__c where Request__c in:reqIds];
    }
    
    system.debug('reqLineItemList: '+reqLineItemList);
    
    if(!reqLineItemList.isEmpty()){
        for(RequestLineItem__c rla: reqLineItemList){
           if(rla.Action__c == 'Remove' && rla.Status__c == 'Approved'){
               system.debug('in REMOVE & Approved');
                //accnameSet.add(rla.Account_Name__c);
                selectedAccountIds.add(rla.Selected_Account_Id__c);
                selectedUserId.add(rla.User_Id_To_Be_Removed__c);
                //usernameSet.add(rla.Team_Member__c);
            }
        }
   }
   
   //system.debug('accnameSet: '+accnameSet);
   //system.debug('usernameSet: '+usernameSet);
   
   Map<Id,Account> accountMap = new Map<Id,Account>( [select id from Account where Id in:selectedAccountIds]);
   Map<Id, User> userMap = new Map<Id, User>([select id, name from User where Id in: selectedUserId]);
   
   system.debug('accountMap: '+accountMap);
   system.debug('userMap : '+userMap );
   
   if(!selectedAccountIds.isEmpty()){ 
      accntmblst= [Select Id,AccountId,TeamMemberRole,Title,UserId from AccountTeamMember where AccountId in:accountMap.keySet()];
   }
  
   system.debug('accntmblst: '+accntmblst);
  
   if(!accntmblst.isEmpty()){
      for(AccountTeamMember acm:accntmblst){ 
            if(accountMap.containsKey(acm.accountId) && userMap.containsKey(acm.UserId)){
                system.debug('in addd/remove Team MAP ');
                removeTeam.add(acm);
            }
        }
    }
   
   system.debug('removeTeam: '+removeTeam);
     
   if(!removeTeam.isEmpty()){ 
    try{
        delete removeTeam;
        for(AccountTeamMember act:removeTeam){
           Account objAccount = new Account(id=act.accountId);
           objAccount.Account_Team_Last_Modified_Date__c =System.Now();
           acctsToUpdates.add(objAccount);
        }
        if(!acctsToUpdates.isEmpty()){  
        update acctsToUpdates;
      }
    }
    catch(Exception e){
        system.debug('Exception: '+ e.getMessage());
    }  
    
  }  
    
    }
 }