/*
    @Author             : Tumish Tak (CBS Team)
    @Date Created       : 12-Nov-2018
    @Description        : Test class for TargetTriggerHandler
*/
@isTest
public class TargetTriggerHandlerTest {
    @testSetup static void dataSetup() {
      //Enable trigger for DCR
        Trigger_Settings__c ts = new Trigger_Settings__c(Target__c = true);
        insert ts;
        
        User usr1 = new User(Alias = 'CSUsr1',
            Email = 'CSUsr1@cs.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'CS1',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            ProfileId = TestDataBuilder.getUserProfileId('System Administrator'),
            TimeZoneSidKey = 'America/Los_Angeles',
            UserName = 'CSUsr1@CS.com.org',
            Region__c='CPN India',
            Business_Unit__c = 'CPN - India',
            Country_Code__c = 'IN',
            CAN_Business__c = 'CPN',
            Primary_Contact_Language__c = 'English',
            isActive = true); 
            insert usr1;
        
        User usr2 = new User(Alias = 'CSUsr2',
            Email = 'CSUsr2@cs.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'CS2',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            ProfileId = TestDataBuilder.getUserProfileId('System Administrator'),
            TimeZoneSidKey = 'America/Los_Angeles',
            UserName = 'CSUsr2@CS.com.org',
            Region__c='CPN India',
            Business_Unit__c = 'CPN - India',
            Country_Code__c = 'IN',
            CAN_Business__c = 'CPN',
            Primary_Contact_Language__c = 'English',
            isActive = true); 
            insert usr2;
        
         User usr3 = new User(Alias = 'CSUsr3',
            Email = 'CSUsr3@cs.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'CS3',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            ProfileId = TestDataBuilder.getUserProfileId('System Administrator'),
            TimeZoneSidKey = 'America/Los_Angeles',
            UserName = 'CSUsr3@CS.com.org',
            Region__c='CPN India',
            Business_Unit__c = 'CPN - India',
            Country_Code__c = 'IN',
            CAN_Business__c = 'CPN',
            Primary_Contact_Language__c = 'English',
            isActive = true);  
            insert usr3;   
        
    }
    static testMethod void testBeforeInsert() {
        
        User usr = [select Id from User where LastName = 'CS1'];
        system.runAs(usr) {
        //create Standard Territoy Obj Record
        Territory2 stndTerr1 = new Territory2();
        stndTerr1.AccountAccessLevel = 'Read';
        stndTerr1.Name = 'Test CPN India Territory1';
        stndTerr1.DeveloperName = 'Test_CPN_India_Territory1';
        stndTerr1.OpportunityAccessLevel = 'Read';
        stndTerr1.Territory2ModelId='0MAj0000000Kz5pGAC';
        stndTerr1.Territory2TypeId='0M5j0000000KymKCAS';
        stndTerr1.Region__c = 'CPN India';
        insert stndTerr1;
            
        Territory2 stndTerr21 = new Territory2();
        stndTerr21.AccountAccessLevel = 'Read';
        stndTerr21.Name = 'Test CPN India Territory1.1';
        stndTerr21.DeveloperName = 'Test_CPN_India_Territory1_1';
        stndTerr21.ParentTerritory2Id = stndTerr1.Id;
        stndTerr21.OpportunityAccessLevel = 'Read';
        stndTerr21.Territory2ModelId='0MAj0000000Kz5pGAC';
        stndTerr21.Territory2TypeId='0M5j0000000KymKCAS';
        stndTerr21.Region__c = 'CPN India';
        insert stndTerr21;
            
        Territory2 stndTerr31 = new Territory2();
        stndTerr31.AccountAccessLevel = 'Read';
        stndTerr31.Name = 'Test CPN India Territory1.2';
        stndTerr31.DeveloperName = 'Test_CPN_India_Territory1_2';
        stndTerr31.ParentTerritory2Id = stndTerr21.Id;
        stndTerr31.OpportunityAccessLevel = 'Read';
        stndTerr31.Territory2ModelId='0MAj0000000Kz5pGAC';
        stndTerr31.Territory2TypeId='0M5j0000000KymKCAS';
		stndTerr31.Region__c = 'CPN India';
        insert stndTerr31;
        
        //create UserTerritory2Association Record
        UserTerritory2Association usrTerrAssoc = new UserTerritory2Association();
        usrTerrAssoc.Territory2Id = stndTerr1.Id;
        usrTerrAssoc.UserId = usr.Id;
        insert usrTerrAssoc;
            
        UserTerritory2Association usrTerrAssoc31 = new UserTerritory2Association();
        usrTerrAssoc31.Territory2Id = stndTerr31.Id;
        usrTerrAssoc31.UserId = usr.Id;
        insert usrTerrAssoc31;
            
        UserTerritory2Association usrTerrAssoc21 = new UserTerritory2Association();
        usrTerrAssoc21.Territory2Id = stndTerr21.Id;
        usrTerrAssoc21.UserId = usr.Id;
        insert usrTerrAssoc21;
        
        //create Target (custom Territory) Obj record 
        Target__c custTerr = new Target__c();
        custTerr.Name = 'Test CPN India Territory1.2';
        custTerr.Employee_Link_To__c = usr.Id;
        insert custTerr;
        
        }
    }
    
