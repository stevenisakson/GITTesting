({
	fetchPlanningMonth : function(cmp) {
        var action=cmp.get("c.getPlanningMonth");
    
        action.setCallback(this,function(resp){
            var state=resp.getState();
            if(state==='SUCCESS'){
                cmp.set("v.isLoading",false);
                var retValue=resp.getReturnValue();
                if(retValue.isSuccess){
                    var custList=retValue.data;
                    console.log(custList);
                    cmp.set("v.plannedMonthList",custList);
                  
                }
            }else{
                console.log('Error');
            }
        });
        $A.enqueueAction(action);
        
	},
   
    showToast : function() {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Success!",
            "message": "The record has been created successfully.",
            "type":"success"
        });
        toastEvent.fire();
    },
    showError : function() {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Failed",
            "message": "The records could'nt be updated",
            "type":"error"
        });
        toastEvent.fire();
    },
    validateForm:function(eventFields,errorList){
     
        if(eventFields['Target__c'] == '' || eventFields['Target__c'] == undefined || eventFields["Month_Planned__c"]== '' || eventFields["Month_Planned__c"] == undefined || eventFields["Plan_Year__c"] == '' || eventFields["Plan_Year__c"] == undefined  ){
          errorList.push($A.get("$Label.c.Cres_DCR_All_Mandatory"));
        }
        
    },
    fetchTypePicklist : function(component){
        var action = component.get("c.getPicklistvalues");
        action.setParams({
            'objectName': component.get("v.ObjectName"),
            'field_apiname': component.get("v.Type"),
            'nullRequired': true // includes --None--
        });
        action.setCallback(this, function(a) {
            var state = a.getState();
            console.log('logs');
            console.log(a.getReturnValue());
            if (state === "SUCCESS"){
                component.set("v.plannedmpnth", a.getReturnValue());
            } 
        });
        $A.enqueueAction(action);
    },   
    
    fetchyearPicklist : function(component){
        var action = component.get("c.getPicklistvalues");
        action.setParams({
            'objectName': component.get("v.ObjectName"),
            'field_apiname': component.get("v.year"),
            'nullRequired': true // includes --None--
        });
        action.setCallback(this, function(a) {
            var state = a.getState();
            console.log('logs');
            console.log(a.getReturnValue());
            if (state === "SUCCESS"){
                component.set("v.plannyear", a.getReturnValue());
            } 
        });
        $A.enqueueAction(action);
    },   
})