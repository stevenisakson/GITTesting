@isTest
private class DynamicRequestControllerTest {
    
    public static Account accountInstance = new Account();
    
    private static testMethod void testNewSysAdm() {
        Id p = TestDataBuilder.getUserProfileId('System Administrator');
        User u = TestDataBuilder.createUser(1, p);
        
        System.runAs(u) {
            Test.startTest();
            PageReference pageRef = Page.DynamicRequest;
            Test.setCurrentPageReference(pageRef);
            
            List<ProtectedFields__c> pfList = new List<ProtectedFields__c>();
            
            ProtectedFields__c pf1 = new ProtectedFields__c();
            pf1.Name = 'Field 1';
            pf1.Field_Name__c = 'Name';
            pf1.Field_Label__c ='Name';
            pf1.Business_Unit__c = 'US';
            pfList.Add(pf1);
            
            ProtectedFields__c pf2 = new ProtectedFields__c();
            pf2.Name = 'Owner 1';
            pf2.Field_Name__c = 'OwnerId';
            pf2.Field_Label__c ='Owner';
            pf2.Business_Unit__c = 'US';
            pfList.Add(pf2);
            
            insert pfList;
            
            accountInstance = TestDataBuilder.createAccount();
            accountInstance.Business__c = 'US';
            accountInstance.Account_Type__c='Commercial Customer';
            accountInstance.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Commercial Customer').getRecordTypeId();
            insert accountInstance;
            
            apexpages.currentpage().getparameters().put('AccId' , accountInstance.Id);
            apexpages.currentpage().getparameters().put('status' , 'New');
            //apexpages.currentpage().getparameters().put('AccId' , yourID);
            
            System.Debug('URL: ' + ApexPages.currentPage().getParameters().get('AccId'));
            
            DynamicRequestController controller = new DynamicRequestController();
            controller.getAccountInfo();
            controller.getFields();
            controller.wrapperList[0].accNew.Name = 'new name';
            
            Id p1 = TestDataBuilder.getUserProfileId('System Administrator');
            User u1 = TestDataBuilder.createUser(2, p1);
            insert u1;
            
            controller.wrapperList[0].accNew.OwnerId = u1.Id;
            controller.save();
            controller.cancel();
            
            Test.stopTest();
        }
    }
    
    private static testMethod void testEditSysAdmDraft() {
        Id p = TestDataBuilder.getUserProfileId('System Administrator');
        User u = TestDataBuilder.createUser(1, p);
        
        System.runAs(u) {
            Test.startTest();
            PageReference pageRef = Page.DynamicRequest;
            Test.setCurrentPageReference(pageRef);
            
            List<ProtectedFields__c> pfList = new List<ProtectedFields__c>();
            
            ProtectedFields__c pf1 = new ProtectedFields__c();
            pf1.Name = 'Field 1';
            pf1.Field_Name__c = 'Name';
            pf1.Field_Label__c ='Name';
            pf1.Business_Unit__c = 'US';
            pfList.Add(pf1);
            
            ProtectedFields__c pf2 = new ProtectedFields__c();
            pf2.Name = 'Owner 1';
            pf2.Field_Name__c = 'OwnerId';
            pf2.Field_Label__c ='Owner';
            pf2.Business_Unit__c = 'US';
            pfList.Add(pf2);
            
            insert pfList;
            
            accountInstance = TestDataBuilder.createAccount();
            accountInstance.Business__c = 'US';
            accountInstance.Account_Type__c='Commercial Customer';
            accountInstance.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Commercial Customer').getRecordTypeId();
            insert accountInstance;
            
            Request__c rq = new Request__c();
            rq.Account__c = accountInstance.Id;
            rq.Status__c = 'Draft';
            rq.RecordTypeId = Schema.SObjectType.Request__c.getRecordTypeInfosByName().get('Commercial Customer Update').getRecordTypeId();
            insert rq;
            
            RequestLineItem__c rli = new RequestLineItem__c();
            rli.Field_Name__c = 'Name';
            rli.request__c = rq.Id;
            rli.New_Value__c = 'Cargill2';
            rli.Existing_Value__c = 'Cargill';
            insert rli;
            
            apexpages.currentpage().getparameters().put('AccId' , accountInstance.Id);
            apexpages.currentpage().getparameters().put('status' , 'Edit');
            apexpages.currentpage().getparameters().put('ReqId' , rq.Id);
            System.Debug('URL: ' + ApexPages.currentPage().getParameters().get('AccId'));
            
            DynamicRequestController controller = new DynamicRequestController();
            controller.getFields();
            controller.wrapperList[0].accNew.Name = 'new name';
            Id p1 = TestDataBuilder.getUserProfileId('System Administrator');
            User u1 = TestDataBuilder.createUser(2, p1);
            insert u1;
            
            controller.wrapperList[0].accNew.OwnerId = u1.Id;
            controller.save();
            
            Test.stopTest();
        }
    }
    
