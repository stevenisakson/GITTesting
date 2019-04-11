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
             component.set("v.isLoading",false);
             var state = response.getState();
           
            if(state==="SUCCESS"){
                var storeResponse = response.getReturnValue();
              
             }
           
             this.checkUserAccess(storeResponse);    
             component.set("v.planmonth",storeResponse);
             console.log(storeResponse);
        });
        component.set("v.isLoading",true);
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
            component.set("v.isLoading",false);
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
              
               
            }
            else {
                // Show an alert if the state is incomplete or error
                alert('Error in getting data');
            }
             console.log(plandaylist);
        });
        // Adding the action variable to the global action queue
        component.set("v.isLoading",true);
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
    },
        showSubmitToast : function() {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Success!",
            "message": "The record has been submitted successfully.",
            "type":"success"
        });
        toastEvent.fire();
    },
     getactivityPickList : function(component){
        var action = component.get("c.getPicklistvalues");
        action.setParams({
            'objectName': "Planning_Month__c",
            'field_apiname': 'First_Half__c',
            'nullRequired': true // includes --None--
        });
        action.setCallback(this, function(a) {
            var state = a.getState();
            console.log('logs');
            console.log(a.getReturnValue());
            component.set("v.isLoading",false);
            if (state === "SUCCESS"){
                component.set("v.activityPickList", a.getReturnValue());
            } 
        });
        component.set("v.isLoading",true);
        $A.enqueueAction(action);
    },
    checkUserAccess:function(planMonth){
        /*check if the user has Access to Edit*/
        var userId = $A.get("$SObjectType.CurrentUser.Id");
        if(planMonth['Target__r']!=undefined){
            console.log(planMonth['Target__r']['Employee_Link_To__c']);
            if(userId!=planMonth['Target__r']['Employee_Link_To__c']){
                planMonth['isReadOnly__c']=true;
            }
        }
    }
})