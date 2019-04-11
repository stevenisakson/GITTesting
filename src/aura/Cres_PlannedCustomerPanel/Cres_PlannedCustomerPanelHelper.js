({
	fetchPlannedCustomers : function(cmp,recId) {
        var action=cmp.get("c.getPlannedCustomerList");
        action.setParams({planDayId:recId});
        action.setCallback(this,function(resp){
            var state=resp.getState();
            if(state==='SUCCESS'){
                cmp.set("v.isLoading",false);
                var retValue=resp.getReturnValue();
                if(retValue.isSuccess){
                    var custList=retValue.data;
                    console.log(custList);
                    cmp.set("v.plannedCustomerList",custList);
                 
                }
            }else{
                console.log('Error');
            }
        });
        $A.enqueueAction(action);
        
	},
   
})