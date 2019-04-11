/*Author:Sam Boban
 * Trigger Handler for PlanningMonth object
*/
public class Cres_PlanMonthTriggerHelper {
    
    public static Map<String,Integer> monthIndexMap=new Map<String,Integer>{'January'=>1,
        'February'=>2,'March'=>3,'April'=>4,'May'=>5,'June'=>6,'July'=>7,'August'=>8,'September'=>9,'October'=>10,
        'November'=>11,'December'=>12};/*Get the Month Index if Month Name is provided*/
            
     /*Method that populates a Unique Fields for Planning Month Object for two record Types on insert.Unique Fields are in used
     for Duplicate Rules*/       
     public static void populateUniqueKeysOnInsert(List<Planning_Month__c> plmList){
      
         Id planDayRecTypeId=Schema.SObjectType.Planning_Month__c.getRecordTypeInfosByName().get(System.Label.Cres_Plan_DayRecType).getRecordTypeId();
         Id planMonthRecTypeId=Schema.SObjectType.Planning_Month__c.getRecordTypeInfosByName().get(System.Label.Cres_PlanMonthRecType).getRecordTypeId();
         for(Planning_Month__c pm:plmList){
             if(pm.RecordTypeId== planDayRecTypeId && pm.Plan_Date__c!=null && pm.TerritoryId__c!=null){
                 
                 pm.Plan_Day_Unique_Key_For_DupRule__c=String.valueOf(pm.Plan_Date__c)+pm.TerritoryId__c+pm.OwnerId;
                 if(pm.Route__c!=null){
                     
                     pm.PlanDay_UniqueKey__c=String.valueOf(pm.Plan_Date__c)+pm.Route__c+pm.TerritoryId__c+pm.OwnerId;
                 }else{
                     pm.PlanDay_UniqueKey__c=String.valueOf(pm.Plan_Date__c)+pm.TerritoryId__c+pm.OwnerId; 
                 }
             }else
                 if(pm.RecordTypeId== planMonthRecTypeId && pm.Plan_Year__c!=null && pm.Month_Planned__c!=null && pm.Target__c!=null){
                     pm.Plan_Month_Unique_Key__c=pm.Plan_Year__c+pm.Month_Planned__c+pm.Target__c+pm.OwnerId;
                 }
         }
         System.debug('$$$PrepopulateList'+plmList);
     }
    /*Method that populates a Unique Fields for Planning Month Object for two record Types on update.Unique Fields are in used
     for Duplicate Rules*/ 
      public static void populateUniqueKeysOnUpdate(List<Planning_Month__c> plmList,Map<Id,Planning_Month__c> oldMap){
      
         Id planDayRecTypeId=Schema.SObjectType.Planning_Month__c.getRecordTypeInfosByName().get(System.Label.Cres_Plan_DayRecType).getRecordTypeId();
         Id planMonthRecTypeId=Schema.SObjectType.Planning_Month__c.getRecordTypeInfosByName().get(System.Label.Cres_PlanMonthRecType).getRecordTypeId();
         for(Planning_Month__c pm:plmList){
             System.debug(pm);
             if(pm.RecordTypeId== planDayRecTypeId && (pm.Plan_Date__c!=oldMap.get(pm.Id).Plan_Date__c || pm.Route__c!=oldMap.get(pm.Id).Route__c) && pm.TerritoryId__c!=null){
                 if(pm.Route__c!=null){
                     
                     pm.PlanDay_UniqueKey__c=String.valueOf(pm.Plan_Date__c)+pm.Route__c+pm.TerritoryId__c+pm.OwnerId;
                 }else{
                     pm.PlanDay_UniqueKey__c=String.valueOf(pm.Plan_Date__c)+pm.TerritoryId__c+pm.OwnerId; 
                 }
             }else
                 if(pm.RecordTypeId== planMonthRecTypeId &&  (pm.Plan_Year__c!=oldMap.get(pm.Id).Plan_Year__c || 
                    pm.Month_Planned__c!=oldMap.get(pm.Id).Month_Planned__c || pm.Target__c!=null || pm.Target__c!=oldMap.get(pm.Id).Target__c || pm.OwnerId!=oldMap.get(pm.Id).ownerId)){
                     pm.Plan_Month_Unique_Key__c=pm.Plan_Year__c+pm.Month_Planned__c+pm.Target__c+pm.OwnerId;
                 }
         }
           System.debug('$$$PrepopulateListUpdate'+plmList);
     } 
    /*Validate the Approvers chosen by the User for Submitting a PlanMonth for Approval*/
    public static void validateApprovers(Map<Id,Planning_Month__c> oldMap,Map<Id,Planning_Month__c> newMap){ 
        system.debug('testoldmap:::'+oldMap.values()); 
        system.debug('testnewmap::::'+newMap.values());
        List<String> ownerIds=new List<String>();
        List<String> targetIds=new List<String>();
        Map<Id,Id> ownerTerIdMap=new Map<Id,Id>();
        Map<Id,Id> parentTerritoryMap=new Map<id,Id>();
        Map<Id,Id> superParentTerritoryMap=new Map<id,Id>();
        Map<Id,Set<Id>> territoryApproverMap=new Map<Id,Set<Id>>();
        Set<Id> approvers=new Set<Id>();
        Set<Id> superapprovers=new Set<Id>();
        List<Planning_Month__c> filteredPlanMonth=new List<Planning_Month__c>();
        /*Filter the records and store the owner Ids*/
        system.debug('planningmonth::::'+newMap.values().size());
        for(Planning_Month__c plm:newMap.values()){ 
            system.debug('planningmonth - old Map:::'+oldMap.get(plm.Id).Approver_1__c); 
            system.debug('planningmonth - New Map:::'+NewMap.get(plm.Id).Approver_1__c); 
            system.debug('planningmonth - old Map2:::'+oldMap.get(plm.Id).Approver_2__c); 
            system.debug('planningmonth - New Map2:::'+NewMap.get(plm.Id).Approver_2__c); 
            
            system.debug('planningmonth - Target:::'+plm.Target__c);  
            system.debug('planningmonth - Approver1:::'+plm.Approver_1__c); 
            /*checks if user  has changed Approver1 and Approver2 field*/
            if(plm.Target__c!=null && (plm.Approver_1__c!=null && oldMap.get(plm.Id).Approver_1__c!=newMap.get(plm.Id).Approver_1__c ) || (plm.Approver_2__c!=null && oldMap.get(plm.Id).Approver_2__c!=newMap.get(plm.Id).Approver_2__c)){
                ownerIds.add(plm.OwnerId);/*Add all OwnerIds*/
                targetIds.add(plm.Target__c);/*Add all Targets(Territory)*/
                filteredPlanMonth.add(plm);/*Filter the records to be processed*/
            }
        }
        System.debug('$$$ownerIds'+ownerIds);
        System.debug('$$$targetIds'+targetIds);
        System.debug('$$$filteredPlanMonth'+filteredPlanMonth);
        /*Build a UserId-(Standard)Territory Map*/
        for(Target__c tar:[select Id,Employee_Link_To__c,Territory_Id__c from Target__c where Id in :targetIds and Employee_Link_To__c in : ownerIds]){
              ownerTerIdMap.put(tar.Employee_Link_To__c,tar.Territory_Id__c);
        }
        System.debug('$$$ownerTerIdMap'+ownerTerIdMap);
        /*Query Standard TerritoryId configured in Salesforce*/
        List<Territory2> territory2List=[SELECT Id,ParentTerritory2Id,ParentTerritory2.ParentTerritory2Id FROM Territory2 where Id in :ownerTerIdMap.values()];
        for(Territory2 ter:territory2List){
            
            if(ter.ParentTerritory2Id!=null){
                /*Build CHild-Parent Territory Id Map*/
                parentTerritoryMap.put(ter.Id,ter.ParentTerritory2Id);
                
            }
            if(ter.ParentTerritory2Id!=null && ter.ParentTerritory2.ParentTerritory2Id!=null){
                /*Build CHild-Super Parent(Parent's Parent) Territory Id Map*/
                superParentTerritoryMap.put(ter.Id,ter.ParentTerritory2.ParentTerritory2Id);
            }
            
        }
        System.debug('$$$parentTerritoryMap'+parentTerritoryMap);
        System.debug('$$$superParentTerritoryMap'+superParentTerritoryMap);
        /*Build Standard Territory-UserId Map*/
        for(UserTerritory2Association uta:[select id,UserId,Territory2Id from UserTerritory2Association where (Territory2Id in : parentTerritoryMap.values() or Territory2Id in : superParentTerritoryMap.values())]){
            if(territoryApproverMap.containsKey(uta.Territory2Id)) {
                territoryApproverMap.get(uta.Territory2Id).add(uta.UserId);
               // territoryApproverMap.put(uta.Territory2Id,uta.UserId);
            }else{
              
                territoryApproverMap.put(uta.Territory2Id,new Set<Id>{uta.UserId});
            }
        }
        System.debug('$$$territoryApproverMap'+territoryApproverMap);
        Map<Id,User> ownerMap=new Map<Id,User>([select id,User_Type__c from User where id in : ownerIds]);
        System.debug('$$$OwnerMap'+ownerMap);
        User owner;
        Id userterId,approver1,approver2,parentTerId,superTerId,approver1UserId,approver2UserId;
        for(Planning_Month__c planMonth:filteredPlanMonth){
            owner=ownerMap.get(planMonth.OwnerId);
            if(owner!=null){
                /*if the User is VSA*/
                if(owner.User_Type__c=='VSA'){
                    userterId=ownerTerIdMap.get(planMonth.OwnerId);
                    /*Get the Parent Territory Id of the User*/
                    parentTerId=parentTerritoryMap.get(userterId);
                    /*Get the Super Parent Territory Id of the User*/
                    superTerId=superParentTerritoryMap.get(userterId);
                    /*Get the Parent Territory User Ids*/
                    approvers=territoryApproverMap.get(parentTerId);
                     /*Get the Super Parent Territory User Ids*/
                    superapprovers=territoryApproverMap.get(superTerId);
                    
                    /*Check if the User selected Approver1 is in the Territory*/
                    System.debug('$$$planMonth.Approver_1__c -approver1UserId'+planMonth.Approver_1__c+'-'+approver1UserId);
                    if(approvers!=null && !approvers.contains(planMonth.Approver_1__c)){
                        planMonth.Approver_1__c.addError(System.Label.Cres_RoutePlan_Incorrect_ASM);
                    }
                    /*Check if the User selected Approver2 is in the Territory*/
                    else if(superapprovers!=null && !superapprovers.contains(planMonth.Approver_2__c)){
                        planMonth.Approver_2__c.addError(System.Label.Cres_RoutePlan_Incorrect_RSM);
                    }
                    /*Check if there is RSM available for the User*/
                    else if(superapprovers==null  && approvers!=null){
                        planMonth.Approver_2__c.addError(System.label.Cres_RoutePlan_NoRSM);
                    }
                    /*Check if there is ASM available for the User*/
                    else if(superapprovers!=null  && approvers==null){
                        planMonth.Approver_1__c.addError(System.label.Cres_RoutePlan_NoASM);
                    }
                    /*check if both ASM and RSM are not present*/
                    else if(superapprovers==null  && approvers==null){
                        planMonth.Approver_2__c.addError(System.label.Cres_RoutePlan_NoASM_RSM);
                    }
                }
                else if(owner.User_Type__c=='ASM'){
                  
                    userterId=ownerTerIdMap.get(planMonth.OwnerId);           
                    parentTerId=parentTerritoryMap.get(userterId);
                    approvers=territoryApproverMap.get(parentTerId);
                    System.debug('$$$planMonth.Approver_1__c -approver1UserId'+planMonth.Approver_1__c+'-'+approver1UserId);  
                    if(approvers!=null && !approvers.contains(planMonth.Approver_2__c)){
                        planMonth.Approver_2__c.addError(System.label.Cres_RoutePlan_RSMIncorrect);
                       // planMonth.Approver_1__c.addError('Please select correct RSM. Both Approver1 and Approver 2 should be same');
                    }
                    else if(approvers!=null && !approvers.contains(planMonth.Approver_1__c)){
                      //  planMonth.Approver_2__c.addError('Please select correct RSM. Both Approver1 and Approver 2 should be same');
                        planMonth.Approver_1__c.addError(System.label.Cres_RoutePlan_RSMIncorrect);
                    }
                    else if(approvers==null){
                        planMonth.Approver_1__c.addError(System.label.Cres_RoutePlan_NoRSM);
                    }
                  
                }
                else if(owner.User_Type__c=='RSM'){
                   
                    userterId=ownerTerIdMap.get(planMonth.OwnerId);           
                    parentTerId=parentTerritoryMap.get(userterId);
                    approvers=territoryApproverMap.get(parentTerId);
                    System.debug('$$$planMonth.Approver_1__c -approver1UserId'+planMonth.Approver_1__c+'-'+approvers); 
                    if(approvers!=null && !approvers.contains(planMonth.Approver_2__c)){
                        planMonth.Approver_2__c.addError(System.label.Cres_RoutePlan_IncorrectBH);
                        //planMonth.Approver_1__c.addError('Please select correct BH. Both Approver1 and Approver 2 should be same');
                    }
                    else if(approvers!=null && !approvers.contains(planMonth.Approver_1__c)){
                       // planMonth.Approver_2__c.addError('Please select correct BH. Both Approver1 and Approver 2 should be same');
                        planMonth.Approver_1__c.addError(System.label.Cres_RoutePlan_IncorrectBH);
                    }
                   /* else if(planMonth.Approver_1__c!=null && planMonth.Approver_2__c!=null && planMonth.Approver_1__c!=planMonth.Approver_2__c){
                          planMonth.Approver_1__c.addError('Both NOTIFICATION and RSM APPROVAL should be same');
                    }*/
                    else if(approvers==null){
                        planMonth.Approver_1__c.addError(System.label.Cres_RoutePlan_NOBH);
                    }
                }
            }
        }
        
    }
    /*Check if the User selected Territory is a Territory that he belong to*/
    public static void validateTerritorySelection(List<Planning_Month__c> pdList){
        List<Planning_Month__c> filteredPMList=new List<Planning_Month__c>();
        Map<Id,Set<Id>> userTerritoryMap=new Map<Id,Set<Id>>();
        List<Id> ownerIdList=new List<Id>();
        Id planMonthRecTypeId=Schema.SObjectType.Planning_Month__c.getRecordTypeInfosByName().get(System.Label.Cres_PlanMonthRecType).getRecordTypeId();
        for(Planning_Month__c pm:pdList){
             if(pm.RecordTypeId==planMonthRecTypeId && pm.Target__c!=null){
                 filteredPMList.add(pm);
                 ownerIdList.add(pm.ownerId);
             }
        }
        for(Target__c tar:[select Id,Employee_Link_To__c,Territory_Id__c from Target__c where Employee_Link_To__c in : ownerIdList]){
            if(userTerritoryMap.containsKey(tar.Employee_Link_To__c)){
                 userTerritoryMap.get(tar.Employee_Link_To__c).add(tar.Id);
            }else{
                userTerritoryMap.put(tar.Employee_Link_To__c,new Set<Id>{tar.Id});
            }
           
        }
        for(Planning_Month__c pm:filteredPMList){
            if(userTerritoryMap.get(pm.OwnerId)!=null && !userTerritoryMap.get(pm.OwnerId).contains(pm.Target__c)){
                pm.Name.addError('Invalid Territory. Please select a Territory you belong to');
            }
        }
        
    }
    
