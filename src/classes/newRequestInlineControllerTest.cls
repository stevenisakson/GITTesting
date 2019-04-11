@isTest
private class newRequestInlineControllerTest{
    
    @testSetup
    static void testSetup(){
        
    }
    
    @isTest static void testnewRequestInlineController(){
        
        Test.startTest();
        
        PageReference pageRef = Page.newRequestInline;
        Test.setCurrentPageReference(pageRef);
        
        Id recId = [SELECT Id, Name FROM RecordType WHERE SobjectType = 'Account' and Name = 'Commercial Customer'].id;
        Account acc = new Account(Name='Test Account', Type = 'Dealer', RecordTypeId = recId );
        insert acc;
        RequestLineItem__c rli = new RequestLineItem__c();
        Request__c req = new Request__c(Account__c = acc.id);
        insert req;
        List<RequestLineItem__c> reqlist = new List<RequestLineItem__c>();
        
        reqlist.add(new RequestLineItem__c(Field_Name__c = 'Vat__c', Existing_Value__c='123', New_Value__c='456', Status__c='Approved', Request__c = req.id));
        reqlist.add(new RequestLineItem__c(Field_Name__c = 'Brand__c', Existing_Value__c='Old Brand', New_Value__c='New Brand', Status__c='Approved', Request__c = req.id));
        reqlist.add(new RequestLineItem__c(Field_Name__c = 'Legal_Name__c', Existing_Value__c='Old Name', New_Value__c='New Name', Status__c='Approved', Request__c = req.id));
        
        insert reqlist;
        
        ApexPages.currentPage().getParameters().put('requestLineItemId',reqlist[0].id);
        ApexPages.currentPage().getParameters().put('currentStatus','Declined');
        
        ApexPages.currentPage().getParameters().put('Id',req.id);
        ApexPages.StandardController stndCont = new ApexPages.StandardController(req);
        newRequestInlineController extension = new newRequestInlineController(stndCont);
        
        //assert that status of request line item before CTRLR_doSave is still Approved
        system.assertEquals(reqlist[0].Status__c, 'Approved');
        
        extension.CTRLR_doSave();
        RequestLineItem__c queryRli = [SELECT Status__c from RequestLineItem__c WHERE id =: reqlist[0].id];
        //Assert that Status of request line item changes to decline after changing current status and calling CTRLR_doSave
        system.assertEquals(queryRli.Status__c, 'Declined');
        
        extension.getStatuses();
        
        
        Test.stopTest();
        
        
    }
    
    @isTest static void testnewRequestInlineControllerApproved(){
         Test.startTest();
        
        PageReference pageRef = Page.newRequestInline;
        Test.setCurrentPageReference(pageRef);
        
        Id recId = [SELECT Id, Name FROM RecordType WHERE SobjectType = 'Account' and Name = 'Commercial Customer'].id;
        Account acc = new Account(Name='Test Account', Type = 'Dealer', RecordTypeId = recId );
        insert acc;
        RequestLineItem__c rli = new RequestLineItem__c();
        Request__c req = new Request__c(Account__c = acc.id);
        insert req;
        List<RequestLineItem__c> reqlist = new List<RequestLineItem__c>();
        
        reqlist.add(new RequestLineItem__c(Field_Name__c = 'Vat__c', Existing_Value__c='123', New_Value__c='456', Status__c='Approved', Request__c = req.id));
        reqlist.add(new RequestLineItem__c(Field_Name__c = 'Brand__c', Existing_Value__c='Old Brand', New_Value__c='New Brand', Status__c='Approved', Request__c = req.id));
        reqlist.add(new RequestLineItem__c(Field_Name__c = 'Legal_Name__c', Existing_Value__c='Old Name', New_Value__c='New Name', Status__c='Approved', Request__c = req.id));
        
        insert reqlist;
        
        ApexPages.currentPage().getParameters().put('requestLineItemId',reqlist[0].id);
        ApexPages.currentPage().getParameters().put('currentStatus','Approved');
        
        ApexPages.currentPage().getParameters().put('Id',req.id);
        ApexPages.StandardController stndCont = new ApexPages.StandardController(req);
        newRequestInlineController extension = new newRequestInlineController(stndCont);
        
        //assert that status of request line item before CTRLR_doSave is still Approved
        system.assertEquals(reqlist[0].Status__c, 'Approved');
        
        extension.CTRLR_doSave();
        RequestLineItem__c queryRli = [SELECT Status__c, Existing_Value__c from RequestLineItem__c WHERE id =: reqlist[0].id];
      
        
        extension.getStatuses();
        
        
        Test.stopTest();
    }
    
}