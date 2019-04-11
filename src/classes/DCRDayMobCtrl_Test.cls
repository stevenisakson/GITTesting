@isTest
public class DCRDayMobCtrl_Test {
 
    public static Map<Integer,String> indexMonthMap=new Map<Integer,String>{1=>'January',
        2=>'February',3=>'March',4=>'April',5=>'May',6=>'June',7=>'July',8=>'August',9=>'September',10=>'October',
        11=>'November',12=>'December'};
    public static testmethod void testGetDCRRecordMob(){
        
        Test.startTest();
        date datefield = Date.today();                   
        Integer numberOfDays = Date.daysInMonth(dateField.year(), dateField.month());
        Date lastDayOfMonth = Date.newInstance(dateField.year(), dateField.month(), numberOfDays);
        
        target__c t = new target__c();    
        t.Name = 'DAIRY:BARASAT HQ'; 
        t.Employee_Link_To__c=UserInfo.getUserId();
        t.OwnerId = UserInfo.getUserId();
        insert t;
        Id routeRecordType = Schema.SObjectType.Route__c.getRecordTypeInfosByName().get('Route').getRecordTypeId(); 
        Route__c rt=new Route__c(Name='R001',recordTypeId=routeRecordType,	Territory__c=t.Id);
        insert rt;
       
        Account acc=new Account(Name='testRouteCustomer');
        insert acc;
       
        
        Trigger_Settings__c tset=new Trigger_Settings__c(SetupOwnerId=UserInfo.getProfileId(),DCRDay__c=true);
        insert tset;
     

        Id RecordTypeIdplanday = Schema.SObjectType.Planning_Month__c.getRecordTypeInfosByName().get('Plan Month').getRecordTypeId();  
        Planning_Month__c pk = new Planning_Month__c(); 
        pk.RecordtypeId = RecordTypeIdplanday;
        pk.Name = 'testplanmonth';  
        pk.target__c = t.id;
        pk.Month_Planned__c = indexMonthMap.get(datefield.month());
        pk.Plan_Year__c =String.valueOf(Date.today().year());
        
        pk.Status__c = 'Approved'; 
        insert pk;
        
              
        Id dcrId=insertDCRRecord('Group Meeting','Group Meeting',datefield,t.Id);
      
       
    Id dcrcustomerid = insertDCRCustomerRecord(rt.Id,acc.Id,dcrId);
        
       //DCRDayMobCtrl.getDCRRecordMob(String.valueOf(datefield)+' 00:00:00',String.valueOf(t.Id),'',String.valueOf(acc.Id));
        
        Account testRoute=new Account(Name='testRouteCustomer2');
        insert testRoute;
        
        target__c target2 = new target__c();    
        target2.Name = 'test1213'; 
        target2.Employee_Link_To__c=UserInfo.getUserId();
        
        insert target2;
         
     // DCRDayMobCtrl_Test ob = new DCRDayMobCtrl_Test();  
    //    ob.hasApprovedPlanMonth(String.valueOf(datefield),String.valueOf(t.OwnerId));
        
       DCRDayMobCtrl.hasApprovedPlanMonth(String.valueOf(datefield),String.valueOf(t.OwnerId));
       DCRDayMobCtrl.hasDCRUNlockAccess(); 
       DCRDayMobCtrl.getDCRRecord(dcrId);
       DCRDayMobCtrl.completeDCR(dcrId); 
       DCRDayMobCtrl.getDCRCustomerRecord(dcrId); 
       DCRDayMobCtrl.getAllConfigValues(); 
       DCRDayMobCtrl.searchDCRMob(String.valueOf(datefield),t.id,String.valueOf(t.OwnerId)); 
       DCRDayMobCtrl.getDCRCustomer(dcrcustomerid);       
       DCRDayMobCtrl.getDCRWrapper(dcrId); 
       DCRDayMobCtrl.getStatus(); 
       DCRDayMobCtrl.unlockDCR(dcrId);
     //   DCRDayMobCtrl.getDCRRecordMob(String.valueOf(datefield)+' 00:00:00',String.valueOf(target2.Id),'',String.valueOf(testRoute.Id));
     //   DCRDayMobCtrl.getDCRRecordMob(String.valueOf(datefield-4)+' 00:00:00',String.valueOf(target2.Id),'',String.valueOf(testRoute.Id));
        
    //    DCRDayMobCtrl.getDCRRecordMob(null,null,'',String.valueOf(testRoute.Id));
        
   //     DCRDayMobCtrl.getDCRRecordMob(String.valueOf(datefield-65)+' 00:00:00',String.valueOf(t.Id),'',String.valueOf(acc.Id));
        Test.stopTest();
    }
    
    public static Id insertDCRRecord(String fHalf,String sHalf,Date activityDate,Id targetId){
        Id RecordTypeIdDcrday = Schema.SObjectType.DCR_Day__c.getRecordTypeInfosByName().get('DCR Day').getRecordTypeId(); 
        DCR_Day__c dd = new DCR_Day__c();  
        dd.RecordTypeId = RecordTypeIdDcrday;  
        
        dd.First_Half__c = fHalf;
        dd.Second_Half__c = sHalf;
        dd.Target__c = targetId;
        dd.Day__c = activityDate;
        dd.OwnerId=UserInfo.getUserId();
        insert dd;
        System.debug('$$DCR'+dd);
        return dd.Id;
      
    }
     public static Id insertDCRCustomerRecord(String Routeid,String AccountId,String dcrId){
        Id RecordTypeIdDcrday = Schema.SObjectType.DCR_Day__c.getRecordTypeInfosByName().get('DCR Customer').getRecordTypeId(); 
        DCR_Day__c dd = new DCR_Day__c();  
        dd.RecordTypeId = RecordTypeIdDcrday;  
        dd.Route__c=RouteId;
        dd.Account__c=AccountId;
        dd.DCR_Day__c=dcrId;
        dd.LOB__c='AH - Dairy';//[select Line_of_Business__c from User where Id=:UserInfo.getUserId()].Line_of_Business__c;
        insert dd;
        return dd.Id;
      
    }
   
}