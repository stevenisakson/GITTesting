/*
@Author             : Jesfer Baculod (CloudSherpas)
@Date Created       : 28-AUG-2015
@Description        : Test class for RequestTriggerHandler
*/

@isTest
private class RequestTriggerHandlerTest {
    
    @testSetup static void dataSetup() {
        
        //Enable trigger for Opportunity
        Trigger_Settings__c ts = new Trigger_Settings__c(Request__c = true);
        insert ts;
        
        //Added by : Tumish Tak: Creating data for the ApprovalProcess Custom Settings
        Auto_Populate_Settings__c appcustSettings = new Auto_Populate_Settings__c(Name = 'US',Lightning_Enabled__c=false,Owner_Change__c=false);
        Account_Approval_Process_Settings__c appSettings1 = new Account_Approval_Process_Settings__c(Name = '012f10000004YCaAAM',Approval_Process_Name__c='New_Consumer_Approval_Request',Account_Approval_Process_Label_Name__c='Consumer Validation');
        Account_Approval_Process_Settings__c appSettings2 = new Account_Approval_Process_Settings__c(Name = '012f10000004YCYAA2',Approval_Process_Name__c='Account_Approval_CompetitorReq',Account_Approval_Process_Label_Name__c='Competitor Update');
        Account_Approval_Process_Settings__c appSettings3 = new Account_Approval_Process_Settings__c(Name = '012f10000004YCZAA2',Approval_Process_Name__c='Competitor_Approval_Request',Account_Approval_Process_Label_Name__c='Competitor Validation');
        Account_Approval_Process_Settings__c appSettings4 = new Account_Approval_Process_Settings__c(Name = '012j00000000IMGAA2',Approval_Process_Name__c='New_Prospect_Approval_Request',Account_Approval_Process_Label_Name__c='Prospect Validation');
        Account_Approval_Process_Settings__c appSettings5 = new Account_Approval_Process_Settings__c(Name = '012j00000010CWnAAM',Approval_Process_Name__c='Global_Account_Approval_Request',Account_Approval_Process_Label_Name__c='Commercial Customer Update');
        Account_Approval_Process_Settings__c appSettings6 = new Account_Approval_Process_Settings__c(Name = '012j00000010CWoAAM',Approval_Process_Name__c='Prospect_Conv_Approval_Req',Account_Approval_Process_Label_Name__c='Prospect Conversion');
       // Added by Poonam
        Account_Approval_Process_Settings__c appSettings7 = new Account_Approval_Process_Settings__c(Name = '012f1000000LJQmAAO',Approval_Process_Name__c='Third_Party_Approval_Request',Account_Approval_Process_Label_Name__c='Third Party Validation');
        Account_Approval_Process_Settings__c appSettings8 = new Account_Approval_Process_Settings__c(Name = '012f1000000LJQlAAO',Approval_Process_Name__c='Third_Party_Update_Approval_Request',Account_Approval_Process_Label_Name__c='Third Party Update');
        Account_Approval_Process_Settings__c appSettings9 = new Account_Approval_Process_Settings__c(Name = '012f1000000LJQkAAO',Approval_Process_Name__c='Consumer_Update_Approval_Request',Account_Approval_Process_Label_Name__c='Consumer Update');
        
        List<Account_Approval_Process_Settings__c> cuslist = new List<Account_Approval_Process_Settings__c>();       
        insert appcustSettings;  
        cuslist.add(appSettings1);
        cuslist.add(appSettings2);
        cuslist.add(appSettings3);
        cuslist.add(appSettings4);
        cuslist.add(appSettings5);
        cuslist.add(appSettings6);
        cuslist.add(appSettings7);
        cuslist.add(appSettings8);
        cuslist.add(appSettings9);
        insert cuslist;
        //Tumish: End
        
        SuspendedAccountSettings__c susSettings1 = new SuspendedAccountSettings__c();
        susSettings1.Account_Team_Delete__c = true;
        susSettings1.Name = 'Canada';
        insert susSettings1;
        
        SuspendedAccountSettings__c susSettings2 = new SuspendedAccountSettings__c();
        susSettings2.Account_Team_Delete__c = false;
        susSettings2.Name = 'US';
        insert susSettings2;
        
    }
    
