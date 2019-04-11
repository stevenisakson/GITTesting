public class VisitReportTriggerHandler
{
    public void afterInsert(Map<Id,Visit_Report__c> vrMap)
    {
        List<Event> eventUpdateList = new List<Event>();
        List<Visit_Report__c> vstRptUpdateList = new List<Visit_Report__c>();
        set<string> eventExtIdset = new set<string>();
        Map<string,string> externIdvisitIdMap = new Map<string,string>();
        Map<string,string> externalIdeventIdMap = new Map<string,string>();
        
        for(Visit_report__c vr: vrMap.values())
        {
            if(String.isNotBlank(vr.External_Event_Id__c))
            {
                externIdvisitIdMap.put(vr.External_Event_Id__c,vr.Id);
                eventExtIdset.add(vr.External_Event_Id__c);
            }
        }
        
        if(!externIdvisitIdMap.isEmpty())
        {
        
            List<Event> eventList = [select Id,Visit_Report__c,External_Id__c,Call_Notes_Updated__c 
                                     from Event
                                     where External_Id__c in : eventExtIdset and IsRecurrence = false];
        
        
            for(Event evt: eventList )
            {
                if(externIdvisitIdMap.containsKey(evt.External_Id__c))
                {
                    evt.Visit_Report__c =  externIdvisitIdMap.get(evt.External_Id__c);
                    evt.Call_Notes_Updated__c = true;
                    externalIdeventIdMap.put(evt.External_Id__c,evt.Id);
                } 
            
            eventUpdateList.add(evt);   
            }
        
            if(!eventUpdateList.isEmpty())
            {
                Update eventUpdateList;
            }
        
            List<Visit_Report__c> visitUpdateList = [select Id,Event_ID__c,External_Event_Id__c 
                                                     from Visit_Report__c 
                                                     where External_Event_Id__c IN : eventExtIdset];
                                                 
            for(Visit_Report__c vr: visitUpdateList)  
            {
                if(externalIdeventIdMap.containsKey(vr.External_Event_Id__c))
                {
                    vr.Event_ID__c=externalIdeventIdMap.get(vr.External_Event_Id__c);
                    vstRptUpdateList.add(vr);
                }
            }  
            
            if(!vstRptUpdateList.isEmpty())
            {
                Update vstRptUpdateList;
            }  
         }                   
      } 
}