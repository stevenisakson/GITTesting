/*
Author              : Tumish Tak
Email               : Tumish.Tak@cognizant.com
Company             : Cognizant Technology Solutions
Date Created        : 26-Dec-2016
Description         : Handler class to get the value of Frontline Marketing Coodinator on basis of respective Territory FMC and Populate Assigned to field of PG.
Modified By         : Tumish Tak
Modified Date       : 2-Feb-2017
*/

public class ACN_ProjectGroupTriggerHandler
{
    Public List<Project_Group__c> projGroupLst;
    public Map<String,CFR_Project_Group_Assignment__c> userList= CFR_Project_Group_Assignment__c.getAll(); // fetching Userid's from Custom setting.
       
    
    
    /*
    
    public void beforeInsert(List<Project_Group__c> projGroupList) 
    {
        list<id> accountidlistFMC = new list<id>();
        set<id> accountidsetNFMC = new set<id>();
        projGroupLst = projGroupList;
        map<id,id> projgrpmap = new map <id,id>();
        
        for(Project_Group__c pg : projGroupList)
        {
            if(pg.Account__c == Label.Cargill_Account_Id)
            {   if(pg.Sales_Consultant_New__c != null){
                accountidlistFMC.add(pg.Sales_Consultant_New__c);
            }       
             
            } else {
                accountidsetNFMC.add(pg.Account__c);
            }
        }
        
        map<id,id> accountIdNFMCMap = new map<id,id> ();
        map<id,id> accountIdFMCMap = new map<id,id> ();
        
        if(!accountidlistFMC.isEmpty()){            
            accountIdFMCMap = CargillFMC(accountidlistFMC);
            system.debug('cargillFMC return ' + accountIdFMCMap);
        }
        
        if(!accountidsetNFMC.isEmpty()){            
            accountIdNFMCMap = nonCargillFMC(accountidsetNFMC);
            system.debug('noncargillFMC return ' + accountIdNFMCMap);
        }
        
        //if(!accountIdFMCMap.isEmpty() || !accountIdNFMCMap.isEmpty()){
        for(Project_Group__c pg : projGroupList)
        {
            system.debug('Acccount Id ' + pg.Account__c + ' Label Cargill ' + Label.Cargill_Account_Id);
            if(pg.Account__c == Label.Cargill_Account_Id && accountIdFMCMap.containskey(pg.Sales_Consultant_New__c)){
                pg.Assigned_To__c = accountIdFMCMap.get(pg.Sales_Consultant_New__c);                      
            } else if(pg.Account__c != Label.Cargill_Account_Id && accountIdNFMCMap.containskey(pg.Account__c)){
                pg.Assigned_To__c = accountIdNFMCMap.get(pg.Account__c);
            } else{
                id tempid = Label.Patty_Young_Id;
                pg.Assigned_To__c =tempid;
            }
        }
        
        //}  
    }
    
    public map<id,id> cargillFMC(List<Id> userIDList)
    {
        List<UserTerritory2Association> UerTerAssoList = new List<UserTerritory2Association>([Select UserId, Territory2Id 
                                                                                              from UserTerritory2Association
                                                                                              where UserId IN: userIDList]);
        map<id,id> usrterrmap = new map<id,id>(); 
        List<Territory2> terriNameList;
        map<id,id> usridfmcmap = new map<id,id>();
        if(!UerTerAssoList.isEmpty()){
            for(UserTerritory2Association ua:UerTerAssoList){
                usrterrmap.put(ua.Userid,ua.Territory2Id);         
            }            
            
            terriNameList = new List<Territory2>([Select Id, Name, ParentTerritory2Id from Territory2 where Id IN: usrterrmap.values()]);           
            map<id,string> ternameidmap = new map<id,string>();          
            if(!terriNameList.isEmpty()){
                for(Territory2 te:terriNameList){
                    ternameidmap.put(te.id,te.name);
                } 
            }                      
            Map<String, FMC_Territory_Mapping__c> FMCMap =  new Map<String, FMC_Territory_Mapping__c> (FMC_Territory_Mapping__c.getAll());
            
            for(id u:usrterrmap.keyset()){
                if(usrterrmap.containskey(u) && ternameidmap.containskey(usrterrmap.get(u)) && FMCMap.containskey(ternameidmap.get(usrterrmap.get(u))) && string.isNotBlank(FMCMap.get(ternameidmap.get(usrterrmap.get(u))).FMC_User_ID__c)){
                    usridfmcmap.put(u,FMCMap.get(ternameidmap.get(usrterrmap.get(u))).FMC_User_ID__c );
                } else if(usrterrmap.containskey(u) && ternameidmap.containskey(usrterrmap.get(u)) && FMCMap.containskey(ternameidmap.get(usrterrmap.get(u))) && string.isBlank(FMCMap.get(ternameidmap.get(usrterrmap.get(u))).FMC_User_ID__c) && string.isNotBlank(FMCMap.get(FMCMap.get(ternameidmap.get(usrterrmap.get(u))).Parent_Territory_Name__c).FMC_User_ID__c)) {
                    usridfmcmap.put(u,FMCMap.get(FMCMap.get(ternameidmap.get(usrterrmap.get(u))).Parent_Territory_Name__c).FMC_User_ID__c);
                } else {
                    id tempid = Label.Patty_Young_Id;
                    usridfmcmap.put(u,tempid);
                }
            }
            
        } else {
            id tempid = Label.Patty_Young_Id;
            for(id u:usrterrmap.keyset()){
                usridfmcmap.put(u,tempid);
            }
        }
        return usridfmcmap; 
    }
    
    public map<Id,Id> nonCargillFMC(set<id> accIDset)
    {
        List<ObjectTerritory2Association> accTerritoryList = new list<ObjectTerritory2Association>([Select Territory2Id, ObjectId 
                                                                                                    from ObjectTerritory2Association
                                                                                                    where ObjectId IN: accIDset]);
        
        set<id> territoryIdset = new set<id>();
        map<id,id> objterrimap = new map<id,id>();
        map<id,id> accountusderidmap = new map<id,id>();
        
        if(!accTerritoryList.isEmpty()){
            for(ObjectTerritory2Association ob:accTerritoryList){
                territoryIdset.add(ob.Territory2Id);
                objterrimap.put(ob.ObjectId,ob.Territory2Id);
            }
            system.debug('territoryId set ' + territoryIdset + 'objterrimap ' + objterrimap);
            
            List <Territory2> territoryList;
            if(!territoryIdset.isEmpty()){
                territoryList = new List<Territory2>([Select Id,Name,ParentTerritory2Id
                                                      from Territory2
                                                      where Id IN: territoryIdset]);
            }
            
            List <Territory2> parentterritoryList;
            map<id,string> terrinamemap = new map<id,string>();
            
            if(!territoryList.isEmpty()){
                for(Territory2 tt: territoryList){
                    terrinamemap.put(tt.id, tt.name);                                 
                }
            }
            //system.debug('terrinameid map  ' + terrinameidmap);
            
            Map<String, FMC_Territory_Mapping__c> FMCMap =  new Map<String, FMC_Territory_Mapping__c> (FMC_Territory_Mapping__c.getAll());
            
            for(id i:accIDset){
                
                system.debug('FMC Territory ' + FMCMap.get(terrinamemap.get(objterrimap.get(i))).FMC_User_ID__c);
                
                if(objterrimap.containskey(i) && terrinamemap.containskey(objterrimap.get(i)) && String.isNotBlank(FMCMap.get(terrinamemap.get(objterrimap.get(i))).FMC_User_ID__c)){            
                    accountusderidmap.put(i,FMCMap.get(terrinamemap.get(objterrimap.get(i))).FMC_User_ID__c);
                } else if(objterrimap.containskey(i) && terrinamemap.containskey(objterrimap.get(i)) && String.isBlank(FMCMap.get(terrinamemap.get(objterrimap.get(i))).FMC_User_ID__c) && string.isNotBlank(FMCMap.get(FMCMap.get(terrinamemap.get(objterrimap.get(i))).Parent_Territory_Name__c).FMC_User_ID__c)){
                    accountusderidmap.put(i,FMCMap.get(FMCMap.get(terrinamemap.get(objterrimap.get(i))).Parent_Territory_Name__c).FMC_User_ID__c);
                }else{
                    id tempid = Label.Patty_Young_Id;
                    accountusderidmap.put(i,tempid);
                }    
            }
        }
        else{
            for(id i:accIDset){
                id tempid = Label.Patty_Young_Id;
                accountusderidmap.put(i,tempid);
            }
        }
        return accountusderidmap;
    } */
    