    static testMethod void testAfterInsert() {
        
        //Create test data for Data Steward User
        User usr = TestDataBuilder.createUser(1, TestDataBuilder.getUserProfileId('System Administrator') );
        insert usr;
        
        //Create test data for BU Coordinator User
        User userSF = TestDataBuilder.createUser(2, TestDataBuilder.getUserProfileId('System Administrator') );
        userSF.ManagerId = usr.Id;
        insert userSF;
        
        System.runAs(userSF){
            //Create test data for Account
            Account acct = TestDataBuilder.createAccount();
            acct.RecordTypeId = TestDataBuilder.getObjectRecordTypeId(Account.SObjectType,'Commercial Customer');
            acct.Request_Approved__c = false;
            acct.Account_Type__c='Commercial Customer';
            insert acct;
            
            //Added by : Tumish
            Account acctComp = TestDataBuilder.createAccount();
            acctComp.RecordTypeId = TestDataBuilder.getObjectRecordTypeId(Account.SObjectType,'Competitor');
            acctComp.Request_Approved__c = false;
           try{
            insert acctComp;
            }
            catch(Exception ex){}
            //Tumish: end
            
            Contact testContact = new Contact();
            testContact.AccountId = acctComp.Id;
            testContact.FirstName = 'TestCon222';
            testContact.LastName = 'TestCon12';
            try{
                insert testContact;
            }catch(Exception e){}
            
            List<Request__c> reqList= new List<Request__c>();
            reqList.add(new Request__c(Status__c = 'Draft', RecordTypeId = TestDataBuilder.getObjectRecordTypeId(Request__c.SObjectType,'Prospect Validation')));
            reqList.add(new Request__c(Status__c = 'Draft', RecordTypeId = TestDataBuilder.getObjectRecordTypeId(Request__c.SObjectType,'Prospect Conversion')));
            
            //Added by: Tumish
            reqList.add(new Request__c(Status__c = 'Draft', RecordTypeId = TestDataBuilder.getObjectRecordTypeId(Request__c.SObjectType,'Competitor Validation')));
            
            reqList.add(new Request__c(Status__c = 'Draft', RecordTypeId = TestDataBuilder.getObjectRecordTypeId(Request__c.SObjectType,'Consumer Validation')));
            //Tumish: End
            reqList.add(new Request__c(Status__c = 'Draft', RecordTypeId = TestDataBuilder.getObjectRecordTypeId(Request__c.SObjectType,'Commercial Customer Update')));
            reqList.add(new Request__c(Status__c = 'Draft', RecordTypeId = TestDataBuilder.getObjectRecordTypeId(Request__c.SObjectType,'Consumer Update')));
           
            reqList.add(new Request__c(Status__c = 'Draft', RecordTypeId = TestDataBuilder.getObjectRecordTypeId(Request__c.SObjectType,'Third Party Validation')));
            reqList.add(new Request__c(Status__c = 'Draft', RecordTypeId = TestDataBuilder.getObjectRecordTypeId(Request__c.SObjectType,'Third Party Update')));
            reqList.add(new Request__c(Contact__c = testContact.Id, Status__c = 'Submitted', RecordTypeId = TestDataBuilder.getObjectRecordTypeId(Request__c.SObjectType,'CFR Contact Approval')));
            
            Test.startTest();
            try{
            insert reqList;
            }
            catch(Exception ex){}
            Test.stopTest();
        }
    }
    
    static testMethod void testAfterInsertNegative() {
        
        //Create test data for Data Steward User
        User usr = TestDataBuilder.createUser(1, TestDataBuilder.getUserProfileId('System Administrator') );
        insert usr;
        
        //Create test data for BU Coordinator User
        User userSF = TestDataBuilder.createUser(2, TestDataBuilder.getUserProfileId('System Administrator') );
        userSF.ManagerId = usr.Id;
        insert userSF;
        
        System.runAs(userSF){
            //Create test data for Account
            Account acct = TestDataBuilder.createAccount();
            acct.RecordTypeId = TestDataBuilder.getObjectRecordTypeId(Account.SObjectType,'Commercial Customer');
            acct.Request_Approved__c = true;
            acct.Business__c = 'US';
            acct.Account_Type__c='Commercial Customer';
            insert acct;
            
            Request__c req = TestDataBuilder.createRequest(acct.Id);
            req.RecordTypeId = TestDataBuilder.getObjectRecordTypeId(Request__c.SObjectType,'Commercial Customer Update');
            req.Status__c = 'Draft';
            
            //Added by : Tumish
            Account acctComp = TestDataBuilder.createAccount();
            acctComp.RecordTypeId = TestDataBuilder.getObjectRecordTypeId(Account.SObjectType,'Competitor');
            acctComp.Request_Approved__c = true;
            acctComp.Business__c = 'US';
            try{
            insert acctComp;}
            catch(Exception ex){}
            
            Request__c reqcomp = TestDataBuilder.createRequest(acctComp.Id);
            reqcomp.RecordTypeId = TestDataBuilder.getObjectRecordTypeId(Request__c.SObjectType,'Competitor Update');
            reqcomp.Status__c = 'Draft';
            
            List<Request__c> reqList1 = new List<Request__c>();
            reqList1.add(reqcomp);
            reqList1.add(req);
            reqList1.add(new Request__c(Status__c = 'Submitted', RecordTypeId = TestDataBuilder.getObjectRecordTypeId(Request__c.SObjectType,'CFR Contact Approval')));
            
            //Tumish: end
            Test.startTest();
            //insert reqcomp;
            //insert req;
            
            insert reqList1;
            Test.stopTest();
        }
    }
    
