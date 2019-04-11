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
    /*Delete the DCR Customer Added*/
    deleteDcrCustomer : function(cmp,recId,callback) {
        var recId=cmp.get("v.dcrcustomer.Id");
       // alert(recId);
		var deleteAction=cmp.get("c.deleteRecord");
        deleteAction.setParams({'recId':recId});
        deleteAction.setCallback(this, function(response){
            var state = response.getState();
            console.log('### state' + state);
            if(state==="SUCCESS"){
                var nav=cmp.getEvent("dcrEvent");
                nav.fire();
                
                var storeResponse = response.getReturnValue();
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Deleted!",
                    "message": "The record has been Deleted successfully.",
                    "type":"success"
                });
                toastEvent.fire();
                
              
            }
            else
            {
                console.log('error');
            }
           
        });
        $A.enqueueAction(deleteAction);
	},
   
})