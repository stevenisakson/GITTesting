public with sharing class LabyrinthAccountNewPage {

    public account acc {set;get;}
    public string accid ;

    public LabyrinthAccountNewPage(ApexPages.StandardController controller) {
    
         
    
       accid =ApexPages.currentPage().getParameters().get('id');  
        if(accid != null && accid !='')    
          {                        
           acc = (Account)controller.getRecord();
            
          }
           else                                                      
           acc=new Account(); 
        //   acc.ownerId = UserInfo.getUserId() ;
            
        

    }
    
     public PageReference save()
         {
         
          if(accid != null && accid !='')
           {
           
           update acc;
          
           }
          else
          {
           insert acc; 
           }
           
           PageReference pr=new PageReference('/apex/LabyrinthAccountDetailPage');
           pr.getParameters().put('id',acc.id);
           pr.setRedirect(true);
           return pr;  
      }
      
     public PageReference Cancel()
         {
               PageReference pr=new PageReference('/apex/LabyrinthAccountDetailPage');
               pr.getParameters().put('id',accid );
               pr.setRedirect(true);
               return pr;  
         }

}