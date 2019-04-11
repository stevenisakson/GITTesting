public class LabyrinthTaskDetailPage {
    
    public id taskid {set;get;}

    public LabyrinthTaskDetailPage(ApexPages.StandardController controller) {
            
           taskid = ApexPages.currentPage().getParameters().get('id');
    }
    
    public pagereference edittask()
    {
       
               PageReference pr=new PageReference('/apex/LabyrinthTaskNewPage');
               pr.getParameters().put('id',taskid );
               pr.setRedirect(true);
               return pr;  
     
    }

}