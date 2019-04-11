@isTest
private class NewRebateRequestShipToController_Test {
    
    @testSetup static void setupRecords() {
        
        Id accRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Standard').getRecordTypeId();
        
        List<Account> accList = new List<Account>();
        for(Integer i = 0; i < 10; i++){
            accList.add(new Account(Name = 'Test ' + i));
        }
        insert accList;
        
    }

	private static testMethod void testMethod1() {
        PageReference pg = Page.NewRebateRequestShipTo;
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
        
        ApexPages.StandardController sc = new ApexPages.StandardController(rebateRequestShipTo);
        ApexPages.currentPage().getParameters().put(Label.Account_ID_Object, acc.Id);
        NewRebateRequestShipToController controller = new NewRebateRequestShipToController(sc);
        
        controller.redirectToNewRebate();
        
        
	}

}