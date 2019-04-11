({
    /*Delete the record*/
	deletePlanDay : function(cmp,recId,callback) {
		var deleteAction=cmp.get("c.deleteRecord");
        deleteAction.setParams({'recId':recId});
        deleteAction.setCallback(this,function(resp){
            var state=resp.getState();
            if(state==='SUCCESS'){
                var retValue=resp.getReturnValue();
                console.log(retValue);
                if(retValue.data!=undefined){
                    if(retValue.isSuccess==true){
                        callback(true);
                    }else{
                        callback(false);
                    }
                }
            }
        });
        $A.enqueueAction(deleteAction);
	},
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
     showDeleteToast : function() {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Success!",
            "message": "The record has been deleted successfully.",
            "type":"success"
        });
        toastEvent.fire();
    }
})