    static testMethod void testAfterInsertApprove() {
        
        //Create test data for Data Steward User
        User usr = TestDataBuilder.createUser(1, TestDataBuilder.getUserProfileId('System Administrator') );
            usr.Region__c='CFN United States';
            usr.Business_Unit__c = 'US';
            usr.Country_Code__c = 'US';
            usr.CAN_Business__c = 'CFN';
        insert usr;
        
        //Create test data for BU Coordinator User
        User userSF = TestDataBuilder.createUser(2, TestDataBuilder.getUserProfileId('System Administrator') );
        userSF.ManagerId = usr.Id;
             userSF.Region__c='CFN United States';
            userSF.Business_Unit__c = 'US';
            userSF.Country_Code__c = 'US';
            userSF.CAN_Business__c = 'CFN';
        insert userSF;
        
        System.runAs(userSF){
            //Create test data for Account
            Account acct = TestDataBuilder.createAccount();
            acct.RecordTypeId = TestDataBuilder.getObjectRecordTypeId(Account.SObjectType,'Commercial Customer');
            acct.Request_Approved__c = false;
            acct.Business__c='US';
            acct.Account_Type__c='Commercial Customer';
            insert acct;
            
            List<ProtectedFields__c> pf = new List<ProtectedFields__c>();
            
            ProtectedFields__c pf1 = new ProtectedFields__c();
            pf1.name = 'Vat__c(US)';
            pf1.Field_Name__c = 'Vat__c';
            pf1.Business_Unit__c = 'US';
            pf.add(pf1);
            
            ProtectedFields__c pf2 = new ProtectedFields__c();
            pf2.name = 'Brand__c(US)';
            pf2.Field_Name__c = 'Brand__c';
            pf2.Business_Unit__c = 'US';
            pf.add(pf2);
            
            ProtectedFields__c pf3 = new ProtectedFields__c();
            pf3.name = 'Credit__c(US)';
            pf3.Field_Name__c = 'Credit__c';
            pf3.Business_Unit__c = 'US';
            pf.add(pf3);
            
            insert pf;
            Request__c req = TestDataBuilder.createRequest(acct.Id);
            req.RecordTypeId = TestDataBuilder.getObjectRecordTypeId(Request__c.SObjectType,'Commercial Customer Update');
            
            Test.startTest();
            insert req;
            
            req.Status__c = 'Approved';
            update req;
            Test.stopTest();
        }
    }
    
    static testMethod void testAfterInsertReject() {
        
        //Create test data for Data Steward User
        User usr = TestDataBuilder.createUser(1, TestDataBuilder.getUserProfileId('System Administrator') );
        insert usr;
        
        //Create test data for BU Coordinator User
        User userSF = TestDataBuilder.createUser(2, TestDataBuilder.getUserProfileId('System Administrator') );
        userSF.ManagerId = usr.Id;
        insert userSF;
        
        System.runAs(userSF){
            //Create test data for Account
            Account acct = TestDataBuilder.createAccount();
            acct.RecordTypeId = TestDataBuilder.getObjectRecordTypeId(Account.SObjectType,'Commercial Customer');
            acct.Request_Approved__c = false;
            acct.Business__c='US';
            acct.Account_Type__c='Commercial Customer';
            insert acct;
            
            List<ProtectedFields__c> pf = new List<ProtectedFields__c>();
            
            ProtectedFields__c pf1 = new ProtectedFields__c();
            pf1.name = 'Vat__c(US)';
            pf1.Field_Name__c = 'Vat__c';
            pf1.Business_Unit__c = 'US';
            pf.add(pf1);
            
            ProtectedFields__c pf2 = new ProtectedFields__c();
            pf2.name = 'Brand__c(US)';
            pf2.Field_Name__c = 'Brand__c';
            pf2.Business_Unit__c = 'US';
            pf.add(pf2);
            
            ProtectedFields__c pf3 = new ProtectedFields__c();
            pf3.name = 'Credit__c(US)';
            pf3.Field_Name__c = 'Credit__c';
            pf3.Business_Unit__c = 'US';
            pf.add(pf3);
            
            insert pf;
            
            Request__c req = TestDataBuilder.createRequest(acct.Id);
            req.RecordTypeId = TestDataBuilder.getObjectRecordTypeId(Request__c.SObjectType,'Commercial Customer Update');
            
            Test.startTest();
            insert req;
            
            req.Status__c = 'Rejected';
            update req;
            Test.stopTest();
        }
    }
    
