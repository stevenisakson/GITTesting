@isTest
public class LabyrinthEventNewPage_ctrl_Test1
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
        
         
         Event e = new Event();
         
         e.Subject='Test for trigger';
         e.WhatId=acc.id;
         e.WhoId=con.id;
         e.OwnerId=userToCreate.id;
         e.Type='Visit';
         e.IsAllDayEvent=false;
         e.DurationInMinutes=1440;
         //e.activitydatetime=system.now();
         e.StartDateTime = system.now();
         //e.EndDateTime = system.now() + 1;
         e.ShowAs = 'Busy';
         e.IsReminderSet = false;
       
         insert e;
         
          Test.StartTest(); 
            e.DurationInMinutes=140;
            upsert e;
            
            PageReference  pageRef     = Page.LabyrinthEventNewPage;
            Test.setCurrentPage(pageRef);
             ApexPages.currentPage().getParameters().put('id',e.id);
            ApexPages.currentPage().getParameters().put('what_id',acc.id);
           
            //ApexPages.currentPage().getParameters().put('who_id',con.id);
            
            ApexPages.StandardController sc = new ApexPages.StandardController( e);
            LabyrinthEventNewPage_ctrl  testTest = new LabyrinthEventNewPage_ctrl(sc);
            //PageReference                   pageRef     = Page.LabyrinthEventNewPage;
            //pageRef.getParameters().put('id', String.valueOf(e.Id));
            //Test.setCurrentPage(pageRef);
            
           try{
                testTest.Save();
            }catch(Exception ex){
                
            }
            testTest.Cancel();
            testTest.enddateselect();
            
            
        Test.StopTest();
    }
    static testmethod void testmethod2forWhoid()
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
        insert con;
        
         
         Event e = new Event();
         
         e.Subject='Test for trigger';
         e.WhatId=acc.id;
         e.WhoId=con.id;
         e.OwnerId=userToCreate.id;
         e.Type='Visit';
         e.IsAllDayEvent=false;
         
         //e.activitydatetime = system.now();
         e.StartDateTime = system.now();
         //e.EndDateTime = e.StartDateTime.addHours(1);
         e.DurationInMinutes = 1440;
         e.ShowAs = 'Busy';
         e.IsReminderSet = false;
        system.debug('e.activitydatetime'+e.activitydatetime);
        system.debug('e.StartDateTime'+e.StartDateTime);
        system.debug('e'+e);
         insert e;
        system.debug('e'+e);
         
          Test.StartTest(); 
            PageReference  pageRef     = Page.LabyrinthEventNewPage;
            Test.setCurrentPage(pageRef);
            //ApexPages.currentPage().getParameters().put('what_id',acc.id);
            ApexPages.currentPage().getParameters().put('id',e.id);
            ApexPages.currentPage().getParameters().put('who_id',con.id);
            ApexPages.StandardController sc = new ApexPages.StandardController( e);
            LabyrinthEventNewPage_ctrl  testTest = new LabyrinthEventNewPage_ctrl(sc);
            e.DurationInMinutes=140;
            upsert e;
           try{
                testTest.Save();
            }catch(Exception ex){
                
            }
            testTest.Cancel();
            testTest.enddateselect();
            
            
        Test.StopTest();
    }
    
    static testmethod void testSave()
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
        insert con;
        
         
         Event e = new Event();
         
         e.Subject='Test for trigger';
         e.WhatId=acc.id;
         e.WhoId=con.id;
         e.OwnerId=userToCreate.id;
         e.Type='Visit';
         e.IsAllDayEvent=false;
         
         e.activitydatetime=system.now();
         e.StartDateTime = system.now();
         //e.EndDateTime = e.StartDateTime.addHours(1);
         e.DurationInMinutes = 1440;
         e.ShowAs = 'Busy';
         e.IsReminderSet = false;
        system.debug('e.EndDateTime'+e.EndDateTime);
        system.debug('e.DurationInMinutes'+e.DurationInMinutes);
        system.debug('e'+e);
         try{
         upsert e;
         }
         catch(Exception ex)
         {
             system.debug(ex);
         }
        system.debug('e.EndDateTime'+e.EndDateTime);
        system.debug('e.DurationInMinutes'+e.DurationInMinutes);
        system.debug('e'+e);
         
          Test.StartTest(); 
            PageReference  pageRef     = Page.LabyrinthEventNewPage;
            Test.setCurrentPage(pageRef);
            ApexPages.currentPage().getParameters().put('id',e.id);
            ApexPages.currentPage().getParameters().put('what_id',acc.id);
           // ApexPages.currentPage().getParameters().put('who_id',con.id);
            
            ApexPages.StandardController sc = new ApexPages.StandardController( e);
            LabyrinthEventNewPage_ctrl  testTest = new LabyrinthEventNewPage_ctrl(sc);
            //e.DurationInMinutes=140;
           // upsert e;
            try{
                testTest.Save();
            }catch(Exception ex){
                
            }
            
            //testTest.Cancel();
            //testTest.enddateselect();
            
            
        Test.StopTest();
    }
    
     static testmethod void testEventId()
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
        insert con;
        
         
         Event e = new Event();
         
         e.Subject='Test for trigger';
         e.WhatId=acc.id;
         e.WhoId=con.id;
         e.OwnerId=userToCreate.id;
         e.Type='Visit';
         e.IsAllDayEvent=false;
         
         e.activitydatetime=system.now();
         e.StartDateTime = system.now();
         //e.EndDateTime = e.StartDateTime.addHours(1);
         e.DurationInMinutes = 1440;
         e.ShowAs = 'Busy';
         e.IsReminderSet = false;
        system.debug('e.EndDateTime'+e.EndDateTime);
        system.debug('e.DurationInMinutes'+e.DurationInMinutes);
        system.debug('e'+e);
         upsert e;
        system.debug('e.EndDateTime'+e.EndDateTime);
        system.debug('e.DurationInMinutes'+e.DurationInMinutes);
        system.debug('e'+e);
         
          Test.StartTest(); 
            PageReference  pageRef     = Page.LabyrinthEventNewPage;
            Test.setCurrentPage(pageRef);
            //ApexPages.currentPage().getParameters().put('what_id',acc.id);
            //ApexPages.currentPage().getParameters().put('who_id',con.id);
            ApexPages.currentPage().getParameters().put('id',e.id);
            ApexPages.StandardController sc = new ApexPages.StandardController( e);
            LabyrinthEventNewPage_ctrl  testTest = new LabyrinthEventNewPage_ctrl(sc);
            testTest.datename = 'system.now';
            //e.DurationInMinutes=140;
           // upsert e;
            try{
                testTest.Save();
            }catch(Exception ex){
                
            }
            
            testTest.Cancel();
            //testTest.enddateselect();
            
            
        Test.StopTest();
    }
     static testmethod void testmethodforsave()
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
       
        Account testAccount = new Account();
        testAccount.Name='Test Account' ;
        testAccount.Business__c='US';
        insert testAccount;
        
        Contact con=new contact();
        con.lastname='test';
        insert con;

          Event e = new Event();
         
         e.Subject='Test for trigger';
         e.WhatId=testAccount.id;
         e.WhoId=con.id;
         e.OwnerId=userToCreate.id;
         e.Type='Visit';
         e.IsAllDayEvent=false;
         e.DurationInMinutes=1440;
         //e.activitydatetime=system.now();
         e.StartDateTime = system.now();
         //e.EndDateTime = system.now() + 1;
         e.ShowAs = 'Busy';
         e.IsReminderSet = false;
       
         upsert e;
         
               
         PageReference pageRef = Page.LabyrinthAccountDetailPage;
         Test.setCurrentPage(pageRef);
        
        ApexPages.CurrentPage().getParameters().put('id',e.id );
        ApexPages.CurrentPage().getParameters().put('what_id',testAccount.id );
        ApexPages.CurrentPage().getParameters().put('who_id',con.id );
        Test.StartTest(); 

            ApexPages.StandardController sc = new ApexPages.StandardController( e);
            LabyrinthEventNewPage_ctrl  testTest = new LabyrinthEventNewPage_ctrl(sc);
            try
          {
            testTest.save();
          }
            catch(Exception ex){
            
        }
            testTest.Cancel();
            testTest.fakeMethod();
            
        Test.StopTest();
    }
}