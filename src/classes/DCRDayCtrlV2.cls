public with sharing class DCRDayCtrlV2 {
    
    @AuraEnabled
    public static User getLoggedInUser(){
        return [select id,Profile.Name from User where id=:UserInfo.getUserId()];
    }
    @AuraEnabled
    public static Boolean finishDCR(String dcrId){
        if(dcrId==null){
            system.debug('DCR is is null###');
            return false;
        }
        Boolean hasError=false;
        try{
            system.debug('inside dcr update try block');
            update new DCR_Day__c(id=dcrId,Status__c='Completed',DCR_Locked__c=true);
            system.debug('Updated record is##'+[select id, Status__c,DCR_Locked__c from DCR_Day__c where id=:dcrId]);
        }catch(Exception e){
            hasError=true;
            System.debug(e.getMessage());
        }
        if(hasError){
            return false;
        }else{
            return true;
        }
        
    }
   @AuraEnabled
    public static Boolean unlockDCR(String dcrId){
        if(dcrId==null){
            return false;
        }
        Boolean hasError=false;
        try{
            update new DCR_Day__c(id=dcrId,Status__c='In Progress',DCR_Locked__c=false,DCR_Unlocked__c=true,DCR_Locked_Process__c=false,CreatedDateCustom__c = System.today());
        }catch(Exception e){
            hasError=true;
            System.debug(e.getMessage());
        }
        if(hasError){
            return false;
        }else{
            return true;
        }
        
    }
    @AuraEnabled
    public static Boolean hasDCRUNlockAccess(){
      
       
        User loggedInUser=[select Profile.Name from User where id=:UserInfo.getUserId()];
        DCRButtonSettings__c dcrMap=DCRButtonSettings__c.getValues(loggedInUser.Profile.Name);
        if(dcrMap!=null){
            return true;
        }
        else{
            return false;
        }
    }
    @AuraEnabled
    public static wrapperDCRClass getDCRRecord(String searchDate,String searchTargetId) {
        wrapperDCRClass returnWrapperRec = new wrapperDCRClass();
        Integer selecteDateMonth = Date.valueOf(searchDate).month();
        Integer selecteDateYear = Date.valueOf(searchDate).year();
        Id planMonthownId = [select Employee_Link_To__c from Target__c where Id=: searchTargetId].Employee_Link_To__c;
        Map<Integer,String> monthNameMap = new Map<Integer,String>{1=>'January',2=>'February',3=>'March',4=>'April',5=>'May',6=>'June',7=>'July',8=>'August',9=>'September',10=>'October',11=>'November',12=>'December'};
        List<Planning_Month__c> plMnthList = [select Id,Month_Planned__c,Plan_Year__c,Status__c 
                                              from Planning_Month__c
                                              where Month_Planned__c =: monthNameMap.get(selecteDateMonth) and Plan_Year__c =: String.valueof(selecteDateYear) and ownerId =: planMonthownId and Status__c = 'Approved' LIMIT 1];
        
        User usr = [Select Id,Business_Unit__c,Region__c 
                   From User where Id=: UserInfo.getUserId() ];
        
        DCRLockingDays__c dcrSetings = DCRLockingDays__c.getValues(usr.Region__c);
       
        
        //system.debug('plan month list'+plMnthList);
        DCR_Day__c dcrRec=null;
        List<DCR_Day__c> existingDCR = new List<DCR_Day__c>();
        String uniqueKey = Date.valueOf(searchDate)+searchTargetId+UserInfo.getUserId();
        system.debug('unique key is##'+uniqueKey);
        Date selectedDate = Date.valueOf(searchDate);
        //system.debug('selected date is'+selectedDate);
        //system.debug('search date date is'+searchDate);
        //system.debug('system date'+system.now());
        //system.debug('system date'+System.today());
        String selectedTerrId = searchTargetId;
        String loggedUsrprofileId = UserInfo.getProfileId();
        String profileName=[Select Id,Name from Profile where Id=:loggedUsrprofileId].Name;
        Integer DaysDifference = selectedDate.daysBetween(System.today());
       
        List<Target__c> selectedTargetList = [select Id,ownerId,Employee_Link_To__c from Target__c where Id=:searchTargetId LIMIT 1];
        
        system.debug('date diff is '+DaysDifference);
        if(profileName.contains('Data Steward')){
         existingDCR = [select Id,Day__c,First_Half__c,Line_Of_Business__c,
                                        Route__c,Route_No__c,Second_Half__c,Target__c,User_Type__c,Status__c,PlannedDeviation__c,Account__c,
                                        DCR_Locked__c,DCR_Unique_Key__c,OwnerId From DCR_Day__c
                                        where Day__c =: selectedDate and Target__c =: selectedTerrId LIMIT 1];
           if(existingDCR.size()>0){
           		    returnWrapperRec.DCRDayRecord=existingDCR[0];
                    returnWrapperRec.isPlanned = true;
                }
        }
        else{
            if(plMnthList.size()>0){   
         existingDCR = [select Id,Day__c,First_Half__c,Line_Of_Business__c,
                                        Route__c,Route_No__c,Second_Half__c,Target__c,User_Type__c,Status__c,PlannedDeviation__c,Account__c,
                                        DCR_Locked__c,DCR_Unique_Key__c,OwnerId From DCR_Day__c
                        				//where DCR_Unique_Key__c =: uniqueKey LIMIT 1];
                						where Day__c =: selectedDate and Target__c =: selectedTerrId LIMIT 1];
             
                if(existingDCR.size()>0){
           		    returnWrapperRec.DCRDayRecord=existingDCR[0];
                    returnWrapperRec.isPlanned = true;
                }
                else{
                    if(DaysDifference < dcrSetings.Days__c){
                        returnWrapperRec.DCRDayRecord=null;
                        returnWrapperRec.isPlanned = true;
                    }
                    else{
                        returnWrapperRec.DCRDayRecord=null;
                        returnWrapperRec.isPlanned = true;
                        returnWrapperRec.outDatedRecord = true;
                        
                        DCR_Day__c outDatedDCR= new DCR_Day__c();
                        outDatedDCR.Day__c = selectedDate;
                        outDatedDCR.ownerId = selectedTargetList[0].Employee_Link_To__c;
                        outDatedDCR.Target__c = selectedTerrId;
                       
                        outDatedDCR.RecordTypeId=Schema.SObjectType.DCR_Day__c.getRecordTypeInfosByDeveloperName().get(System.Label.DCR_Day_RecordType).getRecordTypeId();
                        outDatedDCR.First_Half__c = Label.DCR_Customer_Visit;
                        outDatedDCR.Second_Half__c = Label.DCR_Customer_Visit;
                        outDatedDCR.DCR_Locked__c = true;
                                                
                        insert outDatedDCR;
                    }
                }
            }
            else{
                returnWrapperRec.DCRDayRecord = null;
                returnWrapperRec.isPlanned = false;
            }
        }
     /*   if(existingDCR.size()>0){
            dcrRec=existingDCR[0];
        } */
        return returnWrapperRec;
    }
    
    public class wrapperDCRClass{
    @AuraEnabled public DCR_Day__c DCRDayRecord{get;set;}
    @AuraEnabled public boolean isPlanned{get;set;}
    @AuraEnabled public boolean outDatedRecord{get;set;}    
   }
      @AuraEnabled
    public static List<DCR_Day__c> getDCRCustomerList(Id dcrId){
        List<DCR_Day__c> dcrList=new List<DCR_Day__c>();
        List<DCR_Day__c> customerList = [select Id,Account__c,Route__c,Accompanied_By__c,Brand_Reminder1__c,Brand_Reminder1_Quantity__c,
                                         Brand_Reminder2__c,Brand_Reminder2_Quantity__c,Brand_Reminder3__c,Brand_Reminder3_Quantity__c,
                                         Brand_Reminder4__c,Brand_Reminder4_Quantity__c,Brand_Reminder5__c,Brand_Reminder5_Quantity__c,
                                         Comments__c,CreatedById,CurrencyIsoCode,Day__c,DCR_Day__c,Name,DCR_Locked__c,JFW__c,POB__c,Product_Details1__c,
                                         Product_Details2__c,Product_Details3__c,Product_Details4__c,Product_Details5__c,Product_Quantity1__c,
                                         Product_Quantity2__c,Account_Name__c,Route_No__c,Product_Quantity3__c,Product_Quantity4__c,Product_Quantity5__c,Product1__c,
                                         Product2__c,Product3__c,Product4__c,Product5__c,RecordTypeId from DCR_Day__c where DCR_Day__c= :dcrId];
        return customerList;

    }
    @AuraEnabled
    public static Response deleteRecord(Id recId){
        System.debug('Delete$$$'+recId);
        Database.DeleteResult rs=Database.delete(recId);
        if(rs.isSuccess()){
            return new Response(true,'SUCCESS',true);
        }else{
            return new Response(false,'SUCCESS',false);
        }
        
    }
    /*  @AuraEnabled
      public static wrapperClass fetchRecord(String searchDate,String searchTargetId) {
          wrapperClass returnwrapperClass = new  wrapperClass ();
          
          String uniqueKey = Date.valueOf(searchDate)+searchTargetId+UserInfo.getUserId();
          system.debug('Unique Key is##'+uniqueKey);
          List<DCR_Day__c> existingDCR = [select Id,Day__c,First_Half__c,Line_Of_Business__c,
                                          Route__c,Route_No__c,Second_Half__c,Target__c,User_Type__c,Status__c,PlannedDeviation__c,Account__c,
                                          DCR_Locked__c,DCR_Unique_Key__c,OwnerId From DCR_Day__c
                                          where DCR_Unique_Key__c =: uniqueKey LIMIT 1];
          
          if(!existingDCR.isEmpty())
          {
             returnwrapperClass.DCRDayRecord = existingDCR[0];
             
             List<DCR_Day__c> DCRCustomersList = [select Id,Account__c,Route__c,Accompanied_By__c,Brand_Reminder1__c,Brand_Reminder1_Quantity__c,
                                                  Brand_Reminder2__c,Brand_Reminder2_Quantity__c,Brand_Reminder3__c,Brand_Reminder3_Quantity__c,
                                                  Brand_Reminder4__c,Brand_Reminder4_Quantity__c,Brand_Reminder5__c,Brand_Reminder5_Quantity__c,
                                                  Comments__c,CreatedById,CurrencyIsoCode,Day__c,DCR_Day__c,Name,DCR_Locked__c,JFW__c,POB__c,Product_Details1__c,
                                                  Product_Details2__c,Product_Details3__c,Product_Details4__c,Product_Details5__c,Product_Quantity1__c,
                                                  Product_Quantity2__c,Account_Name__c,Route_No__c,Product_Quantity3__c,Product_Quantity4__c,Product_Quantity5__c,Product1__c,
                                                  Product2__c,Product3__c,Product4__c,Product5__c,RecordTypeId
                                                  From DCR_Day__c
                                                  where DCR_Day__c =: existingDCR[0].Id];
              
             
              if(!DCRCustomersList.isEmpty()){
                    returnwrapperClass.DCRDayCustomerswrapList = DCRCustomersList;
              }
              if(String.valueOf(existingDCR[0].Route__c) != NULL && String.valueOf(existingDCR[0].Route__c) != ''){
                    Route__c dcrRouterec = [Select Id,Name from Route__c where Id =: existingDCR[0].Route__c ];                 
                    returnwrapperClass.DCRRouteRecord = dcrRouterec;
              }
          }
          else{
              returnwrapperClass.DCRDayRecord = null;
              returnwrapperClass.DCRDayCustomerswrapList = null;
              returnwrapperClass.DCRRouteRecord = null;              
          }
          
          List<Planned_Day__c> planDayRecList = [Select Id,Name,Day__c,First_Half__c,Route__c,Second_Half__c,Line_Of_Business__c,User_Type__c
                                                from Planned_Day__c 
                                                where Day__c =: Date.valueOf(searchDate) and CreatedById =: UserInfo.getUserId() LIMIT 1];
              
          if(!planDayRecList.isEmpty())
          {
             returnwrapperClass.PlannedDayRecord = planDayRecList[0];
          }
          else{
              returnwrapperClass.PlannedDayRecord = null;
          }
          return returnwrapperClass;
    }
    
    public class wrapperClass{
    @AuraEnabled public DCR_Day__c DCRDayRecord{get;set;}
    @AuraEnabled public List<DCR_Day__c> DCRDayCustomerswrapList{get;set;}
    @AuraEnabled public Planned_Day__c PlannedDayRecord{get;set;}
    @AuraEnabled public Route__c DCRRouteRecord{get;set;}
   }
    
    @AuraEnabled
      public static wrapperRouteClass fetchRouteCustomers(String routeId) {
          wrapperRouteClass routeCustomerswrapList = new wrapperRouteClass();
          List<Route_Customer__c> routeCustomersList= [Select Id,Account__c,Account_Classification__c,Active__c,Route__c,Name
                                                       From Route_Customer__c 
                                                       where Active__c = TRUE and Route__c =: routeId];
          if(!routeCustomersList.isEmpty()){
              routeCustomerswrapList.RouteCustomersList = routeCustomersList;
          }
          return routeCustomerswrapList;
      }
    
    public class wrapperRouteClass{
    @AuraEnabled public List<Route_Customer__c> RouteCustomersList{get;set;}
    }
    
    @AuraEnabled
    public static wrapperDCRSaveClass saveDCRActivity(String firstHalf,String secondHalf,String status,String plannedDeviation,String selectedRouteRecordId,String selectedTargetRecordId,String selectedDate,String exstDCRRecordId,String newDCR)
    {
        Id DCRdayRecordTypeId = [Select Id From RecordType 
                                     Where SobjectType = 'DCR_Day__c' AND DeveloperName =: Label.DCR_Day_RecordType].Id;
        Id DCRdayCustomerRecordTypeId = [Select Id From RecordType 
                                             Where SobjectType = 'DCR_Day__c' AND DeveloperName =: Label.DCR_Customer_Record_Type].Id;
       
        wrapperDCRSaveClass returnDCRSaveWrapper = new wrapperDCRSaveClass();
        
        DCR_Day__c saveDcr = new DCR_Day__c();
        saveDcr.First_Half__c = firstHalf;
        saveDcr.Second_Half__c = secondHalf;
        saveDcr.Status__c = status;
        //saveDcr.PlannedDeviation__c = Boolean.valueOf(plannedDeviation);
        saveDcr.Route__c = selectedRouteRecordId;
        saveDcr.Target__c = selectedTargetRecordId;
        saveDcr.Day__c = Date.valueOf(selectedDate);
        saveDcr.RecordTypeId = DCRdayRecordTypeId;
        saveDcr.Id = exstDCRRecordId;
        upsert saveDcr;
        String selrouteId = selectedRouteRecordId;
        Id insertedDCRId = saveDcr.Id;
        boolean newDCRvalue = boolean.valueof(newDCR);
        system.debug('Created DCR Id:##'+insertedDCRId+'###New DCR='+newDCRvalue+' Route Id is#'+selrouteId);
        
        if(insertedDCRId != null && selrouteId != null && newDCRvalue){
        List<Route_Customer__c> routeCustomersList= [Select Id,Account__c,Account_Classification__c,Active__c,Route__c,Name
                                                     From Route_Customer__c 
                                                     where Active__c = TRUE and Route__c =: selrouteId];       
        List<DCR_Day__c> insrtDCRCustomer = new List<DCR_Day__c>();
            if(!routeCustomersList.isEmpty()){
                for(Route_Customer__c routeCus: routeCustomersList){
                    DCR_Day__c dcr = new DCR_Day__c();
                    dcr.RecordTypeId = DCRdayCustomerRecordTypeId;
                    dcr.DCR_Day__c = saveDcr.Id;
                    dcr.Account__c = routeCus.Account__c;
                    dcr.Route__c = selrouteId;
                    insrtDCRCustomer.add(dcr);                    
                }
            }
            if(!insrtDCRCustomer.isEmpty()){
                insert insrtDCRCustomer;
            }
           
            List<DCR_Day__c> customerList = [select Id,Account__c,Route__c,Accompanied_By__c,Brand_Reminder1__c,Brand_Reminder1_Quantity__c,
                                                  Brand_Reminder2__c,Brand_Reminder2_Quantity__c,Brand_Reminder3__c,Brand_Reminder3_Quantity__c,
                                                  Brand_Reminder4__c,Brand_Reminder4_Quantity__c,Brand_Reminder5__c,Brand_Reminder5_Quantity__c,
                                                  Comments__c,CreatedById,CurrencyIsoCode,Day__c,DCR_Day__c,Name,DCR_Locked__c,JFW__c,POB__c,Product_Details1__c,
                                                  Product_Details2__c,Product_Details3__c,Product_Details4__c,Product_Details5__c,Product_Quantity1__c,
                                                  Product_Quantity2__c,Account_Name__c,Route_No__c,Product_Quantity3__c,Product_Quantity4__c,Product_Quantity5__c,Product1__c,
                                                  Product2__c,Product3__c,Product4__c,Product5__c,RecordTypeId from DCR_Day__c where Id in : insrtDCRCustomer];
            if(!customerList.isEmpty()){   
                returnDCRSaveWrapper.savedDCRCustList = customerList;
            } 
             else{
               returnDCRSaveWrapper.savedDCRCustList = null; 
            }
        }
        if(saveDcr != null){
            List<DCR_Day__c> savedDcrList = [select Id,First_Half__c,Second_Half__c,Status__c,PlannedDeviation__c,Route__c,Route_No__c,Target__c,Day__c
                                            from DCR_Day__c where Id=:saveDcr.Id];
            
             if(!savedDcrList.isEmpty()){
                returnDCRSaveWrapper.savedDCRrecord = savedDcrList[0];
            }
            else{
                returnDCRSaveWrapper.savedDCRrecord = null;
            }
        }
       
        return returnDCRSaveWrapper;
    }
    
    public class wrapperDCRSaveClass{
        @AuraEnabled public DCR_Day__c savedDCRrecord{get;set;}
        @AuraEnabled public List<DCR_Day__c> savedDCRCustList{get;set;}
    }
    
    @AuraEnabled
     public static List<String> firstHalf(){
        List<String> options = new List<String>();
        Schema.DescribeFieldResult fieldResult = DCR_Day__c.First_Half__c.getDescribe();
        List<Schema.PicklistEntry> pList = fieldResult.getPicklistValues();
        for (Schema.PicklistEntry p: pList) {
            options.add(p.getLabel());
        }
        return options;
    }
     @AuraEnabled
     public static List<String> secondHalf(){
        List<String> options = new List<String>();
        Schema.DescribeFieldResult fieldResult = DCR_Day__c.Second_Half__c.getDescribe();
        List<Schema.PicklistEntry> pList = fieldResult.getPicklistValues();
        for (Schema.PicklistEntry p: pList) {
            options.add(p.getLabel());
        }
        return options;
    }
     @AuraEnabled
     public static List<String> status(){
        List<String> options = new List<String>();
        Schema.DescribeFieldResult fieldResult = DCR_Day__c.Status__c.getDescribe();
        List<Schema.PicklistEntry> pList = fieldResult.getPicklistValues();
        for (Schema.PicklistEntry p: pList) {
            options.add(p.getLabel());
        }
        return options;
    }
     @AuraEnabled
     public static List<String> accompaniedBy(){
        List<String> options = new List<String>();
        Schema.DescribeFieldResult fieldResult = DCR_Day__c.Accompanied_By__c.getDescribe();
        List<Schema.PicklistEntry> pList = fieldResult.getPicklistValues();
        for (Schema.PicklistEntry p: pList) {
            options.add(p.getLabel());
        }
        return options;
    }

        @AuraEnabled
    public static List<String> brandReminder1(){
        List<String> options = new List<String>();
        Schema.DescribeFieldResult fieldResult = DCR_Day__c.Brand_Reminder1__c.getDescribe();
        List<Schema.PicklistEntry> pList = fieldResult.getPicklistValues();
        for (Schema.PicklistEntry p: pList) {
            options.add(p.getLabel());
        }
        return options;
    }
    @AuraEnabled
        public static List<String> brandReminder2(){
        List<String> options = new List<String>();
        Schema.DescribeFieldResult fieldResult = DCR_Day__c.Brand_Reminder2__c.getDescribe();
        List<Schema.PicklistEntry> pList = fieldResult.getPicklistValues();
        for (Schema.PicklistEntry p: pList) {
            options.add(p.getLabel());
        }
        return options;
    }
    @AuraEnabled
        public static List<String> brandReminder3(){
        List<String> options = new List<String>();
        Schema.DescribeFieldResult fieldResult = DCR_Day__c.Brand_Reminder3__c.getDescribe();
        List<Schema.PicklistEntry> pList = fieldResult.getPicklistValues();
        for (Schema.PicklistEntry p: pList) {
            options.add(p.getLabel());
        }
        return options;
    }
    @AuraEnabled
        public static List<String> brandReminder4(){
        List<String> options = new List<String>();
        Schema.DescribeFieldResult fieldResult = DCR_Day__c.Brand_Reminder4__c.getDescribe();
        List<Schema.PicklistEntry> pList = fieldResult.getPicklistValues();
        for (Schema.PicklistEntry p: pList) {
            options.add(p.getLabel());
        }
        return options;
    }
    @AuraEnabled
        public static List<String> brandReminder5(){
        List<String> options = new List<String>();
        Schema.DescribeFieldResult fieldResult = DCR_Day__c.Brand_Reminder5__c.getDescribe();
        List<Schema.PicklistEntry> pList = fieldResult.getPicklistValues();
        for (Schema.PicklistEntry p: pList) {
            options.add(p.getLabel());
        }
        return options;
    }
       @AuraEnabled
        public static List<String> product1(){
        List<String> options = new List<String>();
        Schema.DescribeFieldResult fieldResult = DCR_Day__c.Product1__c.getDescribe();
        List<Schema.PicklistEntry> pList = fieldResult.getPicklistValues();
        for (Schema.PicklistEntry p: pList) {
            options.add(p.getLabel());
        }
        return options;
    }
           @AuraEnabled
        public static List<String> product2(){
        List<String> options = new List<String>();
        Schema.DescribeFieldResult fieldResult = DCR_Day__c.Product2__c.getDescribe();
        List<Schema.PicklistEntry> pList = fieldResult.getPicklistValues();
        for (Schema.PicklistEntry p: pList) {
            options.add(p.getLabel());
        }
        return options;
    }
           @AuraEnabled
        public static List<String> product3(){
        List<String> options = new List<String>();
        Schema.DescribeFieldResult fieldResult = DCR_Day__c.Product3__c.getDescribe();
        List<Schema.PicklistEntry> pList = fieldResult.getPicklistValues();
        for (Schema.PicklistEntry p: pList) {
            options.add(p.getLabel());
        }
        return options;
    }
           @AuraEnabled
        public static List<String> product4(){
        List<String> options = new List<String>();
        Schema.DescribeFieldResult fieldResult = DCR_Day__c.Product4__c.getDescribe();
        List<Schema.PicklistEntry> pList = fieldResult.getPicklistValues();
        for (Schema.PicklistEntry p: pList) {
            options.add(p.getLabel());
        }
        return options;
    }
           @AuraEnabled
        public static List<String> product5(){
        List<String> options = new List<String>();
        Schema.DescribeFieldResult fieldResult = DCR_Day__c.Product5__c.getDescribe();
        List<Schema.PicklistEntry> pList = fieldResult.getPicklistValues();
        for (Schema.PicklistEntry p: pList) {
            options.add(p.getLabel());
        }
        return options;
    }
        @AuraEnabled
        public static List<String> productdetails1(){
        List<String> options = new List<String>();
        Schema.DescribeFieldResult fieldResult = DCR_Day__c.Product_Details1__c.getDescribe();
        List<Schema.PicklistEntry> pList = fieldResult.getPicklistValues();
        for (Schema.PicklistEntry p: pList) {
            options.add(p.getLabel());
        }
        return options;
    }
               @AuraEnabled
        public static List<String> productdetails2(){
        List<String> options = new List<String>();
        Schema.DescribeFieldResult fieldResult = DCR_Day__c.Product_Details2__c.getDescribe();
        List<Schema.PicklistEntry> pList = fieldResult.getPicklistValues();
        for (Schema.PicklistEntry p: pList) {
            options.add(p.getLabel());
        }
        return options;
    }
               @AuraEnabled
        public static List<String> productdetails3(){
        List<String> options = new List<String>();
        Schema.DescribeFieldResult fieldResult = DCR_Day__c.Product_Details3__c.getDescribe();
        List<Schema.PicklistEntry> pList = fieldResult.getPicklistValues();
        for (Schema.PicklistEntry p: pList) {
            options.add(p.getLabel());
        }
        return options;
    }
        @AuraEnabled
        public static List<String> productdetails4(){
        List<String> options = new List<String>();
        Schema.DescribeFieldResult fieldResult = DCR_Day__c.Product_Details4__c.getDescribe();
        List<Schema.PicklistEntry> pList = fieldResult.getPicklistValues();
        for (Schema.PicklistEntry p: pList) {
            options.add(p.getLabel());
        }
        return options;
    }
        @AuraEnabled
        public static List<String> productdetails5(){
        List<String> options = new List<String>();
        Schema.DescribeFieldResult fieldResult = DCR_Day__c.Product_Details5__c.getDescribe();
        List<Schema.PicklistEntry> pList = fieldResult.getPicklistValues();
        for (Schema.PicklistEntry p: pList) {
            options.add(p.getLabel());
        }
        return options;
    }*/
}