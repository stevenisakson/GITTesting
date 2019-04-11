@istest
public class CresTargetLookUpCtrlTest {
    
    public static testmethod void fetchLookUpValuesTest(){
        target__c t = new target__c();    
        t.Name = 'DAIRY:BARASAT HQ'; 
        t.Employee_Link_To__c=UserInfo.getUserId();
        
        insert t;
        
         Target__c tar = [select Id,Name,Employee_Link_To__c from Target__c where Name =: 'DAIRY:BARASAT HQ'];
        
        CresTargetLookUpCtrl.fetchLookUpValues('DAIRY','Target__c');

    }
    
}