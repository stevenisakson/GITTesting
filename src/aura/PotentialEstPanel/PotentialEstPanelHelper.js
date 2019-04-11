({
    /*Helper method for loading categories*/
	loadCalcCategories : function(cmp,callback) {
        var action=cmp.get("c.getCalcCategories");
        action.setCallback(this,function(resp){
           
            cmp.set("v.isLoading",false);
            callback(resp);
          
        });
        $A.enqueueAction(action);
        cmp.set("v.isLoading",true);
	}
})