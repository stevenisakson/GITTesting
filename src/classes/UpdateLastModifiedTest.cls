@IsTest
public class UpdateLastModifiedTest {
    public static testmethod void TestAccountProcessorTest() 
    {
        Account a = new Account();
        a.Name = 'Test Account';
        Insert a;

        
        
        set<Id> setAccId = new Set<ID>();
        setAccId.add(a.id);
 
        Test.startTest();
            UpdateLastModified.proccedaccounts(setAccId);
        Test.stopTest();
        
       
  }
  
}