({
    deleteAccount : function(component, event) {
        var recordId = event.target.id;
        var res = recordId.substr(0, 18);
        if(confirm('Are you sure?')){
            var action = component.get("c.UpdateDocumentAttachment");
            action.setParams({accid:res});
            action.setCallback(this, function(response) {
                console.log('###inside function deletion today');
                //window.location.href = '/BaxterMain/s/detail/'+res;
                window.location.href = component.get("v.homeUrl")+'/detail/'+res;
            });
            $A.enqueueAction(action);
        }
    },
})