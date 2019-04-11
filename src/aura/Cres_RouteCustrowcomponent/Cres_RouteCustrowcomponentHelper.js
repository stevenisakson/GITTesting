({
    showUpdateToast : function() {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Success!",
            "message": "The record has been updated successfully.",
            "type":"success"
        });
        toastEvent.fire();
    },
    showCreatedToast : function() {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Success!",
            "message": "The record has been created successfully.",
            "type":"success"
        });
        toastEvent.fire();
    },
    deleteDcrCustomer : function(cmp, event, helper) {
        var recId=cmp.get("v.routecustomer.Id");
        // alert(recId);
        var deleteAction=cmp.get("c.deleteRecord");
        deleteAction.setParams({'recId':recId});
        deleteAction.setCallback(this, function(response){
            var state = response.getState();
            console.log('### state' + state);
            if(state==="SUCCESS"){
                
                var storeResponse = response.getReturnValue();
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Deleted!",
                    "message": "The record has been Deleted successfully.",
                    "type":"success"
                });
                toastEvent.fire();
                
                var cmpEvent = cmp.getEvent("cmpEvent");
                cmpEvent.fire();
                
            }
            else
            {
                console.log('error');
                alert('Unable to delete the record please contact your Admin');
            }
            
        });
        $A.enqueueAction(deleteAction);
    },
})