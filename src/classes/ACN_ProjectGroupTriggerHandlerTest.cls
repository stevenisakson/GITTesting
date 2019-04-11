/*
Author              : Tumish Tak
Email               : Tumish.Tak@cognizant.com
Company             : Cognizant Technology Solutions
Date Created        : 27 - Dec - 2016
Description         : Test class for Project Group Trigger Handler
Modified By         : -
Modified Date       : -
*/

@isTest 
    private class ACN_ProjectGroupTriggerHandlerTest {
    
    
    static testMethod void testAfterInsert() {
            user marketingUser = TestDataBuilder.createUser(1, TestDataBuilder.getUserProfileId('Marketing Coordinator'));
            // custom setting
            CFR_Project_Group_Assignment__c prj = new  CFR_Project_Group_Assignment__c();
            prj.Assigned_To__c=marketingUser.id;
            prj.Name='Commercial Customer_Baxter';
            insert prj;
            
            Account acct = TestDataBuilder.createAccount();
            acct.RecordTypeId = TestDataBuilder.getObjectRecordTypeId(Account.SObjectType,'Commercial Customer');
            acct.Request_Approved__c = false;
            acct.Account_Type__c='Commercial Customer';
            acct.Segment_Step_1__c = 'Baxter';
            insert acct;
            
            List<Project_Group__c> projgroupRecordList = new List<Project_Group__c>();
            
            projgroupRecordList.add(new Project_Group__c(Account__c = acct.id,  Project_Delivery_Date__c = system.today() + 5 ,
                                                        Project_End_Date__c = system.today() + 7));
                                                        
            insert projgroupRecordList;
            
            
    
    }
    
    static testMethod void testAfterInsert1() {
            user marketingUser = TestDataBuilder.createUser(1, TestDataBuilder.getUserProfileId('Marketing Coordinator'));
            // custom setting
            CFR_Project_Group_Assignment__c prj = new  CFR_Project_Group_Assignment__c();
            prj.Assigned_To__c=marketingUser.id;
            prj.Name='Commercial Customer_NonBaxter';
            insert prj;
            
            Account acct = TestDataBuilder.createAccount();
            acct.RecordTypeId = TestDataBuilder.getObjectRecordTypeId(Account.SObjectType,'Standard');
            acct.Request_Approved__c = false;
            acct.Account_Type__c='Standard';
            acct.Segment_Step_1__c = 'Aiden';
            insert acct;
            
            List<Project_Group__c> projgroupRecordList = new List<Project_Group__c>();
            
            projgroupRecordList.add(new Project_Group__c(Account__c = acct.id,  Project_Delivery_Date__c = system.today() + 5 ,
                                                        Project_End_Date__c = system.today() + 7));
                                                        
            insert projgroupRecordList;
            
            
    
    }
    
    static testMethod void testAfterInsert2() {
            user marketingUser = TestDataBuilder.createUser(1, TestDataBuilder.getUserProfileId('Marketing Coordinator'));
            // custom setting
            CFR_Project_Group_Assignment__c prj = new  CFR_Project_Group_Assignment__c();
            prj.Assigned_To__c=marketingUser.id;
            prj.Name='Consumer_Baxter';
            insert prj;
            
            Account acct = TestDataBuilder.createAccount();
            acct.RecordTypeId = TestDataBuilder.getObjectRecordTypeId(Account.SObjectType,'Consumer');
            acct.Request_Approved__c = false;
            acct.Account_Type__c='Consumer';
            acct.Segment_Step_1__c = 'Baxter';
            insert acct;
            
            List<Project_Group__c> projgroupRecordList = new List<Project_Group__c>();
            
            projgroupRecordList.add(new Project_Group__c(Account__c = acct.id,  Project_Delivery_Date__c = system.today() + 5 ,
                                                        Project_End_Date__c = system.today() + 7));
                                                        
            insert projgroupRecordList;
            
            
    
    }

/*private static testMethod void territorryAssignmentToAccount() {



Account acct = TestDataBuilder.createAccount();
            acct.RecordTypeId = TestDataBuilder.getObjectRecordTypeId(Account.SObjectType,'Commercial Customer');
            acct.Request_Approved__c = false;
            acct.Account_Type__c='Commercial Customer';
            insert acct;
  //Account CargillAccount = [Select Id, Name from Account where Id =: cargillaccid Limit 1 ];
   Account CargillAccount = [Select Id, Name from Account where Id =: acct.id];
Test.startTest();

Territory2 objTerr = [select Id,Name from Territory2 where DeveloperName = 'CFN_US_Retail'];

Territory2 chldobjTerr = [select Id,Name from Territory2 where DeveloperName = 'CFN_US_Retail_Sonya'];

ObjectTerritory2Association objObjectTerritory2Association = new ObjectTerritory2Association(ObjectId = NonCargillAccount.Id, Territory2Id =chldobjTerr.Id, AssociationCause='Territory2Manual' );
insert objObjectTerritory2Association;

//Insert FMC custom setting record for Territory2
User u = [select Id,FirstName,LastName from User where Profile.Name = 'Marketing Coordinator' LIMIT 1];
User u2 = [select Id,FirstName,LastName from User where Profile.Name = 'Marketing Coordinator' LIMIT 1];

//insert fmc;
FMC_Territory_Mapping__c fmc = FMC_Territory_Mapping__c.getValues('CFN US Retail');//new FMC_Territory_Mapping__c(Name='TestTerritory',FMC_User_ID__c=u.Id,FMC_User_Name__c=u.FirstName+' '+u.LastName,Parent_Territory_Name__c='Global_CAN_Territory_Hierarchy',Territory_ID__c=objTerr.Id);

//insert fmc1;         
FMC_Territory_Mapping__c fmc1 = FMC_Territory_Mapping__c.getValues('CFN US Retail – Sonya');//new FMC_Territory_Mapping__c(Name='chldTestTerritory',FMC_User_ID__c=u2.Id,FMC_User_Name__c=u2.FirstName+' '+u2.LastName,Parent_Territory_Name__c=objTerr.Name,Territory_ID__c=chldobjTerr.Id);



// then insert Project group for Cargill and non cargill accounts

Project_Group__c pg1 = new Project_Group__c();
pg1.Account__c = CargillAccount.Id;
pg1.Project_Delivery_Date__c = date.today();
pg1.Sales_Consultant_New__c = [select UserId from UserTerritory2Association where Territory2Id=:fmc1.Territory_ID__c LIMIT 1].UserId;//u2.Id;
insert pg1;  

Project_Group__c pg2 = new Project_Group__c();
pg2.Account__c = NonCargillAccount.Id;
pg2.Project_Delivery_Date__c = date.today();

insert pg2;  

Project_Group__c pg3 = new Project_Group__c();
pg3.Account__c = CargillAccount.Id;
pg3.Project_Delivery_Date__c = date.today();

insert pg3;

Test.stopTest();
}*/

@testSetup static void dataSetup() {
    
    //Enable trigger for Route
    Trigger_Settings__c tsr = new Trigger_Settings__c(Project_Group__c = true);
    insert tsr; 
}

}