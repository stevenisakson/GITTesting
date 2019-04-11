({
	navigateToRecord : function (component, event, helper) {
        console.log('Called function');
        var urlEvent = $A.get("e.force:navigateToURL");
        var conid = component.get("v.accountattId");
        if(urlEvent){
            urlEvent.setParams({ 
                "url":"/detail/"+conid
            }); 
            urlEvent.fire();
        }else{
            window.location = '/detail/'+conid
        }
    },
})