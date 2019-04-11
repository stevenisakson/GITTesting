@isTest
private class RebateApprovalTemplate_Test {

    @testSetup static void setupRecords() {
            
            Id accRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Standard').getRecordTypeId();
            
            List<Account> accList = new List<Account>();
            for(Integer i = 0; i < 10; i++){
                accList.add(new Account(Name = 'Test ' + i));
            }
            insert accList;
            
        }

    private static testMethod void testMethod1() {
        Id rebateId ;
        Set<Id> pIds;
        Set<Id> pInstanceWorkitems;
        Account acc = [Select Id,BillingStreet,BillingCity,BillingCountry FROM Account WHERE Name = 'Test 1' LIMIT 1];
       
        
        String orgId = UserInfo.getOrganizationId();
        String dateString = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');
       
        Profile profileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1];
        Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));
        String uniqueName = orgId + dateString + randomInt;
        User Manager = new User(  firstname = 'Test',
                                lastName = 'Test',
                                email = uniqueName + '@test' + orgId + '.org',
                                Username = uniqueName + '@test' + orgId + '.org',
                                EmailEncodingKey = 'ISO-8859-1',
                                Alias = uniqueName.substring(18, 23),
                                TimeZoneSidKey = 'America/Los_Angeles',
                                LocaleSidKey = 'en_US',
                                LanguageLocaleKey = 'en_US',
                                ProfileId = profileId.id);
        insert Manager;
        
        
        User Testusr = new User(  firstname = 'Test1',
                                lastName = 'Test2',
                                email = uniqueName + '@test' + orgId + '.org',
                                Username = uniqueName+ '1@test' + orgId + '.org',
                                EmailEncodingKey = 'ISO-8859-1',
                                Alias = uniqueName.substring(18, 23),
                                TimeZoneSidKey = 'America/Los_Angeles',
                                LocaleSidKey = 'en_US',
                                LanguageLocaleKey = 'en_US',
                                ManagerId = Manager.id,
                                ProfileId = profileId.id );
         insert Testusr;
        
        CAR_RebateReqs__c rebateRequest = new CAR_RebateReqs__c(CAR_Account__c = acc.Id, Valid_From__c = System.today(),CAR_Status__c = 'Draft',ownerId =Testusr.id );
        insert rebateRequest;
        system.debug('*********rebateRequest'+rebateRequest);
        
        Rebate_Request_Line__c rebateRequestLine = new Rebate_Request_Line__c(CAR_Rebate_Request__c = rebateRequest.Id, Discount_Percentage__c = 120, apply_logistic_discounts__c = true);
        insert rebateRequestLine;
        
        Rebate_Request_Line__c rebateRequestLine2 = new Rebate_Request_Line__c(CAR_Rebate_Request__c = rebateRequest.Id, Product__c = 'Test Product', apply_logistic_discounts__c = true, Discount_Percentage__c = 120);
        insert rebateRequestLine2;
        
        Account_Rebate__c rebateRequestShipTo = new Account_Rebate__c(Account__c = acc.Id, Rebate_Request__c = rebateRequest.Id);
        insert rebateRequestShipTo;
        
        
        
        // Submit the approval request for the account
      
        system.runas(Testusr){
        string id=Testusr.id;
        RebateApprovalTemplate.wrapper obj =new RebateApprovalTemplate.wrapper('draft',id,'Ashok',null,'Test');
        obj.Status='draft';
        obj.AssignedTo=id;
        obj.ActualApprover='draft';
        obj.ApprovedDATE=null;
        obj.Comments='draft';
        
        Approval.ProcessSubmitRequest app = new Approval.ProcessSubmitrequest();
        app.setComments('Submitting request for approval.');
        app.setSubmitterId(Testusr.id);
        app.setObjectId(rebateRequest.id);
        app.setProcessDefinitionNameOrId('Rebate_Approval_Process');
        app.setSkipEntryCriteria(true);
        Approval.ProcessResult result = Approval.process(app);
        
        system.debug('*********result'+result);
        
        Approval.ProcessWorkitemRequest req2 = new Approval.ProcessWorkitemRequest();
        req2.setComments('Approving request.');
        req2.setAction('Approve'); //This is the action that is approve in your case, you can set it to Reject also
        req2.setNextApproverIds(new Id[] {UserInfo.getUserId()});
        
        // Use the ID from the newly created item to specify the item to be worked  
        Id workItemId = rebateRequest.id;
        req2.setWorkitemId(workItemId);
        
        // Submit the request for approval  
        try{
        Approval.ProcessResult result2 =  Approval.process(req2);}
        catch(Exception ex){}
        
            
        RebateApprovalTemplate controller = new RebateApprovalTemplate();
        rebateId = rebateRequest.id;
        controller.getlines();
        controller.getshiptos();
        controller.getRebateApproval();
        controller.fakeMethod();
        PageReference myPage = new Pagereference('/apex/RebateShiptos?');
        Test.setCurrentPage(myPage); }       
    }

}