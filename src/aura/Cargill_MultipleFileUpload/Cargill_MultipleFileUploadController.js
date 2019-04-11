({
    handleUploadFinished: function (cmp, event) {
        // Get the list of uploaded files
        var uploadedFiles = event.getParam("files");
        // show success message – with no of files uploaded
        if(uploadedFiles.length > 1){
            var toastEvent = $A.get("e.force:showToast");
            
            toastEvent.setParams({
                "title": "Success!",
                "type" : "success",
                "message": uploadedFiles.length+" attachments has been uploaded successfully!"
            });
            toastEvent.fire();
        }else if(uploadedFiles.length == 1){
            var toastEvent1 = $A.get("e.force:showToast");
            
            toastEvent1.setParams({
                "title": "Success!",
                "type" : "success",
                "message": uploadedFiles.length+" attachment has been uploaded successfully!"
            });
            toastEvent1.fire();
        }
        
        $A.get('e.force:refreshView').fire();
        
        // Close the action panel
        var dismissActionPanel = $A.get("e.force:closeQuickAction");
        dismissActionPanel.fire();
    },
    
})