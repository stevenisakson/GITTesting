@istest 
public class testcres_PlanningMonthctrl {
    public static Map<Integer,String> indexMonthMap=new Map<Integer,String>{1=>'January',
        2=>'February',3=>'March',4=>'April',5=>'May',6=>'June',7=>'July',8=>'August',9=>'September',10=>'October',
        11=>'November',12=>'December'};

    @istest public static void testgetplanningmonth() 
    {   
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        
        user u = new user(alias = 'standt', Email='standarduser@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='standarduser@testorg.com');  
        
        Profile pe = [SELECT Id FROM Profile WHERE Name='System Administrator'];  
        
        user ue = new user(alias = 'standt', Email='standarduser@testorg.com', 
                           EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                           LocaleSidKey='en_US', ProfileId = pe.Id, 
                           TimeZoneSidKey='America/Los_Angeles', UserName='standarduser@testorg.com');   
        
        target__c t = new target__c();    
        t.Name = 'test1'; 
        t.Territory_Id__c ='c125328'; 
        t.Employee_Link_To__c = u.id; 
        insert t;
        
        Route__c r = new route__c(Name='testRoute008'); 
        
        r.Territory__c = t.id; 
        insert r; 
         
        Id RecordTypeIdplanday = Schema.SObjectType.Planning_Month__c.getRecordTypeInfosByName().get('Plan Month').getRecordTypeId();  
        Planning_Month__c pk = new Planning_Month__c(); 
        pk.RecordtypeId = RecordTypeIdplanday;
        pk.Name = 'testplanmonth';  
        pk.target__c = t.id;
        pk.Month_Planned__c = indexMonthMap.get(Date.today().month());
        pk.Plan_Year__c = String.valueOf(Date.today().year());
         
        insert pk;
        
        Id RecordTypeIdplanmonth = Schema.SObjectType.Planning_Month__c.getRecordTypeInfosByName().get('Plan Day').getRecordTypeId();  
        Planning_Month__c pm = new Planning_Month__c(); 
        pm.RecordtypeId = RecordTypeIdplanmonth;
        pm.Name = 'testplanmonth'; 
       // pm.Month_Planned__c = 'September'; 
       // pm.Plan_Year__c = '2018'; 
        pm.Status__c = 'Submitted for Approval'; 
        pm.target__c = t.id;   
        pm.First_Half__c = 'Holiday';
        pm.Second_Half__c = 'Holiday'; 
        pm.Plan_Date__c = Date.today();
        //pm.Route__c = r.id; 
        pm.Approver_1__c = ue.id; 
        pm.Related_Planning_Month__c =pk.id;
        
        insert pm; 
        
        List<Planning_Month__c> planCust=new List<Planning_Month__c>();
        planCust.add(pm);
        Cres_PlanningMonthCtrl.getPlanningMonth(); 
        Cres_PlanningMonthCtrl.getPlanDayList(pm.id);  
        Cres_PlanningMonthCtrl.getplanmonthdata(pm.id);
        Cres_PlanningMonthCtrl.deleteRecord(pm.id); 
        Cres_PlanningMonthCtrl.getPlannedCustomerList(pm.id);
        Cres_PlanningMonthCtrl.savePlanDay(pm); 
      //  Cres_PlanningMonthCtrl.getFirstHalfValues(); 
        Cres_PlanningMonthCtrl.getPicklistvalues('Planning_Month__c','Plan_Date__c',true);
    }
}