    private static testMethod void testEditSysAdmRejected() {
        Id p = TestDataBuilder.getUserProfileId('System Administrator');
        User u = TestDataBuilder.createUser(1, p);
        
        System.runAs(u) {
            Test.startTest();
            PageReference pageRef = Page.DynamicRequest;
            Test.setCurrentPageReference(pageRef);
            
            List<ProtectedFields__c> pfList = new List<ProtectedFields__c>();
            
            ProtectedFields__c pf1 = new ProtectedFields__c();
            pf1.Name = 'Field 1';
            pf1.Field_Name__c = 'Name';
            pf1.Field_Label__c ='Name';
            pf1.Business_Unit__c = 'US';
            pfList.Add(pf1);
            
            insert pfList;
            
            accountInstance = TestDataBuilder.createAccount();
            accountInstance.Business__c = 'US';
            accountInstance.Account_Type__c='Commercial Customer';
            accountInstance.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Commercial Customer').getRecordTypeId();
            insert accountInstance;
            
            Request__c rq = new Request__c();
            rq.Account__c = accountInstance.Id;
            rq.Status__c = 'Rejected';
            rq.RecordTypeId = Schema.SObjectType.Request__c.getRecordTypeInfosByName().get('Commercial Customer Update').getRecordTypeId();
            insert rq;
            
            RequestLineItem__c rli = new RequestLineItem__c();
            rli.Field_Name__c = 'Name';
            rli.request__c = rq.Id;
            rli.New_Value__c = 'Cargill2';
            rli.Existing_Value__c = 'Cargill';
            insert rli;
            
            apexpages.currentpage().getparameters().put('AccId' , accountInstance.Id);
            apexpages.currentpage().getparameters().put('status' , 'Edit');
            apexpages.currentpage().getparameters().put('ReqId' , rq.Id);
            System.Debug('URL: ' + ApexPages.currentPage().getParameters().get('AccId'));
            
            DynamicRequestController controller = new DynamicRequestController();
            controller.getFields();
            controller.wrapperList[0].accNew.Name = 'new name';
            controller.save();
            
            Test.stopTest();
        }
    }
    
    private static testMethod void testEditSysAdmSubmitted() {
        Id p = TestDataBuilder.getUserProfileId('System Administrator');
        User u = TestDataBuilder.createUser(1, p);
        
        System.runAs(u) {
            Test.startTest();
            PageReference pageRef = Page.DynamicRequest;
            Test.setCurrentPageReference(pageRef);
            
            List<ProtectedFields__c> pfList = new List<ProtectedFields__c>();
            
            ProtectedFields__c pf1 = new ProtectedFields__c();
            pf1.Name = 'Field 1';
            pf1.Field_Name__c = 'Name';
            pf1.Field_Label__c ='Name';
            pf1.Business_Unit__c = 'US';
            pfList.Add(pf1);
            
            insert pfList;
            
            accountInstance = TestDataBuilder.createAccount();
            accountInstance.Business__c = 'US';
            accountInstance.Account_Type__c='Commercial Customer';
            accountInstance.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Commercial Customer').getRecordTypeId();
            insert accountInstance;
            
            Request__c rq = new Request__c();
            rq.Account__c = accountInstance.Id;
            rq.Status__c = 'Submitted';
            rq.RecordTypeId = Schema.SObjectType.Request__c.getRecordTypeInfosByName().get('Commercial Customer Update').getRecordTypeId();
            insert rq;
            
            RequestLineItem__c rli = new RequestLineItem__c();
            rli.Field_Name__c = 'Name';
            rli.request__c = rq.Id;
            rli.New_Value__c = 'Cargill2';
            rli.Existing_Value__c = 'Cargill';
            insert rli;
            
            apexpages.currentpage().getparameters().put('AccId' , accountInstance.Id);
            apexpages.currentpage().getparameters().put('status' , 'Edit');
            apexpages.currentpage().getparameters().put('ReqId' , rq.Id);
            System.Debug('URL: ' + ApexPages.currentPage().getParameters().get('AccId'));
            
            DynamicRequestController controller = new DynamicRequestController();
            controller.getFields();
            controller.wrapperList[0].accNew.Name = 'new name';
            controller.save();
            controller.cancel();
            
            Test.stopTest();
        }
    }
    
    private static testMethod void testCloneSysAdmRejected() {
        Id p = TestDataBuilder.getUserProfileId('System Administrator');
        User u = TestDataBuilder.createUser(1, p);
        
        System.runAs(u) {
            Test.startTest();
            PageReference pageRef = Page.DynamicRequest;
            Test.setCurrentPageReference(pageRef);
            
            List<ProtectedFields__c> pfList = new List<ProtectedFields__c>();
            
            ProtectedFields__c pf1 = new ProtectedFields__c();
            pf1.Name = 'Field 1';
            pf1.Field_Name__c = 'Name';
            pf1.Field_Label__c ='Name';
            pf1.Business_Unit__c = 'US';
            pfList.Add(pf1);
            
            insert pfList;
            
            accountInstance = TestDataBuilder.createAccount();
            accountInstance.Business__c = 'US';
            accountInstance.Account_Type__c='Commercial Customer';
            accountInstance.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Commercial Customer').getRecordTypeId();
            insert accountInstance;
            
            Request__c rq = new Request__c();
            rq.Account__c = accountInstance.Id;
            rq.Status__c = 'Rejected';
            rq.RecordTypeId = Schema.SObjectType.Request__c.getRecordTypeInfosByName().get('Commercial Customer Update').getRecordTypeId();
            insert rq;
            
            RequestLineItem__c rli = new RequestLineItem__c();
            rli.Field_Name__c = 'Name';
            rli.request__c = rq.Id;
            rli.New_Value__c = 'Cargill2';
            rli.Existing_Value__c = 'Cargill';
            insert rli;
            
            apexpages.currentpage().getparameters().put('AccId' , accountInstance.Id);
            apexpages.currentpage().getparameters().put('status' , 'Clone');
            apexpages.currentpage().getparameters().put('ReqId' , rq.Id);
            System.Debug('URL: ' + ApexPages.currentPage().getParameters().get('AccId'));
            
            DynamicRequestController controller = new DynamicRequestController();
            controller.getFields();
            controller.save();
            controller.cancel();
            
            Test.stopTest();
        }
    }
}