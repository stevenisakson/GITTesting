/*
    Author              : Loven Reyes
    Email               : loven.reyes@cloudsherpas.com
    Company             : CloudSherpas
    Date Created        : 22-JUL-2015
    Description         : Test data class consists of records to be used in test class.
    Modified By         : Loven Reyes/Erick Bower - Accenture / Tumish Tak (Commented Invoicer field in ProjectGroup)
    Modified Date       : 10-FEB-2017
*/

@isTest
public class TestDataBuilder {
    //Dynamic method to get Record type id
    public static String getObjectRecordTypeId(SObjectType sObjectType, String recordTypeName){
       //Generate a map of tokens for all the Record Types for the desired object
       Map<String, Schema.RecordTypeInfo> recordTypeInfo = sObjectType.getDescribe().getRecordTypeInfosByName();

       //Retrieve the record type id by name
       return recordTypeInfo.get(recordTypeName).getRecordTypeId();
    }
    
    //Returns ProfileId
    public static string getUserProfileId(String profileName){
        Profile myProfileNotA = [SELECT id FROM PROFILE WHERE Name=: profileName limit 1];
        return myProfileNotA.Id;
    }
    
    //Returns User 
    public static User createUser(Integer i, string ProfID){
        User user = new User(
            Alias = 'CSUsr' + i,
            Email = 'CSUsr' + i + '@cs.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'CS' + i,
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            ProfileId = ProfID,
            TimeZoneSidKey = 'America/Los_Angeles',
            UserName = 'CSUsr' + i + '@CS.com.org',
            Region__c='CFN United States',
            Business_Unit__c = 'US',
            Country_Code__c = 'US',
            CAN_Business__c = 'CFN',
            Primary_Contact_Language__c = 'English',
            isActive = true
        );
        return user;
    }
    
    //Returns User 
    public static User createUser2(String ProfID){
        User user = new User(Alias = 'ACNUser',
                                Email = 'ACNUser@acn.com',
                                EmailEncodingKey = 'UTF-8',
                                LastName = 'ACN ',
                                LanguageLocaleKey = 'en_US',
                                LocaleSidKey = 'en_US',
                                ProfileId = ProfID,
                                TimeZoneSidKey = 'America/Los_Angeles',
                                UserName = 'ACNUser@ACN.com.org',
                                isActive = true);
        return user;
    }

    //Returns Account
    public static Account createAccount(){
        Account myAccount = new Account(
            Name = 'Cargill',
            Business__c = 'CFN - Poland',
            Request_Approved__c = true
        );
        return myAccount; 
    }
    
   
    
    //Returns list of Accounts
    public static List<Account> createListAccount(Id RecordType){
        List<Account> acctRecordList = new List<Account>();
        
        for(integer i=0;i<5;i++){
            acctRecordList.add(new Account(Name = 'AcctRecord '+i, 
                                           RecordTypeId = Recordtype));
                                           
        }
        return acctRecordList;
    }

    //Returns Contact
    public static Contact createContact(Id accID, Integer i ){
        Contact myContact = new Contact(
                AccountId = accID,
                FirstName = 'FName' +i,
                LastName = 'LName' +i
            );
        return myContact;
    }
    
    //Returns list of Contacts
    public static List<Contact> createListContact(Id accountId){
        List<Contact> contactRecordList = new List<Contact>();
        
        for(Integer i=0; i<5; i++){
            contactRecordList.add(new Contact(AccountId = accountId,
                                              FirstName = 'Mike', 
                                              LastName = 'McCoy'+i));
        }
        return contactRecordList;
    } 
    
    //Returns list of Campaigns
    public static List<Campaign> createListCampaign(){
        List<Campaign> campaignRecordList = new List<Campaign>();
        
        for(Integer i=0; i<5; i++){
            campaignRecordList.add(new Campaign(Name = 'CampaignRecord'+i, 
                                                Status = 'In Progress',
                                                IsActive = true,
                                                Location__c = 'USA'));
        }
        return campaignRecordList;
    }
    
