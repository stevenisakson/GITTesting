public class UpdateTerritoryUsers1 {
	@future
    public static void updateUserTerrAssoc1(set<id> targetIdSet){
        Map<Id,Target__c> newtargetMap = new Map<Id,Target__c>([select id,Name,Territory_Id__c,Employee_Link_To__c,Previous_LinkTo_Emp__c,Previous_Territory_Id__c 
                                                                from Target__c where Id in: targetIdSet]);
    	set<Id> terrIdset = new set<Id>();
        
    	Map<Id,List<Id>> terrIdUserIdListMap = new map<Id,List<Id>>(); 
        for(Target__c tr: newtargetMap.values()){
            //Employee Changes but Territory is same
                if(terrIdUserIdListMap.containsKey(tr.Territory_Id__c)){
                    List<Id> usersId = terrIdUserIdListMap.get(tr.Territory_Id__c);
                    usersId.add(tr.Employee_Link_To__c);
                    terrIdUserIdListMap.put(tr.Territory_Id__c,usersId);
                    system.debug('inside if');
                }
                else{
                    system.debug('inside else');
                    terrIdUserIdListMap.put(tr.Territory_Id__c,new List<Id> { tr.Employee_Link_To__c });
                }
             terrIdset.add(tr.Territory_Id__c);
        }
        //List created to insert newly changed User to the Target Record 
        List<UserTerritory2Association> usrTerr2InsertList = new List<UserTerritory2Association>();
        if(!terrIdUserIdListMap.isEmpty()){
            for(Id terrId : terrIdUserIdListMap.keyset()){
                for(Id usersId : terrIdUserIdListMap.get(terrId)){
                   UserTerritory2Association tempinsrt = new UserTerritory2Association();
                    tempinsrt.Territory2Id = terrId;
                    tempinsrt.UserId = usersId;
                    usrTerr2InsertList.add(tempinsrt);
                }
            }
        }
        
        if(!usrTerr2InsertList.isEmpty()){
            system.debug('inside insrt');
            insert usrTerr2InsertList;
        }
        //delete Existing user from Standard Territory functionality starts from here
        list<UserTerritory2Association> user2TerrAssocList = [select Id,Territory2Id,UserId from UserTerritory2Association where Territory2Id in : terrIdset];
        list<UserTerritory2Association> usrTerr2DeleteList = new list<UserTerritory2Association>(); 
       

        List<UserTerritory2Association> deleteList = new  List<UserTerritory2Association>();
        for(UserTerritory2Association u2Terr : user2TerrAssocList){
            for(Target__c u2TerrDel : newtargetMap.values()){
                if(u2Terr.Territory2Id.equals(u2TerrDel.Territory_Id__c) && u2Terr.UserId.equals(u2TerrDel.Previous_LinkTo_Emp__c)){
                    UserTerritory2Association temp = new UserTerritory2Association();
                    temp.Id = u2Terr.Id;
                    deleteList.add(temp);
                }
            }
        }
        
        if(!deleteList.isEmpty()){
            delete deleteList;
        }
    }
    

    
   
}