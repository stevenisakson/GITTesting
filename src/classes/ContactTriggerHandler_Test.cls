@isTest  
private class ContactTriggerHandler_Test {
    
    @testSetup static void setupRecords() {
        
        Id accRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Standard').getRecordTypeId();
        
        User usr = TestDataBuilder.createUser(1, TestDataBuilder.getUserProfileId('System Administrator') );
        insert usr;
        TestDataBuilder.createApproval_Process_Settings();
         Trigger_Settings__c ts = new Trigger_Settings__c(Contact__c = true);
        insert ts;
        
        System.runAs(usr){
            List<Account> accList = new List<Account>();
            //for(Integer i = 0; i < 10; i++){
                accList.add(new Account(Name = 'Test_1'));
                accList.add(new Account(Name = 'Test_2'));
            //}
            insert accList;
        }
        
    }
    
    private static testMethod void testMethod1() {
        
        User usr = [Select Id,Business_Unit__c From User Where Profile.Name = 'System Administrator' and IsActive= True Limit 1];

        System.runAs(usr){
            Account acct = [SELECT Id FROM Account WHERE Name = 'Test_1' limit 1];
            Contact con = TestDataBuilder.createContact(acct.Id, 1);
            insert con;
            Account acct1 = [SELECT Id FROM Account WHERE Name = 'Test_2' limit 1];
            con.Phone='123456789';
            con.AccountId=acct1.Id;
            update con;
            delete con;
            
            //Contact con2 = [SELECT Business_Unit__c,Id from Contact where Id = :con.Id];
            //system.assertEquals(con2.Business_Unit__c, usr.Business_Unit__c);
            
        }
    }

}