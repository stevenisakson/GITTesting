({
    doInit : function(component, event, helper) {
        var contactIds = component.get("v.recordId");
        var checkAction =  component.get("c.checkContactValues"); //Calling Apex class controller 'checkContactValues' method
        checkAction.setParams({contactId:component.get("v.recordId")}); 
        checkAction.setCallback(this,function(a){
            var state = a.getState();
            if(state == "SUCCESS"){
                var aRespdis = a.getReturnValue();
                console.log('Response!!'+aRespdis);
                if(aRespdis){
                    $A.enqueueAction(component.get('c.doUpdateContact'));
                }else{
                    component.set("v.errormsg", 'Please select CFR Contact checkbox before submission');
                }
            }
        });
        $A.enqueueAction(checkAction);
        
    },
    
	    doUpdateContact : function(component, event, helper) {
        var actionApproval = component.get("c.updateContactData"); //Calling Apex class controller 'updateContactData' method
        
        actionApproval.setParams({contactId:component.get("v.recordId")}); 
        actionApproval.setCallback(this,function(a){
            var state = a.getState();
            if(state == "SUCCESS"){
                var aRespdis = a.getReturnValue();
                component.set("v.errormsg", a.getReturnValue());
                window.setTimeout(
                    $A.getCallback(function() {
                        $A.get('e.force:refreshView').fire();
                    }), 3000
                );
                console.log('Function Called');
            } else if(state == "ERROR"){
                
            }
        });
        $A.enqueueAction(actionApproval);
    },
    
    closeModel : function(component, event, helper) {
		$A.get("e.force:closeQuickAction").fire();
	} 
})