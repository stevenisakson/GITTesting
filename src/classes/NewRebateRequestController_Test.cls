@isTest
private class NewRebateRequestController_Test {
    
    @testSetup static void setupRecords() {
        
        Id accRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Standard').getRecordTypeId();
        
        List<Account> accList = new List<Account>();
        for(Integer i = 0; i < 10; i++){
            accList.add(new Account(Name = 'Test ' + i));
        }
        insert accList;
        
    }

    private static testMethod void testMethod1() {
        PageReference pg = Page.NewRebateRequest;
        Test.setCurrentPage(pg);
        
        Account acc = [Select Id,BillingStreet,BillingCity,BillingCountry FROM Account WHERE Name = 'Test 1' LIMIT 1];
       
        
        CAR_RebateReqs__c rebateRequest = new CAR_RebateReqs__c(CAR_Account__c = acc.Id, Valid_From__c = System.today());
        insert rebateRequest;
        
        Rebate_Request_Line__c rebateRequestLine = new Rebate_Request_Line__c(CAR_Rebate_Request__c = rebateRequest.Id, Discount_Percentage__c = 120, apply_logistic_discounts__c = true);
        insert rebateRequestLine;
        
        Rebate_Request_Line__c rebateRequestLine2 = new Rebate_Request_Line__c(CAR_Rebate_Request__c = rebateRequest.Id, Product__c = 'Test Product', apply_logistic_discounts__c = true, Discount_Percentage__c = 120);
        insert rebateRequestLine2;
        
        Account_Rebate__c rebateRequestShipTo = new Account_Rebate__c(Account__c = acc.Id, Rebate_Request__c = rebateRequest.Id);
        insert rebateRequestShipTo;
        
        ApexPages.StandardController sc = new ApexPages.StandardController(rebateRequest);
        NewRebateRequestController controller = new NewRebateRequestController(sc);
        
        NewRebateRequestController.accountSelectionWrapper cmp = new NewRebateRequestController.accountSelectionWrapper(acc);
        controller.saveProgress();
        controller.showPopup();
        controller.selectAllchoice = 'true';
        controller.selectShipToOption();
        controller.cancelProgress();
        controller.cloneRecord();
        controller.currentIndex = '2';
        controller.DeleteRebateRequestLine();
        controller.EditRebateRequestLine();
        controller.SaveEditedRebateRequestLine();
        controller.checkConditions();
        controller.addRequestLineView();
        controller.canDeleteInView ='true';
        controller.DeleteRebateRequestLineView();
        controller.submitForApproval();
        controller.trimAddressInfo(acc);
        
        
    }
    
     private static testMethod void testMethod2() {
        PageReference pg = Page.NewRebateRequest;
        Test.setCurrentPage(pg);
        
        Account acc = [Select Id,BillingStreet,BillingCity,BillingCountry FROM Account WHERE Name = 'Test 1' LIMIT 1];
       
        
        CAR_RebateReqs__c rebateRequest = new CAR_RebateReqs__c(CAR_Account__c = acc.Id, Valid_From__c = System.today());
        insert rebateRequest;
        
        Rebate_Request_Line__c rebateRequestLine = new Rebate_Request_Line__c(CAR_Rebate_Request__c = rebateRequest.Id, Discount_Percentage__c = 120, apply_logistic_discounts__c = true);
        insert rebateRequestLine;
        
        Rebate_Request_Line__c rebateRequestLine2 = new Rebate_Request_Line__c(CAR_Rebate_Request__c = rebateRequest.Id, Product__c = 'Test Product', apply_logistic_discounts__c = true, Discount_Percentage__c = 120);
        insert rebateRequestLine2;
        
        Account_Rebate__c rebateRequestShipTo = new Account_Rebate__c(Account__c = acc.Id, Rebate_Request__c = rebateRequest.Id);
        insert rebateRequestShipTo;
        
        ApexPages.StandardController sc = new ApexPages.StandardController(rebateRequest);
        NewRebateRequestController controller = new NewRebateRequestController(sc);
        
        NewRebateRequestController.accountSelectionWrapper cmp = new NewRebateRequestController.accountSelectionWrapper(acc);
        controller.deleteRebateRequestRecord();
      
               
        
    }
    private static testMethod void testMethod3() {
        PageReference pg = Page.NewRebateRequest;
        Test.setCurrentPage(pg);
        
        Account acc = [Select Id,BillingStreet,BillingCity,BillingCountry FROM Account WHERE Name = 'Test 1' LIMIT 1];
       
        Boolean selectedtest = false;
        
        CAR_RebateReqs__c rebateRequest = new CAR_RebateReqs__c(CAR_Account__c = acc.Id, Valid_From__c = System.today());
        insert rebateRequest;
        
        Rebate_Request_Line__c rebateRequestLine = new Rebate_Request_Line__c(CAR_Rebate_Request__c = rebateRequest.Id, Discount_Percentage__c = 120, apply_logistic_discounts__c = true);
        insert rebateRequestLine;
        
        Rebate_Request_Line__c rebateRequestLine2 = new Rebate_Request_Line__c(CAR_Rebate_Request__c = rebateRequest.Id, Product__c = 'Test Product', apply_logistic_discounts__c = true, Discount_Percentage__c = 120);
        insert rebateRequestLine2;
        
        Account_Rebate__c rebateRequestShipTo = new Account_Rebate__c(Account__c = acc.Id, Rebate_Request__c = rebateRequest.Id);
        insert rebateRequestShipTo;
        
        ApexPages.StandardController sc = new ApexPages.StandardController(rebateRequest);
        NewRebateRequestController controller = new NewRebateRequestController(sc);
        
        NewRebateRequestController.accountSelectionWrapper cmp = new NewRebateRequestController.accountSelectionWrapper(acc);
        controller.selectAllchoice = 'false';
        controller.selectShipToOption();
        controller.saveProgress();
               
        
    }
    
    private static testMethod void testAccountSelectionWrapper() {
        NewRebateRequestController.accountSelectionWrapper aw1 = new NewRebateRequestController.accountSelectionWrapper();
        Account a1 = new Account();
        a1.Name = 'ABC';
        aw1.selected = False;
        aw1.acc = a1;
        
        NewRebateRequestController.accountSelectionWrapper aw2 = new NewRebateRequestController.accountSelectionWrapper();
        Account a2 = new Account();
        a2.Name = 'XYZ';
        aw2.acc = a2;
        Object obj = aw2;
        aw1.compareTo(obj);
    }

}