    //Returns list of Project Groups
    public static List<Project_Group__c> createListProjectGroup(Id accountId, Id campaignId, Id contactId, Id userId){
        List<Project_Group__c> projgroupRecordList = new List<Project_Group__c>();
        
        for(Integer i=0; i<5; i++){
            projgroupRecordList.add(new Project_Group__c(Account__c = accountId, 
                                                        Campaign__c = campaignId,
                                                        Customer_Contact__c = contactId,
    //Commented as deleting the old Sales Consultant field with contact lookup               Sales_Consultant__c = contactId,
                                                        Designate_Payment_Type__c = 'Business Builder',
    // Commented as deleting the Invoicer field         Invoicer__c = userId,
                                                        Project_Delivery_Date__c = system.today() + 5 ,
                                                        Project_End_Date__c = system.today() + 7));
                                                 
        }
        return projgroupRecordList;
    } 
    
    //Returns list of Projects
    public static List<Project__c> createListProject(Id projgroupId, String objectName, String recTypeName, Id recordType){
        List<Project__c> projRecordList = new List<Project__c>();
        
        for(Integer i=0; i<1; i++){
            projRecordList.add(new Project__c(Project_Group__c = projgroupId,
                                            Project_Delivery_Date__c = system.today() + 5,
                                            Project_End_Date__c = system.today() + 7,
                                            Project_Sub_Type__c = 'Fulfillment',
                                            RecordTypeId = recordType,
                                            In_Hands_Date_Requested__c  = system.today() + 3));
        }
        return projRecordList;
    } 
    
    //Returns list of Milestones
    public static List<Milestone__c> createListMilestone(Id projId){
        List<Milestone__c> milestoneRecordList = new List<Milestone__c>();
        
        for(Integer i=0; i<5; i++){
            milestoneRecordList.add(new Milestone__c(Name = 'MilestoneRecord',
                                                    Project__c = projId, 
                                                    Due_Date__c = system.today() + 5,
                                                    Status__c = 'Not Started'));
        }
        return milestoneRecordList;
    } 
    
    
    //Returns list of Project Templates
    public static List<Project_Template__c> createListProjTemp(){
        List<Project_Template__c> projTempRecordList = new List<Project_Template__c>();
        
        for(Integer i=0; i<1; i++){
            projTempRecordList.add(new Project_Template__c(Project_Record_Type__c = 'Standard',
                                                           Project_Sub_Type__c = 'Fulfillment' ));
        }
        return projTempRecordList;
    }
    
    
    //Returns list of Milestone Lists
    public static List<Milestone_List_Library__c> createListMilestoneList(){
        List<Milestone_List_Library__c> milestoneListRecordList = new List<Milestone_List_Library__c>();
        
        for(Integer i=0; i<5; i++){
            milestoneListRecordList.add(new Milestone_List_Library__c(Name = 'MileListRecord', 
                                                                      Due_Date__c = 2));
        }
        return milestoneListRecordList;
    } 
    
    //Returns list of ProjectTemplatesMilestoneList
    public static List<ProjectTemplate_MilestoneList__c> createListProjTempMileList(Id projtempId, Id milestonelistId){
        List<ProjectTemplate_MilestoneList__c> projtempmileListRecordList = new List<ProjectTemplate_MilestoneList__c>();
        
        for(Integer i=0; i<5; i++){
            projtempmileListRecordList.add(new ProjectTemplate_MilestoneList__c(Milestone_List_Library__c = milestonelistId,
                                                                              Project_Template__c = projtempId));
        }
        return projtempmileListRecordList;
    }
    /*
    //Returns list of Expenses
    public static List<Expense__c> createListExpense(Id projId){
        List<Expense__c> expenseRecordList = new List<Expense__c>();
        
        for(Integer i=0; i<5; i++){
            expenseRecordList.add(new Expense__c(Project__c = projId));
        }
        return expenseRecordList;
    }
    
    //Returns list of Shipment Tracking
    public static List<Shipment_Tracking__c> createListShipTrack(Id projId){
        List<Shipment_Tracking__c> shipmentRecordList = new List<Shipment_Tracking__c>();
        
        for(Integer i=0; i<5; i++){
            shipmentRecordList.add(new Shipment_Tracking__c(Project__c = projId));
        }
        return shipmentRecordList;
    }
  */
    
    //Returns Opportunity 
    public static Opportunity createOpportunity(Id accId){ 
        Opportunity myOpp = new Opportunity(
            Name = 'CS Opp ',
            CloseDate = System.today() + 30,
            StageName = 'Open',
            AccountId = accId,
            Business_Unit__c = 'US'
        );
        return myOpp;
    }

