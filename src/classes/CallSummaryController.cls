public class CallSummaryController{
    public Visit_Report__c[] CallSummaryList {get;set;}
    public Visit_Report__c CallSummaryRecord {get;set;}
    public String external_note {get;set;}
    public String internal_note {get;set;}
    public Boolean mobileversion {get;set;}
    public Boolean errorinmobile {get;set;}
    string External;
    string Internal;
    string Link;
    
    Event currentRecord;
    Id currentRecordId;
    public PageReference pageRef;
    
    
    User u = [select Id, username,Business_Unit__c from User where Id = :UserInfo.getUserId()];
    List<Email_Template_Settings__c> etemp= Email_Template_Settings__c.getall().values();
    public Map<String,string> emailtemplatemval= new Map<String,string>();
        
         
      
 

       public CallSummaryController(ApexPages.StandardController controller) {
        currentRecord = (Event)controller.getRecord();
        currentRecordId = currentRecord.id;
        refresh();

        mobileversion = false;
        errorinmobile = false;
        
        for(Email_Template_Settings__c s:etemp){
    
             emailtemplatemval.put(s.Name,s.Template_Id__c);
         }
    }
    
    public void updateTable(){
        if(mobileversion){
            CallSummaryRecord.External_call_notes__c = external_note;
            CallSummaryRecord.Internal_call_notes__c = internal_note;
        }
        
        Savepoint sp = Database.setSavepoint();
        try{
            upsert CallSummaryRecord;

            //Retrieve current Event
            Event evt = [Select Id, Visit_Report__c, Call_Notes_Updated__c From Event Where Id = : currentRecordId];
            
            //Assign created/updated Visit Report to current Event
            evt.Visit_Report__c = CallSummaryRecord.Id;
            evt.Call_Notes_Updated__c = true;

            update evt;
            //update CallSummaryRecord;
            Apexpages.addmessage(new Apexpages.Message(ApexPages.Severity.INFO, 'Record has been saved.'));
            refresh();
        }catch(Exception e){
            errorinmobile = true;
            Database.rollback(sp);
            //Apexpages.addmessage(new Apexpages.Message(ApexPages.Severity.ERROR, 'ERROR!, Please select a Call Purpose.'));
            System.debug('***Error! '+e.getMessage()+' '+e.getLineNumber());
        }
    }
    
    public PageReference sendVisitReportExternal(){
    
    
               Event evt = [Select Id, Visit_Report__c, Call_Notes_Updated__c, whatId,Subject,StartDateTime,EndDateTime From Event Where Id = : currentRecordId];
           
            try
            {
                if((String.valueOf(evt.whatid)).substring(0,3)=='001')
                {
                    Account acct= [Select id, Event_External_Notes__c, Event_Internal_Notes__c,Event_Subject__c,Event_End_DateTime__c,Event_Start_DateTime__c from account where id=:evt.whatid];
                    acct.Event_External_Notes__c= CallSummaryRecord.External_call_notes__c;
                    acct.Event_Internal_Notes__c= CallSummaryRecord.Internal_call_notes__c;
                    acct.Event_Subject__c = evt.Subject;
                    acct.Event_End_DateTime__c = evt.EndDateTime;
                    acct.Event_Start_DateTime__c = evt.StartDateTime;
                    
                    update acct;
                }
            }
            catch(exception e)
            {
                system.debug('The following error occured:'+e.getmessage());
            }
           
           try{
                if((String.valueOf(evt.whatid)).substring(0,3)=='006')
                {
                    Opportunity opp= [Select id, Event_External_Notes__c,Event_Internal_Notes__c,Event_Subject__c,Event_End_DateTime__c,Event_Start_DateTime__c from Opportunity where id=:evt.whatid];
                    opp.Event_External_Notes__c= CallSummaryRecord.External_call_notes__c;
                    opp.Event_Internal_Notes__c= CallSummaryRecord.Internal_call_notes__c;
                    opp.Event_Subject__c = evt.Subject;
                    opp.Event_End_DateTime__c = evt.EndDateTime;
                    opp.Event_Start_DateTime__c = evt.StartDateTime;
                    update opp;
                }
            }
            catch(exception e)
            {
                system.debug('The following error occured:'+e.getmessage());
            }
         if(u.Business_Unit__c!=null){
         External = u.Business_Unit__c +' '+Label.External;
         if(emailtemplatemval.containskey(External)){
             
            Link='/email/author/emailauthor.jsp?retURL=/'+evt.id+'&p3_lkid='+evt.whatid+'&template_id='+emailtemplatemval.get(External)+'&new_template=1';
           
            }
        }
        
        pageRef = new PageReference(Link);
        pageRef.setRedirect(true);
        return pageRef; 
        
    }
    
    public void refresh(){
        CallSummaryList = [SELECT Id, Name,Internal_call_notes__c, External_call_notes__c, Complaint_Raised__c, Training_scheduled__c, Event_ID__c, LastModifiedDate 
                           FROM Visit_Report__c 
                           WHERE Event_ID__c =:currentRecordId];

        if(CallSummaryList.size()>0){
            CallSummaryRecord = CallSummaryList[0];
        }else{
            CallSummaryRecord = new Visit_Report__c ();
            CallSummaryRecord.Event_ID__c = currentRecord.id; 
        }
    }
}