@isTest
public class LabyrinthContactNewpage1_ctrl_Test
{
    static testmethod void testmethod1()
    {
        Profile p = [SELECT Id,Name FROM Profile WHERE Name='System Administrator' limit 1];
        System.debug('profile==='+p);
       User userToCreate = new User();       
       // Do you recognize these fields?
       userToCreate.FirstName = 'Ramesh';
       userToCreate.LastName  = 'y';
       userToCreate.Email     = 'yrameshsf@gmail.coom';
       userToCreate.Username  = 'yrameshsf@gmail.coom.4dx';
       userToCreate.Alias     = 'fatty';
       userToCreate.ProfileId = p.Id; 
 // Don't worry about these
       userToCreate.TimeZoneSidKey    = 'America/Denver';
       userToCreate.LocaleSidKey      = 'en_US';
       userToCreate.EmailEncodingKey  = 'UTF-8';
       userToCreate.LanguageLocaleKey = 'en_US';  
       userToCreate.Business_Unit__c  ='US';    
           
       
       userToCreate.IsActive= True;
       insert userToCreate; 
       
       
        account acc=new account();
        acc.name='test';
        acc.Business__c='US';
        insert acc;
        
        contact con=new contact();
        con.lastname='test';
        con.accountid=acc.id;
        upsert con;
        
       
        
        PageReference pageRef = Page.LabyrinthContactNewpage1;
        system.Test.setCurrentPage(pageRef);
        
       

         pageRef.getParameters().put('Id', String.valueOf(acc.Id));
         ApexPages.StandardController sc = new ApexPages.StandardController(acc);
         LabyrinthContactNewpage1_ctrl testAccPlan = new LabyrinthContactNewpage1_ctrl(sc);
         
        
                
       /*   List<string> contactFieldAPIs = new List<string>();
          contactFieldAPIs.add('lastname');
          contactFieldAPIs.add('accountid');
          sc.addFields(contactFieldAPIs); */
         
        try{
            testAccPlan.save();
        }catch(Exception ex){
            
        }
         
         testAccPlan.cancel();
    }
}