trigger deactivateUser on uf__User_Status__c (after update) {
    List<User> userDetailList=new List<User>();
    List<uf__User_Status__c> userStatusList=new List<uf__User_Status__c>();
     System.debug('Hello');
    User userObj;
    String userId ; 
    for(uf__User_Status__c us:trigger.new){
    
    if(us.uf__Reason_for_Inactivity__c == 'No Longer Need Salesforce'){
   
           userId = us.uf__User__c;
             
        }
      }
      
      deactivateUserNew.deactivateUserID(userId);
    
}