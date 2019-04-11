@isTest
public class Cres_PlanningMonthTrigger_Test {
    
    public static Map<Integer,String> indexMonthMap=new Map<Integer,String>{1=>'January',
        2=>'February',3=>'March',4=>'April',5=>'May',6=>'June',7=>'July',8=>'August',9=>'September',10=>'October',
        11=>'November',12=>'December'};
            
            public static testmethod void testpopulatePlanMonthOnInsert() {
                String RSM_Territory='AH-DAIRY-RSM KOLKATA DAIRY';
                String ASM_Territory='AH-DAIRY-ASM BARASAT DAIRY';
                String VSA_Territory='AH-DAIRY:BARASAT HQ';
                User rsm=addTerritoryUser('RSM',RSM_Territory,'example1@user.com','example1user@email.com');
                Id rsmTargetId=insertTarget(rsm.Id,RSM_Territory);
                
                User asm=addTerritoryUser('ASM',ASM_Territory,'example2@user.com','example2user@email.com');
                Id asmTargetId=insertTarget(asm.Id,ASM_Territory);
                
                User vsa=addTerritoryUser('VSA',VSA_Territory,'example3@user.com','example3user@email.com');
                Id targetId=insertTarget(vsa.Id,VSA_Territory);
                
                System.runAs(vsa){
                    insertPlanMonth(targetId);
                    
                }
                System.runAs(asm){
                    insertPlanMonth(asmTargetId);
                }
                System.runAs(rsm){
                    insertPlanMonth(rsmTargetId);
                    
                }
                
                
            }        
    
    public static testmethod void testPopulateUniqueKeysOnInsert(){
      
        String VSA_Territory='AH-DAIRY:BARASAT HQ';
      
        User vsa=addTerritoryUser('VSA',VSA_Territory,'example3@user.com','example3user@email.com');
        Id targetId=insertTarget(vsa.Id,VSA_Territory);
        
        System.runAs(vsa){
             Planning_Month__c plm=insertPlanMonth(targetId);
             Route__c rt=new Route__c(Name='RRR01');
             insert rt;
             insertPlanDay(plm.Id,'Customer Visit','Customer Visit',Date.today(),rt.Id,null);
        }
    }
     public static testmethod void testPopulateUniqueKeysOnUpdate(){
      
        String VSA_Territory='AH-DAIRY:BARASAT HQ';
      
        User vsa=addTerritoryUser('VSA',VSA_Territory,'example3@user.com','example3user@email.com');
        Id targetId=insertTarget(vsa.Id,VSA_Territory);
        
        System.runAs(vsa){
             Planning_Month__c plm=insertPlanMonth(targetId);
             Route__c rt=new Route__c(Name='RRR01');
             insert rt;
             Route__c rt2=new Route__c(Name='RRR02');
             insert rt2;
            
             Planning_Month__c pd=insertPlanDay(plm.Id,'Customer Visit','Customer Visit',Date.today(),rt.Id,null);
             pd.Route__c=rt2.Id;
             update pd;
            
             
        }
    }
    
     public static testmethod void testCreateHolidayRecordsOnInsert(){
      
        String VSA_Territory='AH-DAIRY:BARASAT HQ';
      
        User vsa=addTerritoryUser('VSA',VSA_Territory,'example3@user.com','example3user@email.com');
        Id targetId=insertTarget(vsa.Id,VSA_Territory);
        
        System.runAs(vsa){
             Planning_Month__c plm=insertPlanMonth(targetId);
             Route__c rt=new Route__c(Name='RRR01');
             insert rt;
             Date todayD=Date.today();
             insertPlanDay(plm.Id,'Leave','Leave',Date.newInstance(todayD.year(),todayD.month(),1),
                           null,Date.newInstance(todayD.year(),todayD.month(),5));
        }
    }
    
