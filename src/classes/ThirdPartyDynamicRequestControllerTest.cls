/*********************************************************************
Name:ThirdPartyDynamicRequestControllerTest
Date:24 Oct 2018
Description: test Class for ThirdPartyDynamicRequestController
             
*********************************************************************/

@isTest
private class ThirdPartyDynamicRequestControllerTest {


public static Account accountInstance = new Account();
    
    private static testMethod void testNewSysAdm() {
        Id p = TestDataBuilder.getUserProfileId(Label.System_Administrator_Profile);
        User u = TestDataBuilder.createUser(1, p);
        u.Region__c='CPN India';
            u.Business_Unit__c = 'CPN - India';
            u.Country_Code__c = 'IN';
            u.CAN_Business__c = 'CPN';
        insert u;
        System.runAs(u) {
            
               Id p1 = TestDataBuilder.getUserProfileId(Label.Data_Steward_Profile);
                User u1 = TestDataBuilder.createUser(2, p1);
            	   u1.Region__c='CPN India';
            u1.Business_Unit__c = 'CPN - India';
            u1.Country_Code__c = 'IN';
            u1.CAN_Business__c = 'CPN';
      
                insert u1;
            
                PageReference pageRef = Page.ThirdPartyDynamicRequest;
                Test.setCurrentPageReference(pageRef);
                
                List<Third_Party_Protected_Fields__c> pfList = new List<Third_Party_Protected_Fields__c>();
                
                Third_Party_Protected_Fields__c pf1 = new  Third_Party_Protected_Fields__c();
                pf1.Name = 'Field 1';
                pf1.Field_Name__c = 'Name';
                pf1.Field_Label__c ='Account Name';
                pf1.Business_Unit__c = 'CPN - India';
                pfList.Add(pf1);
                
                Third_Party_Protected_Fields__c  pf2 = new Third_Party_Protected_Fields__c();
                pf2.Name = 'Owner 1';
                pf2.Field_Name__c = 'OwnerId';
                pf2.Field_Label__c ='Account Owner';
                pf2.Business_Unit__c = 'CPN - India';
                pfList.Add(pf2);
                
                insert pfList;
                
                accountInstance = TestDataBuilder.createAccount();
                accountInstance.Business__c = 'CPN - India';
            	accountInstance.Name = 'Test Acc123';
                accountInstance.Request_Approved__c = false;
            	accountInstance.Account_Type__c='Third Party';
                accountInstance.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Third Party CPN India').getRecordTypeId();
                insert accountInstance;
                
                apexpages.currentpage().getparameters().put('AccId' , accountInstance.Id);
                apexpages.currentpage().getparameters().put('status' , 'New');
                
                
                System.Debug('URL: ' + ApexPages.currentPage().getParameters().get('AccId'));
            
                Test.startTest();
                ThirdPartyDynamicRequestController controller = new ThirdPartyDynamicRequestController();
                controller.getAccountInfo();
                controller.getFields();
                controller.wrapperList[0].accNew.Name = 'new name';
                controller.wrapperList[0].accNew.OwnerId = u1.Id;
                controller.save();
                controller.cancel();
                
            Test.stopTest();
        }
    }
    
  
    private static testMethod void testEditSysAdmDraft() {
        Id p = TestDataBuilder.getUserProfileId(Label.System_Administrator_Profile);
        User u = TestDataBuilder.createUser(1, p);
           u.Region__c='CPN India';
            u.Business_Unit__c = 'CPN - India';
            u.Country_Code__c = 'IN';
            u.CAN_Business__c = 'CPN';
        insert u;
        
        System.runAs(u) {
           
                PageReference pageRef = Page.ThirdPartyDynamicRequest;
                Test.setCurrentPageReference(pageRef);
            
                Id p1 = TestDataBuilder.getUserProfileId(Label.System_Administrator_Profile);
                User u1 = TestDataBuilder.createUser(2, p1);
               u1.Region__c='CPN India';
            u1.Business_Unit__c = 'CPN - India';
            u1.Country_Code__c = 'IN';
            u1.CAN_Business__c = 'CPN';
        
                insert u1;
        
                List<Third_Party_Protected_Fields__c> pfList = new List<Third_Party_Protected_Fields__c>();
                
                Third_Party_Protected_Fields__c pf1 = new Third_Party_Protected_Fields__c();
                pf1.Name = 'Field 1';
                pf1.Field_Name__c = ' Name';
                pf1.Field_Label__c =' Account Name';
                pf1.Business_Unit__c = 'CPN - India';
                pfList.Add(pf1);
                
                Third_Party_Protected_Fields__c pf2 = new Third_Party_Protected_Fields__c();
                pf2.Name = 'Owner 1';
                pf2.Field_Name__c = 'OwnerId';
                pf2.Field_Label__c ='Account Owner';
                pf2.Business_Unit__c = 'CPN - India';
                pfList.Add(pf2);
                
                insert pfList;
                
                accountInstance = TestDataBuilder.createAccount();
                accountInstance.Business__c = 'CPN - India';
            accountInstance.Name = 'Test Acc123';
                accountInstance.Request_Approved__c = false;
            	accountInstance.Account_Type__c='Third Party';
                accountInstance.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Third Party CPN India').getRecordTypeId();
                insert accountInstance;
                
                Request__c rq = new Request__c();
                rq.Account__c = accountInstance.Id;
                rq.Status__c = 'Draft';
                rq.RecordTypeId = Schema.SObjectType.Request__c.getRecordTypeInfosByName().get(Label.Third_Party_Update_Record_Type).getRecordTypeId();
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
                
                Test.startTest();
                ThirdPartyDynamicRequestController controller = new ThirdPartyDynamicRequestController();
                controller.getFields();
                controller.wrapperList[0].accNew.Name = 'new name';
                controller.wrapperList[0].accNew.OwnerId = u1.Id;
                controller.save();
                
            Test.stopTest();
        }
    }
    
