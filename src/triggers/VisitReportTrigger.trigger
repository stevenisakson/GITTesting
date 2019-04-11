trigger VisitReportTrigger on Visit_Report__c (after insert)
{
Trigger_Settings__c triggerControl = Trigger_Settings__c.getInstance(userinfo.getProfileId());

    VisitReportTriggerHandler handler = new VisitReportTriggerHandler();
    if(trigger.isAfter)
    {
        if(triggerControl.Visit_Report__c)
 		{
            If(trigger.isInsert)
            {
                 handler.afterInsert(trigger.newmap); 
            }
    }
  }
}