({
    getAccontRecord : function( component ) {
        var action = component.get("c.getAccountRecord"); //Calling Apex class controller 'getAccountRecord' method
        var action1 = component.get("c.getContactRecord"); //Calling Apex class controller 'getContactRecord' method
        action.setCallback(this, function(response) {
            var state = response.getState(); //Checking response status
            var result = JSON.stringify(response.getReturnValue());
            if (component.isValid() && state === "SUCCESS")
                component.set("v.accLst", response.getReturnValue());// Adding values in Aura attribute variable.   
        });
        
        action1.setCallback(this, function(response) {
            var state = response.getState(); //Checking response status
            var result = JSON.stringify(response.getReturnValue());
            if (component.isValid() && state === "SUCCESS")
                component.set("v.conLst", response.getReturnValue());  // Adding values in Aura attribute variable.   
        });
        
        $A.enqueueAction(action);
        $A.enqueueAction(action1);
    },
    clearAll: function(component, event) {
        // this method set all tabs to hide and inactive
        var getAllLI = document.getElementsByClassName("customClassForTab");
        var getAllDiv = document.getElementsByClassName("customClassForTabData");
        for (var i = 0; i < getAllLI.length; i++) {
            getAllLI[i].className = "slds-tabs--scoped__item slds-text-title--caps customClassForTab";
            getAllDiv[i].className = "slds-tabs--scoped__content slds-hide customClassForTabData";
        }
    },
    
})