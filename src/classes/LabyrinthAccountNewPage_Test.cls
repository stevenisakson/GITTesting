@isTest
public class LabyrinthAccountNewPage_Test
{
    static testmethod void tesmethod1()
    {
        account acc=new account();
        acc.name='test';
        insert acc;
        
        PageReference pageRef = Page.LabyrinthAccountNewPage;
        system.Test.setCurrentPage(pageRef);

         pageRef.getParameters().put('Id', String.valueOf(acc.Id));
         ApexPages.StandardController sc = new ApexPages.StandardController(acc);
         LabyrinthAccountNewPage testAccPlan = new LabyrinthAccountNewPage(sc);
         testAccPlan.save();
         testAccPlan.cancel();
        
    }
    
}