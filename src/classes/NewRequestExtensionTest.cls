@isTest
    private class NewRequestExtensionTest {
    
   private static testMethod void noFieldUpdateCompetitorUpdate1() {
        Id p = TestDataBuilder.getUserProfileId('System Administrator');
        User u = TestDataBuilder.createUser(1, p);
        
        System.runAs(u) {
            Test.startTest();
                Account accountInstance = new Account();
                accountInstance = TestDataBuilder.createAccount();
                accountInstance.Business__c = 'Canada';
                accountInstance.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Competitor CFN Canada').getRecordTypeId();
                accountInstance.Status__c = 'New';
                accountInstance.Account_Type__c='Competitor';
                accountInstance.Prospect_Validated__c=true;
            
                insert accountInstance;
                
                Override_Settings__c osList = new Override_Settings__c();
                osList.Competitor_Record_Type__c = 'Competitor';
                osList.Competitor_Update_Record_Type__c= 'Competitor Update';
                insert osList;
                
                string recordTypeId = Schema.SObjectType.Request__c.getRecordTypeInfosByName().get('Competitor Update').getRecordTypeId();
                
                PageReference pageRef = Page.NewRequest;
                Test.setCurrentPageReference(pageRef);
                pageRef.getParameters().put('RecordType', recordTypeId);

                ApexPages.StandardController sc = new ApexPages.StandardController(accountInstance);

                NewRequestExtension controller = new NewRequestExtension(sc);
                
                controller.saveRecord();
                controller.newReq.Account__c = accountInstance.id;
                controller.checkRecordType();
                
                CompetitorProtectedFields__c pf1 = new CompetitorProtectedFields__c();
                pf1.Name = 'Field 1';
                pf1.Field_Name__c = 'Name';
                pf1.Field_Label__c ='Name';
                pf1.Business_Unit__c = 'US';
                
                insert pf1;
                
                controller.loadCompProtectedFields();
                controller.newAcc.Name = controller.newAcc.Name;
                controller.saveRecord();
            Test.stopTest();
        }
    }
    private static testMethod void checkIfRecordType11() {
        Id p = TestDataBuilder.getUserProfileId('System Administrator');
        User u = TestDataBuilder.createUser(1, p);
        
        System.runAs(u) {
            Test.startTest();
                Account accountInstance = new Account();
                accountInstance = TestDataBuilder.createAccount();
                accountInstance.Business__c = 'Canada';
                accountInstance.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Standard CFN Canada').getRecordTypeId();
                accountInstance.Status__c = 'New';
                accountInstance.Account_Type__c='Standard';
            accountInstance.Prospect_Validated__c=true;
                insert accountInstance;
                
                Override_Settings__c osList = new Override_Settings__c();
                osList.Standard_Record_Type__c = 'Standard';
                osList.Prospect_Validation_Record_Type__c = 'Prospect Validation';
                insert osList;
                
                string recordTypeId = Schema.SObjectType.Request__c.getRecordTypeInfosByName().get('Prospect Validation').getRecordTypeId();
                
                PageReference pageRef = Page.NewRequest;
                Test.setCurrentPageReference(pageRef);
                pageRef.getParameters().put('RecordType', recordTypeId);

                ApexPages.StandardController sc = new ApexPages.StandardController(accountInstance);

                NewRequestExtension controller = new NewRequestExtension(sc);
                controller.newReq.Account__c = accountInstance.id;
                controller.checkRecordType();
            Test.stopTest();
        }
    }
   
  private static testMethod void checkIfRecordTypeIsProspectValidation() {
        Id p = TestDataBuilder.getUserProfileId('System Administrator');
        User u = TestDataBuilder.createUser(1, p);
        
        System.runAs(u) {
            Test.startTest();
                Account accountInstance = new Account();
                accountInstance = TestDataBuilder.createAccount();
                accountInstance.Business__c = 'Canada';
                accountInstance.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Standard CFN Canada').getRecordTypeId();
                accountInstance.Status__c = 'New';
                insert accountInstance;
                
                Override_Settings__c osList = new Override_Settings__c();
                osList.Standard_Record_Type__c = 'Standard CFN Canada';
                osList.Prospect_Validation_Record_Type__c = 'Prospect Validation';
                insert osList;
                
                string recordTypeId = Schema.SObjectType.Request__c.getRecordTypeInfosByName().get('Prospect Validation').getRecordTypeId();
                
                PageReference pageRef = Page.NewRequest;
                Test.setCurrentPageReference(pageRef);
                pageRef.getParameters().put('RecordType', recordTypeId);

                ApexPages.StandardController sc = new ApexPages.StandardController(accountInstance);

                NewRequestExtension controller = new NewRequestExtension(sc);
                controller.newReq.Account__c = accountInstance.id;
                controller.checkRecordType();
            Test.stopTest();
        }
    }
   
    //Added By : Tumish Tak
        private static testMethod void checkIfRecordTypeIsCompetitorValidation() {
        Id p = TestDataBuilder.getUserProfileId('System Administrator');
        User u = TestDataBuilder.createUser(1, p);
        
        System.runAs(u) {
            Test.startTest();
                Account accountInstance = new Account();
                accountInstance = TestDataBuilder.createAccount();
                accountInstance.Business__c = 'Canada';
                accountInstance.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Competitor CFN Canada').getRecordTypeId();
                accountInstance.Status__c = 'New';
                insert accountInstance;
                
                Override_Settings__c osList = new Override_Settings__c();
                osList.Standard_Record_Type__c = 'Competitor CFN Canada';
                osList.Prospect_Validation_Record_Type__c = 'Competitor Validation';
                insert osList;
                
                string recordTypeId = Schema.SObjectType.Request__c.getRecordTypeInfosByName().get('Competitor Validation').getRecordTypeId();
                
                PageReference pageRef = Page.NewRequest;
                Test.setCurrentPageReference(pageRef);
                pageRef.getParameters().put('RecordType', recordTypeId);

                ApexPages.StandardController sc = new ApexPages.StandardController(accountInstance);

                NewRequestExtension controller = new NewRequestExtension(sc);
                controller.newReq.Account__c = accountInstance.id;
                controller.checkRecordType();
            Test.stopTest();
        }
    }
    
    private static testMethod void checkIfRecordTypeIsConsumerValidation() {
        Id p = TestDataBuilder.getUserProfileId('System Administrator');
        User u = TestDataBuilder.createUser(1, p);
        
        System.runAs(u) {
            Test.startTest();
                Account accountInstance = new Account();
                accountInstance = TestDataBuilder.createAccount();
                accountInstance.Business__c = 'Canada';
                accountInstance.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Consumer CFN Canada').getRecordTypeId();
                accountInstance.Status__c = 'New';
                insert accountInstance;
                
                Override_Settings__c osList = new Override_Settings__c();
                osList.Standard_Record_Type__c = 'Consumer CFN Canada';
                osList.Prospect_Validation_Record_Type__c = 'Consumer Validation';
                insert osList;
                
                string recordTypeId = Schema.SObjectType.Request__c.getRecordTypeInfosByName().get('Consumer Validation').getRecordTypeId();
                
                PageReference pageRef = Page.NewRequest;
                Test.setCurrentPageReference(pageRef);
                pageRef.getParameters().put('RecordType', recordTypeId);

                ApexPages.StandardController sc = new ApexPages.StandardController(accountInstance);

                NewRequestExtension controller = new NewRequestExtension(sc);
                controller.newReq.Account__c = accountInstance.id;
                controller.checkRecordType();
            Test.stopTest();
        }
    }
    
    private static testMethod void checkIfRecordTypeIsNotCompetitorValidation() {
        Id p = TestDataBuilder.getUserProfileId('System Administrator');
        User u = TestDataBuilder.createUser(1, p);
        
        System.runAs(u) {
            Test.startTest();
                Account accountInstance = new Account();
                accountInstance = TestDataBuilder.createAccount();
                accountInstance.Business__c = 'Canada';
                accountInstance.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Competitor CFN Canada').getRecordTypeId();
                accountInstance.Status__c = 'New';
                insert accountInstance;
                
                Override_Settings__c osList = new Override_Settings__c();
                osList.Standard_Record_Type__c = 'Competitor CFN Canada';
                osList.Prospect_Validation_Record_Type__c = 'Competitor Validation';
                insert osList;
                
                string recordTypeId = Schema.SObjectType.Request__c.getRecordTypeInfosByName().get('Competitor Validation').getRecordTypeId();
                
                PageReference pageRef = Page.NewRequest;
                Test.setCurrentPageReference(pageRef);
                pageRef.getParameters().put('RecordType', recordTypeId);

                ApexPages.StandardController sc = new ApexPages.StandardController(accountInstance);

                NewRequestExtension controller = new NewRequestExtension(sc);
                controller.newReq.Account__c = accountInstance.id;
                controller.checkRecordType();
            Test.stopTest();
        }
    }
    
    private static testMethod void checkIfRecordTypeIsNotConsumerValidation() {
        Id p = TestDataBuilder.getUserProfileId('System Administrator');
        User u = TestDataBuilder.createUser(1, p);
        
        System.runAs(u) {
            Test.startTest();
                Account accountInstance = new Account();
                accountInstance = TestDataBuilder.createAccount();
                accountInstance.Business__c = 'Canada';
                accountInstance.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Consumer CFN Canada').getRecordTypeId();
                accountInstance.Status__c = 'New';
                insert accountInstance;
                
                Override_Settings__c osList = new Override_Settings__c();
                osList.Standard_Record_Type__c = 'Consumer CFN Canada';
                osList.Prospect_Validation_Record_Type__c = 'Consumer Validation';
                insert osList;
                
                string recordTypeId = Schema.SObjectType.Request__c.getRecordTypeInfosByName().get('Consumer Validation').getRecordTypeId();
                
                PageReference pageRef = Page.NewRequest;
                Test.setCurrentPageReference(pageRef);
                pageRef.getParameters().put('RecordType', recordTypeId);

                ApexPages.StandardController sc = new ApexPages.StandardController(accountInstance);

                NewRequestExtension controller = new NewRequestExtension(sc);
                controller.newReq.Account__c = accountInstance.id;
                controller.checkRecordType();
            Test.stopTest();
        }
    }
    
    
    private static testMethod void checkIfRecordTypeIsCompetitorUpdate() {
        Id p = TestDataBuilder.getUserProfileId('System Administrator');
        User u = TestDataBuilder.createUser(1, p);
        
        System.runAs(u) {
            Test.startTest();
                Account accountInstance = new Account();
                accountInstance = TestDataBuilder.createAccount();
                accountInstance.Business__c = 'Canada';
                accountInstance.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Competitor CFN Canada').getRecordTypeId();
                accountInstance.Status__c = 'New';
                insert accountInstance;
                
                Override_Settings__c osList = new Override_Settings__c();
                osList.Commercial_Customer_Record_Type__c = 'Competitor CFN Canada';
                osList.Commercial_Customer_Update_Record_Type__c = 'Competitor Update';
                insert osList;
                
                string recordTypeId = Schema.SObjectType.Request__c.getRecordTypeInfosByName().get('Competitor Update').getRecordTypeId();
                
                PageReference pageRef = Page.NewRequest;
                Test.setCurrentPageReference(pageRef);
                pageRef.getParameters().put('RecordType', recordTypeId);

                ApexPages.StandardController sc = new ApexPages.StandardController(accountInstance);

                NewRequestExtension controller = new NewRequestExtension(sc);
                controller.newReq.Account__c = accountInstance.id;
                controller.checkRecordType();
                
                List<CompetitorProtectedFields__c> pfList = new List<CompetitorProtectedFields__c>();
                
                CompetitorProtectedFields__c pf1 = new CompetitorProtectedFields__c();
                pf1.Name = 'Field 1';
                pf1.Field_Name__c = 'Name';
                pf1.Field_Label__c ='Name';
                pf1.Business_Unit__c = 'US';
                pfList.Add(pf1);
                
                CompetitorProtectedFields__c pf2 = new CompetitorProtectedFields__c();
                pf2.Name = 'Owner 1';
                pf2.Field_Name__c = 'OwnerId';
                pf2.Field_Label__c ='Owner';
                pf2.Business_Unit__c = 'US';
                pfList.Add(pf2);
                
                insert pfList;
                
                controller.loadCompProtectedFields();
                controller.newAcc.Name = 'new name';
                Id p1 = TestDataBuilder.getUserProfileId('System Administrator');
                User u1 = TestDataBuilder.createUser(2, p1);
                insert u1;
                
                controller.newAcc.OwnerId = u1.Id;
                controller.saveRecord();
            Test.stopTest();
        }
    }
    
    
        private static testMethod void checkIfRecordTypeIsNotCompetitorUpdate() {
        Id p = TestDataBuilder.getUserProfileId('System Administrator');
        User u = TestDataBuilder.createUser(1, p);
        
        System.runAs(u) {
            Test.startTest();
                Account accountInstance = new Account();
                accountInstance = TestDataBuilder.createAccount();
                accountInstance.Business__c = 'Canada';
                accountInstance.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Competitor CFN Canada').getRecordTypeId();
                accountInstance.Status__c = 'New';
                insert accountInstance;
                
                Override_Settings__c osList = new Override_Settings__c();
                osList.Commercial_Customer_Record_Type__c = 'Competitor CFN Canada';
                osList.Commercial_Customer_Update_Record_Type__c = 'Competitor Update';
                insert osList;
                
                string recordTypeId = Schema.SObjectType.Request__c.getRecordTypeInfosByName().get('Competitor Update').getRecordTypeId();
                
                PageReference pageRef = Page.NewRequest;
                Test.setCurrentPageReference(pageRef);
                pageRef.getParameters().put('RecordType', recordTypeId);

                ApexPages.StandardController sc = new ApexPages.StandardController(accountInstance);

                NewRequestExtension controller = new NewRequestExtension(sc);
                controller.newReq.Account__c = accountInstance.id;
                controller.checkRecordType();
            Test.stopTest();
        }
    }
    
    
    private static testMethod void noFieldUpdateCompetitorUpdate() {
        Id p = TestDataBuilder.getUserProfileId('System Administrator');
        User u = TestDataBuilder.createUser(1, p);
        
        System.runAs(u) {
            Test.startTest();
                Account accountInstance = new Account();
                accountInstance = TestDataBuilder.createAccount();
                accountInstance.Business__c = 'Canada';
                accountInstance.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Competitor CFN Canada').getRecordTypeId();
                accountInstance.Status__c = 'New';
                accountInstance.Account_Type__c='Competitor';
                accountInstance.Prospect_Validated__c=true;
            
                insert accountInstance;
                
                Override_Settings__c osList = new Override_Settings__c();
                osList.Competitor_Record_Type__c = 'Competitor';
                osList.Competitor_Update_Record_Type__c= 'Competitor Update';
                insert osList;
                
                string recordTypeId = Schema.SObjectType.Request__c.getRecordTypeInfosByName().get('Competitor Update').getRecordTypeId();
                
                PageReference pageRef = Page.NewRequest;
                Test.setCurrentPageReference(pageRef);
                pageRef.getParameters().put('RecordType', recordTypeId);

                ApexPages.StandardController sc = new ApexPages.StandardController(accountInstance);

                NewRequestExtension controller = new NewRequestExtension(sc);
                
                controller.saveRecord();
                controller.newReq.Account__c = accountInstance.id;
                controller.checkRecordType();
                
                CompetitorProtectedFields__c pf1 = new CompetitorProtectedFields__c();
                pf1.Name = 'Field 1';
                pf1.Field_Name__c = 'Name';
                pf1.Field_Label__c ='Name';
                pf1.Business_Unit__c = 'US';
                
                insert pf1;
                
                controller.loadCompProtectedFields();
                controller.newAcc.Name = controller.newAcc.Name;
                controller.saveRecord();
            Test.stopTest();
        }
    }
    
    //Tumish : End
    
    private static testMethod void checkIfRecordTypeIsProspectConversion() {
        Id p = TestDataBuilder.getUserProfileId('System Administrator');
        User u = TestDataBuilder.createUser(1, p);
        
        System.runAs(u) {
            Test.startTest();
                Account accountInstance = new Account();
                accountInstance = TestDataBuilder.createAccount();
                accountInstance.Business__c = 'Canada';
                accountInstance.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Standard CFN Canada').getRecordTypeId();
                accountInstance.Status__c = 'New';
                insert accountInstance;
                
                Override_Settings__c osList = new Override_Settings__c();
                osList.Standard_Record_Type__c = 'Standard CFN Canada';
                osList.Prospect_Conversion_Record_Type__c = 'Prospect Conversion';
                insert osList;
                
                string recordTypeId = Schema.SObjectType.Request__c.getRecordTypeInfosByName().get('Prospect Conversion').getRecordTypeId();
                
                PageReference pageRef = Page.NewRequest;
                Test.setCurrentPageReference(pageRef);
                pageRef.getParameters().put('RecordType', recordTypeId);

                ApexPages.StandardController sc = new ApexPages.StandardController(accountInstance);

                NewRequestExtension controller = new NewRequestExtension(sc);
                controller.newReq.Account__c = accountInstance.id;
                controller.checkRecordType();
                controller.saveRecord();
            Test.stopTest();
        }
    }
    
    private static testMethod void checkIfRecordTypeIsCommercialCustomerUpdate() {
        Id p = TestDataBuilder.getUserProfileId('System Administrator');
        User u = TestDataBuilder.createUser(1, p);
        
        System.runAs(u) {
            Test.startTest();
                Account accountInstance = new Account();
                accountInstance = TestDataBuilder.createAccount();
                accountInstance.Business__c = 'Canada';
                accountInstance.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Commercial Customer CFN Canada').getRecordTypeId();
                accountInstance.Status__c = 'New';
                insert accountInstance;
                
                Override_Settings__c osList = new Override_Settings__c();
                osList.Commercial_Customer_Record_Type__c = 'Standard CFN Canada';
                osList.Commercial_Customer_Update_Record_Type__c = 'Commercial Customer Update';
                insert osList;
                
                string recordTypeId = Schema.SObjectType.Request__c.getRecordTypeInfosByName().get('Commercial Customer Update').getRecordTypeId();
                
                PageReference pageRef = Page.NewRequest;
                Test.setCurrentPageReference(pageRef);
                pageRef.getParameters().put('RecordType', recordTypeId);

                ApexPages.StandardController sc = new ApexPages.StandardController(accountInstance);

                NewRequestExtension controller = new NewRequestExtension(sc);
                controller.newReq.Account__c = accountInstance.id;
                controller.checkRecordType();
                
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
                
                controller.loadProtectedFields();
                controller.newAcc.Name = 'new name';
                Id p1 = TestDataBuilder.getUserProfileId('System Administrator');
                User u1 = TestDataBuilder.createUser(2, p1);
                insert u1;
                
                controller.newAcc.OwnerId = u1.Id;
                controller.saveRecord();
            Test.stopTest();
        }
    }
    
    private static testMethod void checkIfRecordTypeIsNotProspectValidation() {
        Id p = TestDataBuilder.getUserProfileId('System Administrator');
        User u = TestDataBuilder.createUser(1, p);
        
        System.runAs(u) {
            Test.startTest();
                Account accountInstance = new Account();
                accountInstance = TestDataBuilder.createAccount();
                accountInstance.Business__c = 'Canada';
                accountInstance.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Commercial Customer CFN Canada').getRecordTypeId();
                accountInstance.Status__c = 'New';
                insert accountInstance;
                
                Override_Settings__c osList = new Override_Settings__c();
                osList.Standard_Record_Type__c = 'Standard CFN Canada';
                osList.Prospect_Validation_Record_Type__c = 'Prospect Validation';
                insert osList;
                
                string recordTypeId = Schema.SObjectType.Request__c.getRecordTypeInfosByName().get('Prospect Validation').getRecordTypeId();
                
                PageReference pageRef = Page.NewRequest;
                Test.setCurrentPageReference(pageRef);
                pageRef.getParameters().put('RecordType', recordTypeId);

                ApexPages.StandardController sc = new ApexPages.StandardController(accountInstance);

                NewRequestExtension controller = new NewRequestExtension(sc);
                controller.newReq.Account__c = accountInstance.id;
                controller.checkRecordType();
            Test.stopTest();
        }
    }
    
    private static testMethod void checkIfRecordTypeIsNotProspectConversion() {
        Id p = TestDataBuilder.getUserProfileId('System Administrator');
        User u = TestDataBuilder.createUser(1, p);
        
        System.runAs(u) {
            Test.startTest();
                Account accountInstance = new Account();
                accountInstance = TestDataBuilder.createAccount();
                accountInstance.Business__c = 'Canada';
                accountInstance.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Commercial Customer CFN Canada').getRecordTypeId();
                accountInstance.Status__c = 'New';
                insert accountInstance;
                
                Override_Settings__c osList = new Override_Settings__c();
                osList.Standard_Record_Type__c = 'Standard CFN Canada';
                osList.Prospect_Conversion_Record_Type__c = 'Prospect Conversion';
                insert osList;
                
                string recordTypeId = Schema.SObjectType.Request__c.getRecordTypeInfosByName().get('Prospect Conversion').getRecordTypeId();
                
                PageReference pageRef = Page.NewRequest;
                Test.setCurrentPageReference(pageRef);
                pageRef.getParameters().put('RecordType', recordTypeId);

                ApexPages.StandardController sc = new ApexPages.StandardController(accountInstance);

                NewRequestExtension controller = new NewRequestExtension(sc);
                controller.newReq.Account__c = accountInstance.id;
                controller.checkRecordType();
            Test.stopTest();
        }
    }
    
    private static testMethod void checkIfRecordTypeIsNotCommercialCustomerUpdate() {
        Id p = TestDataBuilder.getUserProfileId('System Administrator');
        User u = TestDataBuilder.createUser(1, p);
        
        System.runAs(u) {
            Test.startTest();
                Account accountInstance = new Account();
                accountInstance = TestDataBuilder.createAccount();
                accountInstance.Business__c = 'Canada';
                accountInstance.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Standard CFN Canada').getRecordTypeId();
                accountInstance.Status__c = 'New';
                insert accountInstance;
                
                Override_Settings__c osList = new Override_Settings__c();
                osList.Commercial_Customer_Record_Type__c = 'Standard CFN Canada';
                osList.Commercial_Customer_Update_Record_Type__c = 'Commercial Customer Update';
                insert osList;
                
                string recordTypeId = Schema.SObjectType.Request__c.getRecordTypeInfosByName().get('Commercial Customer Update').getRecordTypeId();
                
                PageReference pageRef = Page.NewRequest;
                Test.setCurrentPageReference(pageRef);
                pageRef.getParameters().put('RecordType', recordTypeId);

                ApexPages.StandardController sc = new ApexPages.StandardController(accountInstance);

                NewRequestExtension controller = new NewRequestExtension(sc);
                controller.newReq.Account__c = accountInstance.id;
                controller.checkRecordType();
            Test.stopTest();
        }
    }
    
    private static testMethod void noFieldUpdateCommercialCustomerUpdate() {
        Id p = TestDataBuilder.getUserProfileId('System Administrator');
        User u = TestDataBuilder.createUser(1, p);
        
        System.runAs(u) {
            Test.startTest();
                Account accountInstance = new Account();
                accountInstance = TestDataBuilder.createAccount();
                accountInstance.Business__c = 'Canada';
                accountInstance.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Commercial Customer CFN Canada').getRecordTypeId();
                accountInstance.Status__c = 'New';
                insert accountInstance;
                
                Override_Settings__c osList = new Override_Settings__c();
                osList.Commercial_Customer_Record_Type__c = 'Standard CFN Canada';
                osList.Commercial_Customer_Update_Record_Type__c = 'Commercial Customer Update';
                insert osList;
                
                string recordTypeId = Schema.SObjectType.Request__c.getRecordTypeInfosByName().get('Commercial Customer Update').getRecordTypeId();
                
                PageReference pageRef = Page.NewRequest;
                Test.setCurrentPageReference(pageRef);
                pageRef.getParameters().put('RecordType', recordTypeId);

                ApexPages.StandardController sc = new ApexPages.StandardController(accountInstance);

                NewRequestExtension controller = new NewRequestExtension(sc);
                
                controller.saveRecord();
                controller.newReq.Account__c = accountInstance.id;
                controller.checkRecordType();
                
                ProtectedFields__c pf1 = new ProtectedFields__c();
                pf1.Name = 'Field 1';
                pf1.Field_Name__c = 'Name';
                pf1.Field_Label__c ='Name';
                pf1.Business_Unit__c = 'US';
                
                insert pf1;
                
                controller.loadProtectedFields();
                controller.newAcc.Name = controller.newAcc.Name;
                controller.saveRecord();
            Test.stopTest();
        }
    }
    

}