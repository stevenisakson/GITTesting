({
	/*Fetch PlanMonth Data from Server Side*/
    getPlanningMonth: function(component, fieldName, elementId) {
        
         var recordId =  component.get("v.recordId");
       	 console.log('### MAB' + recordId);
        
        var action = component.get("c.getplanmonthdata");
        action.setParams({
            'recordid': recordId         
        });
        
        action.setCallback(this, function(response){
             var state = response.getState();
            console.log('### state' + state);
            if(state==="SUCCESS"){
                var storeResponse = response.getReturnValue();
              
             }
          
             component.set("v.planmonth",storeResponse);
             console.log(storeResponse);
        });
        $A.enqueueAction(action);
  
    },
    /*Fetch Plan Days*/
    fetchplandays : function(component, event, helper) {
        // Assign server method to action variable
        var action = component.get("c.getPlanDayList");
        // Getting the account id from page
        var planmonthid = component.get("v.recordId");
        // Setting parameters for server method
        action.setParams({
            Planmonthid: planmonthid
        });
        // Callback function to get the response
        action.setCallback(this, function(response) {
            // Getting the response state
            var state = response.getState();
            // Check if response state is success
            if(state === 'SUCCESS') {
                // Getting the list of contacts from response and storing in js variable
                var plandaylist = response.getReturnValue();
                if(plandaylist.length==0){
                    component.set("v.plandaylist",[{isNew:true}]);
                }else{
                    component.set("v.plandaylist",plandaylist);
                }
              
                component.set("v.isLoading",false);
            }
            else {
                // Show an alert if the state is incomplete or error
                alert('Error in getting data');
            }
             console.log(plandaylist);
        });
        // Adding the action variable to the global action queue
        $A.enqueueAction(action);
        } 
    ,
    
    showUpdateToast : function() {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Success!",
            "message": "The record has been updated successfully.",
            "type":"success"
        });
        toastEvent.fire();
    }
})