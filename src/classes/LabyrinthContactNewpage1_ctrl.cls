public with sharing class LabyrinthContactNewpage1_ctrl {

    public contact con {set;get;}
    String accid;

    public LabyrinthContactNewpage1_ctrl(ApexPages.StandardController controller) {
    
          
          List<string> contactFieldAPIs = new List<string>();
          
          contactFieldAPIs.add('ownerid');
          contactFieldAPIs.add('ReportsToid');
          contactFieldAPIs.add('firstname');
          contactFieldAPIs.add('phone');
          contactFieldAPIs.add('lastname');
          contactFieldAPIs.add('MobilePhone');
          contactFieldAPIs.add('accountid');
          contactFieldAPIs.add('email');
          contactFieldAPIs.add('Title');
          contactFieldAPIs.add('Secondary_Email__c');
          contactFieldAPIs.add('Business_Unit__c');
          contactFieldAPIs.add('Preferred_Method__c');
          contactFieldAPIs.add('Marketing_Classification__c');
          contactFieldAPIs.add('Secondary_Language__c');
     //     contactFieldAPIs.add('MailingCountrycode');
    //      contactFieldAPIs.add('OtherCountrycode');
          
          contactFieldAPIs.add('MailingCountry');
          contactFieldAPIs.add('OtherCountry');
          
          contactFieldAPIs.add('MailingStreet');
          contactFieldAPIs.add('OtherStreet');
          contactFieldAPIs.add('MailingCity');
          contactFieldAPIs.add('OtherCity');
          
     //     contactFieldAPIs.add('MailingStateCode');
      //    contactFieldAPIs.add('OtherStateCode');
          
          contactFieldAPIs.add('MailingState');
          contactFieldAPIs.add('OtherState');
          contactFieldAPIs.add('MailingPostalCode');
          contactFieldAPIs.add('OtherPostalCode');
          contactFieldAPIs.add('AssistantName');
          contactFieldAPIs.add('Birthdate');
          contactFieldAPIs.add('AssistantPhone');
          contactFieldAPIs.add('Department');
          contactFieldAPIs.add('Website__c');
          contactFieldAPIs.add('Description');
          contactFieldAPIs.add('Primary_Language__c');
           contactFieldAPIs.add('name');
           
           if(!Test.isRunningTest())
             {
              controller.addFields(contactFieldAPIs);
              con = (Contact)controller.getRecord();
             }
         
          
          accid=ApexPages.currentPage().getParameters().get('accid');
          
          
          system.debug('===='+accid+'====accid======');
          
          
     
           if(con != null && con .Id != null){
        
            
            }
        else{
           
             con =new Contact();
             con.Ownerid=UserInfo.getUserId();
             con.accountid=accid ;
                       
            
        }
       
    }
    
            public PageReference save()
                     {
                         
                        try
                        {
                          if(con!=null)
                           {
                          
                                  upsert con;
                          
                           }
                         }
                         catch(DMLException e){
                               ApexPages.Message msg = new ApexPages.Message(Apexpages.Severity.ERROR, e.getdmlMessage(0) );
                               ApexPages.addMessage(msg);
                               return null;
                        
                         } 
                           PageReference pr=new PageReference('/apex/LabyrinthAccountDetailPage');
                           pr.getParameters().put('id',con.accountid);
                           pr.setRedirect(true);
                          return pr;   
                     }
             
            public PageReference Cancel()
                 {
                       PageReference pr=new PageReference('/apex/LabyrinthAccountDetailPage');
                       pr.getParameters().put('id',con.accountid);
                       pr.setRedirect(true);
                       return pr;  
                 }
            
    
  
        

}