/*********************************************************
      ** Author: Poonam Yadav
      ** Date: 9-Oct-2018
      ** Description: Thsis class is used to create ThirdParty Validation Request for CPN INDIA
      ***********************************************************/

public class ThirdpartyValidationRequestController{

     
    @auraEnabled
    public static String getcreateRecord( Id accountID){
    
     string request ='';
     system.debug('in side my class calling');
     Override_Settings__c mhc = Override_Settings__c.getInstance();
    string mPhone = mhc.Third_Party_Record_Type_ID__c;
     system.debug('mPhone :::::::::'+mPhone);
     
         RecordType recordType = [select id,name from RecordType  where ID =: mPhone ];
         system.debug('recordType ::::::::::::'+recordType );
  
    Account Accrecord =[select id,name,Prospect_Validated__c,Status__c from Account where  ID =: accountID];
    List<Request__c> reqlst=[ Select Id,Name,Status__c, Account__c from Request__C where Id=: accountid];
    Account accnt=new Account();
    system.debug('Accrecord :::::::::::::::'+Accrecord);
    system.debug('Accrecord.Prospect_Validated__c:::::::'+Accrecord.Prospect_Validated__c);
    
    
    
    if( Accrecord.Status__c =='Rejected'|| Accrecord.Status__c =='Recalled'){
           
    
            Request__c  requestRecord = new  Request__c();
            
            requestRecord.RecordTypeId= RecordType.id;
            requestRecord.Account__c = accountID;
            insert requestRecord ;
           // accnt.Status__c='New';
           // accnt.id=Accrecord.id;
           // update accnt;
          //  ischeck = true;
          if(requestRecord.Id != null){
            //request= 'Request is created successfully';
            request= System.Label.POT_Converttocustomer_successfully;
            }
       }
       else  if(Accrecord.Status__c =='Approved' ){
       
        //  request= 'Request is already created ..';
        request= System.Label.POT_Convert_alreadycreated;
        
       }
        else if(Accrecord.Status__c =='New'){
        
      
          request= System.Label.Request_already_Created;
    
        }
        
       return request;
    
    }


}