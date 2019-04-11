@isTest(seealldata=true)
public class LabyrinthTaskDetailPage_Test
{
    static testmethod void testmethod1()
    {
        Account testAccount = new Account();
        testAccount.Name='Test Account' ;
        testAccount.Business__c='US';
        insert testAccount;

        Task objTask = new Task();
        objTask.ActivityDate = Date.today().addDays(7);
        objTask.Subject='Sample Task';
        objTask.WhatId = testAccount.Id ;
        objTask.OwnerId = UserInfo.getUserId();
        objTask.Status='In Progress' ;
        insert objTask ;
        
        
        Test.StartTest(); 

            ApexPages.StandardController sc = new ApexPages.StandardController( objTask );
            LabyrinthTaskDetailPage  testTest = new LabyrinthTaskDetailPage (sc);
            testTest.edittask();
            
        Test.StopTest();
    }
}