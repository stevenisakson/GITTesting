({
    getroutecustomers : function(cmp, event, helper) {
        
        var recId=cmp.get("v.recordId");
       // alert(recId);
        var action=cmp.get("c.getCustomerList");
        action.setParams({'routeid':recId});
        action.setCallback(this, function(response){
            var state = response.getState();
            console.log('### state' + state);
            if(state==="SUCCESS"){
               console.log('success');
               cmp.set("v.routecustomerlist",response.getReturnValue());
            }
            else
            {
                console.log('error');
                alert('Unable to get record please contact your Admin');
            }
            
        });
        $A.enqueueAction(action);
     },
    getroute : function(cmp, event, helper) {
        
        var recId=cmp.get("v.recordId");
       // alert(recId);
        var action=cmp.get("c.getroutedetails");
        action.setParams({'routeid':recId});
        action.setCallback(this, function(response){
            var state = response.getState();
            console.log('### state' + state);
            if(state==="SUCCESS"){
               console.log('success');
               cmp.set("v.route",response.getReturnValue());
                console.log( cmp.get("v.route").Status__c);
                if(cmp.get("v.route").Status__c ==="Submit for Approval" || cmp.get("v.route").Status__c ==="Approved")
                {
                     cmp.set("v.isdisabled",true);
                }
               
                
            }
            else
            {
                console.log('error');
                alert('Unable to get record please contact your Admin');
            }
            
        });
        $A.enqueueAction(action);
     },
    
})