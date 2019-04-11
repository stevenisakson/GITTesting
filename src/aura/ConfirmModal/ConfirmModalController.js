({
	openModel : function(component, event, helper) {
        
        var confirmevent=component.getEvent("confirmcheck");
        confirmevent.setParam('isConfirm',true);
        confirmevent.fire();
        component.destroy();
		
	},
    closeModel : function(component, event, helper) {
	  var confirmevent=component.getEvent("confirmcheck");
        confirmevent.setParam('isConfirm',false);
        confirmevent.fire();
        component.destroy();
	}
    
    
})