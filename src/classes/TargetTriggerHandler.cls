public class TargetTriggerHandler {
    public static boolean insertRanOnce = false;
    public static boolean updateRanOnce = false;
    public static boolean ranBeforeUpdtOnce = false;
    //This methid is used to Change the owner of the Record to the Employee Link to selected user.
    public void beforeInsert(List<Target__c> newList){
        for(Target__c tr: newList){
            if(String.isNotBlank(tr.Employee_Link_To__c)){
                tr.ownerid = tr.Employee_Link_To__c;
                tr.Unique_Target_Field__c = (tr.Name.trim()).toUpperCase() + tr.Employee_Link_To__c;
            }    
        } 
    }
    
    public void beforeUpdate(Map<id,Target__c> newMap, Map<id,Target__c> oldMap){
        ranBeforeUpdtOnce = true;
        system.debug('This is new Map in before update####'+newMap);
        system.debug('This is Old Map in before update####'+oldMap);
        for(Target__c tr: newMap.values()){
            //Stamp Owner and Stamp empId on Previous Emp field if Emp is changed
            if(String.isNotBlank(tr.Employee_Link_To__c) && !tr.Employee_Link_To__c.equals(oldMap.get(tr.Id).Employee_Link_To__c)){
                system.debug('Inside OwnerId update');
                tr.ownerid = tr.Employee_Link_To__c;
                tr.Previous_LinkTo_Emp__c = oldMap.get(tr.Id).Employee_Link_To__c;
                tr.Unique_Target_Field__c = (tr.Name.trim()).toUpperCase() + tr.Employee_Link_To__c;
            }
         
            //Stamp TerriotryId on Previous Territory Id field if Territory is changed
            if(String.isNotBlank(tr.Territory_Id__c) && !tr.Name.equals(oldMap.get(tr.Id).Name)){
                tr.Previous_Territory_Id__c = oldMap.get(tr.Id).Territory_Id__c;
            }
            
            tr.Unique_Target_Field__c = (tr.Name.trim()).toUpperCase() + tr.Employee_Link_To__c;
        } 
    }
    
    //This method is used to the validate the terriotory Name entered by the user 
    //and stamp the Territory Id from standard Territory model. Also added the functionality of Territory Sync
    public void stampTerritoryId(Map<Id,Target__c> newMap){

        insertRanOnce = TRUE;
        set<String> TargtNameSet = new set<String>();
        set<Id> ParentTerrIDSet = new set<Id>();
        Map<Id,Territory2> parentGrandParentMap = null;
        List<Target__c> updateTargtList = new List<Target__c>();
        
        for(Target__c tr: newMap.values()){
			TargtNameSet.add(tr.Name);            
        }
        Map<String,Territory2> terrNameIdMap = new Map<String,Territory2>();
        Map<Id,Territory2> terrMap = new Map<Id,Territory2>([select id,Name,DeveloperName,ParentTerritory2Id 
                                      						from Territory2
                                     					    where Name in: TargtNameSet]);
        Map<Id,Target__c> TargtMap = new Map<Id,Target__c>([select id,Name,Territory_Id__c,Employee_Link_To__c
                                                            from Target__c
                                                            where id in : newMap.keyset()]);
        
        for(Territory2 terr: terrMap.values()){
            terrNameIdMap.put(terr.Name,terr);
            ParentTerrIDSet.add(terr.ParentTerritory2Id);
        }
        if(!ParentTerrIDSet.isEmpty()){
        	parentGrandParentMap = new Map<Id,Territory2>([select id,Name,ParentTerritory2Id from Territory2 where Id in : ParentTerrIDSet]);
        }
        for(Target__c tar: newMap.values()){
            
                if(terrNameIdMap.containsKey(tar.Name)){
                    Target__c tempObj = new Target__c();
                    tempObj.Id = tar.Id;
                    tempObj.Territory_Id__c = terrNameIdMap.get(tar.Name).Id;
                    If(String.isNotBlank(terrNameIdMap.get(tar.Name).ParentTerritory2Id) && String.isNotBlank(parentGrandParentMap.get(terrNameIdMap.get(tar.Name).ParentTerritory2Id).ParentTerritory2Id)){
                    	tempObj.Parent_TerritoryId__c = terrNameIdMap.get(tar.Name).ParentTerritory2Id;
                        tempObj.Grand_Parent_TerritoryId__c = parentGrandParentMap.get(terrNameIdMap.get(tar.Name).ParentTerritory2Id).ParentTerritory2Id;
                    }
                    updateTargtList.add(tempObj);
                }
                else{
                    tar.addError(label.Target_Error);
                }
        }
        
        if(!updateTargtList.isEmpty())
        {
            update updateTargtList;           
        }
        
   }
    
        public void stampTerritoryIdUpdate(Map<Id,Target__c> newMap, Map<Id,Target__c> oldMap){

        updateRanOnce = TRUE;
        set<String> TargtNameSet = new set<String>();
        List<Target__c> updateTargtList = new List<Target__c>();
        set<Id> ParentTerrIDSet = new set<Id>();   
        Map<Id,Territory2> parentGrandParentMap = null;    
        Map<Id,Target__c> newTargetMap = new Map<Id,Target__c>();    
        List<Route__c> routeUpdtList = new List<Route__c>();
        for(Target__c tr: newMap.values()){
			TargtNameSet.add(tr.Name);            
        }
        Map<String,Territory2> terrNameIdMap = new Map<String,Territory2>();
        Map<Id,Territory2> terrMap = new Map<Id,Territory2>([select id,Name,DeveloperName,ParentTerritory2Id 
                                      						from Territory2
                                     					    where Name in: TargtNameSet]);
        Map<Id,Target__c> TargtMap = new Map<Id,Target__c>([select id,Name,Territory_Id__c,Employee_Link_To__c
                                                            from Target__c
                                                            where id in : newMap.keyset()]);
        
        for(Territory2 terr: terrMap.values()){
            terrNameIdMap.put(terr.Name,terr);
            ParentTerrIDSet.add(terr.ParentTerritory2Id);
        }
       
        if(!ParentTerrIDSet.isEmpty()){
        	parentGrandParentMap = new Map<Id,Territory2>([select id,Name,ParentTerritory2Id from Territory2 where Id in : ParentTerrIDSet]);
        }
        
        for(Target__c tar: newMap.values()){
            if(!tar.Name.equals(oldMap.get(tar.Id).Name)){
                if(terrNameIdMap.containsKey(tar.Name)){
                    Target__c tempObj = new Target__c();
                    tempObj.Id = tar.Id;
                    tempObj.Territory_Id__c = terrNameIdMap.get(tar.Name).Id;
                    if(String.isNotBlank(terrNameIdMap.get(tar.Name).ParentTerritory2Id) && String.isNotBlank(parentGrandParentMap.get(terrNameIdMap.get(tar.Name).ParentTerritory2Id).ParentTerritory2Id)){
                    	tempObj.Parent_TerritoryId__c = terrNameIdMap.get(tar.Name).ParentTerritory2Id;
                        tempObj.Grand_Parent_TerritoryId__c = parentGrandParentMap.get(terrNameIdMap.get(tar.Name).ParentTerritory2Id).ParentTerritory2Id;
                    }
                    updateTargtList.add(tempObj);
                }
                else{
                    tar.addError(label.Target_Error);
                }
            }
            if(!tar.Employee_Link_To__c.equals(oldMap.get(tar.Id).Employee_Link_To__c)){
                newTargetMap.put(tar.Id,tar);
            } 
        }
         
          //Change the Route Owner if TArget employee linked changes   
            if(!newTargetMap.isEmpty()){
                List<Route__c> routeList = [select id,Territory__c,ownerid from Route__c where Territory__c in : newTargetMap.keySet()];
                
                for(Route__c rt: routeList){
                    Route__c updtroute = new Route__c();
                    updtroute.id = rt.Id;
                    updtroute.ownerid = newTargetMap.get(rt.Territory__c).Employee_Link_To__c;
                    routeUpdtList.add(updtroute);
                }
                
                if(!routeUpdtList.isEmpty()){
                    update routeUpdtList;
                }
            }
            
         //***End************************************************
        //Sync Territory Functionality starts**********************************
          
        set<ID> tarIdset1 = new set<ID>(); //stores ids of target if only Ep Id is changed.
        set<ID> tarIdset2 = new set<ID>(); //stores ids of target if Emp Id and Territory Id both are changed.
        set<ID> tarIdset3 = new set<ID>(); //stores ids of target if Territory Id is changed but emp remains same.
        set<ID> terrOldIdset2 = new set<ID>();
        system.debug('new map is @@'+newMap);
        system.debug('old map is @@'+oldMap);
   
        
        for(Target__c tr: newMap.values()){
            system.debug('inside for first');
            //Employee Changes but Territory is same
            if(!tr.Employee_Link_To__c.equals(oldMap.get(tr.Id).Employee_Link_To__c) && tr.Name.equals(oldMap.get(tr.Id).Name)){
                system.debug('inside main IF');
                tarIdset1.add(tr.Id);                
            }
            //Employee as well as Territory is changed
            if(!tr.Employee_Link_To__c.equals(oldMap.get(tr.Id).Employee_Link_To__c) && !tr.Name.equals(oldMap.get(tr.Id).Name)){
                system.debug('inside main second IF');
                tarIdset2.add(tr.Id); 
                terrOldIdset2.add(tr.Territory_Id__c);
            }
            //Territory is changed, Emp remains same on Target record
            if(tr.Employee_Link_To__c.equals(oldMap.get(tr.Id).Employee_Link_To__c) && !tr.Name.equals(oldMap.get(tr.Id).Name)){
                system.debug('inside main third IF');
                tarIdset3.add(tr.Id); 
                terrOldIdset2.add(tr.Territory_Id__c);
            }
        }
    if(!Test.isRunningTest())
    {     
        if(!tarIdset1.isEmpty()){
            UpdateTerritoryUsers1.updateUserTerrAssoc1(tarIdset1);
        }	
        
        if(!tarIdset2.isEmpty()){
            UpdateTerritoryUsers2.updateUserTerrAssoc2(tarIdset2,terrOldIdset2);
        }
        if(!tarIdset3.isEmpty()){
            UpdateTerritoryUsers3.updateUserTerrAssoc3(tarIdset3,terrOldIdset2);
        }
    } 
        //Sync Territory functionality ends***************************************** 
        
        if(!updateTargtList.isEmpty())
        {
            update updateTargtList;           
        }
        
   }
}