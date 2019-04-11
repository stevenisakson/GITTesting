({
    getDynamicRecord : function( component ) {
        var opts = [];
        var opts1 = [];
        var action = component.get("c.getMonths");
        var action1 = component.get("c.getYears");
        
        action.setCallback(this, function(response){
            var state=response.getState();
            if(state === "SUCCESS"){
                for(var i=0;i<response.getReturnValue().length;i++){
                    opts[i] = {"class": "optionClass", label:response.getReturnValue()[i], value:response.getReturnValue()[i]};
                }
                component.find("InputSelectDynamicMonth").set("v.options", opts);
            }
        })
        
        action1.setCallback(this, function(response){
            var state=response.getState();
            if(state === "SUCCESS"){
                console.log(response.getReturnValue());
                for(var i=0;i<response.getReturnValue().length;i++){
                    opts1[i] = {"class": "optionClass", label:response.getReturnValue()[i], value:response.getReturnValue()[i]};
                }
                component.find("InputSelectDynamicYear").set("v.options", opts1);
                
            }
        })
        $A.enqueueAction(action); 
        $A.enqueueAction(action1); 
        
    },
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