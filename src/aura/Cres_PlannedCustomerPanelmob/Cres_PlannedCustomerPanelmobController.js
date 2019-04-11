({
    doInit : function(cmp, event, helper) {
        var recId=cmp.get("v.recordId");
        console.log('doInit');
        if(recId!=undefined){
            cmp.set("v.isLoading",true);
           
            helper.fetchPlannedCustomers(cmp,recId);
        }else{
            console.log('recordId not available');
        } 
    },
       
})