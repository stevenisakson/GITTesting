/**
* This class is for DCR Mobile functionality.
*
* @author  Sam Boban
* @version 1.0

*/
public class DCRDayMobCtrl {
    
    public static Decimal DCR_LOCK_DEFAULT_DAY=3;
    
    public static String DCR_DEFAULT_ACTIVITY=Label.DCR_Customer_Visit;
    public static String DCR_ALLOWED_ACTIVITY='Customer Visit;Group Meeting';
    public static Id DCRdayRecordTypeId = [Select Id From RecordType 
                                           Where SobjectType = 'DCR_Day__c' AND DeveloperName =: Label.DCR_Day_RecordType].Id;
    public static Id DCRCustRecordTypeId = [Select Id From RecordType 
                                            
                                            Where SobjectType = 'DCR_Day__c' AND DeveloperName =: Label.DCR_Customer_Record_Type].Id;
    /**
* This method is used search a dcr record and dcr customer or create a dcr record. 
* @param searchDate date for which user wants to create or search dcr record
* @param searchTargetId  Target record id for which dcr should be created or searched
* @param routeId DCR customer's route Id
* @param custId User selected Account Id
* @return Response This returns a Wrapper
*/
 
    
    public class DataWrapper{
        @auraenabled
        public String dcrId,custId,lob,userId;
        @auraenabled
        public Boolean isComplete,isLocked,isDataSteward,hasDCRUnlockAccess;
        @auraenabled
        public List<PicklistWrapper> firstHalf=new List<PicklistWrapper>();
        @auraenabled
        public List<PicklistWrapper> secondHalf=new List<PicklistWrapper>();
        @auraenabled
        public List<PicklistWrapper> status=new List<PicklistWrapper>();
        
        @auraenabled
        public List<PicklistWrapper> accompaniedbyList=new List<PicklistWrapper>();
        
        
        @auraenabled
        public List<CalculateUtility.PicklistWrapper> brandReminder =new List<CalculateUtility.PicklistWrapper>();
        @auraenabled
        public List<CalculateUtility.PicklistWrapper> productDiscussed=new List<CalculateUtility.PicklistWrapper>();
        @auraenabled
        public List<CalculateUtility.PicklistWrapper> ProductSample=new List<CalculateUtility.PicklistWrapper>();
        
