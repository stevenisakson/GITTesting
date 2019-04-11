/*
* Author:AnuRekha
* Desciption: Controller for lighting components Potential History Controller 
* Main Functionalities are
* 1.Displaying potential records and History records.
  
*/
public with sharing class PotentialHistoryCtrl {
    
 // This wrapper class wraps History,Potential and created date. 
 // Here created date is passed as string since created date need to be formated as per user locale    
    
 public class wrapper{ 
 @auraenabled
 public Potential__c Pot;
 @auraenabled
 public Potential__History PotHis;
 @auraenabled
 public String CreatedDatePDF;  
       
 public wrapper(Potential__c p, Potential__History PH,String CreatedDateText ){
                      Pot=P;
                      PotHis=PH;
                      CreatedDatePDF = CreatedDateText;
 }
    
 }
 

public static String STD_SUCCESS='success';

// This method display all the potentail history records based on filter and limits. These records are  displayed on UI
@auraEnabled
public static List<wrapper>  getPotentailHistorydetails(Integer offset,Integer recordToDisply, List<String> historyfilter, String fromDate , String ToDate, String Iscomp,Id selectedRecordId ){ 


    Set<Id> PotId1 = PotentialFilter(Iscomp,selectedRecordId,fromDate,ToDate);

    system.debug('%%%PotId'+PotId1);

    List<wrapper> lstwrap =new List<wrapper>();
    Set<String> PotentialParentId = new Set<String> ();
    Set<Id> PotId = new Set<Id>();
    string testsr = 'created';
    String soql = 'Select id ';
    String querysoql ;
    String PotentialHistory ;

    Date dt=null;
    Date ToDateD =null;
    Date fromDateD = null; 

    DateTime ToDateDateTime = null;
    DateTime fromDateDateTime=null;

    TimeZone tz = UserInfo.getTimeZone();
    integer offsetToUserTimeZone = tz.getOffset(Datetime.now());

     
        if(fromDate!=null){
             dt= Date.valueOf(fromDate);
             Integer offsetValue=offsetToUserTimeZone / (1000 * 60 *60);
             fromDateDateTime= Datetime.newInstance(dt.year(),dt.month(),dt.day(),0,0,0);
             offsetValue=offsetValue*-1;
             fromDateDateTime.addHours(offsetValue);
             System.debug('$$$fromDateDateTime'+fromDateDateTime);

        }
        
        if(ToDate !=null){
             dt= Date.valueOf(ToDate);
             ToDateDateTime = Datetime.newInstance(dt.year(),dt.month(),dt.day(),23,59,59);
             Integer offsetValue=offsetToUserTimeZone / (1000 * 60 *60);
             offsetValue=offsetValue*-1;
             ToDateDateTime .addHours(offsetValue);
             System.debug('$$$ToDateDateTime '+ToDateDateTime );
        }


        if(historyfilter.size() != 0 && fromDate != Null && ToDate != Null )
        {
        
        PotentialHistory = 'Select id,ParentId,Field,CreatedDate from Potential__History where CreatedDate <= :ToDateDateTime and   CreatedDate > = :fromDateDateTime and ParentId in: PotId1  AND Field !=  \''+testsr+'\' AND Field in: historyfilter LIMIT '+ recordToDisply + 'OFFSET ' + offset;
        system.debug('%%%PotentialHistory1'+PotentialHistory );
        
        }
        else if(historyfilter.size() != 0 && fromDate != Null && ToDate == Null ){
        PotentialHistory = 'Select id,ParentId,Field,CreatedDate from Potential__History where CreatedDate > = :fromDateDateTime and ParentId in: PotId1  AND Field !=  \''+testsr+'\' AND Field in: historyfilter LIMIT '+ recordToDisply + 'OFFSET ' + offset;
        system.debug('%%%PotentialHistory2'+PotentialHistory );
        
        }
        else if(historyfilter.size() != 0 && fromDate == Null && ToDate != Null)
        {
        PotentialHistory = 'Select id,ParentId,Field,CreatedDate from Potential__History where CreatedDate <= :ToDateDateTime and ParentId in: PotId1  AND Field !=  \''+testsr+'\' AND Field in: historyfilter LIMIT '+ recordToDisply + 'OFFSET ' + offset;
        system.debug('%%%PotentialHistory3'+PotentialHistory );
        
        }
        else if(historyfilter.size() == 0 && fromDate != Null && ToDate != Null)
        {
        PotentialHistory = 'Select id,ParentId,Field,CreatedDate from Potential__History where ParentId in: PotId1  AND Field !=  \''+testsr+'\' AND CreatedDate <= :ToDateDateTime and  CreatedDate > = :fromDateDateTime LIMIT '+ recordToDisply + 'OFFSET ' + offset;
        system.debug('%%%PotentialHistory4'+PotentialHistory );
        }
        else if(historyfilter.size() != 0 && fromDate == Null && ToDate == Null) {
        PotentialHistory = 'Select id,ParentId,Field,CreatedDate from Potential__History where ParentId in: PotId1 AND Field in: historyfilter AND Field !=  \''+testsr+'\' LIMIT ' + recordToDisply + 'OFFSET ' + offset;
        system.debug('%%%PotentialHistory6'+PotentialHistory );
        }
    
        else {
        PotentialHistory = 'Select id,ParentId,Field,CreatedDate from Potential__History where ParentId in: PotId1 AND Field !=  \''+testsr+'\' LIMIT ' + recordToDisply + 'OFFSET ' + offset;
        system.debug('%%%PotentialHistory7'+PotentialHistory );
        }
        
        List<Potential__History> PotHistory  = Database.query(PotentialHistory); 

        for( Potential__History Ph : PotHistory){
            
            PotentialParentId.add(Ph.ParentId);
            PotId.add(Ph.Id);
        }

        for(Potential_History__c fieldName : [SELECT Id,Field_API_Name__c,Backend_field_check__c,Field_Name_to_display__c from Potential_History__c where Backend_field_check__c = TRUE]){
        
          soql = soql + ', ' + fieldName.Field_API_Name__c; 
        }
        
         soql = soql +  ' , (select CreatedBy.name,CreatedDate,Field,Id,IsDeleted,NewValue,OldValue,ParentId FROM Histories where Id in :PotId order by ParentId,CreatedDate Desc' ;   
         querysoql = soql  +  ' )   from Potential__c where Id in : PotentialParentId order by lastmodifiedDate desc' ;
       
        system.debug('@@@querysoql '+querysoql );
       
         List<Potential__c> PotentialList = Database.query(querysoql); 
         List<Potential__History> HH = new List<Potential__History> ();
         
         for(Potential__c pp:PotentialList )
         {
            for(Potential__History Ph: pp.Histories){
            lstwrap.add(new wrapper(pp,Ph,null));
            
            }
         }
         
         system.debug('$$$lstwrap'+lstwrap);
         system.debug('$$$lstwrap'+lstwrap.size());
         return lstwrap; 

        // return PotentialList ;
         
}

// This method is called from Lightning Component. 

@AuraEnabled
public static PotentialPagerWrapper fetchPotential(Decimal pageNumber ,Integer recordToDisply, List<String> historyfilter , String fromDate, String ToDate , String Iscomp , Id selectedRecordId) {
     
        Integer pageSize = recordToDisply;

        Integer offset = ((Integer)pageNumber - 1) * pageSize;
        Set<String> PotentialParentId = new Set<String> (); 

        system.debug('Inside historyfilter '+historyfilter );
        // create a instance of wrapper class.
        PotentialPagerWrapper obj =  new PotentialPagerWrapper();
        // set the pageSize,Page(Number), total records and Potential__c List(using OFFSET)   
        obj.pageSize = pageSize;
        obj.page = (Integer) pageNumber;
        Set<Id> PotId1 = PotentialFilter(Iscomp,selectedRecordId,fromDate,ToDate);
        obj.PotentialHistoryDownload  =   getPotentialHistoryfordownload(historyfilter ,fromDate,ToDate,Iscomp,selectedRecordId);      
       // obj.total = getPotentialHistorycount(historyfilter ,fromDate,ToDate,Iscomp);

        system.debug('***getPotentailHistorydetails(offset,recordToDisply,historyfilter,fromDate,ToDate,Iscomp,selectedRecordId )'+getPotentailHistorydetails(offset,recordToDisply,historyfilter,fromDate,ToDate,Iscomp,selectedRecordId ));
        obj.Potential = getPotentailHistorydetails(offset,recordToDisply,historyfilter,fromDate,ToDate,Iscomp,selectedRecordId);
        obj.PotentialHistoryCusList = fetchPotentialHistoryCustList();
        // return the wrapper class instance .
        return obj;
     }
     
@AuraEnabled
public static List<Potential_History__c> fetchPotentialHistoryCustList() {
  // List<Potential_History__c> cusValues = Potential_History__c.getall().values();  
     List<Potential_History__c> cusValues = [SELECT Id,Header_Column__c,Name,Field_API_Name__c,Sequence__c,Field_Name_to_display__c from Potential_History__c where Header_Column__c = True ORDER BY Sequence__c];
     System.debug('CusList##'+cusValues);
     return cusValues;
 }
 // create a wrapper class with @AuraEnabled Properties    
public class PotentialPagerWrapper {
    @AuraEnabled public Integer pageSize {get;set;}
    @AuraEnabled public Integer page {get;set;}
    @AuraEnabled public Integer total {get;set;}
    @AuraEnabled public List<wrapper> Potential {get;set;}
    @AuraEnabled public List<wrapper> PotentialHistoryDownload {get;set;}
    @AuraEnabled public List<Potential_History__c> PotentialHistoryCusList {get;set;} 
   }
  
//   This method is used to display the picklist values for field "Field"
@auraEnabled
public static Response getHistoryFilters() { 
       
    Map<String,String> optionsMap = new Map<String,String>();

    List<Potential_History_Filter__c> Pot_His_Filter = [Select Id,Field__c,To_display_in_Page__c from Potential_History_Filter__c];

        for(Potential_History_Filter__c phf : Pot_His_Filter )
        {         
        optionsMap.put(phf.To_display_in_Page__c,phf.Field__c );
        system.debug('$$$optionsMap'+optionsMap);
          
        }

    return new Response(true,STD_SUCCESS,optionsMap);      
} 
   
   
    
public static Set<Id> PotentialFilter( String Iscomp, Id selectedRecordId , String fromDate , String ToDate) // String selecteduser - for lookup search filter
    {
    Set<Id> PotId = new Set<Id>();
    system.debug('Iscomp'+Iscomp);
    Boolean Comp;
    List<Potential__c> PPlist ;
    String ProfileName;  
    Set<String> Business = new Set<String> ();
    Date dt=null;
    DateTime ToDateDateTime = null;
    DateTime fromDateDateTime=null;

    TimeZone tz = UserInfo.getTimeZone();
    integer offsetToUserTimeZone = tz.getOffset(Datetime.now());

     
        if(fromDate!=null){
             dt= Date.valueOf(fromDate);
             Integer offsetValue=offsetToUserTimeZone / (1000 * 60 *60);
             fromDateDateTime= Datetime.newInstance(dt.year(),dt.month(),dt.day(),0,0,0);
             offsetValue=offsetValue*-1;
             fromDateDateTime.addHours(offsetValue);
             System.debug('$$$fromDateDateTime'+fromDateDateTime);

        }
        
        if(ToDate !=null){
             dt= Date.valueOf(ToDate);
             ToDateDateTime = Datetime.newInstance(dt.year(),dt.month(),dt.day(),23,59,59);
             Integer offsetValue=offsetToUserTimeZone / (1000 * 60 *60);
             offsetValue=offsetValue*-1;
             ToDateDateTime .addHours(offsetValue);
             System.debug('$$$ToDateDateTime '+ToDateDateTime );
        }
    
        if(Iscomp != Null || Iscomp != ''){
            if(Iscomp == 'True'){
                Comp= True;
            }else{
                Comp= False;
            }
            
        }
   
    List<User> usr = [Select Id,Business_Unit__c,Profile.name from user where id =: UserInfo.getUserId()];
        for(User u: usr)
        {
        Business.add(u.Business_Unit__c );
        
        }
        
        if(Iscomp != Null  && selectedRecordId != Null ){
            PPlist = [Select Id from Potential__c  where Master_Potential__r.Account__r.Business__c =: Business AND isCompetitor__c =: Comp AND Master_Potential__r.Account__c =: selectedRecordId AND lastmodifiedDate <= :ToDateDateTime and  CreatedDate > = :fromDateDateTime order by lastmodifiedDate desc limit 49999 ];
        }
        else if(Iscomp == Null  && selectedRecordId != Null){
        PPlist = [Select Id from Potential__c  where Master_Potential__r.Account__r.Business__c =: Business AND  Master_Potential__r.Account__c =: selectedRecordId AND lastmodifiedDate <= :ToDateDateTime and  CreatedDate > = :fromDateDateTime order by lastmodifiedDate desc limit 49999];
        }
        
        else if(Iscomp != Null  && selectedRecordId == Null){
        PPlist = [Select Id from Potential__c  where Master_Potential__r.Account__r.Business__c =: Business AND isCompetitor__c =: Comp  AND lastmodifiedDate <= :ToDateDateTime and  CreatedDate > = :fromDateDateTime order by lastmodifiedDate desc limit 49999];
        }
       
        else{
            PPlist = [Select Id from Potential__c where Master_Potential__r.Account__r.Business__c =: Business AND lastmodifiedDate <= :ToDateDateTime and  CreatedDate > = :fromDateDateTime order by lastmodifiedDate desc limit 49999];
        }
        
        
        for(Potential__c p: pplist)
        {
        PotId.add(p.Id);
        system.debug('%%%%PotId '+PotId);
        }
        
        return PotId;
    
    }
    
 //   This method is used to display the picklist values for field "Competitor"   
@auraEnabled     
public static Response getCrescendoFilter(){ 
       
    Map<String,String> optionsMap = new Map<String,String>();

    List<Potential_History_Filter__c> Pot_His_Filter = [Select Id,Is_Competitor__c,To_display_in_Page__c from Potential_History_Filter__c ];

        for(Potential_History_Filter__c phf : Pot_His_Filter )
        {         
        optionsMap.put(phf.To_display_in_Page__c,phf.Is_Competitor__c);
        }

        return new Response(true,STD_SUCCESS,optionsMap);      
} 
    

// This method is used to dispaly  the records on click of download button. 
@auraEnabled
    
public static List<wrapper> getPotentialHistoryfordownload(List<String> historyfilter, String fromDate , String ToDate, String Iscomp,Id selectedRecordId ){


    
    Set<Id> PotId = new Set<Id>();
    String soql = 'Select id ';
    String querysoql ;
    String PotentialHistory ;
    Set<String> PotentialParentId = new Set<String> ();
    List<wrapper> lstwrap =new List<wrapper>();
    Set<Id> PotId1 = PotentialFilter(Iscomp,selectedRecordId,fromDate ,ToDate );

    system.debug('%%%PotId'+PotId1);
    string testsr = 'created';
    String PotentailHistory;
    Integer PotentailHistoryCount;
    Date dt=null;
    Date ToDateD =null;
    Date fromDateD = null; 

    DateTime ToDateDateTime = null;
    DateTime fromDateDateTime=null;

    TimeZone tz = UserInfo.getTimeZone();
   
    integer offsetToUserTimeZone = tz.getOffset(Datetime.now());

        if(fromDate!=null){
         dt= Date.valueOf(fromDate);
         Integer offsetValue=offsetToUserTimeZone / (1000 * 60 *60);
         fromDateDateTime= Datetime.newInstance(dt.year(),dt.month(),dt.day(),0,0,0);
         offsetValue=offsetValue*-1;
         fromDateDateTime.addHours(offsetValue);
         System.debug('$$$fromDateDateTime'+fromDateDateTime);
        }
        if(ToDate !=null){
         dt= Date.valueOf(ToDate);
         ToDateDateTime = Datetime.newInstance(dt.year(),dt.month(),dt.day(),23,59,59);
         Integer offsetValue=offsetToUserTimeZone / (1000 * 60 *60);
         offsetValue=offsetValue*-1;
         ToDateDateTime .addHours(offsetValue);
         System.debug('$$$ToDateDateTime '+ToDateDateTime );
        }
        
        
        if(historyfilter.size() != 0 && fromDate != Null && ToDate != Null )
        {
        system.debug('%%%historyfilter '+historyfilter );
        PotentailHistory= 'Select Id,ParentId from Potential__History where CreatedDate <= :ToDateDateTime and   CreatedDate > = :fromDateDateTime and ParentId in: PotId1  AND Field !=  \''+testsr+'\' AND Field in: historyfilter ';
        
        system.debug('%%%PotentialHistory1'+PotentailHistory);
        
        }
        else if(historyfilter.size() != 0 && fromDate != Null && ToDate == Null ){
        PotentailHistory= 'Select Id,ParentId  from Potential__History where CreatedDate > = :fromDateDateTime and ParentId in: PotId1  AND Field !=  \''+testsr+'\' AND Field in: historyfilter';
        system.debug('%%%PotentialHistory2'+PotentailHistory);
        
        }
        else if(historyfilter.size() != 0 && fromDate == Null && ToDate != Null)
        {
        PotentailHistory= 'Select Id,ParentId  from Potential__History where CreatedDate <= :ToDateDateTime and ParentId in: PotId1  AND Field !=  \''+testsr+'\' AND Field in: historyfilter ';
        system.debug('%%%PotentialHistory3'+PotentailHistory);
        
        }
        else if(historyfilter.size() != 0 && fromDate == Null && ToDate == Null)
        {
        PotentailHistory= 'Select Id,ParentId  from Potential__History where ParentId in: PotId1  AND Field !=  \''+testsr+'\' AND Field in: historyfilter ';
        system.debug('%%%PotentialHistory4'+PotentailHistory);
        }
        else if(historyfilter.size() == 0 && fromDate != Null && ToDate != Null)
        {
        PotentailHistory= 'Select id,ParentId,Field,CreatedDate from Potential__History where ParentId in: PotId1  AND Field !=  \''+testsr+'\' AND CreatedDate <= :ToDateDateTime and  CreatedDate > = :fromDateDateTime ';
        system.debug('%%%PotentialHistory5'+PotentailHistory);
        }

        else {
        PotentailHistory= 'Select Id,ParentId  from Potential__History where ParentId in: PotId1 AND Field !=  \''+testsr+'\' ' ;
        system.debug('%%%PotentialHistory6'+PotentailHistory);
        }
    
        List<Potential__History> PotHistory  = Database.query(PotentailHistory); 

        for( Potential__History Ph : PotHistory){
 
            PotId.add(Ph.Id);
            PotentialParentId.add(Ph.ParentId);
            
        }

        for(Potential_History__c fieldName : [SELECT Id,Field_API_Name__c,Backend_field_check__c,Field_Name_to_display__c from Potential_History__c where Backend_field_check__c = TRUE]){
        
          soql = soql + ', ' + fieldName.Field_API_Name__c; 
        }
        
         soql = soql +  ' , (select CreatedBy.name,CreatedDate,Field,Id,IsDeleted,NewValue,OldValue,ParentId FROM Histories where Id in :PotId order by ParentId,CreatedDate ' ;   
         querysoql = soql  +  ' )   from Potential__c where Id in : PotentialParentId order by lastmodifiedDate desc limit 49999 ' ;
       
        system.debug('@@@querysoql '+querysoql );
       
         List<Potential__c> PotentialList = Database.query(querysoql); 
         List<Potential__History> HH = new List<Potential__History> ();
         TimeZone tz1 = UserInfo.getTimeZone();
         Integer offsetToUserTimeZone1 = tz1.getOffset(Datetime.now());
         Datetime OffsetDate;
          
         for(Potential__c pp:PotentialList )
         {
          for(Potential__History Ph: pp.Histories){
            // OffsetDate=Datetime.newInstance(ph.CreatedDate.year(),ph.CreatedDate.month(),ph.CreatedDate.day(),ph.CreatedDate.hour(),ph.CreatedDate.minute(),ph.CreatedDate.second());
             OffsetDate= ph.CreatedDate;
             Integer offsetValue = offsetToUserTimeZone1 / (1000 * 60 *60 );
        
        
             OffsetDate.addHours(offsetValue);
             String createdDateText1= String.valueOf(OffsetDate);
            // String createdDateText = convertToUserTime(t);
             system.debug('@@@ph.CreatedDate'+ph.CreatedDate);
             System.debug('$$$UserDate'+createdDateText1);   
             lstwrap.add(new wrapper(pp,Ph,createdDateText1));
            }
            }
         
         
         system.debug('$$$lstwrap for download'+lstwrap);
         system.debug('$$$lstwrap for download'+lstwrap.size());
         return lstwrap; 
        
        
    }
    
    @AuraEnabled
    public static List <sObject > fetchLookUpValues(String searchKeyWord, String ObjectName) {
        system.debug('ObjectName-->' + ObjectName);
        String searchKey = searchKeyWord + '%';
        
        List < sObject > returnList = new List < sObject > ();
      
        // Create a Dynamic SOQL Query For Fetch Record List with LIMIT 5   
        String sQuery =  'select id, Name from ' +ObjectName + ' where Name LIKE: searchKey order by createdDate DESC limit 5';
        List < sObject > lstOfRecords = Database.query(sQuery);
        
        for (sObject obj: lstOfRecords) {
            returnList.add(obj);
        }
        return returnList;
    }
    
    
}