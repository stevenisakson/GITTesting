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
   
})