/**
* Contoller class for Lightning component Cres_PlanningMonth

* @author  Sam Boban

*/
public with sharing class Cres_PlanningMonthCtrl {
    /*Get all the Planning Month Data created by the user */
    @auraenabled
    public static Response getPlanningMonth(){
        DateTime dt = DateTime.now();
        String monthName = dt.format('MMMMM');
        String  currentYear = String.valueOf(System.Today().year());
        List<Planning_Month__c> planCust=new List<Planning_Month__c>();
        Id planMonthRecTypeId=Schema.SObjectType.Planning_Month__c.getRecordTypeInfosByName().get(System.Label.Cres_PlanMonthRecType).getRecordTypeId();
        planCust=[select Name,Territory_Name__c,TerritoryId__c,Month_Planned__c,Plan_Year__c,Status__c,Target__c,Target__r.Name,Target__r.Employee_Link_to__r.Name from Planning_Month__c where /*ownerId=:UserInfo.getUserId()
                  and */RecordTypeId=:planMonthRecTypeId and Plan_Year__c=:currentYear];
        return new Response(true,'SUCCESS',planCust);
        
        
    }
    /*Get single Plan Month record for the given Id*/
    @AuraEnabled
    public static Planning_Month__c getplanmonthdata(String recordid){
        return [ SELECT Id, Territory_Name__c,name,TerritoryId__c,Target__r.Employee_Link_To__c,Target__r.Employee_Link_To__r.Name,Status__c,Approver_1__c,User_Type__c,Approver_2__c,isReadOnly__c,Number_of_Working_Days__c,No_of_days_missed__c,Days_Planned__c
                FROM Planning_Month__c where id=:recordid limit 1
               ];
    }
    /*Get Plan Day records of Given Plan Month*/
    @AuraEnabled
    public static List<Planning_Month__c> getPlanDayList(Id Planmonthid) {
        
        List<Planning_Month__c> plandaytlist = [SELECT Id, Name,Plan_Date__c,Activity_End_Date__c,First_Half__c,Second_Half__c,Plan_Year__c,Comments__c,
                                                Route__c,Route__r.Name,ASM_JFW__c,RSM_JFW__c,VSA_JFW__c,Other_JFW__c FROM Planning_Month__c WHERE Related_Planning_Month__c =:Planmonthid Order by Plan_Date__c ASC ];
        
        return plandaytlist;
    }
     @AuraEnabled
    public static Response savePlanDay(Planning_Month__c planDay) {
        Boolean isSuccess=true;
        String msg='Success';
        try{
            Id planDayRecTypeId=Schema.SObjectType.Planning_Month__c.getRecordTypeInfosByName().get(System.Label.Cres_Plan_DayRecType).getRecordTypeId();
            planDay.RecordTypeId=planDayRecTypeId;
            upsert planDay;
        }catch(DMLException e){
            msg=e.getMessage();
            isSuccess=false;
            if(msg.contains('FIELD_CUSTOM_VALIDATION_EXCEPTION')){
                
                
                msg=msg.substring(msg.indexOf('FIELD_CUSTOM_VALIDATION_EXCEPTION')+'FIELD_CUSTOM_VALIDATION_EXCEPTION'.length()+1);
            }else
                if(msg.contains('DUPLICATES_DETECTED')){
                    msg=msg.substring(msg.indexOf('DUPLICATES_DETECTED')+'DUPLICATES_DETECTED'.length()+1); 
                }
        }
        if(isSuccess){
             return new Response(true,'',true);
        }else{
             return new Response(isSuccess,msg,null);
        }
       
    }

   
    /*Get single Plan day record for the given Id*/
    @AuraEnabled
    public static Planning_Month__c getplandaydata(String recordid){
        return [ SELECT Id, name,VSA_JFW__c,RSM_JFW__c,First_Half__c,Second_Half__c FROM Planning_Month__c where id=:recordid limit 1];
    }
    @AuraEnabled
    public static Response deleteRecord(Id recId){
        System.debug('Delete$$$'+recId);
        Database.DeleteResult rs=Database.delete(recId);
        if(rs.isSuccess()){
            return new Response(true,'SUCCESS',true);
        }else{
            return new Response(false,'SUCCESS',false);
        }
        
    }
    /*Get Route Customers of a Plan Day record*/
    @auraenabled
    public static Response getPlannedCustomerList(String planDayId){
        List<Route__c> planCust=new List<Route__c>();
        if(planDayId!=null){
            planCust=[select id,Account__c,Account__r.name,Active__c,Account_Classification__c from Route__c  where Related_Route__c=:planDayId
                      and Active__c=true];
            return new Response(true,'SUCCESS',planCust);
            
        }else{
            return new Response(false,'Failed-Paramters missing',planCust);
        }
    }
     @AuraEnabled
    public static List<String> getPicklistvalues(String objectName, String field_apiname,Boolean nullRequired){
        List<String> optionlist = new List<String>();
        
        Map<String,Schema.SObjectType> gd = Schema.getGlobalDescribe(); 
        Map<String, Schema.SObjectField> field_map = gd.get(objectName.toLowerCase()).getDescribe().fields.getMap(); 
        
        List<Schema.PicklistEntry> picklistValues = field_map.get(field_apiname).getDescribe().getPickListValues();
        
        if(nullRequired == true){
            optionlist.add('--None--');
        }
        
        for (Schema.PicklistEntry pv : picklistValues) {
            optionlist.add(pv.getValue());
        }
        return optionlist;
    }
}