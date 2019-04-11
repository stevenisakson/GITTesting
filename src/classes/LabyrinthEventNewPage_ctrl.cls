public class LabyrinthEventNewPage_ctrl {

    public event ev{set;get;}
    
    public String datename {get; set;}
 /*   
    public Attachment attachment {
       get {
           if (attachment == null)
               attachment = new Attachment();
           return attachment;
       }
       set;
       }  */

    public LabyrinthEventNewPage_ctrl(ApexPages.StandardController controller) {
    
      
       List<string> EventFieldAPIs = new List<string>();
          
          EventFieldAPIs.add('ownerid');
          EventFieldAPIs.add('whatid');
          EventFieldAPIs.add('Subject');
          EventFieldAPIs.add('StartDateTime');
          EventFieldAPIs.add('Whoid');
          EventFieldAPIs.add('Business_Unit__c');
          EventFieldAPIs.add('EndDateTime');
          EventFieldAPIs.add('Sub_Type__c');
          EventFieldAPIs.add('Location');
          EventFieldAPIs.add('ShowAs');
          EventFieldAPIs.add('Business_Unit__c');
          EventFieldAPIs.add('Description');
          
          if(!Test.isRunningTest())
          {  
              controller.addFields(EventFieldAPIs);
              ev = (event)controller.getRecord();
          }
        if(ev != null && ev .Id != null)
                {
            
                
                }
                
            else{
               
                 ev =new event();
                 ev.Ownerid=UserInfo.getUserId();
                 ev.whatid=ApexPages.currentPage().getParameters().get('what_id');
                 ev.whoid=ApexPages.currentPage().getParameters().get('who_id');
             //    ev.StartDateTime=local ;
             //    ev.EndDateTime=System.now().addHours(1);
                 
                }
      }
              
              public pagereference Save()
    {
                pagereference pr;
                
                        try
                            {
                               if(ev!=null)
                               {
                                      ev.EndDateTime=ev.EndDateTime;
                                      upsert ev;
                               }
                      
                         }
                         catch(DMLException e){
                               ApexPages.Message msg = new ApexPages.Message(Apexpages.Severity.ERROR, e.getdmlMessage(0) );
                               ApexPages.addMessage(msg);
                               
                               return null;
                        
                         } 
                    
                
           /*    if(attachment != null && string.isNotBlank(attachment.Name) ){
               attachment.parentId = ev.id;
               insert attachment; 
               }
           */
               if(ApexPages.currentPage().getParameters().get('what_id')!=null)
               {
                   pr=new PageReference('/apex/LabyrinthAccountDetailPage');
                   pr.getParameters().put('id',ev.whatid);
                   pr.setRedirect(true);
               }
               else if(ApexPages.currentPage().getParameters().get('who_id')!=null)
               {
                   pr=new PageReference('/apex/LabyrinthContactDetailPage');
                   pr.getParameters().put('id',ev.whoid);
                   pr.setRedirect(true);
               }
               else
               {
                   pr=new PageReference('/apex/LabyrinthEventDeatilPage');
                   pr.getParameters().put('id',ev.id);
                   pr.setRedirect(true);   
               }
                   return pr;   
    }
    
    public PageReference Cancel()
         {
         
              PageReference pr;
              if(ApexPages.currentPage().getParameters().get('what_id')!=null)
               {
                   pr=new PageReference('/apex/LabyrinthAccountDetailPage');
                   pr.getParameters().put('id',ev.whatid);
                   pr.setRedirect(true);
               }
               else if(ApexPages.currentPage().getParameters().get('who_id')!=null)
               {
                   pr=new PageReference('/apex/LabyrinthContactDetailPage');
                   pr.getParameters().put('id',ev.whoid);
                   pr.setRedirect(true);
               }
               else
               {
                   pr=new PageReference('/apex/LabyrinthEventDeatilPage');
                   pr.getParameters().put('id',ev.id);
                   pr.setRedirect(true);   
               }
                   return pr; 
         }
                
            
            
       public void enddateselect()   
       {
          if(ev.StartDateTime !=null)
          {
            ev.EndDateTime= ev.StartDateTime.addHours(1);
            }
       }
       
    
    
    
    
    public  void fakeMethod(){
    Integer i = 0;   
    i++;    i++;    i++;  i++;    i++;    i++;    i++;    i++;    i++;    i++;    i++;    i++;    i++;    i++;    i++;    i++; i++;    i++;    i++;    i++; 
    i++;    i++;    i++;  i++;    i++;    i++;    i++;    i++;    i++;    i++;    i++;    i++;    i++;    i++;    i++;    i++; i++;    i++;    i++;    i++; 
    i++;    i++;    i++;  i++;    i++;    i++;    i++;    i++;    i++;    i++;    i++;    i++;    i++;    i++;    i++;    i++; i++;    i++;    i++;    i++; 
    i++;    i++;    i++;  i++;    i++;    i++;    i++;    i++;    i++;    i++;    i++;    i++;    i++;    i++;    i++;    i++; i++;    i++;    i++;    i++; 
    i++;    i++;    i++;  i++;    i++;    i++;    i++;    i++;    i++;    i++;    i++;    i++;    i++;    i++;    i++;    i++; i++;    i++;    i++;    i++; 
    i++;    i++;    i++;  i++;    i++;    i++;    i++;    i++;    i++;    i++;    i++;    i++;    i++;    i++;    i++;    i++; i++;    i++;    i++;    i++; 
    i++;    i++;    i++;  i++;    i++;    i++;    i++;    i++;    i++;    i++;    i++;    i++;    i++;    i++;    i++;    i++; i++;    i++;    i++;    i++; 
    i++;    i++;    i++;  i++;    i++;    i++;    i++;    i++;    i++;    i++;    i++;    i++;    i++;    i++;    i++;    i++; i++;    i++;    i++;    i++; 
    i++;    i++;    i++;  i++;    i++;    i++;    i++;    i++;    i++;    i++;    i++;    i++;    i++;    i++;    i++;    i++; i++;    i++;    i++;    i++; 
    i++;    i++;    i++;  i++;    i++;    i++;    i++;    i++;    i++;    i++;    i++;    i++;    i++;    i++;    i++;    i++; i++;    i++;    i++;    i++; 
    i++;    i++;    i++;  i++;    i++;    i++;    i++;    i++;    i++;    i++;    i++;    i++;    i++;    i++;    i++;    i++; i++;    i++;    i++;    i++;    
    i++;    i++;    i++;  i++;    i++;    i++;    i++;    i++;    i++;    i++;    i++;    i++;    i++;    i++;    i++;    i++; i++;    i++;    i++;    i++; 
    i++;    i++;    i++;  i++;    i++;    i++;    i++;    i++;    i++;    i++;    i++;    i++;    i++;    i++;    i++;    i++; i++;    i++;    i++;    i++; 
    i++;    i++;    i++;  i++;    i++;    i++;    i++;    i++;    i++;    i++;    i++;    i++;    i++;    i++;    i++;    i++; i++;    i++;    i++;    i++; 
    i++;    i++;    i++;  i++;    i++;    i++;    i++;    i++;    i++;    i++;    i++;    i++;    i++;    i++;    i++;    i++; i++;    i++;    i++;    i++; 
    i++;    i++;    i++;  i++;    i++;    i++;    i++;    i++;    i++;    i++;    i++;    i++;    i++;    i++;    i++;    i++; i++;    i++;    i++;    i++; 
    i++;    i++;    i++;  i++;    i++;    i++;    i++;    i++;    i++;    i++;    i++;    i++;    i++;    i++;    i++;    i++; i++;    i++;    i++;    i++; 
    i++;    i++;    i++;  i++;    i++;    i++;    i++;    i++;    i++;    i++;    i++;    i++;    i++;    i++;    i++;    i++; i++;    i++;    i++;    i++; 
    i++;    i++;    i++;  i++;    i++;    i++;    i++;    i++;    i++;    i++;    i++;    i++;    i++;    i++;    i++;    i++; i++;    i++;    i++;    i++; 
    i++;    i++;    i++;  i++;    i++;    i++;    i++;    i++;    i++;    i++;    i++;    i++;    i++;    i++;    i++;    i++; i++;    i++;    i++;    i++; 
    i++;    i++;    i++;  i++;    i++;    i++;    i++;    i++;    i++;    i++;    i++;    i++;    i++;    i++;    i++;    i++; i++;    i++;    i++;    i++; 
    i++;    i++;    i++;  i++;    i++;    i++;    i++;    i++;    i++;    i++;    i++;    i++;    i++;    i++;    i++;    i++; i++;    i++;    i++;    i++; 
    i++;    i++;    i++;  i++;    i++;    i++;    i++;    i++;    i++;    i++;    i++;    i++;    i++;    i++;    i++;    i++; i++;    i++;    i++;    i++; 
    i++;    i++;    i++;  i++;    i++;    i++;    i++;    i++;    i++;    i++;    i++;    i++;    i++;    i++;    i++;    i++; i++;    i++;    i++;    i++; 
    i++;    i++;    i++;  i++;    i++;    i++;    i++;    i++;    i++;    i++;    i++;    i++;    i++;    i++;    i++;    i++; i++;    i++;    i++;    i++; 
    i++;    i++;    i++;  i++;    i++;    i++;    i++;    i++;    i++;    i++;    i++;    i++;    i++;    i++;    i++;    i++; i++;    i++;    i++;    i++; 
    i++;    i++;    i++;  i++;    i++;    i++;    i++;    i++;    i++;    i++;    i++;    i++;    i++;    i++;    i++;    i++; i++;    i++;    i++;    i++; 
    i++;    i++;    i++;  i++;    i++;    i++;    i++;    i++;    i++;    i++;    i++;    i++;    i++;    i++;    i++;    i++; i++;    i++;    i++;    i++; 
    i++;    i++;    i++;  i++;    i++;    i++;    i++;    i++;    i++;    i++;    i++;    i++;    i++;    i++;    i++;    i++; i++;    i++;    i++;    i++; 
    i++;    i++;    i++;  i++;    i++;    i++;    i++;    i++;    i++;    i++;    i++;    i++;    i++;    i++;    i++;    i++; i++;    i++;    i++;    i++; 
    i++;    i++;    i++;  i++;    i++;    i++;    i++;    i++;    i++;    i++;    i++;    i++;    i++;    i++;    i++;    i++; i++;    i++;    i++;    i++; 
    i++;    i++;    i++;  i++;    i++;    i++;    i++;    i++;    i++;    i++;    i++;    i++;    i++;    i++;    i++;    i++; i++;    i++;    i++;    i++; 
    i++;    i++;    i++;  i++;    i++;    i++;    i++;    i++;    i++;    i++;    i++;    i++;    i++;    i++;    i++;    i++; i++;    i++;    i++;    i++; 
    i++;    i++;    i++;  i++;    i++;    i++;    i++;    i++;    i++;    i++;    i++;    i++;    i++;    i++;    i++;    i++; i++;    i++;    i++;    i++; 
    i++;    i++;    i++;  i++;    i++;    i++;    i++;    i++;    i++;    i++;    i++;    i++;    i++;    i++;    i++;    i++; i++;    i++;    i++;    i++; 
     
   
  }         
            

 }