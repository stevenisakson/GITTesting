({
    createTrainingData : function(component, event, helper) {
        console.log('Create record');
        var attendeeval = component.find("countAttendee").get("v.value");
        //getting the accountAttachment information
        var accountAttachment = component.get("v.accountattachment");
        
        //Validation
        if($A.util.isEmpty(accountAttachment.Training_Date__c) || $A.util.isUndefined(accountAttachment.Training_Date__c)){
            alert('Training Date is Required');
            return;
        } 
        if($A.util.isEmpty(accountAttachment.Topic__c) || $A.util.isUndefined(accountAttachment.Topic__c)){
            alert('Topic name is Required');
            return;
        }	
        if($A.util.isEmpty(accountAttachment.of_Attendees__c) || $A.util.isUndefined(accountAttachment.of_Attendees__c)){
            alert('Number of Attendee is Required');
            return;
        }
        if($A.util.isEmpty(accountAttachment.Attendees__c) || $A.util.isUndefined(accountAttachment.Attendees__c)){
            alert('Attendees Names is Required');
            return;
        }
        if (isNaN(component.find("countAttendee").get("v.value"))) {
            alert('Please enter only numeric characters in Number of attendees field');
            return;
        }
        
        var action = component.get("c.createRecord");
        
        //Setting the Apex Parameter
        action.setParams({
            monthlyattach : accountAttachment, monthSel : null, yearSel : null, Type : $A.get("$Label.c.Cargill_Document_Type_TrainingData")
        });
        
        //Setting the Callback
        action.setCallback(this,function(a){
            //get the response state
            var state = a.getState();
            
            //check if result is successfull
            if(state == "SUCCESS"){
                //Reset Form
                var newCandidate = {'sobjectType': 'Account_Attachments__c','Account__c': '','Start_Month_Date__c': '',
                                    'End_Month_Date__c': '','Quarterly_Start_Date__c': '','Quarterly_End_Date__c':'','Type__c':'',
                                    'Last_Upload_Date__c': '','Training_Date__c': '','Topic__c': '','of_Attendees__c': '','Attendees__c': '','Monthly_Uploaded_Date__c':''};
                component.set("v.accountattachment",newCandidate);
                var aResp = a.getReturnValue();
                component.set("v.accountattId",aResp);
            } else if(state == "ERROR"){
                alert('Error in calling server side action');
            }
            helper.navigateToRecord(component, event, helper); 
        });
        
        //adds the server-side action to the queue        
        $A.enqueueAction(action);
    },
    
    doInit : function(component, event, helper) {
        component.find("topicname").focus();
    },
})