        public DataWrapper(){
            isComplete=false;
            isLocked=false;
            isDataSteward=false;
            hasDCRUnlockAccess=false;
        }
        
    }
    /*Checks if a approved plan month exists for the given date
@param searchDate -user given date
@return Boolean return false- if does not exist.true if exists*/
    @TestVisible private static Boolean hasApprovedPlanMonth(String searchDate,String targetownerId){
        Integer selecteDateMonth = Date.valueOf(searchDate).month();
        Integer selecteDateYear = Date.valueOf(searchDate).year();
        Map<Integer,String> monthNameMap = new Map<Integer,String>{1=>'January',2=>'February',3=>'March',4=>'April',5=>'May',6=>'June',7=>'July',8=>'August',9=>'September',10=>'October',11=>'November',12=>'December'};
            List<Planning_Month__c> plMnthList = [select Id,Month_Planned__c,Plan_Year__c,Status__c 
                                                  from Planning_Month__c
                                                  where Month_Planned__c =: monthNameMap.get(selecteDateMonth) and Plan_Year__c =: String.valueof(selecteDateYear) and ownerId =:targetownerId and Status__c = 'Approved' LIMIT 1];
        if(plMnthList.size()>0){
            return true;
        }else{
            return false;
        }
    }
     @AuraEnabled
    public static Response unlockDCR(String dcrId){
        if(dcrId==null){
             return new Response(false,'Failed:Parameter missing',false);
        }
        Boolean hasError=false;
        try{
            update new DCR_Day__c(id=dcrId,Status__c='In Progress',DCR_Locked__c=false,DCR_Unlocked__c=true,DCR_Locked_Process__c=false,CreatedDateCustom__c = System.today());
        }catch(Exception e){
            hasError=true;
            System.debug(e.getMessage());
        }
        if(hasError){
            return new Response(false,'Failed',null);
        }else{
            return new Response(true,'Success',true);
        }
        
    }
    
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
    @auraenabled
    public static Response getDCRRecord(String dcrId){
        DCR_Day__c dcr=[select First_Half__c,Second_Half__c,Status__c from DCR_Day__c where id=:dcrId limit 1];
        return new Response(true,'SUCCESS',dcr);
    }
    @auraenabled
    public static Response completeDCR(String dcrId){
        
        DCR_Day__c dcr=new DCR_Day__c(id=dcrId,Status__c='Completed',DCR_Locked__c=true);
        update dcr;
        return new Response(true,'SUCCESS',dcr);
    }
    @auraenabled
    public static Response getDCRCustomerRecord(String dcrId){
        List<DCR_Day__c> dcr=[select Account__r.Name,Route__r.Name,Contact_Text__c,POB__c,Comments__c,Accompanied_By__c from DCR_Day__c where DCR_Day__c=:dcrId];
        return new Response(true,'SUCCESS',dcr);
    }
    @auraenabled
    public static Response getAllConfigValues(){
        DataWrapper dw=new DataWrapper();
        dw.firstHalf=getFirstHalfValues();
        dw.secondHalf=getSecondHalfValues();
        //dw.status=getStatus();
        dw.brandReminder=getBrandReminders();
        dw.productDiscussed=getProductDiscussed();
        dw.ProductSample=getProductSample();
        dw.accompaniedbyList=getAccompaniedBy();
        
        User cur_user=[select line_of_business__c,Profile.Name from User where id=:UserInfo.getUserId()];
        dw.lob=cur_user.line_of_business__c;
        dw.userId=cur_user.Id;
        dw.isDataSteward=(cur_user.Profile.Name.contains('Data Steward') || cur_user.Profile.Name.contains('System Administrator')) ? true : false;
        dw.hasDCRUnlockAccess=hasDCRUNlockAccess();
        return new Response(true,'Success',dw);
    }
    private static List<PicklistWrapper> getFirstHalfValues(){
        List<PicklistWrapper> picklist=new List<PicklistWrapper>();
        Map<String,String> options = new Map<String,String>();
        
        Schema.DescribeFieldResult fieldResult = DCR_Day__c.First_Half__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        
        for( Schema.PicklistEntry f : ple)
        {
            picklist.add(new PicklistWrapper(f.getLabel(),f.getValue()));
            
        }       
        return picklist;
    }
    private static List<PicklistWrapper> getAccompaniedBy(){
        List<PicklistWrapper> picklist=new List<PicklistWrapper>();
        Map<String,String> options = new Map<String,String>();
        
        Schema.DescribeFieldResult fieldResult = DCR_Day__c.Accompanied_By__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        
        for( Schema.PicklistEntry f : ple)
        {
            picklist.add(new PicklistWrapper(f.getLabel(),f.getValue()));
            
        }       
        return picklist;
    }
    private static List<CalculateUtility.PicklistWrapper> getBrandReminders(){
        Map<String,List<CalculateUtility.PicklistWrapper>> estMap=new Map<String,List<CalculateUtility.PicklistWrapper>>();
        estMap= CalculateUtility.GetDependentOptions('DCR_Day__c','LOB__c','Brand_Reminder1__c');
        
        return estMap.get([select line_of_business__c from User where id=:UserInfo.getUserId()].line_of_business__c);
    }
    private static List<CalculateUtility.PicklistWrapper> getProductDiscussed(){
        Map<String,List<CalculateUtility.PicklistWrapper>> estMap=new Map<String,List<CalculateUtility.PicklistWrapper>>();
        estMap= CalculateUtility.GetDependentOptions('DCR_Day__c','LOB__c','Product1__c');
        
        return estMap.get([select line_of_business__c from User where id=:UserInfo.getUserId()].line_of_business__c);
    }
    private static List<CalculateUtility.PicklistWrapper> getProductSample(){
        Map<String,List<CalculateUtility.PicklistWrapper>> estMap=new Map<String,List<CalculateUtility.PicklistWrapper>>();
        estMap= CalculateUtility.GetDependentOptions('DCR_Day__c','LOB__c','Product_Details1__c');
        
        return estMap.get([select line_of_business__c from User where id=:UserInfo.getUserId()].line_of_business__c);
    }
    private static List<PicklistWrapper> getSecondHalfValues(){
        List<PicklistWrapper> picklist=new List<PicklistWrapper>();
        Map<String,String> options = new Map<String,String>();
        
        Schema.DescribeFieldResult fieldResult = DCR_Day__c.Second_Half__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        
        for( Schema.PicklistEntry f : ple)
        {
            picklist.add(new PicklistWrapper(f.getLabel(),f.getValue()));
            
        }       
        return picklist;
    }
     @TestVisible private static List<PicklistWrapper> getStatus(){
        List<PicklistWrapper> picklist=new List<PicklistWrapper>();
        Map<String,String> options = new Map<String,String>();
        
        Schema.DescribeFieldResult fieldResult = DCR_Day__c.Status__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        
        for( Schema.PicklistEntry f : ple)
        {
            picklist.add(new PicklistWrapper(f.getLabel(),f.getValue()));
            
        }       
        return picklist;
    }
    public class PicklistWrapper{
        @auraenabled
        public String value;
        @auraenabled
        public String label;
        public PicklistWrapper(String label,String value){
            this.label=label;
            this.value=value;
        }
    }
    @Auraenabled
    public static Response searchDCRMob(String searchDate,String searchTargetId,String targetOwnerId){
        String dcrSearchKey='';
        if(searchDate!=null && searchTargetId!=null){
            dcrSearchKey=searchDate+searchTargetId+targetOwnerId;
        }else{
            return new Response(false,'Error:Parameters Missing',null);
        }
        /*Plan Month check,this check is specifically if the territory id and logged in user are same*/
        if(UserInfo.getUserId()==targetOwnerId){
            if(!hasApprovedPlanMonth(searchDate,targetOwnerId)){
                return new Response(false,System.Label.Cres_DCR_Approval_Error,null);
            }
        }
        List<DCR_Day__c> existingDCR = new List<DCR_Day__c>();
        List<DCR_Day__c> existingDCRCust = new List<DCR_Day__c>();
        /*Search DCR record*/
        existingDCR = [select Id,Status__c,DCR_Locked__c,First_Half__c,Second_Half__c From DCR_Day__c
                       where DCR_Unique_Key__c =: dcrSearchKey and RecordTypeId=:DCRdayRecordTypeId LIMIT 1];
        if(existingDCR.size()>0) {
            return new Response(true,'SUCCESS',existingDCR[0]);
        }else{
            /*if dcr does not exist,create a dcr if the search/create date is outdated*/
             DCR_Day__c dcr=null;
            if(UserInfo.getUserId()==targetOwnerId){
                dcr=createDCRIfOutDated(searchDate,searchTargetId);
            }
            
            return new Response(true,'SUCCESS',dcr);       
        }
        
    }
    private static DCR_Day__c createDCRIfOutDated(String searchDate,String searchTargetId){
        Boolean isDCRLocked=false;
        DCR_Day__c dcrDay;
        Decimal dcrRegionLockDay=0,dayDiff=0;
        User usr = [Select Id,Business_Unit__c,Region__c 
                    From User where Id=: UserInfo.getUserId() ];
        DCRLockingDays__c dcrSetings;
        if(usr.Region__c!=null){
            dcrSetings = DCRLockingDays__c.getValues(usr.Region__c); 
            if(dcrSetings!=null && dcrSetings.Days__c!=null){
                dcrRegionLockDay= dcrSetings.Days__c;
            }else{
                dcrRegionLockDay=DCR_LOCK_DEFAULT_DAY;
            }
            
        }else{
            dcrRegionLockDay=DCR_LOCK_DEFAULT_DAY;
        }
        /*if dcr does not exist create a dcr*/
        dayDiff=Date.valueOf(searchDate).daysBetween(Date.today());
        System.debug('$$$DayDIff'+dayDiff);
        /*Lock dcr is created earlier than number of days configured*/
        if(dayDiff>=dcrRegionLockDay){
            System.debug('$$$Condition');
            isDCRLocked=true;
            dcrDay=new DCR_Day__c(RecordTypeId=DCRdayRecordTypeId,Day__c=Date.valueOf(searchDate),DCR_Locked__c=isDCRLocked,Status__c='Open'
                                             ,First_Half__c=DCR_DEFAULT_ACTIVITY,Second_Half__c=DCR_DEFAULT_ACTIVITY,Target__c=searchTargetId);
            insert dcrDay;
        }
      
       
        return dcrDay;
        
    }
    @auraenabled
    public static Response getDCRCustomer(String dcrCustId){
        List<DCR_Day__c> dcrCustList=new List<DCR_Day__c>();
        dcrCustList=[select Account__r.Name,Route__r.Name,Route__r.Territory__r.Name,Contact_Text__c,POB__c,Comments__c,Accompanied_By__c,
                     Product_Details1__c,Product_Details2__c,Product_Details3__c,Product_Details4__c,Product_Details5__c,
                     Product_Quantity1__c,Product_Quantity2__c, Product_Quantity3__c,Product_Quantity4__c,Product_Quantity5__c,
                     Product1__c,Product2__c,Product3__c,Product4__c,Product5__c,
                     Brand_Reminder1_Quantity__c,Brand_Reminder1__c,Brand_Reminder2__c,Brand_Reminder2_Quantity__c,Brand_Reminder3__c,
                     Brand_Reminder3_Quantity__c,Brand_Reminder4__c,Brand_Reminder5__c,Brand_Reminder5_Quantity__c,Brand_Reminder4_Quantity__c from DCR_Day__c where id=:dcrCustId];
        if(dcrCustList.size()>0){
            return new Response(true,'SUCCESS',dcrCustList[0]);
        }else{
            return new Response(true,'SUCCESS',null);
        }
    }
    @auraenabled
    public static Response getDCRWrapper(String dcrId){
        
        DCRWrapper dcrWrap=new DCRWrapper();
        List<DCR_Day__c> dcr=[select Target__r.Employee_Link_To__c,First_Half__c,DCR_Locked__c,Second_Half__c,Status__c from DCR_Day__c where id=:dcrId limit 1];
        List<DCR_Day__c> dcrCustList=new List<DCR_Day__c>();
        if(dcr.size()>0){
            if(dcr[0].First_Half__c==DCR_DEFAULT_ACTIVITY || dcr[0].Second_Half__c==DCR_DEFAULT_ACTIVITY ||
               dcr[0].First_Half__c=='Group Meeting' || dcr[0].Second_Half__c=='Group Meeting'){
                   dcrWrap.hasCustomerActivity=true;
                   dcrCustList=[select Account__r.Name,Route__r.Name,Contact_Text__c,POB__c,Comments__c,Accompanied_By__c,
                                Product_Details1__c,Product_Details2__c,Product_Details3__c,Product_Details4__c,Product_Details5__c,
                                Product_Quantity1__c,Product_Quantity2__c,  Product_Quantity3__c,Product_Quantity4__c,Product_Quantity5__c,
                                Product1__c,Product2__c,Product3__c,Product4__c,Product5__c,
                                Brand_Reminder1_Quantity__c,Brand_Reminder1__c,Brand_Reminder2__c,Brand_Reminder2_Quantity__c,Brand_Reminder3__c,
                                Brand_Reminder3_Quantity__c,Brand_Reminder4__c,Brand_Reminder5__c,Brand_Reminder5_Quantity__c,Brand_Reminder4_Quantity__c from DCR_Day__c where DCR_Day__c=:dcrId];
                   
                   
                   dcrWrap.dcrCustRec=dcrCustList;
               }else{
                    dcrWrap.hasCustomerActivity=false;
               }
            dcrWrap.dcrRec=dcr[0];
            if(dcr[0].Status__c=='Completed'){
                dcrWrap.isDCRComplete=true;
                dcrWrap.isDCRLocked=true;
                
            }
            if(dcr[0].DCR_Locked__c)  {
                dcrWrap.isDCRLocked=true;
            }
            if(UserInfo.getUserId()==dcr[0].Target__r.Employee_Link_To__c){
                 dcrWrap.hasEditAccess=true;
            }else{
                 dcrWrap.hasEditAccess=false;
            }
            
        }
        
        return new Response(true,'SUCCESS',dcrWrap);
        
    }
    public class DCRWrapper{
        @auraenabled
        public Boolean hasCustomerActivity,isDCRComplete,isDCRLocked,hasEditAccess;
        
        @auraenabled
        public String dcrId;
        @auraenabled
        public DCR_Day__c dcrRec;
        @auraenabled
        public List<DCR_Day__c> dcrCustRec=new List<DCR_Day__c>();
        public DCRWrapper(){
            hasCustomerActivity=false;
            isDCRComplete=false;
            isDCRLocked=false;
            hasEditAccess=false;
        }
        
        
    }
}