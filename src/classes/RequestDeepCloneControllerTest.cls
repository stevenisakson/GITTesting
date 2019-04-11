@isTest
private class RequestDeepCloneControllerTest{
    
    
    @isTest static void RequestDeepCloneControllerDraftTest(){
        
        
        Test.startTest();
        
        PageReference pageRef = Page.RequestDeepClone;
        Test.setCurrentPageReference(pageRef);
        
        Id recId = [SELECT Id, Name FROM RecordType WHERE SobjectType = 'Account' and Name = 'Commercial Customer'].id;
        Account acc = new Account(Name='Test Account', Type = 'Dealer', RecordTypeId = recId, Business__c = 'US' );
        insert acc;
        RequestLineItem__c rli = new RequestLineItem__c();
        Request__c req = new Request__c(Account__c = acc.id, Status__c = 'Draft');
        insert req;
        List<RequestLineItem__c> reqlist = new List<RequestLineItem__c>();
        
        reqlist.add(new RequestLineItem__c(Field_Name__c = 'Vat__c', Existing_Value__c='123', New_Value__c='456', Status__c='Approved', Request__c = req.id));
        reqlist.add(new RequestLineItem__c(Field_Name__c = 'Brand__c', Existing_Value__c='Old Brand', New_Value__c='New Brand', Status__c='Approved', Request__c = req.id));
        reqlist.add(new RequestLineItem__c(Field_Name__c = 'Legal_Name__c', Existing_Value__c='Old Name', New_Value__c='New Name', Status__c='Approved', Request__c = req.id));
        
        insert reqlist;
        
        if([select count() from ProcessInstance where targetobjectid=:req.id] < 1) {
        
            Approval.ProcessSubmitRequest procReq = new Approval.ProcessSubmitRequest();
            procReq.setComments('Approve');
            procReq.setNextApproverIds(new Id[] {UserInfo.getUserId()});
            procReq.setObjectId(req.Id);
            system.debug('@@ procReq'+procReq);
            Approval.ProcessResult result = Approval.process(procReq);
            System.assert(result.isSuccess());
            
             System.assertEquals(
            'Pending', result.getInstanceStatus(),
            'Instance Status'+result.getInstanceStatus());

        }    
        
        ApexPages.currentPage().getParameters().put('Id',req.id);
        ApexPages.StandardController stndCont = new ApexPages.StandardController(req);
        RequestDeepCloneController extension = new RequestDeepCloneController(stndCont);
        
        List<Request__c> idassert= [SELECT id from Request__c];
        //Assert that there is only one request before cloning
        system.assertEquals(1,idassert.size());
        extension.cloneWithItems();
        
        Test.stopTest();
        
        List<Request__c> idassert1= [SELECT id from Request__c];
        //Assert that there is still only one request after cloneWithItems() method since it's status is neither approved or rejected and will not go through with cloning
        system.assertEquals(1,idassert1.size());
    }
    
    @isTest static void RequestDeepCloneControllerApprovedTest(){
        
         Test.startTest();
        
        
        PageReference pageRef = Page.RequestDeepClone;
        Test.setCurrentPageReference(pageRef);
        
        Id recId = [SELECT Id, Name FROM RecordType WHERE SobjectType = 'Account' and Name = 'Commercial Customer'].id;
        Account acc = new Account(Name='Test Account', Type = 'Dealer', RecordTypeId = recId, Business__c = 'US' );
        
        insert acc;
        RequestLineItem__c rli = new RequestLineItem__c();
        Request__c req = new Request__c(Account__c = acc.id, Status__c = 'Rejected');
        system.debug(req);
        insert req;
         Request__c req2 = new Request__c(Account__c = acc.id, Status__c = 'Draft');
        
        insert req2;
        List<RequestLineItem__c> reqlist = new List<RequestLineItem__c>();
        
        reqlist.add(new RequestLineItem__c(Field_Name__c = 'Vat__c', Existing_Value__c='123', New_Value__c='456', Status__c='Approved', Request__c = req.id));
        reqlist.add(new RequestLineItem__c(Field_Name__c = 'Brand__c', Existing_Value__c='Old Brand', New_Value__c='New Brand', Status__c='Approved', Request__c = req.id));
        reqlist.add(new RequestLineItem__c(Field_Name__c = 'Legal_Name__c', Existing_Value__c='Old Name', New_Value__c='New Name', Status__c='Approved', Request__c = req.id));
        
        insert reqlist;
        
       
        Approval.ProcessSubmitRequest procReq = new Approval.ProcessSubmitRequest();
        procReq.setComments('Approve.');
        procReq.setNextApproverIds(new Id[] {UserInfo.getUserId()});
        procReq.setObjectId(req2.Id);

        Approval.ProcessResult result = Approval.process(procReq);
        Request__c status  = [SELECT Status__c FROM Request__c WHERE id = : req2.id];
        system.debug('OUTPUT ====== '+ status.status__c);
        status.Status__c = 'Approved';
        update status;
        
        System.assert(result.isSuccess());
            
        System.assertEquals(
        'Pending', result.getInstanceStatus(),
        'Instance Status'+result.getInstanceStatus());
        
        List<RequestLineItem__c> reqlist2 = new List<RequestLineItem__c>();
        
        reqlist2.add(new RequestLineItem__c(Field_Name__c = 'Vat__c', Existing_Value__c='123', New_Value__c='456', Status__c='Approved', Request__c = req2.id));
        reqlist2.add(new RequestLineItem__c(Field_Name__c = 'Brand__c', Existing_Value__c='Old Brand', New_Value__c='New Brand', Status__c='Approved', Request__c = req2.id));
        reqlist2.add(new RequestLineItem__c(Field_Name__c = 'Legal_Name__c', Existing_Value__c='Old Name', New_Value__c='New Name', Status__c='Approved', Request__c = req2.id));
        
        insert reqlist2;
         
        
        ApexPages.currentPage().getParameters().put('id',req2.id);
        ApexPages.StandardController stndCont = new ApexPages.StandardController(req2);
        RequestDeepCloneController extension = new RequestDeepCloneController(stndCont);
        //Assert that there are two records before cloning
        List<Request__c> idassert= [SELECT id from Request__c];
        system.assertEquals(2,idassert.size());
       
        extension.cloneWithItems();
        
        
        Test.stopTest();
        String status2  = [SELECT Status__c FROM Request__c WHERE id = : req2.id].Status__c;
        system.debug('OUTPUT ====== '+ status2);
        extension.cloneWithItems();
        
        //Assert that there are 4 records after cloning successfully
        List<Request__c> idassert2= [SELECT id from Request__c];
        system.assertEquals(4,idassert2.size());
       
        
    }
    
