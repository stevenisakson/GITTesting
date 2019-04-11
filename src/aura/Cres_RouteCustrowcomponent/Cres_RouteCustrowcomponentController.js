({
    doInit : function(component, event, helper) {
        var rec=component.get("v.routecustomer");
        if(rec['isNew']){
            component.set("v.mode",'Edit');
        }
        if(rec.Id!=undefined){
            component.set("v.mode",'View');
        }
        
    },
    Adddcrcust:function(cmp,event,helper){
        
        var plandaylist=cmp.get("v.routecustomerlist");
        plandaylist.unshift({isNew:true});
        cmp.set("v.routecustomerlist",plandaylist);
        
    },
    Edit:function(cmp,event,helper){
        var mode=cmp.get("v.mode");
        if(mode=='View'){
            cmp.set("v.mode",'Edit');
            
        }
    },
    cancel:function(cmp,event,helper){
        
        cmp.set("v.routeerrors",[]);
        var recList=cmp.get("v.routecustomerlist");
        var mode=cmp.get("v.mode");
        var rec=cmp.get("v.routecustomer");
        var index=cmp.get("v.index"); 
        
        if(mode=='Edit'){
            if(rec['isNew']){
                recList.splice(index,1);
                cmp.set("v.routecustomerlist",recList);
                //cmp.destroy();
            }else{  
                cmp.set("v.mode",'View');
                // cmp.set("v.Count",1);
            }
        }
        
    },
    onSubmit:function(cmp,event,helper){
        
        cmp.set("v.routeerrors",[]);
        event.preventDefault();
        var fields = event.getParam("fields");
        fields["Related_Route__c"] = cmp.get("v.recordId");
        console.log(JSON.stringify(fields));
        cmp.find("routeform").submit(fields);
    },
    
    onSuccess:function(component, event, helper){
        
        var toastEvent = $A.get("e.force:showToast");
        
        if(component.get("v.dcrcustomer.Id")!=undefined){
            helper.showUpdateToast();
        }else{
            helper.showCreatedToast();
        }
        component.set("v.mode",'View');
        var cmpEvent = component.getEvent("cmpEvent");
        cmpEvent.fire();
       
        
    },
    onError : function(component, event, helper) {
        
        var dcrerror=component.get("v.routeerrors");
        var params=event.getParams();
        console.log(JSON.stringify(params));
        if(params['output']['fieldErrors']!=undefined){
            for(var fieldName in params['output']['fieldErrors']){
                var rec=params['output']['fieldErrors'][fieldName];
                for(var i=0;i<rec.length;i++){
                    dcrerror.push(rec[i]['message']);
                }
            }
        }
        if(params['output']['errors']!=undefined){
            var rec=params['output']['errors'];
            for(var i=0;i<rec.length;i++){
                dcrerror.push(rec[i]['message']);
            }
        }
        component.set("v.routeerrors",dcrerror);
    },
    deleteRec : function(component, event, helper) {
       
        var recId=component.get("v.routecustomer.Id");
        console.log(recId);
       // alert(recId);
        helper.deleteDcrCustomer(component,event,helper);
    },
})