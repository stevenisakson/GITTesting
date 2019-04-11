@isTest(seealldata=true)
public class labyrinthAccountDetail_Test
{

    static testmethod void testmethod1()
    {
       
       
              
        account acc=new account();
        acc.name='test';
        acc.Business__c='US';
        insert acc;
        
        contact con=new contact();
        con.lastname='test';
        insert con;
        
  /*      CDH_External_System__c es=new CDH_External_System__c();
     //   es.name='test';
        es.Accounts__c=acc.id;
        insert es;
        */
        
        
        PageReference pageRef = Page.LabyrinthAccountDetailPage;
        system.Test.setCurrentPage(pageRef);
       

         pageRef.getParameters().put('Id', String.valueOf(acc.Id));
         ApexPages.StandardController sc = new ApexPages.StandardController(acc);
         labyrinthAccountDetail testAccPlan = new labyrinthAccountDetail(sc);
         
         try
         {
             testAccPlan.deletecon();
              
         }
         catch(Exception e1)
         {
         
         }
         
         testAccPlan.newContactCreation();
         testAccPlan.newTaskCreation();
         testAccPlan.newEventCreation();
         testAccPlan.editaccount();
        
         
         testAccPlan.load();
        
    }
    
    static testmethod void testmethodeventdel()
    {
       
       
              
        account acc=new account();
        acc.name='test';
        acc.Business__c='US';
        insert acc;
        
        contact con=new contact();
        con.lastname='test';
        insert con;
        
        
        
        PageReference pageRef = Page.LabyrinthAccountDetailPage;
        system.Test.setCurrentPage(pageRef);
       

         pageRef.getParameters().put('Id', String.valueOf(acc.Id));
         ApexPages.StandardController sc = new ApexPages.StandardController(acc);
         labyrinthAccountDetail testAccPlan = new labyrinthAccountDetail(sc);
         
         try
         {
            
              testAccPlan.deleteev();
             
         }
         catch(Exception e1)
         {
         
         }
         
         testAccPlan.newContactCreation();
         testAccPlan.newTaskCreation();
         testAccPlan.newEventCreation();
         testAccPlan.editaccount();
         
         
         testAccPlan.load();
        
    }
    
    static testmethod void testmethodtaskdel()
    {
       
       
              
        account acc=new account();
        acc.name='test';
        acc.Business__c='US';
        insert acc;
        
        contact con=new contact();
        con.lastname='test';
        insert con;
        
        
        
        PageReference pageRef = Page.LabyrinthAccountDetailPage;
        system.Test.setCurrentPage(pageRef);
       

         pageRef.getParameters().put('Id', String.valueOf(acc.Id));
         ApexPages.StandardController sc = new ApexPages.StandardController(acc);
         labyrinthAccountDetail testAccPlan = new labyrinthAccountDetail(sc);
         
         try
         {
             testAccPlan.deleteta();
         }
         catch(Exception e1)
         {
         
         }
         
         testAccPlan.newContactCreation();
         testAccPlan.newTaskCreation();
         testAccPlan.newEventCreation();
         testAccPlan.editaccount();
        
         
         testAccPlan.load();
        
    }
    
    static testmethod void testmethodtaskdelatt()
    {
       
       
              
        account acc=new account();
        acc.name='test';
        acc.Business__c='US';
        insert acc;
        
        contact con=new contact();
        con.lastname='test';
        insert con;
        
        
        
        PageReference pageRef = Page.LabyrinthAccountDetailPage;
        system.Test.setCurrentPage(pageRef);
       

         pageRef.getParameters().put('Id', String.valueOf(acc.Id));
         ApexPages.StandardController sc = new ApexPages.StandardController(acc);
         labyrinthAccountDetail testAccPlan = new labyrinthAccountDetail(sc);
         
         try
         {
             testAccPlan.deleteattachment();
         }
         catch(Exception e1)
         {
         
         }
         
        
        
    }
    

    

    

    


}