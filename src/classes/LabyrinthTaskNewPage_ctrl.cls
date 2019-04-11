public class LabyrinthTaskNewPage_ctrl {
    
    public task ta{set;get;}
    
    public LabyrinthTaskNewPage_ctrl(ApexPages.StandardController controller) {
     
        List<string> taskapi = new List<string>();
        
          taskapi.add('ownerid');
          taskapi.add('whatid');
          taskapi.add('Subject');
          taskapi.add('Whoid');
          taskapi.add('ActivityDate');
          taskapi.add('RecurrenceInterval');
          taskapi.add('Description');
          taskapi.add('Business_Unit__c');
          taskapi.add('Segment__c');
          taskapi.add('Status');
          taskapi.add('Product_Line__c');
          taskapi.add('Priority');
          taskapi.add('Group__c');
          taskapi.add('Class__c');
          taskapi.add('Product_Function__c');
         
         if(!Test.isRunningTest())
           {  
             controller.addFields(taskapi);
             ta= (task)controller.getRecord();   
           }
        if(ta!= null && ta.Id != null){
            
            if(ApexPages.currentPage().getParameters().get('status')=='Completed')
            {
                ta.status='Completed';
            }
            
            
        }
        else{
           
            ta=new Task();      
            ta.ownerid=UserInfo.getUserId();
            ta.whatid=ApexPages.currentPage().getParameters().get('what_id');
            ta.whoid=ApexPages.currentPage().getParameters().get('who_id');
            
            
            }
      
    }
    
     public pagereference Save()
    {
        pagereference pr;
        
                         try
                        {
                            if(ta!=null)
                           {
          
                              upsert ta;
          
                           }
                        }
                         catch(DMLException e){
                               ApexPages.Message msg = new ApexPages.Message(Apexpages.Severity.ERROR, e.getdmlMessage(0) );
                               ApexPages.addMessage(msg);
                               return null;
                        
                         } 
            
       
           
               if(ApexPages.currentPage().getParameters().get('what_id')!=null)
               {
                   pr=new PageReference('/apex/LabyrinthAccountDetailPage');
                   pr.getParameters().put('id',ta.whatid);
                   pr.setRedirect(true);
               }
               else if(ApexPages.currentPage().getParameters().get('who_id')!=null)
               {
                   pr=new PageReference('/apex/LabyrinthContactDetailPage');
                   pr.getParameters().put('id',ta.whoid);
                   pr.setRedirect(true);
               }
               else
               {
                   pr=new PageReference('/apex/LabyrinthTaskDetailPage');
                   pr.getParameters().put('id',ta.id);
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
                   pr.getParameters().put('id',ta.whatid);
                   pr.setRedirect(true);
               }
               else if(ApexPages.currentPage().getParameters().get('who_id')!=null)
               {
                   pr=new PageReference('/apex/LabyrinthContactDetailPage');
                   pr.getParameters().put('id',ta.whoid);
                   pr.setRedirect(true);
               }
               else
               {
                   pr=new PageReference('/apex/LabyrinthTaskDetailPage');
                   pr.getParameters().put('id',ta.id);
                   pr.setRedirect(true);   
               }
                   return pr; 
         }


}