     private static testMethod void testEditSysAdmRejected() {
        Id p = TestDataBuilder.getUserProfileId(Label.System_Administrator_Profile);
        User u = TestDataBuilder.createUser(1, p);
            u.Region__c='CPN India';
            u.Business_Unit__c = 'CPN - India';
            u.Country_Code__c = 'IN';
            u.CAN_Business__c = 'CPN';
        insert u;
        
        System.runAs(u) {
            Test.startTest();
                PageReference pageRef = Page.ThirdPartyDynamicRequest;
                Test.setCurrentPageReference(pageRef);
        
                List<Third_Party_Protected_Fields__c > pfList = new List<Third_Party_Protected_Fields__c>();
                
                Third_Party_Protected_Fields__c pf1 = new Third_Party_Protected_Fields__c();
                pf1.Name = 'Field 1';
                pf1.Field_Name__c = 'Name';
                pf1.Field_Label__c ='Account Name';
                pf1.Business_Unit__c = 'CPN - India';
                pfList.Add(pf1);
                
                insert pfList;
                
                accountInstance = TestDataBuilder.createAccount();
                accountInstance.Business__c = 'CPN - India';
           		accountInstance.Name = 'Test Acc123';
                accountInstance.Request_Approved__c = false;
            	accountInstance.Account_Type__c='Third Party';
                accountInstance.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Third Party CPN India').getRecordTypeId();
                insert accountInstance;
                
                Request__c rq = new Request__c();
                rq.Account__c = accountInstance.Id;
                rq.Status__c = 'Rejected';
                rq.RecordTypeId = Schema.SObjectType.Request__c.getRecordTypeInfosByName().get(Label.Third_Party_Update_Record_Type).getRecordTypeId();
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
                
                ThirdPartyDynamicRequestController controller = new ThirdPartyDynamicRequestController();
                controller.getFields();
                controller.wrapperList[0].accNew.Name = 'new name';
                controller.save();
                
            Test.stopTest();
        }
    }

