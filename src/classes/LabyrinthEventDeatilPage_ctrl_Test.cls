@isTest(seealldata=true)
public class LabyrinthEventDeatilPage_ctrl_Test
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
        
         
         Event e = new Event();
         
         e.Subject='Test for trigger';
         e.WhatId=acc.id;
         e.WhoId=con.id;
         e.OwnerId=userToCreate.id;
         e.Type='Visit';
         e.IsAllDayEvent=false;
         e.DurationInMinutes=60;
         e.activitydatetime=system.now();
         e.ShowAs = 'Busy';
         e.IsReminderSet = false;
       
         insert e;
         
          Test.StartTest(); 

            ApexPages.StandardController sc = new ApexPages.StandardController( e);
            LabyrinthEventDeatilPage_ctrl  testTest = new LabyrinthEventDeatilPage_ctrl (sc);
            testTest.EditEvent();
            
            
        Test.StopTest();
                      
    }
    static testmethod void testmethod2()
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
        
        Blob b = Blob.valueOf('Test Data');
        Attachment attachment = new Attachment();
        attachment.ParentId = acc.ID;
        attachment.Name = 'TestAttachmentforParent.xls';
        attachment.Body = b;
        insert(attachment);
        
         
         Event e = new Event();
         
         e.Subject='Test for trigger';
         e.WhatId=acc.id;
         e.WhoId=con.id;
         e.OwnerId=userToCreate.id;
         e.Type='Visit';
         e.IsAllDayEvent=false;
         e.DurationInMinutes=60;
         e.activitydatetime=system.now();
         e.ShowAs = 'Busy';
         e.IsReminderSet = false;
       
         insert e;
         
          Test.StartTest(); 
          
            ApexPages.currentPage().getParameters().put('attId',attachment.id);

            ApexPages.StandardController sc = new ApexPages.StandardController( e);
            LabyrinthEventDeatilPage_ctrl  testTest = new LabyrinthEventDeatilPage_ctrl (sc);
            try
            {
            testTest.deleteattachment();
            }
            catch(Exception ex)
            {
                
            }
            
        Test.StopTest();
                      
    }
    
    
}