@istest 
public class Test_DCRDayCtrl {
    public static Map<Integer,String> indexMonthMap=new Map<Integer,String>{1=>'January',
        2=>'February',3=>'March',4=>'April',5=>'May',6=>'June',7=>'July',8=>'August',9=>'September',10=>'October',
        11=>'November',12=>'December'};
            public static testmethod void testGetDCRRecord() 
        {  
            String userRegion=[select Region__c from User where id=:UserInfo.getUserId()].Region__c;
            DCRLockingDays__c dcrSetings = new DCRLockingDays__c(Name=userRegion,Days__c=3);
            insert dcrSetings;
            date datefield = Date.today();                   
            Integer numberOfDays = Date.daysInMonth(dateField.year(), dateField.month());
            Date lastDayOfMonth = Date.newInstance(dateField.year(), dateField.month(), numberOfDays);
            target__c t = new target__c();    
            t.Name = 'test1'; 
            t.Employee_Link_To__c=UserInfo.getUserId();
            insert t;
            
            
            Id RecordTypeIdplanday = Schema.SObjectType.Planning_Month__c.getRecordTypeInfosByName().get('Plan Month').getRecordTypeId();  
            Planning_Month__c pk = new Planning_Month__c(); 
            pk.RecordtypeId = RecordTypeIdplanday;
            pk.Name = 'testplanmonth';  
            pk.target__c = t.id;
            pk.Month_Planned__c = indexMonthMap.get(Date.today().month());
            pk.Plan_Year__c =String.valueOf(Date.today().year());
            
            pk.Status__c = 'Approved'; 
            
            insert pk;   
           
            Id RecordTypeIdplanmonth = Schema.SObjectType.Planning_Month__c.getRecordTypeInfosByName().get('Plan Day').getRecordTypeId();  
            Planning_Month__c pm = new Planning_Month__c(); 
            
            pm.RecordtypeId = RecordTypeIdplanmonth;
           
          
            pm.Related_Planning_Month__c=pk.Id;
            pm.Plan_Date__c = Date.today();          
            
            pm.Activity_End_Date__c = lastDayOfMonth;
            pm.First_Half__c = 'Training'; 
            pm.Second_Half__c = 'Training';
          
            insert pm;  
            
            
            Id RecordTypeIdDcrday = Schema.SObjectType.DCR_Day__c.getRecordTypeInfosByName().get('DCR Day').getRecordTypeId(); 
            DCR_Day__c dd = new DCR_Day__c();  
            dd.RecordTypeId = RecordTypeIdDcrday;  
            
            dd.First_Half__c = 'Training';  
            dd.Second_Half__c = 'Training';  
            dd.Target__c = t.id; 
            dd.Day__c = Date.today();
            insert dd;
            
            string sa = string.valueOf(date.today());
            
            
            DCRDayCtrlV2.finishDCR(dd.id);  
            DCRDayCtrlV2.unlockDCR(dd.Id); 
            DCRDayCtrlV2.hasDCRUNlockAccess(); 
            DCRDayCtrlV2.getDCRCustomerList(dd.Id); 
            DCRDayCtrlV2.getDCRRecord(sa, t.id); 
            DCRDayCtrlV2.getDCRRecord(String.valueOf(Date.today().addDays(-3)), t.id); 
            DCRDayCtrlV2.getDCRRecord(String.valueOf(Date.today().addDays(-2)), t.id); 
            DCRDayCtrlV2.getDCRRecord(String.valueOf(Date.today().addDays(-6)), t.id); 
            DCRDayCtrlV2.deleteRecord(dd.id);
        } 
   public static testmethod void testGetDCRRecordDataSteward() 
    { 
        
        
        
        Profile p = [SELECT Id FROM Profile WHERE Name='Data Steward'];
        
        User u = new User(Alias = 'CPNData', Email='standarduser@testorg.com',
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
                          LocaleSidKey='en_US', ProfileId = p.Id,TimeZoneSidKey='America/Los_Angeles',
                          UserName = 'cpnindian_ds@cognizant.com');
        
        System.runAs(u) { 
            
            
            
            date datefield = Date.today();                   
            Integer numberOfDays = Date.daysInMonth(dateField.year(), dateField.month());
            Date lastDayOfMonth = Date.newInstance(dateField.year(), dateField.month(), numberOfDays);
            target__c t = new target__c();    
            t.Name = 'test1'; 
            
            insert t;
            
            
            Id RecordTypeIdplanday = Schema.SObjectType.Planning_Month__c.getRecordTypeInfosByName().get('Plan Month').getRecordTypeId();  
            Planning_Month__c pk = new Planning_Month__c(); 
            pk.RecordtypeId = RecordTypeIdplanday;
            pk.Name = 'testplanmonth';  
            pk.target__c = t.id;
            pk.Month_Planned__c = indexMonthMap.get(Date.today().month());
            pk.Plan_Year__c =String.valueOf(Date.today().year());
            
            
            
            insert pk;   
            
            //pk.Target__c = t.id;
            //pk.Approver_1__c =u.id; 
            
            // update pk;           
            
            
            Id RecordTypeIdplanmonth = Schema.SObjectType.Planning_Month__c.getRecordTypeInfosByName().get('Plan Day').getRecordTypeId();  
            Planning_Month__c pm = new Planning_Month__c(); 
            pm.RecordtypeId = RecordTypeIdplanmonth;
           
            pm.target__c = t.id;   
            pm.Related_Planning_Month__c=pk.Id;
            pm.Plan_Date__c = Date.today();          
            
            pm.Activity_End_Date__c = lastDayOfMonth;
            pm.First_Half__c = 'Training'; 
            pm.Second_Half__c = 'Training';
            
            insert pm;  
            
            
            Id RecordTypeIdDcrday = Schema.SObjectType.DCR_Day__c.getRecordTypeInfosByName().get('DCR Day').getRecordTypeId(); 
            DCR_Day__c dd = new DCR_Day__c();  
            dd.RecordTypeId = RecordTypeIdDcrday;  
            
            dd.First_Half__c = 'Training';  
            dd.Second_Half__c = 'Training';  
            dd.Target__c = t.id; 
            dd.Day__c = Date.today();
            insert dd;
            
            string sa = string.valueOf(date.today());
            
            
            DCRDayCtrlV2.finishDCR(dd.id);  
            DCRDayCtrlV2.unlockDCR(dd.Id); 
            DCRDayCtrlV2.hasDCRUNlockAccess(); 
            DCRDayCtrlV2.getDCRCustomerList(dd.Id); 
            DCRDayCtrlV2.getDCRRecord(sa, t.id); 
            DCRDayCtrlV2.deleteRecord(dd.id);
            
        }
        
    }
    public static testmethod void thirdAnothermethod() 
    { 
        DCRDayCtrlV2.finishDCR(null); 
        DCRDayCtrlV2.unlockDCR(null);   
    }   
     public static testmethod void testgetLoggedInUser() 
    { 
        DCRDayCtrlV2.getLoggedInUser();
          
    }   
    
}