    //Returns Customer360__c 
    /* Commented By Shalu Req 4.6 
    public static Customer360__c createCustomer360(Id accId, String busUnit){
        Customer360__c myC360 = new Customer360__c(
            Account__c = accId,
            Segment_Step_1__c = 'Aiden',
            X9_Box_Step_2__c = '1',
            Business_Unit__c = busUnit
        );
        return myC360;
    }*/

    //Returns Product_Line__c
    /* Commented By Shalu Req 4.6
    public static Product_Line__c createProductLine(Id cus360){
        Product_Line__c myProLine = new Product_Line__c(
            Customer360__c = cus360,
            Product_Line__c = 'Poultry',
            Sub_Species__c = 'Layers',
            Class__c = 'Chicken',
            Product_Function__c = 'Pre-Starter',
            Segment_Step_1__c = 'Aiden'
        );
        return myProLine;
    }*/

    //Returns Potential__c
    /* Commented By Shalu Req 4.6
    public static Potential__c createPotential(Id plId, String type){
        Potential__c myPotential = new Potential__c(
            Product_Line__c = plId,
            //Animal_yr__c = 2,
            //Days_Fed_Cycle__c = 100,
            //Cycles_Yr__c = 10,
            //Feeding_Rate__c = 15,
            CFE_Conversion_Factor__c = 1.5,
            MT__c = 200,
            Type__c = type
        );
        return myPotential;
    }*/

    //Returns Competitors__c
    public static Competitors__c createCompetitor(Id accId, Id oppId){
        Competitors__c myCompetitor = new Competitors__c(
            Competitor__c = accId,
            //Customer360_Line__c = plId,
            Opportunity__c = oppId
            //Potential__c = potId
        );
        return myCompetitor;
    }

    //Returns Related_Product_Line__c
    /* Commented By Shalu Req 4.6
    public static Related_Product_Line__c createRelatedProdLine(Id oppId, Id plId){
        Related_Product_Line__c myRelatedProdLine = new Related_Product_Line__c(
            Opportunity__c = oppId,
            Product_Line__c = plId
        );
        return myRelatedProdLine;
    }*/

    //Returns Visit_Report__c
    public static Visit_Report__c createVisitReport(){
        Visit_Report__c myVisitReport = new Visit_Report__c(
            Product_Line__c = 'Aquaculture',
            Complaint_Raised__c = false,
            Event_ID__c = '123adas12',
            External_Call_Notes__c = 'Note Ext',
            Internal_Call_Notes__c = 'Note Int',
            Related_Event__c = 'Event',
            Training_Scheduled__c = false
        );
        return myVisitReport;
    }

    //Returns Request__c
    public static Request__c createRequest(Id accId){
        Request__c myRequest = new Request__c(
            Account__c = accId,
            Status__c = 'Draft'
        );
        return myRequest;
    }

    //Returns Event
    public static Event createEvent(Id visitId){
        Event myEvent= new Event(
            Business_Unit__c = 'Brazil',
            Cancelled__c = false,
            Claim_Complaint__c = false,
            Class__c = 'Class',
            Group__c = 'Group',
            Product_Function__c = 'Developer',
            Product_Line__c = 'Aquaculture',
            Reminder_to_Schedule_Follow_Up__c = System.today(),
            Sales__c = true,
            Segment__c = 'Dennis',
            Service__c = false,
            Sub_Type__c = Label.Site_Visit,
            Time_Taken_Hours__c = 3,
            Visit_Report__c = visitId,
            DurationInMinutes = 2,
            ActivityDateTime = System.now()
        );
        return myEvent;
    }

    //Returns CDH Account
    /*public static CDH_Account__c  createCDHAccount(Id userId){
        CDH_Account__c  myCDHTerritory = new CDH_Account__c (
            CDH_Territory__c = '001',
            CDH_CAN_Business__c = 'SFBU',
            CDH_Primary_Account_Owner__c = userId
        );
        return myCDHTerritory;
    }*/

    //Returns CDH Territory
   /* public static CDH_Territory__c createCDHTerritory(Id userId){
        CDH_Territory__c myCDHTerritory = new CDH_Territory__c(
            CDH_Territory_Name__c = 'Test Territory',
            CDH_Primary__c = TRUE,
            CDH_CAN_Business__c = 'SFBU',
            CDH_Territory_Owner__c = userId,
            CDH_External_Territory_ID__c = '001'
        );
        return myCDHTerritory;
    } */
    
