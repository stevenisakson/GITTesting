public class ConverttoCustomerController{

   //  @auraEnabled public Boolean ischeck ;//{get;set;}
     
    @auraEnabled
    public static String getcreateRecord( Id accountID){
    
     string request ='';
     system.debug('in side my class calling');
     Override_Settings__c mhc = Override_Settings__c.getInstance();
    string mPhone = mhc.Prospect_Conversion_RecordTypeID__c;
     system.debug('mPhone :::::::::'+mPhone);
     
  //  RecordType recordType = [select id,name from RecordType  where ID ='012j00000010CWoAAM'];
         RecordType recordType = [select id,name from RecordType  where ID =: mPhone ];
         system.debug('recordType ::::::::::::'+recordType );
  
    Account Accrecord =[select id,name,Prospect_Validated__c,Status__c from Account where  ID =: accountID];
    
    system.debug('Accrecord :::::::::::::::'+Accrecord);
    system.debug('Accrecord.Prospect_Validated__c:::::::'+Accrecord.Prospect_Validated__c);
    
    
    
    if(Accrecord.Prospect_Validated__c == true && Accrecord.Status__c !='Conversion In progress'){
    
            Request__c  requestRecord = new  Request__c();
            
            requestRecord.RecordTypeId= RecordType.id;
            requestRecord.Account__c = accountID;
            insert requestRecord ;
            
          //  ischeck = true;
          if(requestRecord.Id != null){
            //request= 'Request is created successfully';
            request= System.Label.POT_Converttocustomer_successfully;
            }
       }
       else  if(Accrecord.Prospect_Validated__c == true && Accrecord.Status__c =='Conversion In progress' ){
       
        //  request= 'Request is already created ..';
        request= System.Label.POT_Convert_alreadycreated;
        
       }
        else if(Accrecord.Prospect_Validated__c == false){
        
      //request= 'This Prospect needs to be validated first';
          request= System.Label.POT_Convert_Validated;
    
        }
       return request;
    
    }
 
 
 }