@isTest(SeeAllData=true)
private class VisitReportTriggerHandlerTest {
 static testMethod void testafterInsert() {
   //Creating Event
    Event myEvent= new Event(Business_Unit__c = 'US',
            Cancelled__c = false,
            Claim_Complaint__c = false,
            External_Id__c='12345678',
            IsRecurrence = false,
            Reminder_to_Schedule_Follow_Up__c = System.today(),
            Sales__c = true,
            Segment__c = 'Dennis',
            Service__c = false,
            Sub_Type__c = 'Visit',
            Time_Taken_Hours__c = 3,
            DurationInMinutes = 2,
            ActivityDateTime = System.now()
        );
    Insert myEvent;
    //Creating Related Visit Report
    Visit_Report__c myVisitReport= new Visit_Report__C(
            Complaint_Raised__c = false,
            Event_ID__c = myEvent.Id,
            External_Call_Notes__c = 'Note Ext',
            External_Event_Id__c= myEvent.External_Id__c,                                         
            Internal_Call_Notes__c = 'Note Int',
            
            Training_Scheduled__c = false);
    Insert myVisitReport; 
    }
    
}