    static testMethod void testAfterInsertRecall() {
        
        //Create test data for Data Steward User
        User usr = TestDataBuilder.createUser(1, TestDataBuilder.getUserProfileId('System Administrator') );
        insert usr;
        
        //Create test data for BU Coordinator User
        User userSF = TestDataBuilder.createUser(2, TestDataBuilder.getUserProfileId('System Administrator') );
        userSF.ManagerId = usr.Id;
        insert userSF;
        
        System.runAs(userSF){
            //Create test data for Account
            Account acct = TestDataBuilder.createAccount();
            acct.RecordTypeId = TestDataBuilder.getObjectRecordTypeId(Account.SObjectType,'Commercial Customer');
            acct.Request_Approved__c = false;
            acct.Business__c='US';
            acct.Account_Type__c='Commercial Customer';
            insert acct;
            
            List<ProtectedFields__c> pf = new List<ProtectedFields__c>();
            
            ProtectedFields__c pf1 = new ProtectedFields__c();
            pf1.name = 'Vat__c(US)';
            pf1.Field_Name__c = 'Vat__c';
            pf1.Business_Unit__c = 'US';
            pf.add(pf1);
            
            ProtectedFields__c pf2 = new ProtectedFields__c();
            pf2.name = 'Brand__c(US)';
            pf2.Field_Name__c = 'Brand__c';
            pf2.Business_Unit__c = 'US';
            pf.add(pf2);
            
            ProtectedFields__c pf3 = new ProtectedFields__c();
            pf3.name = 'Credit__c(US)';
            pf3.Field_Name__c = 'Credit__c';
            pf3.Business_Unit__c = 'US';
            pf.add(pf3);
            
            insert pf;
            Request__c req = TestDataBuilder.createRequest(acct.Id);
            req.RecordTypeId = TestDataBuilder.getObjectRecordTypeId(Request__c.SObjectType,'Commercial Customer Update');
            
            Test.startTest();
            insert req;
            
            req.Status__c = 'Recalled';
            update req;
            Test.stopTest();
        }
    }
    
    static testMethod void testErrorManagerNotDefined() {
        
        //Create test data for Data Steward User
        User usr = TestDataBuilder.createUser(1, TestDataBuilder.getUserProfileId('System Administrator') );
        insert usr;
        
        //Create test data for BU Coordinator User
        User userSF = TestDataBuilder.createUser(2, TestDataBuilder.getUserProfileId('System Administrator') );
        userSF.ManagerId = usr.Id;
        insert userSF;
        
        Account acct = TestDataBuilder.createAccount();
        acct.RecordTypeId = TestDataBuilder.getObjectRecordTypeId(Account.SObjectType,'Commercial Customer');
        acct.Request_Approved__c = true;
        acct.Account_Type__c='Commercial Customer';
        insert acct;
        
        System.runAs(userSF){
            Request__c req = TestDataBuilder.createRequest(acct.Id);
            req.RecordTypeId = TestDataBuilder.getObjectRecordTypeId(Request__c.SObjectType,'Commercial Customer Update');
            
            Test.startTest();
            try{
                insert req;
            }catch(Exception e){
                
            }
            Test.stopTest();
        }
    }
    
    static testMethod void testErrorAlreadyInProcess() {
        
        //Create test data for Data Steward User
        User usr = TestDataBuilder.createUser(1, TestDataBuilder.getUserProfileId('System Administrator') );
        insert usr;
        
        //Create test data for BU Coordinator User
        User userSF = TestDataBuilder.createUser(2, TestDataBuilder.getUserProfileId('System Administrator') );
        userSF.ManagerId = usr.Id;
        insert userSF;
        
        Account acct = TestDataBuilder.createAccount();
        acct.RecordTypeId = TestDataBuilder.getObjectRecordTypeId(Account.SObjectType,'Commercial Customer');
        acct.Request_Approved__c = true;
        acct.Business__c = 'US';
        acct.Account_Type__c='Commercial Customer';
        insert acct;
        
        System.runAs(userSF){
            Request__c req = TestDataBuilder.createRequest(acct.Id);
            req.RecordTypeId = TestDataBuilder.getObjectRecordTypeId(Request__c.SObjectType,'Commercial Customer Update');
            insert req;
            
            Request__c req2 = TestDataBuilder.createRequest(acct.Id);
            req2.RecordTypeId = TestDataBuilder.getObjectRecordTypeId(Request__c.SObjectType,'Commercial Customer Update');
            
            Test.startTest();
            try{
                insert req;
            }catch(Exception e){
                
            }
            Test.stopTest();
        }
    }
    
    static testMethod void testDelete() {
        
        //Create test data for Data Steward User
        User usr = TestDataBuilder.createUser(1, TestDataBuilder.getUserProfileId('System Administrator') );
        insert usr;
        
        //Create test data for BU Coordinator User
        User userSF = TestDataBuilder.createUser(2, TestDataBuilder.getUserProfileId('System Administrator') );
        userSF.ManagerId = usr.Id;
        insert userSF;
        
        System.runAs(userSF){
            //Create test data for Account
            Account acct = TestDataBuilder.createAccount();
            acct.RecordTypeId = TestDataBuilder.getObjectRecordTypeId(Account.SObjectType,'Commercial Customer');
            acct.Request_Approved__c = false;
            acct.Business__c = 'US';
            acct.Account_Type__c='Commercial Customer';
            insert acct;
            
            Request__c req = TestDataBuilder.createRequest(acct.Id);
            req.Status__c = 'Draft';
            insert req;
            
            Test.startTest();
            delete req;
            Test.stopTest();
        }
    }
    
