/*
    Author              : Erick
    Email               : erick.carle.bower@accenture.com
    Company             : Accenture
    Date Created        : 19-OCT-2016
    Description         : Test class for Project Trigger Handler / Story No.64
    Modified By         : -
    Modified Date       : -
*/

@isTest
private class ACN_ProjectTriggerHandlerTest {
  
    public static Project_Group__c pGroup;
    public static Project_Template__c pTemp;
    public static Milestone_List_Library__c mlist;
    
    @testSetup public static void dataSetup() {
    List<User> usrList = new List<User>();   
        
    insert TestDataBuilder.createUser(1, TestDataBuilder.getUserProfileId('Marketing Coordinator'));
	User u = [SELECT Id, Name FROM User LIMIT 1];
        
    User usr2 = TestDataBuilder.createUser(2, TestDataBuilder.getUserProfileId('Marketing Data Steward'));
    //usr2.Username = 'ACNUser2@ACN.com.org';
    
    usrList.add(usr2);    
        
    insert usrList;
        
              Trigger_Settings__c t=new Trigger_Settings__c();
               t.Project__c=true;
               t.Name='test';
               insert t;         
        CFR_Project_Group_Assignment__c prj = new  CFR_Project_Group_Assignment__c();
            prj.Assigned_To__c=usrList[0].id;
            prj.Name='Commercial Customer_Baxter';
            insert prj;
        
    Id acctRecType = TestDataBuilder.getObjectRecordTypeId(Account.sObjectType, 'Commercial Customer'); 
        
     
        
      List<Account> acclst =new List<Account>(); //= TestDataBuilder.createListAccount(acctRecType); 
        
        for(Account a: TestDataBuilder.createListAccount(acctRecType)){
            a.Account_Type__c='Commercial customer';
            a.Segment_Step_1__c = 'Baxter';
            acclst.add(a);
        }
        insert acclst;
        
    Account acct = [SELECT Id, Name FROM Account LIMIT 1];

    insert TestDataBuilder.createListContact(acct.id);
    Contact cont = [SELECT Id, Name FROM Contact LIMIT 1];

    insert TestDataBuilder.createListCampaign();    
    Campaign camp = [SELECT Id, Name FROM Campaign LIMIT 1];

    //insert TestDataBuilder.createListProjectGroup(acct.id, camp.id, cont.id, u.Id);  
    insert TestDataBuilder.createListMilestoneList();
    insert TestDataBuilder.createListProjTemp();
        
         List<Project_Group__c> projgroupRecordList = new List<Project_Group__c>();
        
        for(Integer i=0; i<5; i++){
            projgroupRecordList.add(new Project_Group__c(Account__c = acct.id, 
                                                        Campaign__c = camp.id,
                                                        Customer_Contact__c =cont.id,
                                                        Project_Delivery_Date__c = system.today() + 5 ,
                                                        Project_End_Date__c = system.today() + 7));
                                                 
        }
        insert projgroupRecordList;
       
    }
    
    static testMethod void testdoBeforeInsert(){
        pGroup = [SELECT Id, Name FROM Project_Group__c LIMIT 1];
        pTemp = [SELECT Id, Name FROM Project_Template__c LIMIT 1];
        mlist = [SELECT Id, Name FROM Milestone_List_Library__c LIMIT 1];

        CANQueueMapping__c cqmapping  = new CANQueueMapping__c(Name='Fulfillment', QueueName__c = 'Fulfillment Pod', SubType__c= 'Fulfillment');
        insert cqmapping;
        
        User usr = [Select Id From User Where Profile.Name = 'Marketing Coordinator' AND IsActive = true Limit 1];
        Id standardRecType = TestDataBuilder.getObjectRecordTypeId(Project__c.sObjectType, 'Standard'); 
        
        //System.runAs(usr){
            List<Project__c> projRec = TestDataBuilder.createListProject(pGroup.id, 'Project__c', 'Standard', standardRecType);

            for(Project__c p: projRec){
               p.Project_Sub_Type__c = 'Fulfillment';
            }

            insert TestDataBuilder.createListProjTempMileList(pTemp.Id, mlist.Id);

            Test.startTest();
            try{
                insert projRec;
            }catch(Exception e){
                
            }
            Test.stopTest();
        
        //}
        
    }
    
    static testMethod void testdoBeforeInsert2(){
        pGroup = [SELECT Id, Name, Project_Delivery_Date__c FROM Project_Group__c LIMIT 1];
        pGroup.Project_Delivery_Date__c = null;
        update pGroup;
        
        Id standardRecType = TestDataBuilder.getObjectRecordTypeId(Project__c.sObjectType, 'Standard');
        
        Test.startTest();
        try{
            List<Project__c> projRec = TestDataBuilder.createListProject(pGroup.id, 'Project__c', 'Standard', standardRecType);

            for(Project__c p: projRec){
               p.Project_Sub_Type__c = 'Template Creative';
            }
            
            insert projRec;
        }catch(DmlException ex){
            
        }
        Test.stopTest();
    }
    