    //Returns CDH Territory/Account
  /*  public static CDH_Territory_Account__c createCDHTerritoryAccount(Id cdhAccId, Id cdhTerrId){
        CDH_Territory_Account__c myCDHTerritoryAccount = new CDH_Territory_Account__c(
            CDH_Account__c = cdhAccId,
            CDH_Territory__c = cdhTerrId
        );
        return myCDHTerritoryAccount;
    }*/

    /**
    * @author       : Mark Anthony Pamintuan
    * @date         : 13-JAN-2016
    * @description  : builds a CDH Territory record
    * @return       : CDH Territory record
    **/ 
  /*  public static CDH_Territory__c buildCDHTerritory(integer i, string canBusiness, string canBusinessUnit, Id ownerId, string extTerritoryId){
        CDH_Territory__c cdhTerritory = new CDH_Territory__c(
            CDH_Territory_Name__c = 'Test Territory' + i,
            CDH_Primary__c = TRUE,
            CDH_CAN_Business__c = canBusiness,
            CDH_Business__c = canBusinessUnit,
            CDH_Territory_Owner__c = ownerId,
            CDH_External_Territory_ID__c = extTerritoryId
        );
        return cdhTerritory;
    }*/

    /*********************************** Custom Settings ***********************************/
    
    public static void createApproval_Process_Settings(){
        Auto_Populate_Settings__c appSettings = new Auto_Populate_Settings__c(name = 'Canada',Lightning_Enabled__c = true,Owner_Change__c = true);
        insert appSettings;
    } 
    
    public static void createOverrideSettings(){
        Override_Settings__c overset = new Override_Settings__c(
            Contact_Role_Account_Field_ID__c = '123',
            Contact_Role_Product_Line_Field_ID__c ='123',
            Account_Business_Unit_Field_ID__c = '123',
            Account_Physical_Country_Field_ID__c = '123',
            Account_Correspondence_Country_Field_ID__c = '123',
            Account_CAN_Business_Field_ID__c = '123',
            Contact_Business_Unit_Field_ID__c = '123',
            Event_Business_Unit_Field_ID__c = '123',
            Opportunity_Business_Unit_Field_ID__c = '123'
            );
        insert overset;
    } 

    public static void createFieldSets() {
        List<FieldSets_Setting__c> fieldsSets = new List<FieldSets_Setting__c>();
        
        /* Commented By Shalu Req 4.6 
        fieldsSets.add(new FieldSets_Setting__c(
            Name = 'Potential__c-Edit-Aiden(US)',
            Business_Unit__c = 'US',
            FieldSet_Name__c = 'Potential_FS_Input_OMSN',
            Object__c = 'Potential__c',
            Segment__c = 'Aiden',
            Type__c = 'Edit',
            Used_In__c = 'Customer360',
            Index__c = '0'
        ));

        fieldsSets.add(new FieldSets_Setting__c(
            Name = 'Customer360__c-Edit-Aiden(US)',
            Business_Unit__c = 'US',
            FieldSet_Name__c = 'C360_FS_Input_OMSN',
            Object__c = 'Customer360__c',
            Segment__c = 'Aiden',
            Type__c = 'Edit',
            Used_In__c = 'Customer360',
            Index__c = '0'
        ));*/

        fieldsSets.add(new FieldSets_Setting__c(
            Name = 'Competitors__c-Edit-Aiden(US)',
            Business_Unit__c = 'US',
            FieldSet_Name__c = 'Competitor_FS_Input_OMSN',
            Object__c = 'Competitors__c',
            Segment__c = 'Aiden',
            Type__c = 'Edit',
            Used_In__c = 'Customer360',
            Index__c = '0'
        ));
/* Commented By Shalu Req 4.6 
        fieldsSets.add(new FieldSets_Setting__c(
            Name = 'Customer360__c-View-Aiden(US)',
            Business_Unit__c = 'US',
            FieldSet_Name__c = 'C360_FS_Readonly_OMSN',
            Object__c = 'Customer360__c',
            Segment__c = 'Aiden',
            Type__c = 'View',
            Used_In__c = 'Customer360',
            Index__c = '0'
        ));

        fieldsSets.add(new FieldSets_Setting__c(
            Name = 'Potential__c-View-Aiden(US)',
            Business_Unit__c = 'US',
            FieldSet_Name__c = 'Potential_FS_Readonly_OMSN',
            Object__c = 'Potential__c',
            Segment__c = 'Aiden',
            Type__c = 'View',
            Used_In__c = 'Customer360',
            Index__c = '0'
        ));*/

        fieldsSets.add(new FieldSets_Setting__c(
            Name = 'Competitors__c-View-Aiden(US)',
            Business_Unit__c = 'US',
            FieldSet_Name__c = 'Competitor_FS_Readonly_OMSN',
            Object__c = 'Competitors__c',
            Segment__c = 'Aiden',
            Type__c = 'View',
            Used_In__c = 'Customer360',
            Index__c = '0'
        ));

        fieldsSets.add(new FieldSets_Setting__c(
            Name = 'Visit_Report-US-All(Noah)',
            Business_Unit__c = 'US',
            FieldSet_Name__c = 'US_Noah_Dennis_Aiden_Visit_Report',
            Object__c = 'Visit_Report__c',
            Segment__c = 'Aiden',
            Type__c = 'All',
            Used_In__c = 'Customer360',
            Index__c = '0'
        ));
/* Commented By Shalu Req 4.6 
        fieldsSets.add(new FieldSets_Setting__c(
            Name = 'Product_Line__c-All-All(US)',
            Business_Unit__c = 'US',
            FieldSet_Name__c = 'C360Line_FS',
            Object__c = 'Product_Line__c',
            Segment__c = 'All',
            Type__c = 'All',
            Used_In__c = 'Customer360',
            Index__c = '0'
        ));

        fieldsSets.add(new FieldSets_Setting__c(
            Name = 'Product_Line__c-All-All(US)-1',
            Business_Unit__c = 'US',
            FieldSet_Name__c = 'C360Line_FS',
            Object__c = 'Product_Line__c',
            Segment__c = 'All',
            Type__c = 'All',
            Used_In__c = 'Customer360',
            Index__c = '1'
        ));*/

        insert fieldsSets;
    }
    