    static testMethod void testRequestLineUpdate() {
        
        //Create test data for Data Steward User
        User usr = TestDataBuilder.createUser(1, TestDataBuilder.getUserProfileId('System Administrator') );
        insert usr;
        
        //Create test data for BU Coordinator User
        User userSF = TestDataBuilder.createUser(2, TestDataBuilder.getUserProfileId('System Administrator') );
        userSF.ManagerId = usr.Id;
        insert userSF;
        
        
        
        System.runAs(userSF){
            //Create test data for Account
            Account acct = TestDataBuilder.createAccount();
            acct.RecordTypeId = TestDataBuilder.getObjectRecordTypeId(Account.SObjectType,'Commercial Customer');
            acct.Request_Approved__c = false;
            acct.Business__c='US';
            acct.Account_Type__c='Commercial Customer';
            insert acct;
            
            List<ProtectedFields__c> pf = new List<ProtectedFields__c>();
            
            ProtectedFields__c pf1 = new ProtectedFields__c();
            pf1.name = 'Vat__c(US)';
            pf1.Field_Name__c = 'Vat__c';
            pf1.Business_Unit__c = 'US';
            pf.add(pf1);
            
            ProtectedFields__c pf2 = new ProtectedFields__c();
            pf2.name = 'Brand__c(US)';
            pf2.Field_Name__c = 'Brand__c';
            pf2.Business_Unit__c = 'US';
            pf.add(pf2);
            
            ProtectedFields__c pf3 = new ProtectedFields__c();
            pf3.name = 'Credit__c(US)';
            pf3.Field_Name__c = 'Credit__c';
            pf3.Business_Unit__c = 'US';
            pf.add(pf3);
            
            insert pf;
            
            Request__c req = TestDataBuilder.createRequest(acct.Id);
            req.RecordTypeId = TestDataBuilder.getObjectRecordTypeId(Request__c.SObjectType,'Commercial Customer Update');
            
            RequestLineItem__c rli = new RequestLineItem__c();
            List<RequestLineItem__c> reqlist = new List<RequestLineItem__c>();
            insert req;
            
            Test.startTest();
           // insert req;
            
            reqlist.add(new RequestLineItem__c(Field_Name__c = 'Vat__c', Existing_Value__c='123', New_Value__c='456', Status__c='Approved', Request__c = req.id));
            reqlist.add(new RequestLineItem__c(Field_Name__c = 'Brand__c', Existing_Value__c='Old Brand', New_Value__c='New Brand', Status__c='Approved', Request__c = req.id));
            reqlist.add(new RequestLineItem__c(Field_Name__c = 'Credit__c', Existing_Value__c='true', New_Value__c='false', Status__c='Approved', Request__c = req.id));
            
            insert reqlist;
            
            
            
            system.debug('@@ before update ' + req);
            req.Status__c = 'Approved';
            update req;
            
            Approval.ProcessSubmitRequest procReq = new Approval.ProcessSubmitRequest();
            procReq.setComments('Approve');
            procReq.setNextApproverIds(new Id[] {UserInfo.getUserId()});
            procReq.setObjectId(req.Id);
            system.debug('@@ after update ' + req);
            system.debug('@@ req.account__c = ' + req.account__c);
            Account acc = [Select Vat__c, Brand__c, Credit__c from account where id =: req.account__c];
            system.debug('@@ after ' + acc.Vat__c);
            system.debug('@@ after ' + acc.Brand__c);
            
            system.assertEquals(acc.Vat__c, '456');
            system.assertEquals(acc.Brand__c, 'New Brand');
            
            
            Test.stopTest();
        }
    }
    
