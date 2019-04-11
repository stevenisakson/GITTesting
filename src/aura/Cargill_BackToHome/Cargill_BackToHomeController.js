({
    doInit : function(component, event, helper) {
        var action = component.get('c.getCommunityDetails'); // get community name details
        action.setCallback(this, function(response) {
            var state = response.getState(); //Checking response status
            var result = JSON.stringify(response.getReturnValue());
            console.log('$$$$result'+result);
            if (component.isValid() && state === "SUCCESS")
                component.set("v.homeUrl", response.getReturnValue());// Adding values in Aura attribute variable.   
            
            window.location.href = component.get("v.homeUrl");
        });
        $A.enqueueAction(action);
        
    }
})