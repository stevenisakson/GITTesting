@isTest
public class ContactDetailPage_ctrl_Test {
    
    
    Static Testmethod void Tetsmethod1()
    {
        
        
        contact con=new contact();
        con.lastname='test';
        insert con;
        
        PageReference pageRef = Page.LabyrinthContactDetailPage;
        system.Test.setCurrentPage(pageRef);
       

         pageRef.getParameters().put('Id', String.valueOf(con.Id));
         ApexPages.StandardController sc = new ApexPages.StandardController(con);
         ContactDetailPage_ctrl conplan = new ContactDetailPage_ctrl(sc);
         ContactDetailPage_ctrl c=new ContactDetailPage_ctrl();
        
        conplan.editcontact();
        conplan.load();
        conplan.newEventCreation();
        conplan.newTaskCreation();
        try
        {
            conplan.deleteev();
           
        }
        catch(Exception ex)
        {
            
        }
        
        
    }
    Static Testmethod void Tetsmethod2()
    {
        
        
        contact con=new contact();
        con.lastname='test';
        insert con;
        
        PageReference pageRef = Page.LabyrinthContactDetailPage;
        system.Test.setCurrentPage(pageRef);
       

         pageRef.getParameters().put('Id', String.valueOf(con.Id));
         ApexPages.StandardController sc = new ApexPages.StandardController(con);
         ContactDetailPage_ctrl conplan = new ContactDetailPage_ctrl(sc);
         ContactDetailPage_ctrl c=new ContactDetailPage_ctrl();
        
        conplan.editcontact();
        conplan.load();
        conplan.newEventCreation();
        conplan.newTaskCreation();
        try
        {
           conplan.deleteta();
       
        }
        catch(Exception ex)
        {
            
        }
        
        
    }
    

}