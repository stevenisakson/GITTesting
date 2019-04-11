/*@description: A class to test the TerritoryNameUpdate apex class.
 *@author: Regina Victoria L. Ligan 
 *@date created: 9/01/2016
 *@history: 9/01/2016 - created
 */

@isTest
private class TerritoryNameUpdateTest {
   
    @testSetup
    Static void dataForTerritoryNameUpdateTest(){
        
        id profID = [Select id from profile where name = 'System Administrator'].id;
        
        User u = new user();
        u.LastName = 'Test Code';
        u.Email = 'test@test.com';
        u.Alias = 'Tcode';
        u.Username = 'test1234444@testcargill.com';
        u.CommunityNickname = 'test12';
        u.LocaleSidKey = 'en_US';
        u.TimeZoneSidKey = 'GMT';
        u.ProfileID = profID;
        u.LanguageLocaleKey = 'en_US';
        u.EmailEncodingKey = 'UTF-8';
        insert u;
        
        List<Territory2Model> T2M = new list<Territory2Model>();
        T2M.add(new Territory2Model(Name = 'T2M1', DeveloperName = 'Dev1'));
        insert T2M;
        
        list<Territory2Type> terriType   = [SELECT id, DeveloperName from Territory2Type where  DeveloperName = 'Global_Sales_Territory_Type'];
        
        system.runAs(u){
        
        List<CDH_Territory__c> CDHTerr = new List<CDH_Territory__c>();
        CDHTerr.add(new CDH_Territory__c(CDH_Territory_Name__c = 'Test Territory 1'));
        CDHTerr.add(new CDH_Territory__c(CDH_Territory_Name__c = 'Test Territory 2'));
        CDHTerr.add(new CDH_Territory__c(CDH_Territory_Name__c = 'Test territory 3'));
        insert CDHTerr;
        
        //Create list of  Territory2
        List<Territory2> terr = new List<Territory2>();
        terr.add(new Territory2(Name = 'reg:Territory One', Legacy_CDH_Territory_Id__c = CDHTerr[0].Id, Description = '', External_Territory_ID__c = '1', Territory2ModelId = T2M[0].Id, DeveloperName = 'Dev1', Territory2TypeId = terriType[0].id ));
        terr.add(new Territory2(Name = 'reg:Territory Two',Legacy_CDH_Territory_Id__c = CDHTerr[1].Id, Description = '', External_Territory_ID__c = '2',  Territory2ModelId = T2M[0].Id, DeveloperName = 'Dev2', Territory2TypeId = terriType[0].id));
        terr.add(new Territory2(Name = 'reg:Territory Three', Legacy_CDH_Territory_Id__c = CDHTerr[2].Id, Description = '', External_Territory_ID__c = '3', Territory2ModelId = T2M[0].Id, DeveloperName = 'Dev3', Territory2TypeId = terriType[0].id));
        terr.add(new Territory2(Name = 'reg:Territory Four', Legacy_CDH_Territory_Id__c = CDHTerr[2].Id, Description = '', External_Territory_ID__c = '4', Territory2ModelId = T2M[0].Id, DeveloperName = 'Dev4', Territory2TypeId = terriType[0].id));
        insert terr;
        }
        
    }
    
    @isTest static void TerritoryNameUpdate(){
        
        Test.startTest();
        TerritoryNameUpdate TNUpdate = new TerritoryNameUpdate();
        
        List<Territory2> ter = [Select Description FROM Territory2 WHERE Name = 'reg:Territory One'];
        system.assertEquals(ter.size(), 1);
        system.assertEquals(ter[0].Description, null);
        Database.executeBatch(TNUpdate);
        Test.stopTest();
        List<Territory2> ter1 = [Select Description FROM Territory2 WHERE Name = 'reg:Territory One'];
        system.assertEquals(ter1.size(), 0);
        List<Territory2> ter2 = [Select Description FROM Territory2 WHERE id =: ter[0].id];
        system.assertEquals(ter2[0].Description, 'Test Territory 1');
        
    }

}