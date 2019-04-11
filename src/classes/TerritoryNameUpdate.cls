/******************************************************************
** Author: Dipendra Shrestha (Accenture)
** Date: 8-31-16
** Description: A Batch class for updating the Territory Name and description from CDH Territories. This Batch class will created to work around the issue of retaining the Polish Characters. If the data import tool is handling it, this class is not needed.
** -----------------------------------------------------
*******************************************************************/

global class TerritoryNameUpdate implements Database.Batchable<sObject>{

           // Start Method
        global Database.QueryLocator start(Database.BatchableContext BC){
           If(Test.IsRunningTest()){
               return Database.getQueryLocator('Select Id, Legacy_CDH_Territory_Id__c, Name, Description, External_Territory_ID__c from Territory2 where name like \'reg:%\'');
           }
           else{
               return Database.getQueryLocator('Select Id, Legacy_CDH_Territory_Id__c, Name, Description, External_Territory_ID__c from Territory2 where Legacy_CDH_Territory_Id__c <> null');
           }
        }
      
      // Execute Logic
       global void execute(Database.BatchableContext BC, List<sObject>scope){
           
          for (Territory2 Tlist: (list<Territory2>)scope) {            
                  if (Tlist.Legacy_CDH_Territory_Id__c <> ''){
               List<CDH_Territory__c > TerrName = [Select CDH_Territory_Name__c from  CDH_Territory__c where Id =:Tlist.Legacy_CDH_Territory_Id__c limit 1];
               
                Tlist.Name=  TerrName.get(0).CDH_Territory_Name__c ;
                Tlist.Description = TerrName.get(0).CDH_Territory_Name__c;
                }

           }
           update scope;
       }
     
    
    global void finish(Database.BatchableContext BC)
    {
}

            // Logic to be Executed at finish
       }