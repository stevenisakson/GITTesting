/*********************************************************************
Name: DuplicateRecordItemTriggerHandler
Date    : 17 October 2016
Description: Handler for DuplicateRecordItem
             after insert
*********************************************************************/
public class DuplicateRecordItemTriggerHandler {

List<Messaging.SingleEMailMessage> emailListToSend= new List<Messaging.SingleEMailMessage>();
Override_Settings__c overSettings = Override_Settings__c.getInstance(userinfo.getProfileId());
      /**
    * This method will update the duplicate account and send email to account owner and Data Steward business unit.
    **/
    
    public void duplicateCheck(Map<id,DuplicateRecordItem> tempMap)
    {  
      Set<Id> duplicateAccId = new Set<Id>();
      List<Account> accUpdateList = new List<Account>();
      List<Application_Mapping__c> appMappingDelList = new List<Application_Mapping__c>();
      Request__c newReq = new Request__c();

        for(DuplicateRecordItem DRItem: tempMap.values())
         {         
            duplicateAccId.add(DRItem.recordId);
         } 
         List<Account> DuplicateAccountList=[Select id,Account_Type__c,Auto_Validate__c,name,Is_Duplicate__c,Prospect_Validated__c,Owner.Email,Status__c,Account_Owner__c,Owner.id, Business__c, RecordType__c, CreatedDate 
                                             from Account
                                             where id IN:duplicateAccId ORDER BY CreatedDate DESC LIMIT 1];
                                             
         List<Application_Mapping__c> AppMappingList=[Select Id, Name, Account__c, External_Record_num__c, External_System__c 
                                                      from Application_Mapping__c 
                                                      where Account__c IN:duplicateAccId ORDER BY CreatedDate DESC LIMIT 1];          
           
           if(!DuplicateAccountList.isEmpty())
           {
               for(Account a:DuplicateAccountList)
               { 
                //** Created object for custom setting "Prospect Validation Settings" and get value of business unit.
                  // Prospect_Validation_Settings__c ProsValObj = Prospect_Validation_Settings__c.getValues(a.Business__c);
                        
                       
                        if(a.Account_Type__c == Label.Standard_Record_Type && a.Auto_Validate__c)
                        {
                                                 
                            if(!a.Is_Duplicate__c)
                             {
                                 a.Is_Duplicate__c = true;
                                 a.Status__c = 'On Hold';
                                 a.Active__c = true;
                                 a.Prospect_Validated__c = false;
                               //  a.Auto_Validate__c = false;
                                 a.Account_Owner__c = a.OwnerId;
                                 a.Application_Mapping_Created__c = false;
                                 accUpdateList.add(a);
                               
                                 
                                 newReq.Account__c = a.Id;
                                 newReq.RecordTypeID = overSettings.Prospect_Validation_Request_RecordTypeID__c;
                                 newReq.Status__c = 'Draft';
                                 newReq.OwnerId = a.OwnerId;
                                 newReq.CreatedById = a.OwnerId;
                                  
                             }
                                // sendEmailCheck(a.Owner.Email,ProsValObj.DS_Email_Id__c,a.id,a.name);
                               //  Messaging.sendEmail(emailListToSend);
                          if(!AppMappingList.isEmpty())
                          {  
                             if(a.Id == AppMappingList[0].Account__c)
                             {
                                 appMappingDelList.add(AppMappingList[0]);
                             }  
                          }
                        }
                        
                        if(a.Account_Type__c == Label.Standard_Record_Type && !a.Auto_Validate__c)
                        {
                        
                            if(!a.Is_Duplicate__c)
                             {
                                 a.Is_Duplicate__c = true;
                                 a.Status__c = 'On Hold';
                                 accUpdateList.add(a);
                             }
                        }
                        
               
               
                 if(a.Account_Type__c == Label.Consumer_Record_Type)
                 {
            //Below mentioned Obj varible ProsValObj is fetching the corresponding Custom Setting values as per the Business unit of inserted Account.
               
                     if(!a.Is_Duplicate__c)
                     {
                         a.Is_Duplicate__c = true;
                         a.Active__c = true;
                         a.Status__c = 'On Hold';
                        // a.Auto_Validate__c = false;
                         a.Customer_Status__c = 'Prospect';
                         a.Prospect_Validated__c = false;
                         a.Application_Mapping_Created__c = false;
                         
                         accUpdateList.add(a);
                         
                       
                       newReq.Account__c = a.Id;
                       newReq.RecordTypeID = overSettings.Consumer_Validation_Request_RecordTypeID__c;
                       newReq.Status__c = 'Draft';
                       newReq.OwnerId = a.OwnerId;
                       newReq.CreatedById = a.OwnerId;
                       
                       if(!AppMappingList.isEmpty())
                       {
                            if(a.Id == AppMappingList[0].Account__c)
                            {
                                appMappingDelList.add(AppMappingList[0]);
                            }     
                        }
                    }   
                  
                  
                }
                
            }
            
           if(newReq<>NULL)
           {
               insert newReq;
           }  
            
             if(!accUpdateList.isEmpty())
             {
                 update accUpdateList;
             }
            
           //Delete Application Mapping Record created for Duplicate Account Records
                                  
           if(!appMappingDelList.isEmpty())
           {
               delete appMappingDelList;
           }
                
           
             
      } 
           
        
    }
}