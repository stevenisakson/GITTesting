public class DCRTriggerHaldler{
    public void beforeInsert(List<DCR_Day__c> newList){
        //Fetch DCR RecordType Ids
        Id DCRdayRecordTypeId = [Select Id From RecordType 
                                     Where SobjectType = 'DCR_Day__c' AND DeveloperName =: Label.DCR_Day_RecordType].Id;
        Id DCRCustRecordTypeId = [Select Id From RecordType 
                                     Where SobjectType = 'DCR_Day__c' AND DeveloperName =: Label.DCR_Customer_Record_Type].Id;
        set<ID> targetIdset = new set<Id>();
       //Create TargetId set
        for(DCR_Day__c dcr: newList){
            if(String.isNotBlank(String.valueOf(dcr.Day__c)) && String.isNotBlank(String.valueOf(dcr.Target__c)) && DCRdayRecordTypeId.equals(dcr.recordtypeId)){
                targetIdset.add(dcr.Target__c);
            }
            if(String.isNotBlank(String.valueOf(dcr.Route__c)) && String.isNotBlank(String.valueOf(dcr.CustomerDCRDate__c)) && String.isNotBlank(String.valueOf(dcr.CustomerDCRTerrID__c)) && DCRCustRecordTypeId.equals(dcr.recordtypeId)){
                targetIdset.add(dcr.CustomerDCRTerrID__c);
            }
            
        }
        
        
        
        map<id,Target__c> terrIdOwnIdMap = new map<Id,Target__c>([select ID,ownerID,Employee_Link_To__c from Target__c where id in: targetIdset]);
        
        //Stamp Unique Id on DCR Day record and Change Status to In Progress
        for(DCR_Day__c dcr: newList){
            if(String.isNotBlank(String.valueOf(dcr.Day__c)) && String.isNotBlank(String.valueOf(dcr.Target__c)) && DCRdayRecordTypeId.equals(dcr.recordtypeId)){
                dcr.DCR_Unique_Key__c = String.valueOf(dcr.Day__c)+' 00:00:00'+String.valueOf(dcr.Target__c) + terrIdOwnIdMap.get(dcr.Target__c).Employee_Link_To__c;
                system.debug('Inside before insert DCR handler');
                dcr.Status__c = Label.DCR_InProgressStatus;
                dcr.CreatedDateCustom__c = dcr.Day__c;
                dcr.ownerid = terrIdOwnIdMap.get(dcr.Target__c).Employee_Link_To__c;
            }
            if(String.isNotBlank(String.valueOf(dcr.Route__c)) && String.isNotBlank(String.valueOf(dcr.CustomerDCRDate__c)) && String.isNotBlank(String.valueOf(dcr.CustomerDCRTerrID__c)) && DCRCustRecordTypeId.equals(dcr.recordtypeId)){
                dcr.DCR_Unique_Key__c = String.valueOf(dcr.CustomerDCRDate__c)+String.valueOf(dcr.Route__c)+String.valueOf(dcr.Account__c)+String.valueOf(dcr.CustomerDCRTerrID__c)+terrIdOwnIdMap.get(dcr.CustomerDCRTerrID__c).Employee_Link_To__c;
            }
            
         }
    }
        public void beforeUpdate(List<DCR_Day__c> newList){
        //Fetch DCR RecordType Ids
        Id DCRdayRecordTypeId = [Select Id From RecordType 
                                     Where SobjectType = 'DCR_Day__c' AND DeveloperName =: Label.DCR_Day_RecordType].Id;
        Id DCRCustRecordTypeId = [Select Id From RecordType 
                                     Where SobjectType = 'DCR_Day__c' AND DeveloperName =: Label.DCR_Customer_Record_Type].Id;
        //Stamp Unique Id on DCR Day record
        for(DCR_Day__c dcr: newList){
            if(String.isNotBlank(String.valueOf(dcr.Day__c)) && String.isNotBlank(String.valueOf(dcr.Target__c)) && DCRdayRecordTypeId.equals(dcr.recordtypeId)){
                dcr.DCR_Unique_Key__c = String.valueOf(dcr.Day__c)+' 00:00:00'+String.valueOf(dcr.Target__c)+dcr.ownerId;
                
            }
            if(String.isNotBlank(String.valueOf(dcr.Route__c)) && String.isNotBlank(String.valueOf(dcr.CustomerDCRDate__c)) && String.isNotBlank(String.valueOf(dcr.CustomerDCRTerrID__c)) && DCRCustRecordTypeId.equals(dcr.recordtypeId)){
                dcr.DCR_Unique_Key__c = String.valueOf(dcr.CustomerDCRDate__c)+String.valueOf(dcr.Route__c)+String.valueOf(dcr.Account__c)+String.valueOf(dcr.CustomerDCRTerrID__c)+dcr.ownerId;
            }
        }
    }
    public void afterInsert(Map<id,DCR_Day__c> newDCRMap){
       
       //Fetch DCR RecordType Ids
        Id DCRdayRecordTypeId = [Select Id From RecordType 
                                     Where SobjectType = 'DCR_Day__c' AND DeveloperName =: Label.DCR_Day_RecordType].Id;
        Id DCRdayCustomerRecordTypeId = [Select Id From RecordType 
                                             Where SobjectType = 'DCR_Day__c' AND DeveloperName =: Label.DCR_Customer_Record_Type].Id;
        Id planDayRecTypeId=Schema.SObjectType.Planning_Month__c.getRecordTypeInfosByName().get(System.Label.Cres_Plan_DayRecType).getRecordTypeId();
        system.debug('plan day record type id is ##'+planDayRecTypeId);
        // DCR new Map       
          Map<Id,DCR_Day__c> DCRNewMap = new Map<Id,DCR_Day__c>();
        //  List<DCR_Day__c> insrtDCRCustList = new List<DCR_Day__c>();
         system.debug('outside'); 
        
       //Creating RouteId Set
       set<Id> routeIdset = new set<Id>();
       set<Id> dcrOwnerIdset = new set<Id>();
       set<Date> dcrDateset = new set<Date>();
  
       for(DCR_Day__c dcr : newDCRMap.values())
       {
           if(dcr.Route__c != null && DCRdayCustomerRecordTypeId.equals(dcr.recordtypeId))
           {	
               system.debug('inside 1');
               routeIdset.add(dcr.Route__c);
               DCRNewMap.put(dcr.Id,dcr);
               dcrOwnerIdset.add(dcr.OwnerId);
               dcrDateset.add(dcr.ParentDCRDate__c);
           }
        }
        system.debug('Owner id set'+dcrOwnerIdset);
        system.debug('dcrdateset set'+dcrDateset);
        system.debug('DCR New Map Values'+DCRNewMap);
      
        
        //Stamp Planned Day Functionality*************************************************
        Map<ID,String> uniqueDCRMap = new Map<ID,String>();
        Map<ID,Planning_Month__c> pDayMap = new Map<ID,Planning_Month__c>([select Id,OwnerId,TerritoryId__c,Plan_Date__c from Planning_Month__c where RecordTypeId =: planDayRecTypeId and ownerId in: dcrOwnerIdset and Plan_Date__c in: dcrDateset]);
        system.debug('Plan Map is##'+pDayMap);
        Map<String,Id> OwnerIdmapPlanDay = new Map<String,Id>();
       
        for(Planning_Month__c plm: pDayMap.values()){
            OwnerIdmapPlanDay.put(String.valueOf(plm.Plan_Date__c) + plm.OwnerId + plm.TerritoryId__c, plm.Id);
        }
            
	system.debug('ownerplan map##'+OwnerIdmapPlanDay);        
        List<DCR_Day__c> dcrUpdateList = new List<DCR_Day__c>();
        
        for(DCR_Day__c dcr: DCRNewMap.values()){
            
                uniqueDCRMap.put(dcr.Id,String.valueOf(dcr.ParentDCRDate__c) + dcr.ownerId + dcr.CustomerDCRTerrID__c);
            
        }     
       system.debug('uniqueDCRMap map##'+uniqueDCRMap); 
       
        for(ID dcrID: uniqueDCRMap.keyset()){
            system.debug('Inside for loop');
            string tempValue = uniqueDCRMap.get(dcrID); 
            if(OwnerIdmapPlanDay.containsKey(tempValue)){
             system.debug('Inside ifff');   
                DCR_Day__c day = new DCR_day__c();
                day.Id = dcrID;
                day.Planned_Day__c = OwnerIdmapPlanDay.get(tempValue);
                dcrUpdateList.add(day);
            }
          
        }
        
       If(!dcrUpdateList.isEmpty()){
            update dcrUpdateList;
        }
        
    }   
    
    public void afterUpdate(Map<id,DCR_Day__c> newDCRMap,Map<id,DCR_Day__c> oldDCRMap){
      /* system.debug('inside dcr after update');
       //Fetch DCR RecordType Ids
        Id DCRdayRecordTypeId = [Select Id From RecordType 
                                     Where SobjectType = 'DCR_Day__c' AND DeveloperName =: Label.DCR_Day_RecordType].Id;
        Id DCRdayCustomerRecordTypeId = [Select Id From RecordType 
                                             Where SobjectType = 'DCR_Day__c' AND DeveloperName =: Label.DCR_Customer_Record_Type].Id;
       
        // DCR new Map       
          Map<Id,DCR_Day__c> DCRNewMap = new Map<Id,DCR_Day__c>();
          List<DCR_Day__c> insrtDCRCustList = new List<DCR_Day__c>();
          
       //Creating RouteId Set
       set<Id> routeIdset = new set<Id>();
       set<Id> routeOldIdset = new set<Id>(); 
       system.debug('DCR New Map Values'+newDCRMap.values());
       for(DCR_Day__c dcr : newDCRMap.values())
       {
           if(dcr.Route__c != null && DCRdayRecordTypeId.equals(dcr.recordtypeId) && dcr.Route__c != oldDCRMap.get(dcr.Id).Route__c)
           {	
               system.debug('inside update 1');
               routeIdset.add(dcr.Route__c);
               DCRNewMap.put(dcr.Id,dcr); 
               routeOldIdset.add(oldDCRMap.get(dcr.Id).Route__c);
           }
       }
       if(!routeIdset.isEmpty())
       {
           system.debug('inside update 2');
           Map<id,Route_Customer__c> rtCustMap = new Map<id,Route_Customer__c>([select Id,Account__c,Route__c,Active__c 
                                                                                 From Route_Customer__c 
                                                                                 where Route__c in :routeIdset AND Active__c = TRUE]);   
           
      	   system.debug('DCR New Map Values'+rtCustMap.values());
           //creating new customer list if Route is Changed
           for(DCR_Day__c dc:DCRNewMap.values())
            {
                for(Route_Customer__c rc: rtCustMap.values()){
                     if(dc.Route__c == rc.Route__c){
                         system.debug('inside update 3');
                         DCR_Day__c dcr = new DCR_Day__c();
                         
                         dcr.Account__c = rc.Account__c;
                         dcr.Route__c = rc.Route__c;
                         dcr.RecordTypeId = DCRdayCustomerRecordTypeId;
                         dcr.DCR_Day__c = dc.Id;
                         insrtDCRCustList.add(dcr);
                     }
                }
            } 
       
        }
       
        system.debug('updated insertlist is:'+insrtDCRCustList);
        //Inserting Newly selected Route customer as DCR Customers
        if(!insrtDCRCustList.isEmpty()){
            insert insrtDCRCustList;
        }  
        //Creating list of Customer to be deleteed of old route
        List<DCR_Day__c> delOldCustList = [select id from DCR_Day__c 
                                           where DCR_Day__c in : DCRNewMap.keySet() AND Route__c in : routeOldIdset];
        
        if(!delOldCustList.isempty()){
            delete delOldCustList;
        }
        
        */
        
		Id DCRdayRecordTypeId = [Select Id From RecordType 
                                 Where SobjectType = 'DCR_Day__c' AND DeveloperName =: Label.DCR_Day_RecordType].Id;
        Id DCRdayCustomerRecordTypeId = [Select Id From RecordType 
                                         Where SobjectType = 'DCR_Day__c' AND DeveloperName =: Label.DCR_Customer_Record_Type].Id;        
        
        Map<Id,DCR_Day__c> DCRNewMap = new Map<Id,DCR_Day__c>();
       
        //Creating map of only parent record type records of DCR 
       for(DCR_Day__c dcr : newDCRMap.values())
       {
           if(DCRdayRecordTypeId.equals(dcr.recordtypeId) && !(dcr.First_Half__c.equals('Customer Visit') || dcr.First_Half__c.equals('Group Meeting')) && !(dcr.Second_Half__c.equals('Customer Visit') || dcr.Second_Half__c.equals('Group Meeting')))
           {	
               DCRNewMap.put(dcr.Id,dcr);
           }
       }
       
       List<DCR_Day__c> childDCRList = [select Id from DCR_Day__c 
                                        where recordtypeid =: DCRdayCustomerRecordTypeId and DCR_Day__c in : DCRNewMap.keySet()] ; 
       
        if(!childDCRList.isEmpty()){
            delete childDCRList;
        } 
    }    
}