     static testMethod void testBeforeUpdate() {
        
       User user2 = [select Id from User where LastName = 'CS2']; 
       User user3 = [select Id from User where LastName = 'CS3'];
       Map<Id,Target__c> newTargetMap = new Map<Id,Target__c>();
       Map<Id,Target__c> oldTargetMap = new Map<Id,Target__c>();
       
       system.runAs(user2) {
        //create Standard Territoy Obj Record
        Territory2 stndTerr2 = new Territory2();
        stndTerr2.AccountAccessLevel = 'Read';
        stndTerr2.Name = 'Test CPN India Territory2';
        stndTerr2.DeveloperName = 'Test_CPN_India_Territory2';
        stndTerr2.OpportunityAccessLevel = 'Read';
        stndTerr2.Territory2ModelId='0MAj0000000Kz5pGAC';
        stndTerr2.Territory2TypeId='0M5j0000000KymKCAS';
        stndTerr2.Region__c = 'CPN India';
        insert stndTerr2;
           
        Territory2 stndTerr21 = new Territory2();
        stndTerr21.AccountAccessLevel = 'Read';
        stndTerr21.Name = 'Test CPN India Territory2.1';
        stndTerr21.DeveloperName = 'Test_CPN_India_Territory2_1';
        stndTerr21.ParentTerritory2Id = stndTerr2.Id;
        stndTerr21.OpportunityAccessLevel = 'Read';
        stndTerr21.Territory2ModelId='0MAj0000000Kz5pGAC';
        stndTerr21.Territory2TypeId='0M5j0000000KymKCAS';
        stndTerr21.Region__c = 'CPN India';
        insert stndTerr21;
            
        Territory2 stndTerr31 = new Territory2();
        stndTerr31.AccountAccessLevel = 'Read';
        stndTerr31.Name = 'Test CPN India Territory2.2';
        stndTerr31.DeveloperName = 'Test_CPN_India_Territory2_2';
        stndTerr31.ParentTerritory2Id = stndTerr21.Id;
        stndTerr31.OpportunityAccessLevel = 'Read';
        stndTerr31.Territory2ModelId='0MAj0000000Kz5pGAC';
        stndTerr31.Territory2TypeId='0M5j0000000KymKCAS';
		stndTerr31.Region__c = 'CPN India';
        insert stndTerr31;
            
        system.debug('After Insert standTerr2'+stndTerr2.Territory2ModelId);  
            
        Territory2 stndTerr3 = new Territory2();
        stndTerr3.AccountAccessLevel = 'Read';
        stndTerr3.Name = 'Test CPN India Territor3';
        stndTerr3.DeveloperName = 'Test_CPN_India_Territory3';
        stndTerr3.OpportunityAccessLevel = 'Read';
        stndTerr3.Territory2ModelId='0MAj0000000Kz5pGAC';
        stndTerr3.Territory2TypeId='0M5j0000000KymKCAS';
        stndTerr3.Region__c = 'CPN India';
        insert stndTerr3;
        system.debug('After Insert standTerr3');  
            
        //create UserTerritory2Association Record
        UserTerritory2Association usrTerrAssoc = new UserTerritory2Association();
        system.debug('Stand Terr 2 Id##'+stndTerr2.Id);
        usrTerrAssoc.Territory2Id = stndTerr2.Id;
		system.debug('User 2 Id##'+user2.Id);                     
        usrTerrAssoc.UserId = user2.Id;
        insert usrTerrAssoc;
                   
         UserTerritory2Association usrTerrAssoc2 = new UserTerritory2Association();
        system.debug('Stand Terr 2 Id##'+stndTerr2.Id);
        usrTerrAssoc2.Territory2Id = stndTerr21.Id;
		system.debug('User 2 Id##'+user2.Id);                     
        usrTerrAssoc2.UserId = user2.Id;
        insert usrTerrAssoc2;
         
        UserTerritory2Association usrTerrAssoc3 = new UserTerritory2Association();
        system.debug('Stand Terr 2 Id##'+stndTerr2.Id);
        usrTerrAssoc3.Territory2Id = stndTerr31.Id;
		system.debug('User 2 Id##'+user2.Id);                     
        usrTerrAssoc3.UserId = user2.Id;
        insert usrTerrAssoc3;
       
        system.debug('After Insert userTerAssoc');    
        
        //create Target (custom Territory) Obj record 
        Target__c custTerr = new Target__c();
        	custTerr.Name = 'Test CPN India Territory2.2';
        	custTerr.Employee_Link_To__c = user2.Id;
        insert custTerr;
        
        oldTargetMap.put(custTerr.Id,custTerr);
                
        //Update Target (Custom Territory) object Employee Link To User
        Target__c updcustTerr1= [select id,Previous_LinkTo_Emp__c,Name,Employee_Link_To__c,Territory_Id__c,Previous_Territory_Id__c,ownerid from Target__c where Name = 'Test CPN India Territory2.2'];
         
        Target__c upobj = new Target__c();
            upobj.id = updcustTerr1.id;
            upobj.Name = 'Test CPN India Territory2.2';
            upobj.Employee_Link_To__c = user3.Id;
            upobj.Previous_LinkTo_Emp__c = updcustTerr1.Employee_Link_To__c;
            update upobj; 
        newTargetMap.put(upobj.Id,upobj);
       
           set<Id> tarIdset1 = new set<Id>();
           tarIdset1.add(upobj.id);
       
        TargetTriggerHandler passpararmeter =  new TargetTriggerHandler();
        
         //call before update to change the owner of record
        passpararmeter.beforeUpdate(newTargetMap,oldTargetMap); 
          //call future class method and pass target id set.
        UpdateTerritoryUsers1.updateUserTerrAssoc1(tarIdset1);
           
       //Update Target (Custom Territory) object record Name and Employee Link To User
        Target__c fetchTarget = [select id,Name,Territory_Id__c,Previous_LinkTo_Emp__c,Previous_Territory_Id__c,Employee_Link_To__c,ownerid from Target__c where Name = 'Test CPN India Territory2.2'];
        
        Target__c updcustTerr2 = new Target__c();
        	updcustTerr2.id = fetchTarget.Id;
        	updcustTerr2.Employee_Link_To__c = user2.Id;
        	updcustTerr2.Name = 'Test CPN India Territory3';
            updcustTerr2.Previous_LinkTo_Emp__c = fetchTarget.Employee_Link_To__c;
            updcustTerr2.Previous_Territory_Id__c = fetchTarget.Territory_Id__c;
            updcustTerr2.Territory_Id__c = stndTerr3.Id;
        update updcustTerr2;
        
        Map<Id,Target__c> newTargetMapUpd1 = new Map<Id,Target__c>();
        Map<Id,Target__c> oldTargetMapUpd1 = new Map<Id,Target__c>();
           newTargetMapUpd1.put(updcustTerr2.Id,updcustTerr2); 
		   oldTargetMapUpd1.put(fetchTarget.Id,fetchTarget);
       
           set<Id> tarIdset2 = new set<Id>();
           tarIdset2.add(updcustTerr2.id);
           set<Id> terrOldIdset2 = new set<Id>();
           terrOldIdset2.add(updcustTerr2.Territory_Id__c);
           
       // passpararmeter.stampTerritoryIdUpdate(newTargetMapUpd1,oldTargetMapUpd1); 
        UpdateTerritoryUsers2.updateUserTerrAssoc2(tarIdset2,terrOldIdset2);
        
        //Update Target (Custom Territory) object record Name
        Target__c updcustTerr3 = [select id,Name,Employee_Link_To__c,Previous_LinkTo_Emp__c,Territory_Id__c,Previous_Territory_Id__c,ownerid from Target__c where Name = 'Test CPN India Territory3'];
     
        updcustTerr3.Name = 'Test CPN India Territory2.2';
        updcustTerr3.Previous_LinkTo_Emp__c = updcustTerr3.Employee_Link_To__c;
        updcustTerr3.Previous_Territory_Id__c = updcustTerr3.Territory_Id__c;
        update updcustTerr3;
        Map<Id,Target__c> newTargetMapUpd = new Map<Id,Target__c>();
        Map<Id,Target__c> oldTargetMapUpd = new Map<Id,Target__c>();
        newTargetMapUpd.put(updcustTerr2.Id,updcustTerr2);    
        oldTargetMapUpd.put(upobj.Id,upobj);
        
           set<Id> tarIdset3 = new set<Id>();
           tarIdset3.add(updcustTerr3.id);
           set<Id> terrOldIdset3 = new set<Id>();
           terrOldIdset3.add(updcustTerr3.Territory_Id__c);
        passpararmeter.stampTerritoryIdUpdate(newTargetMapUpd,oldTargetMapUpd);
           //call future class method and pass target id set and territory id set.
        UpdateTerritoryUsers3.updateUserTerrAssoc3(tarIdset3,terrOldIdset3);
      }
    }
}