    static testMethod void testdoAfterInsert1() {
        pGroup = [SELECT Id, Name FROM Project_Group__c LIMIT 1];
        pTemp = [SELECT Id, Name FROM Project_Template__c LIMIT 1];
        mlist = [SELECT Id, Name FROM Milestone_List_Library__c LIMIT 1];
        
        User usr = [Select Id From User Where Profile.Name = 'Marketing Coordinator' AND IsActive = true Limit 1];
        Id standardRecType = TestDataBuilder.getObjectRecordTypeId(Project__c.sObjectType, 'Standard'); 
        
        //System.runAs(usr){
            List<Project__c> projRec = TestDataBuilder.createListProject(pGroup.id, 'Project__c', 'Standard', standardRecType);
            for(Project__c p: projRec){
               p.Project_Sub_Type__c = 'Coupon'; 
            }
        
        	ptemp = [SELECT Id,Project_Record_Type__c, Project_Sub_Type__c FROM Project_Template__c LIMIT 1];
            ptemp.Project_Record_Type__c = 'Standard';
            ptemp.Project_Sub_Type__c = 'Coupon';
        
            update ptemp;
            
            insert TestDataBuilder.createListProjTempMileList(pTemp.Id, mlist.Id);
     
            Test.startTest();
            try{
                insert projRec;
            }catch(Exception e){
                
            }
            Test.stopTest();
        //}
        
        //Milestone__c m = [SELECT Id, Name, Due_Date__c FROM Milestone__c WHERE Name = 'Order Fulfillment Item'];
        //System.assertEquals(date.Valueof('2016-10-25'),m.Due_Date__c);
     
    }
   
    static testMethod void testdoAfterInsert2() {
        pGroup = [SELECT Id, Name FROM Project_Group__c LIMIT 1];
        pTemp = [SELECT Id, Name FROM Project_Template__c LIMIT 1];
        mlist = [SELECT Id, Name FROM Milestone_List_Library__c LIMIT 1];
        
        User usr = [Select Id From User Where Profile.Name = 'Marketing Data Steward' AND IsActive = true Limit 1];
        Id CustomRecType = TestDataBuilder.getObjectRecordTypeId(Project__c.sObjectType, 'Custom');    

        //System.runAs(usr){
            List<Project__c> projRec = TestDataBuilder.createListProject(pGroup.id, 'Project__c', 'Custom',CustomRecType);
            for(Project__c p: projRec){
                p.Project_Sub_Type__c = 'Custom Creative'; 
            }
        
            ptemp = [SELECT Id,Project_Record_Type__c, Project_Sub_Type__c FROM Project_Template__c LIMIT 1];
            ptemp.Project_Record_Type__c = 'Custom';
            ptemp.Project_Sub_Type__c = 'Custom Creative';
        
            update ptemp;
        
            insert TestDataBuilder.createListProjTempMileList(pTemp.Id, mlist.Id);
            
            Test.startTest();
            try{
                insert projRec;
            }catch(Exception e){
                
            }
            Test.stopTest();
        //}          
    }
    
    static testMethod void testdoAfterInsert3() {
        pGroup = [SELECT Id, Name FROM Project_Group__c LIMIT 1];
        pTemp = [SELECT Id, Name FROM Project_Template__c LIMIT 1];
        mlist = [SELECT Id, Name FROM Milestone_List_Library__c LIMIT 1];
        
        User usr = [Select Id From User Where Profile.Name = 'Marketing Data Steward' AND IsActive = true Limit 1];
        Id CustomRecType = TestDataBuilder.getObjectRecordTypeId(Project__c.sObjectType, 'Custom');    

        //System.runAs(usr){
            List<Project__c> projRec = TestDataBuilder.createListProject(pGroup.id, 'Project__c', 'Custom',CustomRecType);
            for(Project__c p: projRec){
                p.Project_Sub_Type__c = 'Custom Fulfillment'; 
                p.In_Hands_Date_Requested__c = null;
            }
        
            ptemp = [SELECT Id,Project_Record_Type__c, Project_Sub_Type__c FROM Project_Template__c LIMIT 1];
            ptemp.Project_Record_Type__c = 'Custom';
            ptemp.Project_Sub_Type__c = 'Custom Fulfillment';
        
            update ptemp;
        
            insert TestDataBuilder.createListProjTempMileList(pTemp.Id, mlist.Id);
            
            Test.startTest();
            try{
                insert projRec;
            }catch(Exception e){
                
            }
            Test.stopTest();
        //}          
    }

  
}