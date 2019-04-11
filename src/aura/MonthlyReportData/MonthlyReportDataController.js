({
    
    doInit:function(cmp,event,helper){
        
        console.log(cmp.get("v.recordId"));
        cmp.set("v.isLoading",true);
        window.setTimeout(
            $A.getCallback(function() {
                cmp.set("v.isLoading",false);
            }), 3000
        )
    },
    closeError:function(cmp,event,helper){
         cmp.set("v.cfrerror",[]);
    },
    OnLoad:function(cmp,event,helper){
       
    },
	onSuccess : function(component, event, helper) {
        
        component.set("v.isLoading",false);
        var payload = event.getParams().response;
        console.log(payload.id);
        helper.showCreatedToast();
      
       
        location.reload();
        //navEvt.fire();
    },
       handleUploadFinished: function (cmp, event) {
        // This will contain the List of File uploaded data and status
        var uploadedFiles = event.getParam("files");
        alert("Files uploaded : " + uploadedFiles.length);
    },
    onSubmit:function(component,event,helper){
        component.set("v.cfrerror",[]);
        component.set("v.isLoading",true);
    },
     onError : function(component, event, helper) {
	
        component.set("v.isLoading",false);
         var payload = event.getParams().response;
         console.log(payload.id);
        var cfrerror=component.get("v.cfrerror");
        var params=event.getParams();
        console.log(JSON.stringify(params));
        if(params['output']['fieldErrors']!=undefined){
            for(var fieldName in params['output']['fieldErrors']){
                var rec=params['output']['fieldErrors'][fieldName];
                for(var i=0;i<rec.length;i++){
                    cfrerror.push(rec[i]['message']);
                }
            }
        }
        if(params['output']['errors']!=undefined){
            var rec=params['output']['errors'];
            for(var i=0;i<rec.length;i++){
                cfrerror.push(rec[i]['message']);
            }
        }
         if(params['error']['status']==404){
           //  helper.showCreatedToast();
            // location.reload();
         }
        component.set("v.cfrerror",cfrerror);
	}
})