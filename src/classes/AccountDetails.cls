/********************************************************************************************************************
   ** Author: Sagar Patil
   ** Date: 03-06-2019
   ** Description: To Display Account details for account team member and create request & request line items record.
  ********************************************************************************************************************/
public class AccountDetails{
    @AuraEnabled
    public static List<accountListWrapper> fetchAccountDetails(String selectedUserId) {
    
    List<Account> accListResult = new List<Account>();
    List<AccountTeamMember> accTeamMemberList = new List<AccountTeamMember>();
    Map<Id, AccountTeamMember> accTeamMemberMap = new Map<Id, AccountTeamMember>();
        
    User user = [select id, profile.name from User where id=:selectedUserId];
    accTeamMemberList=[select id,AccountId,UserId from AccountTeamMember where UserId =:user.Id];
        
    Id profileId=userinfo.getProfileId();
    String profileName=[Select Id,Name from Profile where Id=:profileId].Name;
    system.debug('ProfileName'+profileName);
    
    if(!accTeamMemberList.isEmpty()){
      for(AccountTeamMember act: accTeamMemberList){
          accTeamMemberMap.put(act.AccountId, act);    
     }
    }
    set<Id> keys = accTeamMemberMap.keyset();
    //String selduserid = user.id;
    string query = 'select id, name, Owner.name, Type, (select id,TeamMemberRole From AccountTeamMembers where userid =:selectedUserId) from Account where id in: keys ';
    system.debug('user profile: '+user.profile.name);   
        
    if(profileName.contains('Data Steward')){
       query += ' ORDER BY owner.name ASC';
    }
    else{
      query += ' and owner.id=\''+UserInfo.getUserId()+'\''+'ORDER BY owner.name ASC';
      system.debug('in else loop');
    }
    accListResult = Database.query(query);
     
    system.debug('accListResult: '+accListResult);
    system.debug('accListResult size: '+accListResult.size());
    List<accountListWrapper> lstaccountListWrapper = new List<accountListWrapper>();
        // query account records and create 'accountListWrapper' class instance for each record. 
    for(Account acc : accListResult){
        lstaccountListWrapper.add(new accountListWrapper(false,acc));
    } 
    system.debug('lstaccountListWrapper '+ lstaccountListWrapper);  
    return lstaccountListWrapper;     
   }
    
    public class accountListWrapper {
        @AuraEnabled public boolean isChecked {get;set;}
        @AuraEnabled public  account objAccount{get;set;}
        public accountListWrapper(boolean isChecked, account objAccount){
            this.isChecked = isChecked;
            this.objAccount = objAccount;
        }
    }
    
    @auraEnabled
    public static void createRequestRecord(String accIds,String username, String selectedUserId){
    
     system.debug('accIds in method: '+accIds);
    
     Type idArrType = Type.forName('set<id>');
     set<id> acctsIdSet = (set<id>) JSON.deserialize(accIds, idArrType);
   
     system.debug('acctsIdSet in method: '+acctsIdSet);
        
     system.debug('in side my class calling');
     Override_Settings__c os = Override_Settings__c.getInstance();
     string recordTypeId = os.Account_Team_Delete_RecordTypeID__c;
     system.debug('recordTypeId :::::::::'+recordTypeId);
     RecordType recordType = [select id,name from RecordType  where ID =: recordTypeId];
     system.debug('recordType ::::::::::::'+recordType);
  
     List<RequestLineItem__c> reqLineItemList = new List<RequestLineItem__c>();
    
     List<Account> accList = [select id, name, ownerid from Account where id in:acctsIdSet];
     
     Request__c  requestRecord = new  Request__c();
     requestRecord.RecordTypeId= recordType.id;
     requestRecord.Status__c = 'Draft';
     requestRecord.Account__c = accList[0].id;
     
     
    if(requestRecord!=null){
            try{
             insert requestRecord ;
            }
            catch(Exception e){
                system.debug('Exception: '+e.getMessage());
            }
        } 
     system.debug('requestRecord ::::::::::::'+requestRecord );
        
     for(Account acc:accList){
        system.debug('In Acc For Loop::::::::::::');
        system.debug('In IF::::::::::::');
        RequestLineItem__c reqLineItem = new RequestLineItem__c();
        reqLineItem.Field_Label__c     ='Account Name';
        reqLineItem.Field_Name__c      ='Name';
        reqLineItem.Request__c         = requestRecord.Id;
        reqLineItem.Account_Name__c    = acc.name;
        reqLineItem.Action__c          = Label.Remove_Action_Value_on_Request_Line_Item;
        reqLineItem.Team_Member__c     = username;
        reqLineItem.Selected_Account_Id__c =acc.id;
        reqLineItem.User_Id_To_Be_Removed__c= selectedUserId;
        reqLineItemList.add(reqLineItem); 
      }
     system.debug('reqLineItemList::::::::::::'+reqLineItemList);    
        
      if(!reqLineItemList.isEmpty()){
            try{
             insert reqLineItemList;
            }
            catch(Exception e){
                system.debug('Exception: '+e.getMessage());
            }
        }
        
      Account_Approval_Process_Settings__c accAppSettings = Account_Approval_Process_Settings__c.getValues(requestRecord.RecordTypeId); 
      system.debug('accAppSettings : '+accAppSettings);
       
      // Create an approval request for the request
      List<Approval.ProcessSubmitRequest> requests = new List<Approval.ProcessSubmitRequest> ();
      Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
      req1.setComments('Automatic record lock.');
      req1.setObjectId(requestRecord.Id);
      req1.setProcessDefinitionNameOrId(accAppSettings.Approval_Process_Name__c); 
      requests.add(req1);
      
      system.debug('requests: '+requests);
      
       // Submit the approval request for the account
      Approval.ProcessResult[] processResults = null;
        if (requests.size() > 0){
            try{
              processResults = Approval.process(requests, true);
              System.debug('$$$$$$$$$$$$$ Approval Process Result ' + processResults );
           }
           catch(System.DmlException e) {
              System.debug('Exception Is ' + e.getMessage());
          }
        }
    }
 /*    @auraEnabled
    public static List<String> selectedAccountIds(String accIds1){
      
     system.debug('accIds in method1: '+accIds1);
     List<id> accountIds = new List<id>();
    
     Type idArrType = Type.forName('set<id>');
     set<id> acctsIdSet = (set<id>) JSON.deserialize(accIds1, idArrType);
   
     system.debug('acctsIdSet in method1: '+acctsIdSet);
        
	 List<RequestLineItem__c> reqLineItemList = [SELECT Id,Selected_Account_Id__c,Request__r.Status__c FROM RequestLineItem__c where Selected_Account_Id__c in:acctsIdSet];
      
     if(!reqLineItemList.isEmpty()){
        for(RequestLineItem__c rla: reqLineItemList) 
           accountIds.add(rla.Selected_Account_Id__c);
        }
      system.debug('accountIds: '+accountIds);
        
       return accountIds;
        
    } */
  
}