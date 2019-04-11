public class RequestDeepCloneController{
//added an instance varaible for the standard controller
    private ApexPages.StandardController controller {get; set;}
     // add the instance for the variables being passed by id on the url
    private Request__c req {get;set;}
    // set the id of the record that is created -- ONLY USED BY THE TEST CLASS
    public ID newRecordId {get;set;}

    // initialize the controller
    public RequestDeepCloneController (ApexPages.StandardController controller) {

        //initialize the stanrdard controller
        this.controller = controller;
        // load the current record
        req = (Request__c)controller.getRecord();
        ProcessInstance procstep;

    }

    // method called from the VF's action attribute to clone the req
    public PageReference cloneWithItems() {

         // setup the save point for rollback
         Savepoint sp = Database.setSavepoint();
         Request__c newreq = new Request__c();
         string customerRecordTypeId = [Select Id From RecordType Where SobjectType = 'Request__c' AND DeveloperName = 'Commercial_Customer_Update'].Id;

         try{
              //copy the request - ONLY INCLUDE THE FIELDS YOU WANT TO CLONE
             req = [select Id, Name, Account__c, RecordTypeId, Status__c from Request__c where id = :req.id];
             
             if(req.Status__c != 'Approved' && req.Status__c!= 'Rejected'){
                      ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Request needs to be either Approved or Rejected in order to be cloned'));
                      return null;
             }
             
             else{
                 newreq = req.clone(false);
                 newreq.cloned__c = true;
                 newreq.RecordTypeId =customerRecordTypeId ;
                 newreq.Status__c ='Submitted';
                 
                 for (processinstance procstep: [SELECT Id, (SELECT Id, StepStatus, Comments FROM StepsAndWorkitems where StepStatus ='Approved' or StepStatus='Rejected') FROM ProcessInstance where targetObjectId = :req.id order by CreatedDate desc LIMIT 1]){
                     for (ProcessInstanceHistory  st: procstep.StepsAndWorkitems ){
                        // newreq.description__c = newreq.description__c +'\n'+   st.StepStatus + ' Comments: '+ st.Comments;}
                        newreq.description__c =   'Cloned from: '+req.Name+ '\n'+' Data Steward Comments: '+st.Comments;
                        
                     }
                    
                    
                     system.debug('@@@@@@@@@         ' + newreq);
                     newreq.Parent_Request__c = req.id;
                     insert newreq;
        
                     // set the id of the new req created for testing
                     newRecordId = newreq.id;
                     
                     // copy over the line items - ONLY INCLUDE THE FIELDS YOU WANT TO CLONE
                     List<RequestLineItem__c> items = new List<RequestLineItem__c>();
                     for(RequestLineItem__c reqline: [Select rline.Id, rline.Existing_Value__c,rline.Field_Name__c, rline.New_Value__c, rline.Status__c, rline.request__c From RequestLineItem__c rline where Request__c = :req.id]) {
                        RequestLineItem__c newrline = reqline.clone(false);
                        newrline.Request__c = newreq.id;
                        items.add(newrline);
                     }
                     
                     system.debug('\n\n** items : '+ items +'**\n\n');
                     insert items;
                 }
             } 
         }
         catch (Exception e){
             // roll everything back in case of error
            Database.rollback(sp);
            ApexPages.addMessages(e);
            return null;
         }

        //return new PageReference('/'+newreq.id+'/e?retURL=%2F'+newreq.id);
      //  return new PageReference('/'+newreq.id);
      return new PageReference('/apex/DynamicRequest?AccId='+newreq.Account__c+'&oldReqId='+req.Id+'&ReqId='+newreq.Id+'&status=Clone');//changed the status to clone and added oldReqId by Anjerico Caburnay 8-18   
    }
    
}