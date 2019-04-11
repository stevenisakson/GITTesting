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
    
    populateType : function( component ) {
        var opts = [];
        var action = component.get("c.FetchDocumentType"); // call display function	
        action.setCallback(this, function(response){
            
            var state=response.getState();
            if(state === "SUCCESS"){
                for(var i=0;i<response.getReturnValue().length;i++){
                    opts[i] = {"class": "optionClass", label:response.getReturnValue()[i], value:response.getReturnValue()[i]};
                }
                component.find("InputSelectDynamicType").set("v.options", opts);
            }
        })
        $A.enqueueAction(action);
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
        //window.location = '/BaxterMain/s/detail/'+conid
    },
    
    
    
   
})