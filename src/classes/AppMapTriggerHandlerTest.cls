/*
    Author              : Tumish Tak
    Email               : Tumish.Tak@cognizant.com
    Company             : Cognizant Technology Solutions
    Date Created        : 02 - Feb - 2017
    Description         : Test class for ApplicationMappingTrigger Handler class
    Modified By         : -
    Modified Date       : -
*/

@isTest(SeeAllData=True)
private class AppMapTriggerHandlerTest
{
    static testMethod void testonAfterInsert()
    {
        Account accObj = new Account();
        accObj.Name = 'ProjectGroup Test Account';
        accObj.Business__c = 'US';
        accObj.Default_Cargill_Plant__c = 'Dobrzelin';
        accObj.RecordType = [select Id from RecordType where name=:Label.Commercial_Customer_Record_Type and SObjectType='Account' limit 1];
    insert accObj;
    
    Account accObj1 = [Select Id from Account where Name = 'ProjectGroup Test Account'];
         
        Project_Group__c pg1 = new Project_Group__c();
        pg1.Account__c = accObj1.Id;
        pg1.Project_Delivery_Date__c = date.today();
        pg1.Consultant_Requesting__c = 'test req1';
    insert pg1;
    
        Application_Mapping__c amObj = new Application_Mapping__c();
        amObj.Account__c = accObj1.Id;
        amObj.External_Record_num__c = '12345';
        amObj.External_System__c = Label.NIS_Label;
    insert amObj;
    
    }
    
    static testMethod void testonAfterUpdate()
    {
        Account accObj = new Account();
        accObj.Name = 'ProjectGroup Test Account Update';
        accObj.Business__c = 'US';
        accObj.Default_Cargill_Plant__c = 'Dobrzelin';
        accObj.RecordType = [select Id from RecordType where name=:Label.Commercial_Customer_Record_Type and SObjectType='Account' limit 1];
    insert accObj;
    
    Account accObj1 = [Select Id from Account where Name = 'ProjectGroup Test Account Update'];
         
        Project_Group__c pg1 = new Project_Group__c();
        pg1.Account__c = accObj1.Id;
        pg1.Project_Delivery_Date__c = date.today();
        pg1.Consultant_Requesting__c = 'test req1';
    insert pg1;
    
        Application_Mapping__c amObjNew = new Application_Mapping__c();
        amObjNew.Account__c = accObj1.Id;
        amObjNew.External_Record_num__c = '123';
        amObjNew.External_System__c = Label.AXPTA_Label;
    insert amObjNew ;
    
        Application_Mapping__c amObjUpdate = [select Id,External_System__c from Application_Mapping__c where External_Record_num__c =: '123' AND Account__c =: accObj1.Id LIMIT 1];
        amObjUpdate.External_System__c = Label.NIS_Label;
    update amObjUpdate;
    
        Application_Mapping__c amObjUpdateNew = [select Id,External_System__c from Application_Mapping__c where External_Record_num__c =: '123' AND Account__c =: accObj1.Id LIMIT 1];
        amObjUpdateNew.External_System__c = Label.AXPTA_Label;
    update amObjUpdateNew;
        
    }
    
    static testMethod void testonAfterDelete()
    {
        Account accObj = new Account();
        accObj.Name = 'ProjectGroup Test Account Delete';
        accObj.Business__c = 'US';
        accObj.Default_Cargill_Plant__c = 'Dobrzelin';
        accObj.RecordType = [select Id from RecordType where name=:Label.Commercial_Customer_Record_Type and SObjectType='Account' limit 1];
    insert accObj;
    
    Account accObj1 = [Select Id from Account where Name = 'ProjectGroup Test Account Delete'];
         
        Project_Group__c pg1 = new Project_Group__c();
        pg1.Account__c = accObj1.Id;
        pg1.Project_Delivery_Date__c = date.today();
        pg1.Consultant_Requesting__c = 'test req1';
    insert pg1;
    
        Application_Mapping__c amObj = new Application_Mapping__c();
        amObj.Account__c = accObj1.Id;
        amObj.External_Record_num__c = '1111';
        amObj.External_System__c = Label.NIS_Label;
    insert amObj;
    
    delete amObj;
    }
}