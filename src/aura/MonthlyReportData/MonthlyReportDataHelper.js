({
	  showCreatedToast : function() {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Success!",
            "message": "The record has been Submitted successfully.",
            "type":"success"
        });
        toastEvent.fire();
    }
})