    /*public static CDH_Field_Mapping__c createCDHCustomSettingList(String uniqueName, String CDH_object, String CDH_fieldname, String import_fieldname, String obj, String object_fieldname){
        
        CDH_Field_Mapping__c CDHCustomSet = new CDH_Field_Mapping__c(
        Name = uniqueName,
        CDH_Object__c = CDH_object,
        CDH_Field_Name__c = CDH_fieldname,
        Import_Field_Name__c = import_fieldname,
        Object__c = obj,
        Object_Field_Name__c = object_fieldname);
        
        return CDHCustomSet;
            
    }*/
/* Commented By Shalu Req 4.6
    public static Product_Line__c buildProductLine(Id cus360, String pl,  String plGroup, String plClass, String plFunction, String segmentStep1){
        Product_Line__c pLine = new Product_Line__c(
            Customer360__c = cus360,
            Product_Line__c = pl,
            Sub_Species__c = plGroup,
            Class__c = plClass,
            Product_Function__c = plFunction,
            Segment_Step_1__c = segmentStep1
        );
        return pLine;
    }*/
    
    public static ProductLineGroupValues__c buildCsPlineGroupValues (String plName, String groupNames){
        
        ProductLineGroupValues__c plgv = new ProductLineGroupValues__c(Name=plName, Value__c = groupNames);
        return plgv;
        
    }
    
    public static ProductLineClassValues__c buildCsPlineClassValues (String groupName, String classNames){

        ProductLineClassValues__c plcv = new ProductLineClassValues__c(Name=groupName, Values__c = classNames);
        return plcv;
        
    }

    public static ProductLineFunctionValues__c buildCsPlineFunctionValues (String className, String functionNames){

        ProductLineFunctionValues__c plfv = new ProductLineFunctionValues__c(Name=className, Values__c = functionNames);
        return plfv;
        
    }

    /**
    * @author       : Mark Anthony Pamintuan
    * @date         : 25-JAN-2016
    * @description  : builds a Customer_360_Setting__c record
    * @return       : Customer_360_Setting__c record
    **/ 
    /* Commented By Shalu Req 4.6        
    public static Customer_360_Setting__c buildC360Setting(){
        
        Customer_360_Setting__c c360setting = new Customer_360_Setting__c(
            Name = 'US',
            Show_Metrics_on_Inline__c = true,
            Show_Opportunities_on_Inline__c = true,
            Show_Segmentation_on_Inline__c = true
        );
        
        return c360setting;
        
    }*/
}