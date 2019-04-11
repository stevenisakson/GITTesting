@isTest
private class RequestPDFController_Test {
    
    @testSetup static void setupRecords() {
        
        Id accRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Standard').getRecordTypeId();
        
        List<Account> accList = new List<Account>();
        for(Integer i = 0; i < 10; i++){
            accList.add(new Account(Name = 'Test ' + i));
        }
        insert accList;
        
    }

    private static testMethod void testMethod1() {
        PageReference pg = Page.RequestPDF;
        Test.setCurrentPage(pg);
        
        Account acc = [Select Id,BillingStreet,BillingCity,BillingCountry FROM Account WHERE Name = 'Test 1' LIMIT 1];
        Id requestRecTypeId = Schema.SObjectType.Request__c.getRecordTypeInfosByName().get('Prospect Conversion').getRecordTypeId();
        
        Request__c request = new Request__c(Account__c = acc.Id, RecordTypeId = requestRecTypeId);
        insert request;
        
        ApexPages.StandardController sc = new ApexPages.StandardController(request);
        RequestPDFController controller = new RequestPDFController(sc);
        
        
    }

}