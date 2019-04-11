public class RouteCustRollUp {
    public static Boolean ranOnce=false;
   public static void RollupRouteCustforRoute(List<Route__c> rcList){
        
        set<Id> routePlatIds = new set<Id>();
        set<Id> routeDiaIds = new set<Id>();
        set<Id> routeGoldIds = new set<Id>();
       
        set<Id> accPlatIds = new set<Id>();
        set<Id> accDiaIds = new set<Id>();
        set<Id> accGoldIds = new set<Id>();
        
       set<Id> accIdset = new set<Id>();
       // System.debug('$$$pdList'+rcList);
       
       for(Route__c rt: rcList){
           if(rt.RecordTypeId == Schema.SObjectType.Route__c.getRecordTypeInfosByName().get('Route Customer').getRecordTypeId())
           		accIdset.add(rt.Account__c);
       }
       Map<Id,Account> accIdClassificationMap = new Map<ID,Account>([select id,Classification__c from Account where Id in : accIdset]);
     
		//system.debug('Map is ##'+accIdClassificationMap);       
       
       for(Route__c rc:rcList){
            if(rc.RecordTypeId == Schema.SObjectType.Route__c.getRecordTypeInfosByName().get('Route Customer').getRecordTypeId() && rc.Related_Route__c != null && accIdClassificationMap.get(rc.Account__c).Classification__c=='Platinum'){
                routePlatIds.add(rc.Related_Route__c);
               // accPlatIds.add(rc.Account__c);
            }
            if(rc.RecordTypeId == Schema.SObjectType.Route__c.getRecordTypeInfosByName().get('Route Customer').getRecordTypeId() && rc.Related_Route__c != null && accIdClassificationMap.get(rc.Account__c).Classification__c=='Gold'){
                routeGoldIds.add(rc.Related_Route__c);
              //  accGoldIds.add(rc.Account__c);
            }
            if(rc.RecordTypeId == Schema.SObjectType.Route__c.getRecordTypeInfosByName().get('Route Customer').getRecordTypeId() && rc.Related_Route__c != null && accIdClassificationMap.get(rc.Account__c).Classification__c=='Diamond'){
                routeDiaIds.add(rc.Related_Route__c);
              //  accDiaIds.add(rc.Account__c);
            }
        }
        
        id RId = Schema.SObjectType.Route__c.getRecordTypeInfosByName().get('Route Customer').getRecordTypeId();
       AggregateResult[] groupedplatResults = [SELECT count(id)routecustomers, Related_Route__c 
                                                FROM Route__c 
                                                WHERE Related_Route__c in :routePlatIds and Recordtype.Id=:RId and Account_Classification__c = 'Platinum'
                                                GROUP BY Related_Route__c];
       AggregateResult[] groupedgoldResults = [SELECT count(id)routecustomers, Related_Route__c 
                                                FROM Route__c 
                                                WHERE Related_Route__c in :routeGoldIds and Recordtype.Id=:RId and Account_Classification__c = 'Gold'
                                                GROUP BY Related_Route__c];
       AggregateResult[] groupeddiaResults = [SELECT count(id)routecustomers, Related_Route__c 
                                                FROM Route__c 
                                                WHERE Related_Route__c in :routeDiaIds and Recordtype.Id=:RId and Account_Classification__c = 'Diamond'
                                                GROUP BY Related_Route__c];
       
     /*  AggregateResult[] groupedaccplatResults = [SELECT count(id)routecustomers, Account__c 
                                                FROM Route__c 
                                                WHERE Account__c in :accPlatIds and Recordtype.Id=:RId and Account_Classification__c = 'Platinum'
                                                GROUP BY Account__c];
       AggregateResult[] groupedaccgoldResults = [SELECT count(id)routecustomers, Account__c 
                                                FROM Route__c 
                                                WHERE Account__c in :accGoldIds and Recordtype.Id=:RId and Account_Classification__c = 'Gold'
                                                GROUP BY Account__c];
       AggregateResult[] groupedaccdiaResults = [SELECT count(id)routecustomers, Account__c 
                                                FROM Route__c 
                                                WHERE Account__c in :accDiaIds and Recordtype.Id=:RId and Account_Classification__c = 'Diamond'
                                                GROUP BY Account__c]; */
        Map<id,Route__c> routePlatMap = new Map<Id,Route__c>([SELECT id ,Related_Route__c FROM Route__c WHERE Id in :routePlatIds]);
        Map<id,Route__c> routeGoldMap = new Map<Id,Route__c>([SELECT id ,Related_Route__c FROM Route__c WHERE Id in :routeGoldIds]);
        Map<id,Route__c> routeDiaMap = new Map<Id,Route__c>([SELECT id ,Related_Route__c FROM Route__c WHERE Id in :routeDiaIds]);
        
      /*  Map<id,Account> accPlatMap = new Map<Id,Account>([SELECT id ,Name FROM Account WHERE Id in :accPlatIds]);
        Map<id,Account> accGoldMap = new Map<Id,Account>([SELECT id ,Name FROM Account WHERE Id in :accGoldIds]);
        Map<id,Account> accDiaMap = new Map<Id,Account>([SELECT id ,Name FROM Account WHERE Id in :accDiaIds]);*/
        
       for(AggregateResult ar: groupedplatResults){
             routePlatMap.get((Id)ar.get('Related_Route__c')).Number_Of_Platinum_Customers__c = (decimal)ar.get('routecustomers');
        }
        for(AggregateResult ar: groupedgoldResults){
             routeGoldMap.get((Id)ar.get('Related_Route__c')).Number_Of_Gold_Customers__c = (decimal)ar.get('routecustomers');
        }
        for(AggregateResult ar: groupeddiaResults){
             routeDiaMap.get((Id)ar.get('Related_Route__c')).Number_Of_Diamond_Customers__c = (decimal)ar.get('routecustomers');
        }
       
      /*  for(AggregateResult ar: groupedaccplatResults){
             accPlatMap.get((Id)ar.get('Account__c')).Number_Of_Platinum_Customers__c = (decimal)ar.get('routecustomers');
        }
        for(AggregateResult ar: groupedaccgoldResults){
             accGoldMap.get((Id)ar.get('Account__c')).Number_Of_Gold_Customers__c = (decimal)ar.get('routecustomers');
        }
        for(AggregateResult ar: groupedaccdiaResults){
             accDiaMap.get((Id)ar.get('Account__c')).Number_Of_Diamond_Customers__c = (decimal)ar.get('routecustomers');
        }*/
       
        try{
            if(!routePlatMap.values().isEmpty())
            update routePlatMap.values();
        }
        catch(DmlException e){
            System.debug(e.getMessage());
        }
        try{
            if(!routeGoldMap.values().isEmpty())
            update routeGoldMap.values();
        }
        catch(DmlException e){
            System.debug(e.getMessage());
        }
        try{
            if(!routeDiaMap.values().isEmpty())
            update routeDiaMap.values();
        }
        catch(DmlException e){
            System.debug(e.getMessage());
        }
       
      /*  try{
            if(!accPlatMap.values().isEmpty())
            update accPlatMap.values();
        }
        catch(DmlException e){
            System.debug(e.getMessage());
        }
        try{
            if(!accGoldMap.values().isEmpty())
            update accGoldMap.values();
        }
        catch(DmlException e){
            System.debug(e.getMessage());
        }
        try{
            if(!accDiaMap.values().isEmpty())
            update accDiaMap.values();
        }
        catch(DmlException e){
            System.debug(e.getMessage());
        }*/
    }
    
    public static void DelRollupRouteCustforRoute(List<Route__c> oldList){
        
        Map<Id,Integer> parentIDPlatMap = new Map<Id,Integer>();
        Map<Id,Integer> parentIDGoldMap = new Map<Id,Integer>();
        Map<Id,Integer> parentIDDiaMap = new Map<Id,Integer>();
        set<id> parentIdset = new set<Id>();
        
        Map<Id,Integer> parentaccIDPlatMap = new Map<Id,Integer>();
        Map<Id,Integer> parentaccIDGoldMap = new Map<Id,Integer>();
        Map<Id,Integer> parentaccIDDiaMap = new Map<Id,Integer>();
        set<id> parentaccIdset = new set<Id>();
        
        
        for(Route__c rt: oldList){
            //Platinum
            if(rt.RecordTypeId == Schema.SObjectType.Route__c.getRecordTypeInfosByName().get('Route Customer').getRecordTypeId() && parentIDPlatMap.containsKey(rt.Related_Route__c) && rt.Account_Classification__c == 'Platinum'){
                parentIDPlatMap.put(rt.Related_Route__c,parentIDPlatMap.get(rt.Related_Route__c) + 1);
               // parentaccIDPlatMap.put(rt.Account__c,parentaccIDPlatMap.get(rt.Account__c) + 1);
            }
            if(rt.RecordTypeId == Schema.SObjectType.Route__c.getRecordTypeInfosByName().get('Route Customer').getRecordTypeId() && !parentIDPlatMap.containsKey(rt.Related_Route__c) && rt.Account_Classification__c == 'Platinum'){
               parentIDPlatMap.put( rt.Related_Route__c,1);
              // parentaccIDPlatMap.put( rt.Account__c,1); 
            }
            //Gold
            if(rt.RecordTypeId == Schema.SObjectType.Route__c.getRecordTypeInfosByName().get('Route Customer').getRecordTypeId() && parentIDGoldMap.containsKey(rt.Related_Route__c) && rt.Account_Classification__c == 'Gold'){
                parentIDGoldMap.put(rt.Related_Route__c,parentIDPlatMap.get(rt.Related_Route__c) + 1);
               // parentaccIDGoldMap.put(rt.Account__c,parentaccIDPlatMap.get(rt.Account__c) + 1);
            }
            if(rt.RecordTypeId == Schema.SObjectType.Route__c.getRecordTypeInfosByName().get('Route Customer').getRecordTypeId() && !parentIDGoldMap.containsKey(rt.Related_Route__c) && rt.Account_Classification__c == 'Gold'){
               parentIDGoldMap.put( rt.Related_Route__c,1);
              // parentaccIDGoldMap.put( rt.Account__c,1);
            }
            //Diamond
            if(rt.RecordTypeId == Schema.SObjectType.Route__c.getRecordTypeInfosByName().get('Route Customer').getRecordTypeId() && parentIDDiaMap.containsKey(rt.Related_Route__c) && rt.Account_Classification__c == 'Diamond'){
                parentIDDiaMap.put(rt.Related_Route__c,parentIDPlatMap.get(rt.Related_Route__c) + 1);
              //  parentaccIDDiaMap.put(rt.Account__c,parentaccIDPlatMap.get(rt.Account__c) + 1);
            }
            if(rt.RecordTypeId == Schema.SObjectType.Route__c.getRecordTypeInfosByName().get('Route Customer').getRecordTypeId() && !parentIDDiaMap.containsKey(rt.Related_Route__c) && rt.Account_Classification__c == 'Diamond'){
               parentIDDiaMap.put( rt.Related_Route__c,1);
             //  parentaccIDDiaMap.put( rt.Account__c,1);
            }
            
            if(rt.RecordTypeId == Schema.SObjectType.Route__c.getRecordTypeInfosByName().get('Route Customer').getRecordTypeId() && rt.Related_Route__c != Null && rt.Account__c != Null){
                parentIdset.add(rt.Related_Route__c);
              //  parentaccIdset.add(rt.Account__c);
            }
        }
        
        Map<Id,Route__c> parentRouteMap = new Map<Id,Route__c>([select id,Number_Of_Diamond_Customers__c,Number_Of_Gold_Customers__c,Number_Of_Platinum_Customers__c from Route__c where Id in: parentIdset]);
      //  Map<Id,Account> parentAccountMap = new Map<Id,Account>([select id,Number_Of_Diamond_Customers__c,Number_Of_Gold_Customers__c,Number_Of_Platinum_Customers__c from Account where Id in: parentaccIdset]);
        
        for(Route__c rt:parentRouteMap.values()){
            if(parentIDPlatMap.containsKey(rt.Id)){
                parentRouteMap.get(rt.Id).Number_Of_Platinum_Customers__c = parentRouteMap.get(rt.Id).Number_Of_Platinum_Customers__c - parentIDPlatMap.get(rt.Id);
            }
            if(parentIDGoldMap.containsKey(rt.Id)){
                parentRouteMap.get(rt.Id).Number_Of_Gold_Customers__c = parentRouteMap.get(rt.Id).Number_Of_Gold_Customers__c - parentIDGoldMap.get(rt.Id);
            }
            
            if(parentIDDiaMap.containsKey(rt.Id)){
                parentRouteMap.get(rt.Id).Number_Of_Diamond_Customers__c = parentRouteMap.get(rt.Id).Number_Of_Diamond_Customers__c - parentIDDiaMap.get(rt.Id);
            }
        }
        
       /* for(Account rt:parentAccountMap.values()){
            if(parentaccIDPlatMap.containsKey(rt.Id)){
                parentAccountMap.get(rt.Id).Number_Of_Platinum_Customers__c = parentAccountMap.get(rt.Id).Number_Of_Platinum_Customers__c - parentaccIDPlatMap.get(rt.Id);
            }
            if(parentaccIDGoldMap.containsKey(rt.Id)){
                parentAccountMap.get(rt.Id).Number_Of_Gold_Customers__c = parentAccountMap.get(rt.Id).Number_Of_Gold_Customers__c - parentaccIDGoldMap.get(rt.Id);
            }
            
            if(parentaccIDDiaMap.containsKey(rt.Id)){
                parentAccountMap.get(rt.Id).Number_Of_Diamond_Customers__c = parentAccountMap.get(rt.Id).Number_Of_Diamond_Customers__c - parentaccIDDiaMap.get(rt.Id);
            }
        } 
        
        try{
            if(!parentAccountMap.values().isEmpty())
            update parentAccountMap.values();
        }
        catch(DmlException e){
            System.debug(e.getMessage());
        }*/
        
        try{
            if(!parentRouteMap.values().isEmpty())
            update parentRouteMap.values();
        }
        catch(DmlException e){
            System.debug(e.getMessage());
        }
        
    }
    
    public static void UpdateRollupRouteCustforRoute(Map<ID,Route__c> newMap,Map<Id,Route__c> oldMap){
     
    	system.debug('inside update roll up');    
        System.debug('$$$newMap'+newMap);
        ranOnce = true;
        //Creating List for Routes which are of Customer Record Type
        List<Route__c> newRouteCustList = [select Id,Account__c,Related_Route__c,Account_Classification__c from Route__c where RecordTypeId =: Schema.SObjectType.Route__c.getRecordTypeInfosByName().get('Route Customer').getRecordTypeId() AND ID in:newMap.keyset()];
        system.debug('new route list##'+newRouteCustList);
        //Creating Parent RouteId Set
        set<ID> relRouteIdset = new set<Id>();
        for(Route__c rt: newRouteCustList){
            if(String.isnotBlank(String.valueof(rt.Related_Route__c))){
                relRouteIdset.add(rt.Related_Route__c);
            }
        }
        system.debug('parent route set##'+relRouteIdset);
        
        //Creating parent map i.e. to be updated
        Map<Id,Route__c> updatedMap = new Map<Id,Route__c>([select Id,Number_Of_Platinum_Customers__c,Number_Of_Gold_Customers__c,Number_Of_Diamond_Customers__c from Route__c where Id in: relRouteIdset]);
        system.debug('parent map ##'+updatedMap);
        
        for(Route__c rt: newRouteCustList){
             //If account and classification both are changed
            if(rt.Account__c != null && oldMap.get(rt.Id).Account__c!=null && rt.Account__c != oldMap.get(rt.Id).Account__c && rt.Account_Classification__c != oldMap.get(rt.Id).Account_Classification__c){
                //Subtract Old Classification
                if(oldMap.get(rt.Id).Account_Classification__c == 'Platinum'){
                    updatedMap.get(rt.Related_Route__c).Number_Of_Platinum_Customers__c = updatedMap.get(rt.Related_Route__c).Number_Of_Platinum_Customers__c - 1;
                }
                if(oldMap.get(rt.Id).Account_Classification__c == 'Gold'){
                    updatedMap.get(rt.Related_Route__c).Number_Of_Gold_Customers__c = updatedMap.get(rt.Related_Route__c).Number_Of_Gold_Customers__c - 1;
                }
                if(oldMap.get(rt.Id).Account_Classification__c == 'Diamond'){
                    updatedMap.get(rt.Related_Route__c).Number_Of_Diamond_Customers__c = updatedMap.get(rt.Related_Route__c).Number_Of_Diamond_Customers__c - 1;
                }
                //Add New Classification
                if(rt.Account_Classification__c == 'Platinum'){
                    updatedMap.get(rt.Related_Route__c).Number_Of_Platinum_Customers__c = updatedMap.get(rt.Related_Route__c).Number_Of_Platinum_Customers__c + 1;
                }
                if(rt.Account_Classification__c == 'Gold'){
                    updatedMap.get(rt.Related_Route__c).Number_Of_Gold_Customers__c = updatedMap.get(rt.Related_Route__c).Number_Of_Gold_Customers__c + 1;
                }
                if(rt.Account_Classification__c == 'Diamond'){
                    updatedMap.get(rt.Related_Route__c).Number_Of_Diamond_Customers__c = updatedMap.get(rt.Related_Route__c).Number_Of_Diamond_Customers__c + 1;
                }
            }
            //If account is same but classification is updated
             if(rt.Account__c != null && rt.Account__c == oldMap.get(rt.Id).Account__c && rt.Account_Classification__c != oldMap.get(rt.Id).Account_Classification__c){
                //Subtract old classification
                system.debug('inside common Id if statement');
                if(oldMap.get(rt.Id).Account_Classification__c == 'Platinum'){
                    system.debug('inside sub plat');
                    updatedMap.get(rt.Related_Route__c).Number_Of_Platinum_Customers__c = updatedMap.get(rt.Related_Route__c).Number_Of_Platinum_Customers__c - 1;
                }
                if(oldMap.get(rt.Id).Account_Classification__c == 'Gold'){
                    system.debug('inside sub gold');
                    updatedMap.get(rt.Related_Route__c).Number_Of_Gold_Customers__c = updatedMap.get(rt.Related_Route__c).Number_Of_Gold_Customers__c - 1;
                }
                if(oldMap.get(rt.Id).Account_Classification__c == 'Diamond'){
                    system.debug('inside sub diamond');
                    updatedMap.get(rt.Related_Route__c).Number_Of_Diamond_Customers__c = updatedMap.get(rt.Related_Route__c).Number_Of_Diamond_Customers__c - 1;
                }
                 //Add New Classification
                if(rt.Account_Classification__c == 'Platinum'){
                     system.debug('inside add plat');
                    updatedMap.get(rt.Related_Route__c).Number_Of_Platinum_Customers__c = updatedMap.get(rt.Related_Route__c).Number_Of_Platinum_Customers__c + 1;
                }
                if(rt.Account_Classification__c == 'Gold'){
                    system.debug('inside add gold');
                    updatedMap.get(rt.Related_Route__c).Number_Of_Gold_Customers__c = updatedMap.get(rt.Related_Route__c).Number_Of_Gold_Customers__c + 1;
                }
                if(rt.Account_Classification__c == 'Diamond'){
                    system.debug('inside add diamond');
                    updatedMap.get(rt.Related_Route__c).Number_Of_Diamond_Customers__c = updatedMap.get(rt.Related_Route__c).Number_Of_Diamond_Customers__c + 1;
                }
            }
        }
        
       if(!updatedMap.values().isEmpty())
       {
           update updatedMap.values();
         
       }
        
    }
}