({
	deleteAccount : function(component, event) {
        var d = new Date();
        var currentMonth = d.getMonth() + 1;
        var recordId = event.target.id;
        var res = recordId.substr(0, 18);
        var monthset = recordId.substr(recordId.indexOf("_")+6,2);
        
        
        if(confirm('Are you sure?')){
            if(monthset < currentMonth)
                alert('Past month document are locked for deletion');
            else{
                var action = component.get("c.UpdateDocumentAttachment");
                action.setParams({accid:res});
                action.setCallback(this, function(response) {
                    console.log('###inside function deletion today');
                    window.location.href = component.get("v.homeUrl")+'/detail/'+res;
                });
                $A.enqueueAction(action);
            }
        }
    },
})