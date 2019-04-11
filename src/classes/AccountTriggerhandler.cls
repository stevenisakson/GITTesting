/*********************************************************************
Name: CDH_AccountTriggerHandler
Date    : 9 September 2015
Description: Handler for Account trigger
             after insert/after update
History: Christian Canlas - created handler
Modified: 
11 Dec 2015 David Ragsdale
- Updated After Insert trigger handler to create C360(Segment) and Product Line when tmpSegment is not null - Allows for import of data from ERP and creation of CDH Records 
11 Nov 2016 Tumish Tak
- Added onBeforeInsert method for prospect account validation.
*********************************************************************/
public without sharing class AccountTriggerhandler {
    
    public static Boolean runOnAfterUpdate = true;
    
    public void onAfterUpdate(list<Account> newList, Map<Id,Account> oldmap){ 
        if(runOnAfterUpdate){
            for(Account acc: newList){          
                Account oldAcc = oldMap.get(acc.Id);
                if(acc.Request_Approved__c == true && acc.Approval_Status__c == 'Approved' && acc.Approval_Status__c != oldAcc.Approval_Status__c){
                    approveRecord(acc);             
                }
                
                if(acc.Request_Approved__c == false && acc.Approval_Status__c != oldAcc.Approval_Status__c && (acc.Approval_Status__c == 'Recalled')){
                    recalledRecord(acc);              
                } 
                
                 if(acc.Request_Approved__c == false && acc.Approval_Status__c != oldAcc.Approval_Status__c && (acc.Approval_Status__c == 'Rejected')){
                    rejectRecord(acc);              
                }          
            }
        }
    }
    
   /* public void onAfterInsert(list<Account> newList)
    {
        list<Account> createC360 = new list<Account>();
        
        for(Account newAcc: newList)
        {
            if(newAcc.tmpSegment__c != null && newAcc.tmpSegment__c != '')
            {
                   createC360.add(newAcc);
            }           
        }
        
        if(createC360.Size() > 0)
        {
        //   addSegment(createC360);    //  commented By Shalu
        }       
    }*/
    
    /*Add Segment based on new Account creation*/
    /* Commented By Shalu
    public void addSegment(list<Account> createC360)
    {
        list<Customer360__c> insertC360 = new list<Customer360__c>();
        
        for(Account tmpAcc: createC360)
        {
            Customer360__c newC360 = new Customer360__c();          
               newC360.Account__c = tmpAcc.Id;
               newC360.Business_Unit__c = tmpAcc.CAN_Business__c;
               newC360.Segment_Step_1__c = tmpAcc.tmpSegment__c;
               
               if(tmpAcc.tmpStep2__c != '' && tmpAcc.tmpStep2__c != null)
               {
                   newC360.X9_Box_Step_2__c = tmpAcc.tmpStep2__c;
               }else{
                   newC360.X9_Box_Step_2__c = '--Not Defined--';
               }
               newC360.Primary__c = true;
        
           insertC360.add(newC360);
        }
        
        if(insertC360.size() > 0)
        {
            insert insertC360;        

            addProductLine(insertC360);
        }
    }*/
    
    /*Add Product Line based on new Account/C60 creation*/
    /* Commented By Shalu Req 4.9
    public void addProductLine(list<Customer360__c> newC360)
    {
        list<Product_Line__c> insertProductLine = new list<Product_Line__c>();
        
        for(Customer360__c tmpC360: newC360)
        {
            Product_Line__c newProductLine = new Product_Line__c();          
               newProductLine.Customer360__c = tmpC360.Id;
               newProductLine.Segment_Step_1__c = tmpC360.Segment_Step_1__c;
               newProductLine.Product_Line__c = 'Not Defined';
               newProductLine.Calculation_Method__c = 'Daily Animal Consumption';
        
            insertProductLine.add(newProductLine);
        }
        
        if(insertProductLine.size() > 0)
        {
            insert insertProductLine;
        }
    }    */
    
    public Id getWorkItemId(Id targetObjectId){
        Id retVal = null;

        for(ProcessInstanceWorkitem workItem  : [Select p.Id from ProcessInstanceWorkitem p where p.ProcessInstance.TargetObjectId =: targetObjectId]){
            retVal  =  workItem.Id;
        }
        System.debug('@@@ '+retVal);
        return retVal;
    }

    /**
    * This method will Approve the Account
    **/
    public void approveRecord(Account acc){
        Approval.ProcessWorkitemRequest req = new Approval.ProcessWorkitemRequest();
        req.setComments('Approving request using Trigger');
        req.setAction('Approve');
        //req.setNextApproverIds(new Id[] {UserInfo.getUserId()});
        //req.setNextApproverIds(new Id[] {opp.Next_Approver__c});
        Id workItemId = getWorkItemId(acc.id); 

        if(workItemId == null){
            acc.addError('The Request Cannot be Approved as the Account is already Unlocked.');
        }else{
            req.setWorkitemId(workItemId);
            // Submit the request for approval
            Approval.ProcessResult result =  Approval.process(req);
        }
    }
    
    /**
    * This method will Reject the Account
    **/
    public void rejectRecord(Account acc){
        Approval.ProcessWorkitemRequest req = new Approval.ProcessWorkitemRequest();
        req.setComments('Rejected request using Trigger');
        req.setAction('Reject');
        Id workItemId = getWorkItemId(acc.id);   

        if(workItemId == null){
            acc.addError('The Request Cannot be Approved as the Account is already Unlocked.');
        }else{
            req.setWorkitemId(workItemId);
            // Submit the request for approval
            Approval.ProcessResult result =  Approval.process(req);
        }
    }
    
     public void recalledRecord(Account acc){
        Approval.ProcessWorkitemRequest req = new Approval.ProcessWorkitemRequest();
        req.setComments('Recalled request using Trigger');
        req.setAction('Removed');
        Id workItemId = getWorkItemId(acc.id);   

        if(workItemId == null){
            acc.addError('The Request Cannot be Approved as the Account is already Unlocked.');
        }else{
            req.setWorkitemId(workItemId);
            // Submit the request for approval
            Approval.ProcessResult result =  Approval.process(req);
        }
    }
    
    
    /*
    This method is written by Tumish Tak for handling the AccountTrigger on BeforeInsert event.
    The formal parameter is a list of Newly inserted Account records passed from AccountTrigger on BeforeInsert event.
    */
    public void onBeforeInsert(list<Account> accList)
    { 
      for(Account acc : accList)
      {
         if(acc.Account_Type__c == Label.Standard_Record_Type)
         {
            //Below mentioned Obj varible pval is fetching the corresponding Custom Setting values as per the Business unit of inserted Account.
         //   if(!Test.isRunningTest()){    
               // Prospect_Validation_Settings__c pval = Prospect_Validation_Settings__c.getValues(acc.Business__c);
              //  if(pval.Auto_Validate_Check_Box__c && !acc.Is_Duplicate__c && !acc.Prospect_Validated__c)
                if(!acc.Is_Duplicate__c && !acc.Prospect_Validated__c && acc.Auto_Validate__c)
                  {                         
                     acc.Prospect_Validated__c = true;
                     acc.Status__c = 'Approved';
                     //acc.Auto_Validate__c = true;
                  } 
            // }
         }
         
         if(acc.Account_Type__c == Label.Consumer_Record_Type)
         {
            //Below mentioned Obj varible pval is fetching the corresponding Custom Setting values as per the Business unit of inserted Account.
          //  if(!Test.isRunningTest()){    
               // Prospect_Validation_Settings__c pval = Prospect_Validation_Settings__c.getValues(acc.Business__c);
              //  if(pval.Auto_Validate_Check_Box__c && !acc.Is_Duplicate__c && !acc.Prospect_Validated__c)
                if(!acc.Is_Duplicate__c && !acc.Prospect_Validated__c && acc.Auto_Validate__c && acc.Source_System__c == 'LM')
                  {                         
                     acc.Prospect_Validated__c = true;
                     acc.Status__c = 'Approved';
                     acc.Active__c= true;
                     acc.Customer_Status__c = 'Prospect';
                     //acc.Auto_Validate__c = true;
                  } 
          //   }
         }
      }
    }
    
  public void setAccountCurrency(list<Account> accountList)
    {
      set<Id> ownerIdset = new set<Id>();
      Map<string,string> ownerCurrencyMap = new Map<string,string>();
      
      for(Account acc: accountList)
      {
            ownerIdset.add(acc.OwnerId);
      }
      for(User usr: [Select Id,DefaultCurrencyISOCode from User where Id In : ownerIdset])   
      {
         ownerCurrencyMap.put(usr.Id,usr.DefaultCurrencyISOCode);
      }
      
      for(Account acc: accountList)
      {
           if(ownerCurrencyMap.containsKey(acc.OwnerId))
           {
               acc.CurrencyISOCode = ownerCurrencyMap.get(acc.OwnerId);
           }
      } 
        
    }
    
    public void updateChildEvents(Map<Id,Account> accNewMap, Map<Id,Account> accOldMap)
    {
        set<ID> accIdset = new Set<Id>();
        for(Account acc : accNewMap.values())
        {
            if(accOldMap.get(acc.Id).Name != acc.Name || accOldMap.get(acc.Id).Customer_Status__c != acc.Customer_Status__c || accOldMap.get(acc.Id).Account_Type__c != acc.Account_Type__c)
            {
                accIdset.add(acc.Id);
            }
        }
        
        Map<Id,Event> eveMap = new Map<Id,Event>([Select whatId,Account_Type__c,Account_Customer_Status__c,Account_Name__c,Event_Related_To_Accounts__c from Event where ActivityDate >=TODAY  and whatId in : accIdset]);
        List<Event> eveUpdateList = new List<Event>();
      if(!eveMap.isEmpty())
      {  
        for(Event eve: eveMap.values())
        {
               eve.Account_Type__c = accNewMap.get(eve.whatId).Account_Type__c;
               eve.Account_Customer_Status__c = accNewMap.get(eve.whatId).Customer_Status__c;
               eve.Account_Name__c = accNewMap.get(eve.whatId).Name;
               eve.Event_Related_To_Accounts__c = 'Account';
               eve.Account__c = eve.whatId;
               eveUpdateList.add(eve);
        }
      } 
       /* if(!eveUpdateList.isEmpty())
        {
            update eveUpdateList;
        }  */ 
    }
    
     /*
     Method Name-:suspendedAccountUpdate
     Description-:This method is defined to update the account owner to Data Steward and remove account team members
                   when Sales Status of account is changed to Suspended.
     Input parameter-:List of accounts
     Output parameter-:None
    */
    public void suspendedAccountUpdate(List<Account> suspendedaccountlist){
       
       String ProfileName;
       Set<Id> acctembrids=new Set<Id>();
       Map<String,String> pval=new Map<String,String>();
       User ds;
        
      // To check loggedin user Business Unit
       User u=[Select Id, Name,Profile_Name__c,Business_Unit__c from User where Id = :UserInfo.getUserId()];
   
       List<ProfileSettingDataSteward__c> ps= ProfileSettingDataSteward__c.getall().values();
        // To check if the customsetting values are not empty put the values in map and get the profile based on business unit.
         if(!ps.isEmpty()){
            for(ProfileSettingDataSteward__c p: ps){
                    pval.put(p.Name,p.ProfileName__c);
                }
              }
      
           if(pval.containskey(u.Business_Unit__c)){
                 ProfileName=pval.get(u.Business_Unit__c); 
                 ds= [Select id,Name,Profile_Name__c,isactive from User where isactive=true and Profile_Name__c=:ProfileName and (NOT Name like '%Master%') limit 1];
           }
          for(Account acc:suspendedaccountlist){
              SuspendedAccountSettings__c spndAccSetting = SuspendedAccountSettings__c.getValues(acc.Business__c); 
                if(!String.isBlank(ProfileName)){
                     if(acc.Customer_Status__c==Label.Suspended && string.isNotBlank(ds.id) && spndAccSetting.Account_Team_Delete__c){
                        acc.ownerId=ds.Id;
                        acctembrids.add(acc.id);           
                     }
                   }
             
             else{ if(acc.Customer_Status__c==Label.Suspended)
                      acc.addError('Your Business Unit is not mapped in Profile Custom settings.Please contact system administrator');
                     }
                 }
             
             // To get all the account team members and remove it from account.
           if(!acctembrids.isEmpty()){
                List<AccountTeamMember> accntmblst= [Select Id from AccountTeamMember where AccountId =:acctembrids]; 
                try{
                     delete accntmblst;
                   }
                catch(Exception e){
                    System.debug('The following exception has occurred: ' + e.getMessage());                    
                  }
               }
                    
            } 
            
            
 /*
     Method Name-:BusinessAutoUpdate
     Description-:This method  update the account owner Business to account record business
     Input parameter-:List of accounts
     Output parameter-:None
    */
    public void BusinessAutoUpdate(List<Account> acclist){
        
        map<id,user> Users = new map<id,user>();
        for(account ac:acclist) 
        {   
            Users.put(ac.OwnerId,null);
        }
        Users.remove(null);
        Users.putAll([select id,name,Business_Unit__c from user where id in :Users.keyset()]);
        System.debug('Users@@@@@@'+Users);
        
        for(account acc:acclist)
        {
            if(Users.containskey(acc.OwnerId))
            {
                acc.Business__c=Users.get(acc.OwnerId).Business_Unit__c;
            }
            
        }
          
    }           
            
    
}