    public static testmethod void testvalidateApprovers() {
        String RSM_Territory='AH-DAIRY-RSM KOLKATA DAIRY';
        String ASM_Territory='AH-DAIRY-ASM BARASAT DAIRY';
        String VSA_Territory='AH-DAIRY:BARASAT HQ';
        User rsm=addTerritoryUser('RSM',RSM_Territory,'example1@user.com','example1user@email.com');
        Id rsmTargetId=insertTarget(rsm.Id,RSM_Territory);
        
        User asm=addTerritoryUser('ASM',ASM_Territory,'example2@user.com','example2user@email.com');
        Id asmTargetId=insertTarget(asm.Id,ASM_Territory);
        
        User vsa=addTerritoryUser('VSA',VSA_Territory,'example3@user.com','example3user@email.com');
        Id targetId=insertTarget(vsa.Id,VSA_Territory);
        
        System.runAs(vsa){
            Planning_Month__c plm=insertPlanMonth(targetId);
            plm.Approver_1__c=UserInfo.getUserId();
            try{
                update plm;
            }catch(DMLException e){
                
            }
            plm.Approver_2__c=UserInfo.getUserId();
            try{
                update plm;
            }catch(DMLException e){
                
            }
        }
        System.runAs(asm){
            Planning_Month__c plm=insertPlanMonth(asmTargetId);
            plm.Approver_1__c=UserInfo.getUserId();
            try{
                update plm;
            }catch(DMLException e){
                
            }
            plm.Approver_2__c=UserInfo.getUserId();
            try{
                update plm;
            }catch(DMLException e){
                
            }
        }
        System.runAs(rsm){
            Planning_Month__c plm =insertPlanMonth(rsmTargetId);
            plm.Approver_1__c=UserInfo.getUserId();
            try{
                update plm;
            }catch(DMLException e){
                
            }
            plm.Approver_2__c=UserInfo.getUserId();
            try{
                update plm;
            }catch(DMLException e){
                
            }
        }
        
        
    }        
    
    
    public static User addTerritoryUser(String userType,String TerritoryName,String userName,String userEmail){
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        
        user u = new user(alias = 'stantt', Email=userEmail, 
                          EmailEncodingKey='UTF-8', LastName='Testing1', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id,User_Type__c=userType, 
                          TimeZoneSidKey='America/Los_Angeles', UserName=userName);  
        insert u; 
        Userterritory2Association ua = new Userterritory2Association(); 
        ua.UserId = u.id;  
        
        ua.Territory2Id =[select id from territory2 where Name =:TerritoryName limit 1].id;
        
        return u;
    }
    public static Planning_Month__c insertPlanMonth(Id TargetId){
        Id RecordTypeIdplanday = Schema.SObjectType.Planning_Month__c.getRecordTypeInfosByName().get('Plan Month').getRecordTypeId();  
        Planning_Month__c pk = new Planning_Month__c(); 
        pk.RecordtypeId = RecordTypeIdplanday;
        pk.Name = 'testplanmonth';  
        pk.target__c = TargetId;
        pk.Month_Planned__c = indexMonthMap.get(Date.today().month());
        pk.Plan_Year__c = String.valueOf(Date.today().year());
        insert pk;
        return pk;
    }
    public static Planning_Month__c insertPlanDay(Id planMonthId,String firstHalf,String secondHalf,Date startDate,Id routeId,Date endDate){
        Id RecordTypeIdplanmonth = Schema.SObjectType.Planning_Month__c.getRecordTypeInfosByName().get('Plan Day').getRecordTypeId();  
        Planning_Month__c pm = new Planning_Month__c(); 
        pm.RecordtypeId = RecordTypeIdplanmonth;
        
        pm.target__c = null;   
        pm.Related_Planning_Month__c=planMonthId;
        pm.Plan_Date__c = startDate;
        pm.Activity_End_Date__c =endDate; 
        pm.First_Half__c = firstHalf;
        pm.Second_Half__c = secondHalf;
        pm.Route__c=routeId;
        insert pm;  
        return pm;
    }
    public static Id insertTarget(String UserId,String TerritoryName){
        target__c t = new target__c();    
        t.Name = 'test1'; 
        t.Territory_Id__c =[select id from territory2 where Name =:TerritoryName limit 1].id; 
        t.Employee_Link_To__c = UserId;
        
        
        insert t;
        return t.Id;
    }
    
}