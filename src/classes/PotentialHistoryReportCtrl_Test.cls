@isTest

public with sharing class PotentialHistoryReportCtrl_Test {
    
    // public user userToCreate = new user();
    @testSetup static void testSetup() {
        Test.startTest();
        
        Profile p = [SELECT Id,Name FROM Profile WHERE Name='System Administrator' limit 1];
        
        User userToCreate= new user();
        userToCreate.FirstName = 'Test';
        userToCreate.LastName  = 'user';
        userToCreate.Email     = 'testuser@gmail.com';
        userToCreate.Username  = 'testuser@gmail.com.4dx';
        userToCreate.Alias     = 'tuser';
        userToCreate.ProfileId = p.Id; 
        userToCreate.TimeZoneSidKey    = 'America/Denver';
        userToCreate.LocaleSidKey      = 'en_US';
        userToCreate.EmailEncodingKey  = 'UTF-8';
        userToCreate.LanguageLocaleKey = 'en_US';
        userToCreate.Business_Unit__c  ='US';    
        userToCreate.IsActive= True;
        insert userToCreate;  
        
        Potential_History_Filter__c objPotHisFilter= new Potential_History_Filter__c();
        objPotHisFilter.Name='testFilter';
        objPotHisFilter.Is_Competitor__c='Cargill';
        insert objPotHisFilter;
        
        Potential_History__c objPotHis= new Potential_History__c();
        objPotHis.Name='testHistory';
        objPotHis.Backend_field_check__c= True;
        objPotHis.Field_Name_to_display__c='Account';
        objPotHis.Field_API_Name__c='Account_Name__c';
        insert objPotHis;
        
        Test.stopTest();
    }
    
    @isTest static void getPotentailHistorydetailsTest() {   
        User usr= [Select id from User where Username='testuser@gmail.com.4dx' Limit 1];
        System.runAs(usr){
            Account objAccts = PotentialTestDataFactory.Accountcreatemethod('test123451');
            
            Cres_Master_Potential__c  objMasterpotential= PotentialTestDataFactory.Materpotentialmethod(objAccts.Id, 'EstimationType', 'Species');
            
            Potential__c objPots = PotentialTestDataFactory.Cyclesconsummethod(objMasterpotential.id, 'ProductFunction','Type', 12, 3, 2, 4, 2);
            objPots.share__c = 20;
            
            test.startTest();
            update objPots;
            system.debug('@@@@@@@@@updated potential'+objPots);
            test.stopTest();
            system.debug('@@@@@@@@@updated potential'+objPots);
            List<String> testList= new List<String>();
            testList.add('share__c');
            //testList.add('Competitor');
            PotentialHistoryCtrl.getPotentailHistorydetails(2, 10, testList, '2018-05-03T13:19:56.000Z', '2018-05-11T05:24:40.000Z', 'True',objAccts.Id);
            PotentialHistoryCtrl.getPotentailHistorydetails(2, 10, testList, Null, '2018-05-11T05:24:40.000Z', 'True',objAccts.Id);
            PotentialHistoryCtrl.getPotentailHistorydetails(2, 10, testList, '2018-05-03T13:19:56.000Z', Null, 'True',null);
            PotentialHistoryCtrl.getPotentailHistorydetails(2, 10, testList, Null, Null, 'True',null);
            testList.clear();
            
            PotentialHistoryCtrl.getPotentailHistorydetails(2, 10, testList, '2018-05-03T13:19:56.000Z', '2018-05-11T05:24:40.000Z', 'True',objAccts.Id);
        }
    }
    
    @isTest static void fetchPotentialTest() { 
        List<String> testList= new List<String>();
        testList.add('share__c');
        Account objAccts = PotentialTestDataFactory.Accountcreatemethod('test123451');
        //testList.add('Competitor');
        PotentialHistoryCtrl.fetchPotential(2, 10, testList, '2018-05-03T13:19:56.000Z', '2018-05-11T05:24:40.000Z', 'True',objAccts.Id);
        PotentialHistoryCtrl.fetchPotential(2, 10, testList, Null, '2018-05-11T05:24:40.000Z', 'True',objAccts.Id);
        PotentialHistoryCtrl.fetchPotential(2, 10, testList, '2018-05-03T13:19:56.000Z', Null, 'True',objAccts.Id);
        PotentialHistoryCtrl.fetchPotential(2, 10, testList, Null, Null, 'True',objAccts.Id);
        
        PotentialHistoryCtrl.fetchPotential(2, 10, testList, '2018-05-03T13:19:56.000Z', '2018-05-11T05:24:40.000Z', 'False',objAccts.Id);
        System.debug('****SOQL'+Limits.getQueries());
        
    } 
    @isTest static void getFilterTest() {
        PotentialHistoryCtrl.getCrescendoFilter();
        PotentialHistoryCtrl.getHistoryFilters();
        
    }
}