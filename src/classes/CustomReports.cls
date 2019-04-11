public with sharing class CustomReports {
    @AuraEnabled
    public static wrapperClass getReportInfo(){
        wrapperClass returnwrapperClass = new  wrapperClass ();
        string userbUnit= [SELECT Business_Unit__c FROM User where id=:UserInfo.getUserId()].Business_Unit__c;
        String query= 'Select Id,Name,Report_Name__c,Report_link__c,External_System_Report__c,SFDC_System_Report__c,Section_Name__c,Sequence__c,Business_Unit__c from Custom_Reports__c where Business_Unit__c ='+'\''+userbUnit+'\''+' ORDER BY Sequence__c';
        system.debug(query);
        List<Custom_Reports__c> listReport = Database.query(query); 
        returnwrapperClass.CustomReportwrapList = listReport;
        set<string> sectionNameSet = new set<string>();
        for(Custom_Reports__c cus: listReport)
        {
        	sectionNameSet.add(cus.Section_Name__c);
        }
        returnwrapperClass.sectionNamewrapSet = sectionNameSet;
        System.debug('***'+listReport);
        returnwrapperClass.baseOrgURL = System.URL.getSalesforceBaseUrl().toExternalForm()+'/c/';
		//System.debug('baseUrl =' + baseUrl);
        if(!listReport.isEmpty()){
        return returnwrapperClass;
    }
        else
            return null;
    }
    
    public class wrapperClass{
    @AuraEnabled public List<Custom_Reports__c> CustomReportwrapList{get;set;}
    @AuraEnabled public set<string> sectionNamewrapSet{get;set;}    
    @AuraEnabled public string baseOrgURL{get;set;}    
    }
}