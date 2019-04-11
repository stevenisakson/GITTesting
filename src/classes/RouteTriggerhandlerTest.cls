/*********************************************************************
Name:RouteTriggerHandlerTest
Date:22 Oct 2018
Description: test Class for Route trigger handler
             
*********************************************************************/

@isTest
private class RouteTriggerhandlerTest{

@testSetup static void dataSetup() {

 //Enable trigger for Route
   Trigger_Settings__c tsr = new Trigger_Settings__c(Route__c = true);
   insert tsr;
    

}


static testMethod void testsubmitForApproval() {

 // Created System Admin user
   User systemAdminUserCPNIndia = TestDataBuilder.createUser(3, TestDataBuilder.getUserProfileId(Label.System_Administrator_Profile));
   systemAdminUserCPNIndia.CAN_Business__c = 'CPN';
   systemAdminUserCPNIndia.Region__c='CPN India';
   systemAdminUserCPNIndia.Business_Unit__c = 'CPN - India';
   systemAdminUserCPNIndia.Country_Code__c = 'IN';
   systemAdminUserCPNIndia.Auto_Validate__c = true; 
   insert systemAdminUserCPNIndia;

  System.runAs(systemAdminUserCPNIndia){
 
 Territory2Model territorymodelid= [Select Id from Territory2Model limit 1];
 Territory2Type territorytype=[SELECT Id FROM Territory2Type limit 1];
   
  // Create test data for standard territory
  
    Territory2 cpnindiaterty = new Territory2();
    cpnindiaterty.Name='CPNINDIATerritory';
    cpnindiaterty.Region__c='CPN India';
    //cpnindiaterty.ParentTerritory2Id ='';
    cpnindiaterty.Territory2ModelId=territorymodelid.id;
    cpnindiaterty.DeveloperName='CPNINDIATerritory';
    cpnindiaterty.Territory2TypeId =territorytype.id;
    insert cpnindiaterty;
  
    Territory2 rsmterty = new Territory2();
    rsmterty.Name='RSMTerritory';
    rsmterty.Region__c='CPN India';
    rsmterty.ParentTerritory2Id = cpnindiaterty.id;
    rsmterty.Territory2ModelId=territorymodelid.id;
    rsmterty.DeveloperName='RSMTerritory';
    rsmterty.Territory2TypeId =territorytype.id;
 
    insert rsmterty ;
    
    Territory2 asmterty = new Territory2();
    asmterty.Name='ASMTerritory';
    asmterty.Region__c='CPN India';
    asmterty.ParentTerritory2Id = rsmterty.id;
    asmterty.Territory2ModelId=territorymodelid.id; 
    asmterty.DeveloperName='ASMTerritory';
    asmterty.Territory2TypeId =territorytype.id;
    insert asmterty;
    
    Territory2 vsaterty = new Territory2();
    vsaterty.Name='VSATerritory';
    vsaterty.Region__c='CPN India';
    vsaterty.ParentTerritory2Id = asmterty.id;
    vsaterty.Territory2ModelId=territorymodelid.id;
    vsaterty.DeveloperName='VSATerritory';
    vsaterty.Territory2TypeId =territorytype.id;
    insert vsaterty;
   
  
   User vsausr = TestDataBuilder.createUser(2, TestDataBuilder.getUserProfileId(Label.Sales_Professional_CPN_India_Profile) );
   vsausr.CAN_Business__c = 'CPN';
   vsausr.Region__c='CPN India';
   vsausr.Business_Unit__c = 'CPN - India';
   vsausr.Country_Code__c = 'IN';
   insert vsausr; 
    
    
// Create test data for Territory user association

   UserTerritory2Association usrtrasn = new UserTerritory2Association();
   usrtrasn.Territory2Id= vsaterty.id;
   usrtrasn.UserId=vsausr.id;
  // usrtrasn.Territory2Id=asmterty.id;
  //usrtrasn.Territory2.ParentTerritory2Id=asmterty.id;
  
  insert usrtrasn;
   
   UserTerritory2Association usrtrasn2 = new UserTerritory2Association();
   usrtrasn2.Territory2Id= asmterty.id;
   usrtrasn2.UserId=vsausr.id;
  // usrtrasn2.Territory2Id=rsmterty.id;
  //usrtrasn2.Territory2.ParentTerritory2Id=rsmterty.id;
  
  insert usrtrasn2;
   
   UserTerritory2Association usrtrasn3 = new UserTerritory2Association();
   usrtrasn3.Territory2Id= rsmterty.id;
   usrtrasn3.UserId=vsausr.id;
  // usrtrasn3.Territory2Id=cpnindiaterty.id;
  //usrtrasn3.Territory2.ParentTerritory2Id=rsmterty.id;
  
  insert usrtrasn3;
      
   //Create test data for custom territory

    Target__c trg =new Target__C();
    trg.Name='TestTargetRecord';
    //trg.Employee_Link_To__c=vsausr.id;
    trg.Employee_Link_To__c=vsausr.id;
    trg.Territory_Id__c=vsaterty.id;
   // trg.ownerID=vsausr.id;
   // trg.ownerID=systemAdminUserCPNIndia.id;
    insert trg;
  
    
    
// Account creation

    Account acct = TestDataBuilder.createAccount();
    acct.RecordTypeId = TestDataBuilder.getObjectRecordTypeId(Account.SObjectType,Label.Standard_Record_Type);
    acct.Business__c='CPN - India';
    //acct.Type='Chemist';
    acct.Classification__c ='Platinum';
    try{
    insert acct;}
    catch(Exception ex){}
   
   
 // Route creation
 
     Route__c rt=new Route__c();
     rt.RecordTypeId =Schema.SObjectType.Route__c.getRecordTypeInfosByName().get(Label.Route_Record_Type).getRecordTypeId();
     rt.Name='TRT1';
     rt.Name__c='TestRoute';
     rt.Territory__c=trg.id;
    
      Test.startTest();
          insert rt;
      Test.stopTest(); 
   
  } 

}

static testMethod void testApprovalprocess(){

    
 // Created System Admin user
   User systemAdminUserCPNIndia = TestDataBuilder.createUser(5, TestDataBuilder.getUserProfileId(Label.System_Administrator_Profile));
   systemAdminUserCPNIndia.CAN_Business__c = 'CPN';
   systemAdminUserCPNIndia.Region__c='CPN India';
   systemAdminUserCPNIndia.Business_Unit__c = 'CPN - India';
   systemAdminUserCPNIndia.Country_Code__c = 'IN';
   systemAdminUserCPNIndia.Auto_Validate__c = true;
   insert systemAdminUserCPNIndia;
    
    system.debug('User Details-->'+ systemAdminUserCPNIndia);

  System.runAs(systemAdminUserCPNIndia){
 
 Territory2Model territorymodelid= [Select Id from Territory2Model limit 1];
 Territory2Type territorytype=[SELECT Id FROM Territory2Type limit 1];
   
  // Create test data for standard territory
  
    Territory2 cpnindiaterty = new Territory2();
    cpnindiaterty.Name='CPNINDIATerritory';
    cpnindiaterty.Region__c='CPN India';
    //cpnindiaterty.ParentTerritory2Id ='';
    cpnindiaterty.Territory2ModelId=territorymodelid.id;
    cpnindiaterty.DeveloperName='CPNINDIATerritory';
    cpnindiaterty.Territory2TypeId =territorytype.id;
    insert cpnindiaterty;
  
    Territory2 rsmterty = new Territory2();
    rsmterty.Name='RSMTerritory';
    rsmterty.Region__c='CPN India';
    rsmterty.ParentTerritory2Id = cpnindiaterty.id;
    rsmterty.Territory2ModelId=territorymodelid.id;
    rsmterty.DeveloperName='RSMTerritory';
    rsmterty.Territory2TypeId =territorytype.id;
 
    insert rsmterty ;
    
    Territory2 asmterty = new Territory2();
    asmterty.Name='ASMTerritory';
    asmterty.Region__c='CPN India';
    asmterty.ParentTerritory2Id = rsmterty.id;
    asmterty.Territory2ModelId=territorymodelid.id; 
    asmterty.DeveloperName='ASMTerritory';
    asmterty.Territory2TypeId =territorytype.id;
    insert asmterty;
    
    Territory2 vsaterty = new Territory2();
    vsaterty.Name='VSATerritory';
    vsaterty.Region__c='CPN India';
    vsaterty.ParentTerritory2Id = asmterty.id;
    vsaterty.Territory2ModelId=territorymodelid.id;
    vsaterty.DeveloperName='VSATerritory';
    vsaterty.Territory2TypeId =territorytype.id;
    insert vsaterty;
   
      
  
   User vsausr1 = TestDataBuilder.createUser(2, TestDataBuilder.getUserProfileId(Label.Sales_Professional_CPN_India_Profile) );
   vsausr1.CAN_Business__c = 'CPN';
   vsausr1.Region__c='CPN India';
   vsausr1.Business_Unit__c = 'CPN - India';
   vsausr1.Country_Code__c = 'IN';
   insert vsausr1; 
      
   User asmusr = TestDataBuilder.createUser(3, TestDataBuilder.getUserProfileId(Label.Sales_Professional_CPN_India_Profile) );
   asmusr.CAN_Business__c = 'CPN';
   asmusr.Region__c='CPN India';
   asmusr.Business_Unit__c = 'CPN - India';
   asmusr.Country_Code__c = 'IN';
   insert asmusr;    
   
   User rsmusr = TestDataBuilder.createUser(4, TestDataBuilder.getUserProfileId(Label.Sales_Professional_CPN_India_Profile) );
   rsmusr.CAN_Business__c = 'CPN';
   rsmusr.Region__c='CPN India';
   rsmusr.Business_Unit__c = 'CPN - India';
   rsmusr.Country_Code__c = 'IN';
   insert rsmusr;    
    
    
// Create test data for Territory user association

   UserTerritory2Association usrtrasn = new UserTerritory2Association();
   usrtrasn.Territory2Id= vsaterty.id;
   usrtrasn.UserId=vsausr1.id;
  // usrtrasn.Territory2Id=asmterty.id;
  //usrtrasn.Territory2.ParentTerritory2Id=asmterty.id;
  
  insert usrtrasn;
   
   UserTerritory2Association usrtrasn2 = new UserTerritory2Association();
   usrtrasn2.Territory2Id= asmterty.id;
   usrtrasn2.UserId=asmusr.id;
  // usrtrasn2.Territory2Id=rsmterty.id;
  //usrtrasn2.Territory2.ParentTerritory2Id=rsmterty.id;
  
  insert usrtrasn2;
   
   UserTerritory2Association usrtrasn3 = new UserTerritory2Association();
   usrtrasn3.Territory2Id= rsmterty.id;
   usrtrasn3.UserId=rsmusr.id;
  // usrtrasn3.Territory2Id=cpnindiaterty.id;
  //usrtrasn3.Territory2.ParentTerritory2Id=rsmterty.id;
  
  insert usrtrasn3;
   
   
  // Create VSA user 

   // User usr = TestDataBuilder.createUser(1, TestDataBuilder.getUserProfileId('Data Steward - CPN India') );
   // usr.CAN_Business__c = 'CPN';
   // usr.Region__c='CPN India';
  //  usr.Business_Unit__c = 'CPN-India';
   // usr.Country_Code__c = 'IN';
   // insert usr;
    
   
     
   
   //Create test data for custom territory

    Target__c trg =new Target__C();
    trg.Name='VSATerritory';
    trg.Employee_Link_To__c=vsausr1.id;
    trg.Territory_Id__c=vsaterty.id;
    //trg.ownerID=vsausr.id;
    insert trg;
    system.debug('Target record id:' + trg.id);
// Account creation

    Account acct = TestDataBuilder.createAccount();
    acct.RecordTypeId = TestDataBuilder.getObjectRecordTypeId(Account.SObjectType,Label.Standard_Record_Type);
    acct.Business__c='CPN-India';
   // acct.Type='Chemist';
    acct.Classification__c ='Platinum';
    acct.Status__c='Approved';
    acct.account_type__c='Standard';
    //acct.Number_Of_Platinum_Customers__c=1;
    
    insert acct;
      
      Account acct1 = TestDataBuilder.createAccount();
      acct1.Name = 'Test Acc Second';
    acct1.RecordTypeId = TestDataBuilder.getObjectRecordTypeId(Account.SObjectType,Label.Standard_Record_Type);
    acct1.Business__c='CPN-India';
   // acct.Type='Chemist';
    acct1.Classification__c ='Gold';
    acct1.Status__c='Approved';
    acct1.account_type__c='Standard';
    //acct.Number_Of_Platinum_Customers__c=1;
    
    insert acct1;
      
   system.debug('Inserted Account-->'+ acct);
      
      Account a=[Select Id, name, status__c from Account where id=:acct.id];
      
    system.debug('Account status-->'+ a);
         
    // Route creation
  
 
     Route__c rt=new Route__c();
     rt.Name='TRT1';
     rt.Name__c='TestRoute';
     rt.RecordTypeId =Schema.SObjectType.Route__c.getRecordTypeInfosByName().get(Label.Route_Record_Type).getRecordTypeId();
     rt.Territory__c=trg.id;
     rt.ownerid =  vsausr1.id;
     rt.Status__c = 'New';
     rt.Submitted_For_Approval__c=False;
     //rt.Account__c=a.id;
    // rt.Related_Route__c=rtc.id;
   // rt.Number_Of_Diamond_Customers__c=1;
     insert rt;
   
  Route__c rtt = [select Total_No_of_Customers_on_Route__c,id,status__c from Route__c where id=:rt.Id]; 
      
    system.debug('Total No of customers before-->'+ rtt.Total_No_of_Customers_on_Route__c);
     
     Route__c rtc=new Route__c();
     rtc.RecordTypeId =Schema.SObjectType.Route__c.getRecordTypeInfosByName().get(Label.Route_Customer_Record_Type).getRecordTypeId();
     rtc.Account__c=acct.id;
     rtc.Related_Route__c=rt.id;
     rtc.Account_Classification__c='Platinum';
    
      
      Test.startTest();
      
        insert rtc;
       
        // System.debug('in submit route custmer id'+rtc.id);
        system.debug('Route Customer classification-->'+ rtc.Account_Classification__c);
         System.debug('in submit route Id'+rt.id);
       //  System.debug('in submit related Id'+rtc.Related_Route__c);
          Route__c rttUpdt = [select Total_No_of_Customers_on_Route__c,id,status__c from Route__c where id=:rt.Id]; 
         System.debug(' Total Customer-->'+ rttUpdt.Total_No_of_Customers_on_Route__c);
          rttUpdt.Status__c='Submit for Approval';
          update rttUpdt;
      Route__C rc=[Select Id from Route__c where id=:rtc.id];
      rc.Account__c=acct1.id;
      rc.Account_Classification__c='Gold';
      update rc;
      delete rc;          
      Test.stopTest(); 
   
  } 
    


}

}