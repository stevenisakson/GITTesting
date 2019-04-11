@isTest
public class AccountlandingPage_Ctrl_Test
{
    /*    
    static testMethod void testmethod1()
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
       
       userToCreate.IsActive= True;
       insert userToCreate; 
       
      /*  Account acc = new Account(Name='Test_Account', Type='Dealer', RecordType=[select Id from RecordType where name=:Label.Standard_Record_Type and SObjectType='Account' limit 1], Segment_Step_1__c='Mila', Business__c='Test_country', Prospect_Validated__c=false);
        system.debug('acc='+acc.RecordType);
        insert acc; */
       /*  
      
        List<Account> accounts = new List<Account>();
        for(Integer i=0;i<10;i++) 
        {
         accounts.add(new Account(Name='Test_Account'+i, Type='Dealer', RecordType=[select Id from RecordType where name=:Label.Standard_Record_Type and SObjectType='Account' limit 1], Segment_Step_1__c='Mila', Business__c='Test_country', Prospect_Validated__c=false));
        } 
        insert accounts;
         System.assertEquals( 10, accounts.size() );
        
       
       list<account> acclist=[SELECT ID FROM Account where OwnerId = :userToCreate.Id];
        
        ApexPages.StandardSetController con = new ApexPages.StandardSetController(acclist);
        con.setSelected(acclist);
        
         pagereference pg = page.AccountlandingPage;
        // test.setCurrentPage(pg);
        system.test.setCurrentPageReference(pg);


        
        AccountlandingPage_Ctrl alc=new AccountlandingPage_Ctrl();
       // alc.viewname='My Team Accounts';
       alc.search='test1';
       
        acclist=alc.getaccounts();
        System.assertEquals( 10, acclist.size() );
        
               
        alc.refreshPageSize();
        alc.find();
      //  alc.getaccounts();
        
       
    
    } */
    
     static testMethod void testmethod2()
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
         
      
        List<Account> accounts = new List<Account>();
        for(Integer i=0;i<10;i++) 
        {
         accounts.add(new Account(Name = 'TEST' + i,Business__c='US'));
        } 
        insert accounts;
         System.assertEquals( 10, accounts.size() );
        
       
       list<account> acclist=[SELECT ID FROM Account where Id IN :null];
        
        ApexPages.StandardSetController con = new ApexPages.StandardSetController(acclist);
        con.setSelected(acclist);
        
         pagereference pg = page.AccountlandingPage;
        // test.setCurrentPage(pg);
        system.test.setCurrentPageReference(pg);


        
        AccountlandingPage_Ctrl alc=new AccountlandingPage_Ctrl();
        
        alc.viewname='All Accounts';
        alc.search='test1';
       
       
        acclist=alc.getaccounts();
        System.assertEquals( 10, acclist.size() );
        
               
        alc.refreshPageSize();
        alc.find();
      //  alc.getaccounts();
        
       
    
    }
     static testMethod void testmethod3()
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
         
      
        List<Account> accounts = new List<Account>();
        for(Integer i=0;i<10;i++) 
        {
         accounts.add(new Account(Name = 'TEST' + i,Business__c='US'));
        } 
        insert accounts;
         System.assertEquals( 10, accounts.size() );
        
       
       list<account> acclist=[SELECT ID FROM Account where OwnerId = :userToCreate.Id];
        
        ApexPages.StandardSetController con = new ApexPages.StandardSetController(acclist);
        con.setSelected(acclist);
        
         pagereference pg = page.AccountlandingPage;
        // test.setCurrentPage(pg);
        system.test.setCurrentPageReference(pg);


        
        AccountlandingPage_Ctrl alc=new AccountlandingPage_Ctrl();
        alc.viewname='Accounts I Own';
        alc.search='test1';
       
        acclist=alc.getaccounts();
        System.assertEquals( 10, acclist.size() );
        
               
        alc.refreshPageSize();
        alc.find();
      //  alc.getaccounts();
        
       
    
    }
    
     static testMethod void testmethod4()
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
         
      
        List<Account> accounts = new List<Account>();
        for(Integer i=0;i<10;i++) 
        {
         accounts.add(new Account(Name = 'TEST' + i,Business__c='US'));
        } 
        insert accounts;
         System.assertEquals( 10, accounts.size() );
        
       
       list<account> acclist=[SELECT ID FROM Account where OwnerId = :userToCreate.Id];
        
        ApexPages.StandardSetController con = new ApexPages.StandardSetController(acclist);
        con.setSelected(acclist);
        
         pagereference pg = page.AccountlandingPage;
        // test.setCurrentPage(pg);
        system.test.setCurrentPageReference(pg);


        
        AccountlandingPage_Ctrl alc=new AccountlandingPage_Ctrl();
        alc.viewname='My Team Accounts';
        alc.search='test1';
       
        acclist=alc.getaccounts();
       // System.assertEquals( 1, acclist.size() );
        
               
        alc.refreshPageSize();
        alc.find();
      //  alc.getaccounts();
        
       
    
    }
    
     static testMethod void testmethod5()
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
         
      
        List<Account> accounts = new List<Account>();
        for(Integer i=0;i<10;i++) 
        {
         accounts.add(new Account(Name = 'TEST' + i,Business__c='US'));
        } 
        insert accounts;
         System.assertEquals( 10, accounts.size() );
        
       
       list<account> acclist=[SELECT ID FROM Account where OwnerId = :userToCreate.Id];
        
        ApexPages.StandardSetController con = new ApexPages.StandardSetController(acclist);
        con.setSelected(acclist);
        
         pagereference pg = page.AccountlandingPage;
        // test.setCurrentPage(pg);
        system.test.setCurrentPageReference(pg);


        
        AccountlandingPage_Ctrl alc=new AccountlandingPage_Ctrl();
        alc.viewname='--None--';
        alc.search='test1';
       
     //   acclist=alc.getaccounts();
        System.assertEquals( 0, acclist.size() );
        
               
        alc.refreshPageSize();
        alc.find();
      //  alc.getaccounts();
        
       
    
    }
        
}