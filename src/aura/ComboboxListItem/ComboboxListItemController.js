({
	select : function(cmp, event, helper) {
		var eve=cmp.getEvent("itemSelected");
        eve.setParam("data",cmp.get("v.item"));
        eve.fire();
        
	}
})