        @isTest static void RequestDeepCloneControllerFailTest(){
        
         Test.startTest();
        
        
        PageReference pageRef = Page.RequestDeepClone;
        Test.setCurrentPageReference(pageRef);
        
        Id recId = [SELECT Id, Name FROM RecordType WHERE SobjectType = 'Account' and Name = 'Commercial Customer'].id;
        Account acc = new Account(Name='Test Account', Type = 'Dealer', RecordTypeId = recId, Business__c = 'US' );
        
        insert acc;
        RequestLineItem__c rli = new RequestLineItem__c();
        Request__c req = new Request__c(Account__c = acc.id, Status__c = 'Rejected');
        system.debug(req);
        insert req;
         Request__c req2 = new Request__c(Account__c = acc.id, Status__c = 'Draft');
        
        insert req2;
        List<RequestLineItem__c> reqlist = new List<RequestLineItem__c>();
        
        reqlist.add(new RequestLineItem__c(Field_Name__c = 'Vat__c', Existing_Value__c='123', New_Value__c='456', Status__c='Approved', Request__c = req.id));
        reqlist.add(new RequestLineItem__c(Field_Name__c = 'Brand__c', Existing_Value__c='Old Brand', New_Value__c='New Brand', Status__c='Approved', Request__c = req.id));
        reqlist.add(new RequestLineItem__c(Field_Name__c = 'Legal_Name__c', Existing_Value__c='Old Name', New_Value__c='New Name', Status__c='Approved', Request__c = req.id));
        
        insert reqlist;
        
       
        Approval.ProcessSubmitRequest procReq = new Approval.ProcessSubmitRequest();
        procReq.setComments('Approve.');
        procReq.setNextApproverIds(new Id[] {UserInfo.getUserId()});
        procReq.setObjectId(req2.Id);

        Approval.ProcessResult result = Approval.process(procReq);
        Request__c status  = [SELECT Status__c FROM Request__c WHERE id = : req2.id];
        system.debug('OUTPUT ====== '+ status.status__c);
        status.Status__c = 'Approved';
        update status;
        
        System.assert(result.isSuccess());
            
        System.assertEquals(
        'Pending', result.getInstanceStatus(),
        'Instance Status'+result.getInstanceStatus());
        
        List<RequestLineItem__c> reqlist2 = new List<RequestLineItem__c>();
        
        reqlist2.add(new RequestLineItem__c(Field_Name__c = 'Vat__c', Existing_Value__c='123', New_Value__c='456', Status__c='Approved', Request__c = req2.id));
        reqlist2.add(new RequestLineItem__c(Field_Name__c = 'Brand__c', Existing_Value__c='Old Brand', New_Value__c='New Brand', Status__c='Approved', Request__c = req2.id));
        reqlist2.add(new RequestLineItem__c(Field_Name__c = 'Legal_Name__c', Existing_Value__c='Old Name', New_Value__c='New Name', Status__c='Approved', Request__c = req2.id));
        
        insert reqlist2;
         
        
        ApexPages.currentPage().getParameters().put('id',req2.id);
        ApexPages.StandardController stndCont = new ApexPages.StandardController(req2);
        RequestDeepCloneController extension = new RequestDeepCloneController(stndCont);
        
        List<Request__c> idassert= [SELECT id from Request__c];
        
        system.assertEquals(2,idassert.size());
        try{
            delete req2;
       
        extension.cloneWithItems();
        
        
        Test.stopTest();
        String status2  = [SELECT Status__c FROM Request__c WHERE id = : req2.id].Status__c;
        system.debug('OUTPUT ====== '+ status2);
        extension.cloneWithItems();
        
        }catch(exception e){
            
        }
        
        }
    
}