({
	doInit : function(component, event, helper) {
		var action = component.get("c.getAttachmentListEvents"); 
        var action1 = component.get("c.getCommunityDetails"); // get community name details
        action.setCallback(this, function(a){            
            if (a.getState() === "SUCCESS"){
                var arrayEvents = a.getReturnValue();
                arrayEvents.sort(function(a, b){
                    var dateA=new Date(a.StartMonthDate), dateB=new Date(b.StartMonthDate)
                    //return dateA-dateB //sort by date ascending
                    return dateB-dateA //sort by date descending
                })
            	component.set('v.eventList',arrayEvents);                    
            }else if (a.getState() === "ERROR") 
            	console.log(a.getError());       
        });
        action1.setCallback(this, function(response) {
            var state = response.getState(); //Checking response status
            var result = JSON.stringify(response.getReturnValue());
            if (component.isValid() && state === "SUCCESS")
                component.set("v.homeUrl", response.getReturnValue());// Adding values in Aura attribute variable.   
		});
        
        $A.enqueueAction(action);
        $A.enqueueAction(action1);
    },
    callUpdateRecord : function(component, event, helper) {	
        helper.deleteAccount(component, event); 
	},
})