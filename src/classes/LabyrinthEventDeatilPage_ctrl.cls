public class LabyrinthEventDeatilPage_ctrl {

      public id eventid {set;get;}
      public list<Visit_Report__c> vr{set;get;}
      
      public list<attachment> attachments {set;get;}
      public string attId {set;get;}
      

    public LabyrinthEventDeatilPage_ctrl(ApexPages.StandardController controller) {
    
        eventid = ApexPages.currentPage().getParameters().get('id');
        load();
        loadattachment();

    }
    
    public pagereference EditEvent()
    {
       
               PageReference pr=new PageReference('/apex/LabyrinthEventNewPage');
               pr.getParameters().put('id',eventid);
               pr.setRedirect(true);
               return pr; 
     
    }
    
    public void load()
    {
        vr=[select id,name,External_Call_Notes__c,Internal_Call_Notes__c,Event_ID__c from Visit_Report__c where Event_ID__c=:eventid];
    }
    
    public void loadattachment()
    {
         attachments = [SELECT Id, ParentId, Name, LastModifiedDate, BodyLength FROM Attachment WHERE ParentId=:eventid];
    }
    
    public void deleteattachment(){
       
       attachments = [SELECT Id, ParentId, Name, LastModifiedDate, BodyLength FROM Attachment WHERE id=:attId];
         
       if(attachments.size() > 0 || attachments[0].Id != ''){
         delete attachments;
        }
        loadattachment(); 
        
        }

}