/*********************************************************************
Name:RouteTriggerHandler
Date:29 August 2018
Description: Handler for Route trigger
             before update/after update
History:
*********************************************************************/
public class RouteTriggerhandler {
public static boolean ranRouteApprovalonce = false;    
/******************************************
Name:RouteUserApproval
Date:29 August 2018
Description: This class is used for RouteApprovalProcess for CPNINDIA.
History:Created: Poonam Yadav
*******************************************/
    public class RouteUserApproval{
      
        
        
    
        
/******************************************
Method Name: submitForApproval
Description: This method is used to submit the route record for approval.
InputParameters:List of Routes
OutputParameters:None
*******************************************/
public void submitForApproval(List<Route__c> routeList){
    
    List<Route__c> newList=routeList.clone();
    ID Approver1;
    ID Approver2;
    List<Territory2> territorylst=new List<Territory2>();    
    List<Territory2> grndprnt;
    Map<ID,Target__c> usrtargetmap;
    List<UserTerritory2Association> userparentterritory=new List<UserTerritory2Association>();
    List<UserTerritory2Association> usergrndparentterritory=new List<UserTerritory2Association>();
    Map<Id,Id>userterritorymap =new Map<Id,Id>();// 
    Map<Id,List<Id>>territoryusers =new Map<Id,List<Id>>();// storing parent territory and its associated users.
    Map<Id,List<Id>>territorygrandusers =new Map<Id,List<Id>>();// storing  grand parent territory and its associated users.
    List<Id> parentlist=new List<Id>();
    List<id> grandparenids=new List<Id>();
    Map<ID,ID> usrtarget =new Map<ID,ID>();
    Map<Id,Id> routeowneridsmap =new Map<Id,Id>();
    Id parentids;
    List<ID> parntusrs;
    List<ID> grndprntusrs;
    Id prnt;
    Map<Id,ID> parntandgrnparnt=new Map<Id,ID>();
    Map<Id,Id> userterritorytargetmap= new Map<Id,Id>();
    Set<String> regionset=new Set<String>();
    Map<ID,ID> territoryparentmap=new Map<ID,ID>();
    Map<Id,Set<Id>> territoryusermap=new Map<Id,Set<ID>>();
    set<Id> tempset;
    Set<id> ASMuseridset;
    Set<id> RSMuseridset;
    Id RSMTerritoryid;
    Id ASMTerritoryid;
    set<id> targetIdset = new set<Id>();
     
    //change Owner to selected Territory Owner
        
    for (Route__c r: routeList){
        system.debug('##route record is##'+r);
        if(r.RecordTypeId == Schema.SObjectType.Route__c.getRecordTypeInfosByName().get('Route').getRecordTypeId()){
            targetIdset.add(r.Territory__c);
                     
                r.UniqueRouteName__c = (r.Name__c.trim()).toUpperCase() + r.Territory__c;
                r.UniqueRouteNo__c = (r.Name.trim()).toUpperCase() + r.Territory__c;
            
        }
    }
    map<id,Target__c> terrIdOwnIdMap = new map<Id,Target__c>([select ID,ownerID,Employee_Link_To__c,Territory_Id__c from Target__c where id in: targetIdset]);    
    
    for (Route__c r: routeList){
        if(r.RecordTypeId != Schema.SObjectType.Route__c.getRecordTypeInfosByName().get('Route Customer').getRecordTypeId()){
            r.ownerid = terrIdOwnIdMap.get(r.Territory__c).Employee_Link_To__c;
            r.Standard_Territory_Id__c = terrIdOwnIdMap.get(r.Territory__c).Territory_Id__c;
        }
    }
    
    // Get list of route owner Ids
    for (Route__c r: routeList){
        if(r.RecordTypeId != Schema.SObjectType.Route__c.getRecordTypeInfosByName().get('Route Customer').getRecordTypeId()){
            routeowneridsmap.put(r.ownerId,r.Territory__c);}
    }
   // system.debug('list of owner territories++'+ routeowneridsmap);
    List<Target__c> targetlist = new List<Target__c>();
    if(!routeowneridsmap.values().isEmpty()){
        targetlist=new List<Target__c>([SELECT Id,Employee_Link_To__c,Name,Territory_Id__c FROM Target__c where ID IN:routeowneridsmap.values()]);
    }
    if(!targetlist.isEmpty()){ 
        for(Target__c t: targetlist){
            
            userterritorytargetmap.put(t.Employee_Link_To__c,t.Territory_Id__c);
        }
    }
   // system.debug('Employee and target record id++'+ userterritorytargetmap);
    
    // List of users regions
     List<User> userlist = new List<User>();
    if(!routeowneridsmap.keySet().isEmpty()){
          userlist=new List<User>([Select id,Region__c from user where id IN:routeowneridsmap.keySet()]);
    }
    if(!userlist.isEmpty()){
        for(User u: userlist){
            regionset.add(u.Region__c);        
        }
    } 
    //system.debug('List of users where region is cpn india'+ regionset);
    if(!regionset.isEmpty()){  
        territorylst=[SELECT Id,Name,Region__c,ParentTerritory2Id FROM Territory2 where Region__c IN:regionset];
    }
    
    if(!territorylst.isEmpty()){
    for(Territory2 tr: territorylst){
        if(string.isNotBlank(tr.ParentTerritory2Id)){ 
             territoryparentmap.put(tr.id,tr.ParentTerritory2Id);// for CPN INDIA child territories, it will not store the territory id's.
        }
        
    }
  }
    
  // system.debug('territories and parent teritory ++'+ territoryparentmap);
    List<UserTerritory2Association> usrterritory = new List<UserTerritory2Association>();
    if(!territoryparentmap.keySet().isEmpty()){
        usrterritory=[SELECT Id,Territory2Id,UserId,Territory2.ParentTerritory2Id from UserTerritory2Association where Territory2Id IN:territoryparentmap.keySet()];
    }
    
    // Get users's territory and its parent territory
     if(!usrterritory.isEmpty())
     {
         for(UserTerritory2Association uta:usrterritory){
             if(territoryusermap.containsKey(uta.Territory2Id)){
                 
                    tempset=new set<id>();
                 if(string.isNotBlank(uta.UserId)){ // if users are not assigned to territory it will not be stored in map.
                 
                    tempset=territoryusermap.get(uta.Territory2Id);
                    tempset.add(uta.UserId);
                    territoryusermap.put(uta.Territory2Id,tempset);
                 }
                 
              } else{
                  
                   tempset=new set<Id>();
                 if(string.isNotBlank(uta.userId)){ // if users are not assigned to territory it will not be stored in map.
                   tempset.add(uta.userId);
                   territoryusermap.put(uta.Territory2Id,tempset);
                  }
             }    
             
         }  
         
       }   
        //  system.debug('ASM ID'+ territoryusermap.containsKey('0MI4C000000L074WAC'));
         // system.debug('ASM ID'+ territoryusermap.get('0MI4C000000L074WAC'));
    if(!routeList.isEmpty() && !routeowneridsmap.keySet().isEmpty()){
       for(Route__c rt:routeList){
        
       if(rt.RecordTypeId != Schema.SObjectType.Route__c.getRecordTypeInfosByName().get('Route Customer').getRecordTypeId()){
         Id Userterritoryid = userterritorytargetmap.get(rt.ownerId);// changed to owner id
         if(!territoryparentmap.containsKey(Userterritoryid)){
            
            rt.addError(Label.TargetTerritoryMappingIncorrect);
             
         } else{
             
         ASMTerritoryid = territoryparentmap.get(Userterritoryid);
         RSMTerritoryid = territoryparentmap.get(ASMTerritoryid);
             
        if(!territoryusermap.containsKey(ASMTerritoryid)){ 
           
              rt.addError(Label.ASM_Not_Assigned); 
              
         } else{
                  
          ASMuseridset = new set<id>(territoryusermap.get(ASMTerritoryid));
         // RSMuseridset = new set<id>(territoryusermap.get(RSMTerritoryid)); 
             
               
                if(!ASMuseridset.isEmpty()){
                   if(String.isBlank(rt.Approver1__c)){
                     if(ASMuseridset.size()>1){
                          rt.addError(Label.Multiple_ASM);
                         }
                      else{
                        if(!ASMuseridset.isEmpty() && ASMuseridset.size()==1 ){
                       for(Id stids:ASMuseridset){
                         rt.Approver1__c=stids;
                            
                        }
                    }
                 }
               }     
               else {
                      if(string.isNotBlank(rt.Approver1__c)){
                          if(!ASMuseridset.contains(rt.Approver1__c)){
                             rt.AddError(Label.Incorrect_ASM);
                          }
                      }
                  } 
               } 
         } if(!territoryusermap.containsKey(RSMTerritoryid)){  
              
              rt.addError(Label.RSM_Not_Assigned); 
              
             } else{
                 
             RSMuseridset = new set<id>(territoryusermap.get(RSMTerritoryid));  
          if(!RSMuseridset.isEmpty()){
               if(String.isBlank(rt.Approver2__c)){
                        if(RSMuseridset.size()>1){
                            rt.addError(Label.Multiple_RSM);
                        }
                         else{
                            if(!RSMuseridset.isEmpty() && RSMuseridset.size()==1 ){
                                 for(Id rsids: RSMuseridset){
                                    rt.Approver2__c= rsids;
                                   }
                             }
                        }
                 }
                   
               else{
                    if(string.isNotBlank(rt.Approver2__c)){
                          if(!RSMuseridset.contains(rt.Approver2__c)){
                             rt.AddError(Label.Incorrect_RSM);
                          } 
                    }
                  }
               }
           }// ending of RSM else
         } //ending of userterritory else     
    }
  }
}
}
        
/******************************************
Method Name: RouteApprovalProcess
Description: This method is used to submit the route record for approval.
InputParameters:List of Routes
OutputParameters:None
*******************************************/
public void RouteApprovalProcess(List<Route__c> routesubmitlist){
            
 ranRouteApprovalonce = true;          
for(Route__c r:routesubmitlist){
   if(r.Status__c==Label.Submitted_for_Approval && r.Submitted_For_Approval__c == false){
       
         system.debug('Approval method + route id is' + r);   
         Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
         req.setObjectId(r.id);
         Approval.ProcessResult result =  Approval.process(req);   
   
           
    }

    }
}
}
    public static Boolean ranOnce=false;
    public void stampAccountClassicification(list<Route__c> rcList){
        ranOnce = true;
        set<Id> accIdset = new set<Id>();
        List<Route__c> newList = new List<Route__c>();
        for(Route__c rt: rcList){
           // system.debug('con 1'+String.isNotBlank(String.valueOf(rt.Account__c)));
           // system.debug('con 2'+String.valueOf(rt.RecordTypeId).equals(String.valueOf(Schema.SObjectType.Route__c.getRecordTypeInfosByName().get('Route Customer').getRecordTypeId())));
            if(String.isNotBlank(String.valueOf(rt.Account__c)) && String.valueOf(rt.RecordTypeId).equals(String.valueOf(Schema.SObjectType.Route__c.getRecordTypeInfosByName().get('Route Customer').getRecordTypeId()))){
                accIdset.add(rt.Account__c);
                newList.add(rt);
            }
       }
        system.debug('newlist is ####'+newList);
       Map<Id,Account> accIdClassificationMap = new Map<ID,Account>([select id,Classification__c from Account where Id in : accIdset]);
        
        for(Route__c rt: newList){
   
            if(rt.RecordTypeId == Schema.SObjectType.Route__c.getRecordTypeInfosByName().get('Route Customer').getRecordTypeId()){
                rt.Account_Classification__c = accIdClassificationMap.get(rt.Account__c).Classification__c;
                rt.RouteCustUniqueKey__c=String.valueof(rt.Related_Route__c)+String.valueOf(rt.Account__c); 
            }
        }
    }
    
    /* Delete Option we removed form pagelayout 
    public void beforedeletecheckstatus(List<Route__c> routesubmitlist){
      
        String ProfileId = UserInfo.getProfileId(); 
        profile  CPNSP = [SELECT id FROM Profile p WHERE p.name = 'Sales Professional CPN India'] ; 
        for(Route__c r:routesubmitlist){
            if(ProfileId == CPNSP.Id  && (r.OwnerId != userinfo.getUserId())){
                r.AddError(Label.Cres_Route_Delete);
            }
            
        }
    }
    */
}