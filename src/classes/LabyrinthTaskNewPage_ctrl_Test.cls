@isTest
public class LabyrinthTaskNewPage_ctrl_Test
{
    static testmethod void testmethod1()
    {
        Account testAccount = new Account();
        testAccount.Name='Test Account' ;
        testAccount.Business__c='US';
        insert testAccount;
        
        Contact con=new contact();
        con.lastname='test';
        insert con;

        Task objTask = new Task();
        objTask.ActivityDate = Date.today().addDays(7);
        objTask.Subject='Sample Task';
        objTask.WhatId = testAccount.Id ;
        objTask.OwnerId = UserInfo.getUserId();
        objTask.Status='In Progress' ;
        objTask.ActivityDate=system.Today();
        insert objTask ;
        
         PageReference pageRef = Page.LabyrinthTaskNewPage;
        Test.setCurrentPage(pageRef);
        
        ApexPages.CurrentPage().getParameters().put('id',objTask.id );
        ApexPages.CurrentPage().getParameters().put('what_id',testAccount.id );
       // ApexPages.CurrentPage().getParameters().put('who_id',con.id );
        Test.StartTest(); 

            ApexPages.StandardController sc = new ApexPages.StandardController( objTask );
            LabyrinthTaskNewPage_ctrl  testTest = new LabyrinthTaskNewPage_ctrl (sc);
          
            testTest.Cancel();
            
        Test.StopTest();
    }
    static testmethod void testmethod2()
    {
        Account testAccount = new Account();
        testAccount.Name='Test Account' ;
          testAccount.Business__c='US';
        insert testAccount;
        
        Contact con=new contact();
        con.lastname='test';
        insert con;

        Task objTask = new Task();
        objTask.ActivityDate = Date.today().addDays(7);
        objTask.Subject='Sample Task';
        objTask.WhatId = testAccount.Id ;
        objTask.OwnerId = UserInfo.getUserId();
        objTask.Status='Completed' ;
        insert objTask ;
        
        PageReference pageRef = Page.LabyrinthTaskNewPage;
        Test.setCurrentPage(pageRef);
        
        ApexPages.CurrentPage().getParameters().put('id',objTask.id );
   //     ApexPages.CurrentPage().getParameters().put('what_id',testAccount.id );
        ApexPages.CurrentPage().getParameters().put('who_id',con.id );
       
        Test.StartTest(); 

            ApexPages.StandardController sc = new ApexPages.StandardController( objTask );
            LabyrinthTaskNewPage_ctrl  testTest = new LabyrinthTaskNewPage_ctrl (sc);
         
         testTest.Cancel();
         
            
        Test.StopTest();
    }
     static testmethod void testmethod3()
    {
        Account testAccount = new Account();
        testAccount.Name='Test Account' ;
          testAccount.Business__c='US';
        insert testAccount;
        
        Contact con=new contact();
        con.lastname='test';
        insert con;

        Task objTask = new Task();
        objTask.ActivityDate = Date.today().addDays(7);
        objTask.Subject='Sample Task';
        objTask.WhatId = testAccount.Id ;
        objTask.OwnerId = UserInfo.getUserId();
        objTask.Status='Completed' ;
        insert objTask ;
        
        PageReference pageRef = Page.LabyrinthTaskNewPage;
        Test.setCurrentPage(pageRef);
        
        ApexPages.CurrentPage().getParameters().put('id',objTask.id );
   //     ApexPages.CurrentPage().getParameters().put('what_id',testAccount.id );
    //    ApexPages.CurrentPage().getParameters().put('who_id',con.id );
       
        Test.StartTest(); 

            ApexPages.StandardController sc = new ApexPages.StandardController( objTask );
            LabyrinthTaskNewPage_ctrl  testTest = new LabyrinthTaskNewPage_ctrl (sc);
         
         testTest.Cancel();
         
            
        Test.StopTest();
    }
     static testmethod void testmethod4()
    {
        Account testAccount = new Account();
        testAccount.Name='Test Account' ;
          testAccount.Business__c='US';
        insert testAccount;
        
        Contact con=new contact();
        con.lastname='test';
        insert con;

        Task objTask = new Task();
        objTask.ActivityDate = Date.today().addDays(7);
        objTask.Subject='Sample Task';
        objTask.WhatId = testAccount.Id ;
        objTask.OwnerId = UserInfo.getUserId();
        objTask.Status='In Progress' ;
        
       
        
       // objTask.ActivityDate=Datetime.Today();
        system.debug('....................duedate'+Date.today().addDays(7));
         system.debug('....................duedate'+system.today().addDays(7));
        insert objTask ;
        
         PageReference pageRef = Page.LabyrinthTaskNewPage;
        Test.setCurrentPage(pageRef);
        
       // ApexPages.CurrentPage().getParameters().put('id',null );
       // ApexPages.CurrentPage().getParameters().put('what_id',testAccount.id );
       // ApexPages.CurrentPage().getParameters().put('who_id',con.id );
        Test.StartTest(); 

            ApexPages.StandardController sc = new ApexPages.StandardController( objTask );
            LabyrinthTaskNewPage_ctrl  testTest = new LabyrinthTaskNewPage_ctrl (sc);
       
            testTest.Save();
       
        Test.StopTest();
    }
    
}