 public void projectOwnerUpdate(List<Project_Group__c> projgrplst, Boolean Updateflag){
        
     List<Project_Group__c> projgrpUpdatelst= new List<Project_Group__c>();
     Map<Project_Group__c,Id> ProjectGrpAcccountIDMap = new Map<Project_Group__c,Id>();
     //set<id> Accountid = new set<id>();
     //List<Project__c>projUpdatelst=new List<Project__c>();//child 
     for(Project_Group__c prjgrp: projgrplst){
         if(prjgrp.Account__c != null){
             ProjectGrpAcccountIDMap.put(prjgrp, prjgrp.Account__c);
             //Accountid.add()
         }
    }
     //List <Project_Group__c> projectlst=[Select Id, Assigned_To__c, Account__r.Name, Account__r.Account_Record_Type__c,Account__r.Segment_Step_1__c,(Select Project_Sub_Type__c from Projects__r) from Project_Group__c where Id IN: projgrplst];
     
     Map<Id,Account> AccountMap = new Map<Id,Account>([Select Id,Account_Record_Type__c,Segment_Step_1__c,Account_Type__c From Account Where Id IN: ProjectGrpAcccountIDMap.values()]);
     //System.debug('Project group List'+projectlst);
     
     for(Project_Group__c projgrp: ProjectGrpAcccountIDMap.Keyset()){
         if(projgrp.Account__c != null){
                Account ac = new Account();
                ac = AccountMap.get(ProjectGrpAcccountIDMap.get(projgrp)); 
                system.debug('@@@@ ' + ac.Account_Type__c);
                system.debug('@@@ ' + ac.Account_Record_Type__c);     
             if(ac.Account_Type__c==Label.Commercial_Customer_Record_Type || ac.Account_Type__c==Label.Standard_Record_Type){
             if(ac.Segment_Step_1__c==Label.CFR_Baxter){
                 projgrp.Assigned_To__c=userList.get(Label.CFR_Commercial_Customer_Baxter).Assigned_To__C;
                 system.debug('@@#@# ' + projgrp.Assigned_To__c);
                 projgrpUpdatelst.add(projgrp);
                
             } 
             else{
                   
                 projgrp.Assigned_To__c=userList.get(Label.CFR_Commercial_Customer_Non_Baxter).Assigned_To__C;
                  System.debug('InsideCommercial Non Baxter'+ projgrp.Assigned_To__c);
                 projgrpUpdatelst.add(projgrp);
             }
         }
         else if(ac.Account_Type__c==Label.Consumer_Record_Type){
                if(ac.Segment_Step_1__c==Label.CFR_Baxter){
                   projgrp.Assigned_To__c=userList.get(Label.CFR_Consumer_Baxter).Assigned_To__C;
                   projgrpUpdatelst.add(projgrp);
             } 
             else{
                 projgrp.Assigned_To__c=userList.get(Label.CFR_Consumer_Non_Baxter).Assigned_To__C;
                 projgrpUpdatelst.add(projgrp);
             } 
         }
        } 
         system.debug('## ' + projgrp.Designate_Payment_Type__c);
         system.debug('##1 ' + Label.CFR_Purchase_Order);
         system.debug('##2 ' + Label.CFR_Credit_Card);
         system.debug('##3 ' + Label.CFR_Budget);
         
         system.debug('##3 ' + Label.CFR_Budget);
         system.debug('##3 Label Budget_Name_ ' + Label.CFR_GEM);
          system.debug('##3 Label Budget_Name_ ' + Label.CFR_Business_Builder);
         system.debug('Budget_Name_' + projgrp.Budget_Name__c);
         
         
         
         if((projgrp.Designate_Payment_Type__c == Label.CFR_Purchase_Order) || (projgrp.Designate_Payment_Type__c == Label.CFR_Credit_Card)){
           //  projgrp.Status__c = Label.CFR_Work_Complete;
         }
         if(projgrp.Designate_Payment_Type__c == Label.CFR_Budget){ 
              system.debug('##@ ');
             if ((projgrp.Budget_Name__c == Label.CFR_GEM) || (projgrp.Budget_Name__c == Label.CFR_Business_Builder)) {
                 system.debug('##@$');
                //    projgrp.Status__c = Label.CFR_Delivered_Invoicing;
             } else{
                 system.debug('##@$^');
               //  projgrp.Status__c = Label.CFR_Work_Complete;
            }
        }     
     }
     
     System.debug('Update lst record'+ projgrpUpdatelst);
     
     if(!projgrpUpdatelst.isempty() && Updateflag) {
         update projgrpUpdatelst;
         
     }
 }
  /*
    public void projectGroupBeforeInsert(List<Project_Group__c> projgrplst){ 
        for(Project_Group__c pg:projgrplst){
            
            if(pg.Account__r.Account_Record_Type__c==Label.Commercial_Customer_Record_Type || pg.Account__r.Account_Record_Type__c==Label.Standard_Record_Type){
                if(pg.Account__r.Segment_Step_1__c==Label.CFR_Baxter){
                    pg.Assigned_To__c=userList.get(Label.CFR_Commercial_Customer_Baxter).Assigned_To__C;   
                } 
                else{
                    pg.Assigned_To__c=userList.get(Label.CFR_Commercial_Customer_Non_Baxter).Assigned_To__C;
                    
                }
            } 
            
            else if(pg.Account__r.Account_Record_Type__c==Label.Consumer_Record_Type){
                if(pg.Account__r.Segment_Step_1__c==Label.CFR_Baxter){
                    pg.Assigned_To__c=userList.get(Label.CFR_Consumer_Baxter).Assigned_To__C;
                    
                } 
                else{
                    pg.Assigned_To__c=userList.get(Label.CFR_Consumer_Non_Baxter).Assigned_To__C;
    
                } 
            }
         
        }    
    } */
}