  private static testMethod void testEditSysAdmSubmitted() {
        Id p = TestDataBuilder.getUserProfileId('System Administrator');
        User u = TestDataBuilder.createUser(1, p);
           u.Region__c='CPN India';
            u.Business_Unit__c = 'CPN - India';
            u.Country_Code__c = 'IN';
            u.CAN_Business__c = 'CPN';
        insert u;
      
        System.runAs(u) {
            
                PageReference pageRef = Page.ThirdPartyDynamicRequest;
                Test.setCurrentPageReference(pageRef);
        
                List<Third_Party_Protected_Fields__c> pfList = new List<Third_Party_Protected_Fields__c>();
                
                Third_Party_Protected_Fields__c pf1 = new Third_Party_Protected_Fields__c();
                pf1.Name = 'Field 1';
                pf1.Field_Name__c = 'Name';
                pf1.Field_Label__c ='Account Name';
                pf1.Business_Unit__c = 'CPN - India';
                pfList.Add(pf1);
                
                insert pfList;
                
                accountInstance = TestDataBuilder.createAccount();
                accountInstance.Business__c = 'CPN - India';
            accountInstance.Name = 'Test Acc123';
                accountInstance.Request_Approved__c = false;
            	accountInstance.Account_Type__c='Third Party';
                accountInstance.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Third Party CPN India').getRecordTypeId();
                insert accountInstance;
                
                Request__c rq = new Request__c();
                rq.Account__c = accountInstance.Id;
                rq.Status__c = 'Submitted';
                rq.RecordTypeId = Schema.SObjectType.Request__c.getRecordTypeInfosByName().get(Label.Third_Party_Update_Record_Type).getRecordTypeId();
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
            
                Test.startTest();
                ThirdPartyDynamicRequestController controller = new ThirdPartyDynamicRequestController();
                controller.getFields();
                controller.wrapperList[0].accNew.Name = 'new name';
                controller.save();
                controller.cancel();
                
            Test.stopTest();
        }
    }


 private static testMethod void testCloneSysAdmRejected() {
 

        Id p = TestDataBuilder.getUserProfileId(Label.System_Administrator_Profile);
        User u = TestDataBuilder.createUser(1, p);
		   u.Region__c='CPN India';
            u.Business_Unit__c = 'CPN - India';
            u.Country_Code__c = 'IN';
            u.CAN_Business__c = 'CPN';
        insert u;
     
        System.runAs(u) {
            
               PageReference pageRef = Page.ThirdPartyDynamicRequest;
               Test.setCurrentPageReference(pageRef);
        
                List<Third_Party_Protected_Fields__c> pfList = new List<Third_Party_Protected_Fields__c>();
                
                Third_Party_Protected_Fields__c pf1 = new Third_Party_Protected_Fields__c();
                pf1.Name = 'Field 1';
                pf1.Field_Name__c = 'Name';
                pf1.Field_Label__c ='Name';
                pf1.Business_Unit__c = 'CPN - India';
                pfList.Add(pf1);
                
               insert pfList;
                
                accountInstance = TestDataBuilder.createAccount();
                accountInstance.Business__c = 'CPN - India';
            accountInstance.Name = 'Test Acc123';
                accountInstance.Request_Approved__c = false;
            	accountInstance.Account_Type__c='Third Party';
                accountInstance.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Third Party CPN India').getRecordTypeId();
                insert accountInstance;
                
                Request__c rq = new Request__c();
                rq.Account__c = accountInstance.Id;
                rq.Status__c = 'Rejected';
                rq.RecordTypeId = Schema.SObjectType.Request__c.getRecordTypeInfosByName().get(Label.Third_Party_Update_Record_Type).getRecordTypeId();
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
                
                Test.startTest();
                ThirdPartyDynamicRequestController controller = new ThirdPartyDynamicRequestController();
                controller.getFields();
                controller.save();
                controller.cancel();
                
            Test.stopTest();
       
        }
 
    }


}