    /*Rolls up Days Planned when Plan Day record is added/deleted*/
    public static void RollupPlandayforMonth(List<Planning_Month__c> pdList, boolean flag){
        
        List<Id> PlanmonthIds = new List<Id>();
        System.debug('$$$pdList'+pdList);
        for(Planning_Month__c pd:pdList){
            if(pd.RecordTypeId == Schema.SObjectType.Planning_Month__c.getRecordTypeInfosByName().get('Plan Day').getRecordTypeId() && pd.Related_Planning_Month__c != null){
                PlanmonthIds.add(pd.Related_Planning_Month__c);
            }
        }
        System.debug('$$$PlanmonthIds'+PlanmonthIds);
        id RId = Schema.SObjectType.Planning_Month__c.getRecordTypeInfosByName().get('Plan Day').getRecordTypeId();
        AggregateResult[] groupedResults = [SELECT count(id)planneddays, Related_Planning_Month__c FROM Planning_Month__c WHERE Related_Planning_Month__c in :PlanmonthIds and Recordtype.Id=:RId GROUP BY Related_Planning_Month__c];
        System.debug('$$$groupedResults'+groupedResults);
        System.debug('$$$groupedResults'+groupedResults.size());
        
        Map<id,Planning_Month__c> PlanmonthMap = new Map<Id,Planning_Month__c>([SELECT id ,Days_Planned__c,Related_Planning_Month__c FROM Planning_Month__c WHERE Id in :PlanmonthIds]);
        System.debug('$$$PlanmonthMap '+PlanmonthMap );
        
        for(AggregateResult ar: groupedResults) {
        system.debug('::1'+PlanmonthMap.get((Id)ar.get('Related_Planning_Month__c')).Days_Planned__c);
        system.debug('::2'+(decimal)ar.get('planneddays'));
              
              if(flag){
                 PlanmonthMap.get((Id)ar.get('Related_Planning_Month__c')).Days_Planned__c =  (decimal)ar.get('planneddays') - 1.0;
                 }
              else
              {
               PlanmonthMap.get((Id)ar.get('Related_Planning_Month__c')).Days_Planned__c =  (decimal)ar.get('planneddays');
              }
         }
        System.debug('$$$PlanmonthMap'+PlanmonthMap);
        try {
        system.debug('::3'+PlanmonthMap.values());
            update PlanmonthMap.values();
        }catch(DmlException e) {
            System.debug(e.getMessage());
        }
        
        
        
    }
    /*Populate necessary values(Approver 1,Approver 2,Month Start Date and Month End Date) for PlanningMonth when PlanningMonth is created*/
    public static void populatePlanMonthOnInsert(List<Planning_Month__c> pmList){
        Id parentTerritoryId;
        Id superParentTerritoryId;
        Id parentTerritoryApprId;
        Id superParentTerritoryApprId;
        Id terId;
        
        List<Planning_Month__c> filteredPMList=new List<Planning_Month__c>();
        List<Id> userIds=new List<Id>();
        User currUser;
        Set<String> BUList=new Set<String>();
        List<String> targetIds=new List<String>();
        User current_user;
        Map<Id,User> userMap=new Map<Id,User>();
        Map<Id,Id> ownerTerIdMap=new Map<Id,Id>();
        Map<Id,Id> parentTerritoryMap=new Map<id,Id>();
        Map<Id,Id> superParentTerritoryMap=new Map<id,Id>();
        Map<Id,Id> territoryApproverMap=new Map<id,Id>();
        
        Id planMonthRecTypeId=Schema.SObjectType.Planning_Month__c.getRecordTypeInfosByName().get(System.Label.Cres_PlanMonthRecType).getRecordTypeId();
        /*Filter records*/
        for(Planning_Month__c pm:pmList){
            if(pm.RecordTypeId==planMonthRecTypeId && pm.Plan_Year__c!=null && pm.Month_Planned__c!=null && pm.Target__c!=null){
                filteredPMList.add(pm);
                userIds.add(pm.OwnerId);
                targetIds.add(pm.Target__c);
            }
        }
        System.debug('$$$$filteredPMList'+filteredPMList);
        System.debug('$$$$userIds'+userIds);
        System.debug('$$$$targetIds'+targetIds);
        /*Build a User Id-TerritoryId(Standard) Map*/
        for(Target__c tar:[select Id,Employee_Link_To__c,Territory_Id__c from Target__c where Id in :targetIds and Employee_Link_To__c in : userIds]){
            ownerTerIdMap.put(tar.Employee_Link_To__c,tar.Territory_Id__c);
        }
        List<Territory2> territory2List=[SELECT Id,ParentTerritory2Id,ParentTerritory2.ParentTerritory2Id FROM Territory2 where Id in :ownerTerIdMap.values()];
        for(Territory2 ter:territory2List){
            
            if(ter.ParentTerritory2Id!=null){
                  /*Build CHild-Parent Territory Id Map*/
                parentTerritoryMap.put(ter.Id,ter.ParentTerritory2Id);
                
            }
            if(ter.ParentTerritory2Id!=null && ter.ParentTerritory2.ParentTerritory2Id!=null){
                   /*Build CHild-Super Parent(Parent's Parent) Territory Id Map*/
                superParentTerritoryMap.put(ter.Id,ter.ParentTerritory2.ParentTerritory2Id);
            }
            
        }
        System.debug('$$$parentTerritoryMap'+parentTerritoryMap);
        System.debug('$$$superParentTerritoryMap'+superParentTerritoryMap);
       for(UserTerritory2Association uta:[select id,UserId,Territory2Id from UserTerritory2Association where (Territory2Id in : parentTerritoryMap.values() or Territory2Id in : superParentTerritoryMap.values())]){
            if(!territoryApproverMap.containsKey(uta.Territory2Id)) {
                territoryApproverMap.put(uta.Territory2Id,uta.UserId);
            }else{
                /*There are more users in the Territory mark as null*/
                territoryApproverMap.put(uta.Territory2Id,null);
            }
        }
        System.debug('$$$territoryApproverMap'+territoryApproverMap);
        userMap=new Map<Id,user>([select id,User_Type__c,Business_Unit__c from User where id in :userIds]);
        System.debug('$$$userMap'+userMap);
        /*Get the Number of working days of the User Business*/
        Map<String,Cres_Country_Routing__c> routingMap= Cres_Country_Routing__c.getAll();
        System.debug('$$$routingMap'+routingMap);
        for(Planning_Month__c pm:filteredPMList){
            /*populate First Day and Last Day of the month*/
            pm.Month_Start_Date__c=Date.newInstance(Integer.valueOf(pm.Plan_Year__c),monthIndexMap.get(pm.Month_Planned__c),1);
            pm.Month_End_Date__c=monthIndexMap.get(pm.Month_Planned__c)==12 ? Date.newInstance(Integer.valueOf(pm.Plan_Year__c),monthIndexMap.get(pm.Month_Planned__c),31):Date.newInstance(Integer.valueOf(pm.Plan_Year__c),monthIndexMap.get(pm.Month_Planned__c)+1,1).addDays(-1);
            currUser=userMap.get(pm.OwnerId);
            if(currUser.Business_Unit__c!=null && routingMap.get(userMap.get(pm.OwnerId).Business_Unit__c)!=null){
              pm.Working_Days_Per_week__c=routingMap.get(currUser.Business_Unit__c).Working_Days_Per_Week__c;  
            }
            terId=ownerTerIdMap.get(currUser.Id);
            if(terId!=null && currUser.User_Type__c=='VSA'){
                /*if User is VSA. Approver1 must be the user from Parent Terriotry Id*/
                parentTerritoryId=parentTerritoryMap.get(terId);
                parentTerritoryApprId=territoryApproverMap.get(parentTerritoryId);
                if(parentTerritoryApprId!=null){
                    pm.Approver_1__c=parentTerritoryApprId;//ASM
                }
                /*if User is VSA. Approver2 must be the user from Super Parent Terriotry Id*/
                superParentTerritoryId=superParentTerritoryMap.get(terId);
                superParentTerritoryApprId=territoryApproverMap.get(superParentTerritoryId);
                if(superParentTerritoryApprId!=null){
                    pm.Approver_2__c=superParentTerritoryApprId;//RSM
                }
                
            }else
                 /*if User is RSM/ASM.Both Approver1 and Approver2 must be the user from Parent Terriotry Id*/
                if(terId!=null && (currUser.User_Type__c=='RSM' || currUser.User_Type__c=='ASM')){
                    parentTerritoryId=parentTerritoryMap.get(terId);
                    parentTerritoryApprId=territoryApproverMap.get(parentTerritoryId);
                    if(parentTerritoryApprId!=null){
                        pm.Approver_1__c=parentTerritoryApprId;//ASM
                        pm.Approver_2__c=parentTerritoryApprId;//ASM
                    }
                }
            
           
        }
        System.debug('$$$filteredPMList'+filteredPMList);
        
    }
    /*When ever a new  PlaningMonth (Plan Day record Type) records are created. Update its Parent PlaningMonth record Status*/
    public static void updatePlanMonthStatus(List<Planning_Month__c> pdList){
        Set<Id> planMonthIds=new Set<Id>();
        Id planDayRecTypeId=Schema.SObjectType.Planning_Month__c.getRecordTypeInfosByName().get(System.Label.Cres_Plan_DayRecType).getRecordTypeId();
        for(Planning_Month__c pd:pdList){ 
            
            if(pd.RecordTypeId==planDayRecTypeId){
               planMonthIds.add(pd.Related_Planning_Month__c);
            }
        }
        List<Planning_Month__c> planMonthList=[select Status__c from Planning_Month__c where id in : planMonthIds and Status__c='Open'];
        for(Planning_Month__c pm:planMonthList){
            pm.Status__c='In Progress';
            
        }
        System.debug('$$$PlanMonthStatusUpdate'+planMonthList);
        update planMonthList;
    }
     /*Generate Plan Day records Automatically based on Activity End Date when FirstHalf and SecondHalf is Leave/Training*/
     public static void createHolidayRecordsOnInsert(List<Planning_Month__c> pdList){
        Map<String,Cres_Country_Routing__c> routingMap= Cres_Country_Routing__c.getAll();
        User currentUser;
        List<Planning_Month__c> filterPlanDay=new List<Planning_Month__c>();
        Set<Id> ownerId=new Set<Id>(); 
        List<Planning_Month__c> holidayPlanList=new List<Planning_Month__c>();
        Id planDayRecTypeId=Schema.SObjectType.Planning_Month__c.getRecordTypeInfosByName().get(System.Label.Cres_Plan_DayRecType).getRecordTypeId();
        Integer dayDiff;
        Date startDate;
        for(Planning_Month__c pd:pdList){ 
            system.debug('test13:::'+pd);
            if(pd.RecordTypeId==planDayRecTypeId &&  pd.Target__c==null && ((pd.First_Half__c=='Leave' && pd.Second_Half__c=='Leave') || (pd.First_Half__c=='Training' && pd.Second_Half__c=='Training')) && pd.Activity_End_Date__c!=pd.Plan_Date__c){
                ownerId.add(pd.OwnerId);
                filterPlanDay.add(pd);
               
            }
        }
         Map<Id,User> ownerMap=new Map<Id,User>([select Id,Business_Unit__c from User where id in :ownerId]);
         
         for(Planning_Month__c pd:filterPlanDay){
             dayDiff=pd.Plan_Date__c.daysBetween(pd.Activity_End_Date__c);
             startDate=pd.Plan_Date__c;
             if(dayDiff>0){
                 for(Integer i=0;i<dayDiff;i++){
                     currentUser=ownerMap.get(pd.OwnerId);

                     startDate=startDate.addDays(1);
                     holidayPlanList.add(new Planning_Month__c(Related_Planning_Month__c=pd.Related_Planning_Month__c,recordTypeId=planDayRecTypeId,Activity_End_Date__c=startDate,Plan_Date__c=startDate,Second_Half__c=pd.Second_Half__c,First_Half__c=pd.First_Half__c));
                  
                 }
             }
         }
        if(holidayPlanList.size()>0){
            System.debug('$$$Holiday'+holidayPlanList);
            Database.SaveResult[] srList= Database.insert(holidayPlanList,false);
            for(Database.SaveResult sr:srList){
                if(sr.isSuccess()){
                    System.debug(sr.getErrors());
                }
            }
        }
    }
 
}