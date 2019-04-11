({
	openModel : function(component, event, helper) {
		component.set("v.isOpen", true);
	},
    closeModel : function(component, event, helper) {
		//component.set("v.isOpen", false);
		    component.destroy();
	},
     yesModel : function(component, event, helper) {
         // alert('are you sure....)');
       
         console.log('DEL:::::'+component.get("v.deleteRowID"));
         var delEvent=component.getEvent("deleteModelEvent"); 
         delEvent.setParam("rowID",component.get("v.deleteRowID"));
         delEvent.fire();
         //document.body.style.overflow = "hidden";
        // component.set("v.isOpen", false);
         component.destroy();
         
	}
    
    
})