    static testMethod void testRequestLineCompetitorUpdate() {
        
        //Create test data for User
        User usr = TestDataBuilder.createUser(1, TestDataBuilder.getUserProfileId('System Administrator') );
        insert usr;
        
        //Create test data for User
        User userSF = TestDataBuilder.createUser(2, TestDataBuilder.getUserProfileId('System Administrator') );
        userSF.ManagerId = usr.Id;
        insert userSF;
        
        
        
        System.runAs(userSF){
            //Create test data for Account
            Account acct = TestDataBuilder.createAccount();
            acct.RecordTypeId = TestDataBuilder.getObjectRecordTypeId(Account.SObjectType,'Competitor');
            acct.Request_Approved__c = false;
            acct.Business__c='US';
            acct.Account_Type__c='Competitor';
            insert acct;
            
            List<CompetitorProtectedFields__c> pf = new List<CompetitorProtectedFields__c>();
            
            CompetitorProtectedFields__c pf1 = new CompetitorProtectedFields__c();
            pf1.name = 'BillingCity';
            pf1.Field_Name__c = 'BillingCity';
            pf1.Business_Unit__c = 'US';
            pf.add(pf1);
            
            insert pf;
            
            Request__c req = TestDataBuilder.createRequest(acct.Id);
            req.RecordTypeId = TestDataBuilder.getObjectRecordTypeId(Request__c.SObjectType,'Competitor Update');
            
            RequestLineItem__c rli = new RequestLineItem__c();
            List<RequestLineItem__c> reqlist = new List<RequestLineItem__c>();
            insert req;
            
            Test.startTest();
           // insert req;
            
            reqlist.add(new RequestLineItem__c(Field_Name__c = 'BillingCity', Existing_Value__c='Jaipur', New_Value__c='Udaipur', Status__c='Approved', Request__c = req.id));
            
            insert reqlist;
            
            
            
            system.debug('@@ before update ' + req);
            req.Status__c = 'Approved';
            update req;
            
            Approval.ProcessSubmitRequest procReq = new Approval.ProcessSubmitRequest();
            procReq.setComments('Approve');
            procReq.setNextApproverIds(new Id[] {UserInfo.getUserId()});
            procReq.setObjectId(req.Id);
            system.debug('@@ after update ' + req);
            system.debug('@@ req.account__c = ' + req.account__c);
            Account acc = [Select BillingCity from account where id =: req.account__c];
            system.debug('@@ after ' + acc.BillingCity);
            
            Test.stopTest();
        }
    }
     /*********************************************************
      ** Author: Mallikharjuna 
      ** Date: 03-04-2019
      ** Description: Test class for accont TeamMemberDelete
      ***********************************************************/
 /*    static testMethod void TestacctTeamMemberDelete() {
         
         List<Request__c>  Requestlst1 = new List<Request__c>();
         Request__c obj= new Request__c();
        // obj.Request_Type__c='Account Team Delete';
         obj.Status__c='Approved';
         //obj.Name=R-20050;
         Requestlst1.add(obj);
         
         List<RequestLineItem__c> LstReqItem= new List<RequestLineItem__c>();
         RequestLineItem__c objReq = new RequestLineItem__c();
         objReq.Account_Name__c='Account1';
         objReq.Action__c='Remove';
         objReq.Status__c='Approved';
         objReq.Request__c=Requestlst1[0].id;
         objReq.Team_Member__c='Sagar Patil';
         LstReqItem.add(objReq);
         
     }
    */
    
    
      static testMethod void acctTeamMemberDeleteTest()
    {
         Test.StartTest();
        
       Profile p = [SELECT Id FROM Profile WHERE Name='Data Steward']; 
         User u = new User(Alias = 'standt', Email='standarduser@testorg.com', 
                EmailEncodingKey='UTF-8', LastName='Testing', FirstName='AccTeamDelete', LanguageLocaleKey='en_US', 
                LocaleSidKey='en_US', ProfileId = p.Id, 
                TimeZoneSidKey='America/Los_Angeles', UserName='AccTeamDelete@testorg.com');
        
       insert u;
        
        User user2 = new User(Alias = 'standt', Email='standarduser@testorg.com', 
                EmailEncodingKey='UTF-8', LastName='user', FirstName='test', LanguageLocaleKey='en_US', 
                LocaleSidKey='en_US', ProfileId = p.Id, 
                TimeZoneSidKey='America/Los_Angeles', UserName='AccTeamDeleteuser2@testorg.com');
        
       insert user2;
        
       List<Account> accounts = new List<Account>();
        
       Account acc1= new Account();
       acc1.name = 'test_Account1';
       acc1.RecordTypeId = TestDataBuilder.getObjectRecordTypeId(Account.SObjectType,'Standard');
       acc1.Account_Type__c='Standard';
       //acc1.OwnerId = u.id;
       insert acc1;
       accounts.add(acc1);
        
       Account acc2= new Account();
       acc2.name = 'test_Account2';
       acc2.RecordTypeId = TestDataBuilder.getObjectRecordTypeId(Account.SObjectType,'Standard');
       acc2.Account_Type__c='Standard';
       acc2.Type = 'Consultant';
       //acc2.OwnerId = u.id;
       insert acc2;        
       
       Trigger_Settings__c t=new Trigger_Settings__c();
       t.Account__c=true;
       t.Name='test';
       insert t;
        
       String teamMemberRole = 'Account Manager';
      String accountAccessLevel = 'Read', opportunityAccessLevel = 'Read', caseAccessLevel = 'None';
     List<AccountTeamMember> members = new list<AccountTeamMember>();
       List<AccountShare> sharingRules = new list<AccountShare>();
        
     for(Account a : accounts) {
        members.add(New AccountTeamMember(AccountId = a.id, TeamMemberRole = teamMemberRole, UserId= user2.Id));
        sharingRules.add(new AccountShare(AccountAccessLevel = accountAccessLevel, OpportunityAccessLevel = OpportunityAccessLevel, CaseAccessLevel = caseAccessLevel, UserOrGroupId = u.Id, AccountId = a.id));
     }

    insert members; 
    insert sharingRules;
        
        RecordType rt=[select id, name from RecordType  WHERE Name = 'Account Team Delete' ];
        
        Override_Settings__c  o=new Override_Settings__c();
        o.Account_Team_Delete_RecordTypeID__c=rt.Id;
        insert o;
        
        List<Request__c>  reqList = new List<Request__c>();
         
        system.debug('rt id: '+rt.Id);
        
         Request__c  requestRecord = new  Request__c();
        requestRecord.Status__c = 'Approved';
         requestRecord.RecordTypeId =rt.Id;
         reqList.add(requestRecord);
         insert reqList;
         system.debug('reqList: '+reqList);
         system.debug('user2 id: '+user2.Id);
        
        
         RequestLineItem__c reqLineItem = new RequestLineItem__c();
         reqLineItem.Field_Label__c     ='Account Name';
         reqLineItem.Field_Name__c      ='Name';
         reqLineItem.Request__c         = requestRecord.Id;
         reqLineItem.Account_Name__c    = acc1.name;
         reqLineItem.Action__c          = Label.Remove_Action_Value_on_Request_Line_Item;
         reqLineItem.Team_Member__c     = 'test user';
         reqLineItem.Status__c = 'Approved';
         reqLineItem.Selected_Account_Id__c =acc1.id;
         reqLineItem.User_Id_To_Be_Removed__c =user2.Id;
         insert reqLineItem; 
        
         RequestLineItem__c reqLineItem2 = new RequestLineItem__c();
         reqLineItem2.Field_Label__c     ='Account Name';
         reqLineItem2.Field_Name__c      ='Name';
         reqLineItem2.Request__c         = requestRecord.Id;
         reqLineItem2.Account_Name__c    = acc2.name;
         reqLineItem2.Action__c          = Label.Remove_Action_Value_on_Request_Line_Item;
         reqLineItem2.Team_Member__c     = 'test user';
         reqLineItem2.Status__c = 'Approved';
         reqLineItem2.Selected_Account_Id__c =acc2.id;
         reqLineItem2.User_Id_To_Be_Removed__c =user2.Id;
         insert reqLineItem2;
         system.debug('reqLineItem2: '+reqLineItem2);
         
         //List<Request__c> reqList = [select id,Status__c, RecordTypeId from Request__c];
         //system.debug('reqList: '+reqList);
         RequestTriggerHandler reqHandler = new RequestTriggerHandler();
         reqHandler.acctTeamMemberDelete(reqList);
        
         Test.StopTest();
    }
   static testMethod void approveTest(){
       Test.StartTest();
        
       ProtectedFields__c protectedFieldObj = new ProtectedFields__c();
       protectedFieldObj.Field_Label__c    = 'Account Name / Nom du compte';
       protectedFieldObj.Field_Name__c     = 'Name';
       protectedFieldObj.Name              = 'Account Name (CN)';
       protectedFieldObj.Business_Unit__c  = 'Canada';
       protectedFieldObj.Object__c = 'Account';
       insert protectedFieldObj;
       
      Account acc= new Account();
       acc.name = 'test_Account1';
       acc.RecordTypeId = TestDataBuilder.getObjectRecordTypeId(Account.SObjectType,'Commercial Customer CFN Canada');
       acc.Account_Type__c='Commercial Customer';
       acc.Business__c='Canada';
       insert acc;
       system.debug('acc: '+acc);
      
       List<Request__c>  reqList = new List<Request__c>();
       
       //String commCustomerUpdateRecordTypeId = TestDataBuilder.getObjectRecordTypeId(Request__c.SObjectType,'Commercial Customer Update');
       
       //Account_Approval_Process_Settings__c appSettings = new Account_Approval_Process_Settings__c(Name = commCustomerUpdateRecordTypeId,Approval_Process_Name__c='Global_Account_Approval_Request',Account_Approval_Process_Label_Name__c='Commercial Customer Update');
       //insert appSettings;
       
       Request__c  requestRecord = new  Request__c();
       requestRecord.Status__c = 'Approved';
       requestRecord.Account__c=acc.id;
       requestRecord.RecordTypeId =TestDataBuilder.getObjectRecordTypeId(Request__c.SObjectType,'Commercial Customer Update');
       //requestRecord.RecordTypeId =   '012j00000010CWnAAM';
       
       reqList.add(requestRecord);
       insert reqList;
       system.debug('reqList2: '+reqList); 
       
      
       
       List<id> accIdList = new List<id>();
       accIdList.add(requestRecord.Account__c);
       
       RequestLineItem__c reqLineItem = new RequestLineItem__c();
       reqLineItem.Request__c         = requestRecord.id;
       reqLineItem.Field_Label__c     ='Account Name';
       reqLineItem.Field_Name__c      ='Name';
       reqLineItem.Existing_Value__c  ='Test 15 March';
       reqLineItem.New_Value__c       = 'Test 5 March 2019';
       reqLineItem.Status__c          = 'Approved';
      
       insert reqLineItem; 
       
       system.debug('reqLineItem: '+reqLineItem);
 
    
       /*Account acc= [select id, name, Account_Type__c, Business__c from Account where name='test_Account3'];
       List<Id> accIdList = new List<Id>();
       accIdList.add(acc.id);
       
       system.debug('accIdList: '+accIdList);
       
       Request__c requestRecord = [select id,Status__c,RecordTypeId,Account__c from Request__c where Account__c =:acc.id]; */
       
       Map<id,list<id>> reqSet = new Map<id,list<id>>();
       reqSet.put(requestRecord.id, accIdList);
       
       
       RequestTriggerHandler.approve(reqSet);
       
       Test.StopTest();
}
static testMethod void updateRequestRecords(){
/* User usr = TestDataBuilder.createUser(1, TestDataBuilder.getUserProfileId('System Administrator') );
        insert usr;
        
        //Create test data for BU Coordinator User
        User userSF = TestDataBuilder.createUser(2, TestDataBuilder.getUserProfileId('System Administrator') );
        userSF.ManagerId = usr.Id;
        insert userSF;
        
        System.runAs(userSF){*/
         
    Test.StartTest();
            
   /*  String accTeamDeleteRcrdTypeId= TestDataBuilder.getObjectRecordTypeId(Account.SObjectType,'Account Team Delete');
        
        Override_Settings__c  o=new Override_Settings__c();
        o.Account_Team_Delete_RecordTypeID__c=accTeamDeleteRcrdTypeId;
        insert o;
    */
    Account acct = TestDataBuilder.createAccount();
   acct.name ='test account';
   acct.Request_Approved__c = false;
   acct.Approval_Status__c='Approved';
   insert acct;
   Account acctComp1 = TestDataBuilder.createAccount();
            acctComp1.RecordTypeId = TestDataBuilder.getObjectRecordTypeId(Account.SObjectType,'Competitor');
            acctComp1.Request_Approved__c = false;
           try{
            insert acctComp1;
            }
            catch(Exception ex){}
    Contact testContact = new Contact();
            testContact.AccountId = acctComp1.Id;
            testContact.FirstName = 'TestCon222';
            testContact.LastName = 'TestCon12';
            try{
                insert testContact;
            }catch(Exception e){}
 
 List<Request__c> reqList= new List<Request__c>();
            reqList.add(new Request__c(Status__c = 'Draft', Account__c=acct.id, RecordTypeId =TestDataBuilder.getObjectRecordTypeId(Request__c.SObjectType,'Prospect Validation')));
            reqList.add(new Request__c(Status__c = 'Draft', Account__c=acct.id, RecordTypeId = TestDataBuilder.getObjectRecordTypeId(Request__c.SObjectType,'Prospect Conversion')));
            reqList.add(new Request__c(Status__c = 'Draft', Account__c=acct.id, RecordTypeId = TestDataBuilder.getObjectRecordTypeId(Request__c.SObjectType,'Competitor Validation')));
            reqList.add(new Request__c(Status__c = 'Draft', Account__c=acct.id, RecordTypeId = TestDataBuilder.getObjectRecordTypeId(Request__c.SObjectType,'Consumer Validation')));
           reqList.add(new Request__c(Status__c = 'Draft', Account__c=acct.id, RecordTypeId = TestDataBuilder.getObjectRecordTypeId(Request__c.SObjectType,'Commercial Customer Update')));
            reqList.add(new Request__c(Status__c = 'Draft', Account__c=acct.id, RecordTypeId = TestDataBuilder.getObjectRecordTypeId(Request__c.SObjectType,'Consumer Update')));
            reqList.add(new Request__c(Status__c = 'Draft',  Account__c=acct.id,RecordTypeId = TestDataBuilder.getObjectRecordTypeId(Request__c.SObjectType,'Third Party Validation')));
            reqList.add(new Request__c(Status__c = 'Draft', Account__c=acct.id, RecordTypeId = TestDataBuilder.getObjectRecordTypeId(Request__c.SObjectType,'Third Party Update')));
            reqList.add(new Request__c(Contact__c = testContact.Id, Status__c = 'Submitted',  Account__c=acct.id,RecordTypeId = TestDataBuilder.getObjectRecordTypeId(Request__c.SObjectType,'CFR Contact Approval')));
    
          
            try{
            insert reqList;
            }
            catch(Exception ex){
                system.debug('Exception inserting req list---->'+ex.getMessage());
            }
            
            system.debug('reqList-->'+reqList);
List<Request__c> reqListUpdate= new List<Request__c>(); 
 for(Request__c req:  reqList){
    req.Status__c ='Submitted';
    reqListUpdate.add(req);
   }
            
   map<id,Request__c> reqMap = new map<id,Request__c>();
   reqMap.putAll(reqListUpdate);
 if(reqMap.size()>0){
   try{
            update reqMap.values();
            }
            catch(Exception ex){
                system.debug('Exception updating req list: '+ex.getMessage());
            }
 }      
        system.debug('reqList-->'+reqList);
    Test.StopTest(); 
} 

   //}

}