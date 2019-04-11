({
    /*Delete the record*/
	deletePlanDay : function(cmp,recId,callback) {
		var deleteAction=cmp.get("c.deleteRecord");
        deleteAction.setParams({'recId':recId});
        deleteAction.setCallback(this,function(resp){
            var state=resp.getState();
            if(state==='SUCCESS'){
                var retValue=resp.getReturnValue();
                console.log(retValue);
                if(retValue.data!=undefined){
                    if(retValue.isSuccess==true){
                        callback(true);
                    }else{
                        callback(false);
                    }
                }
            }
        });
        $A.enqueueAction(deleteAction);
	},
      showUpdateToast : function() {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Success!",
            "message": "The record has been updated successfully.",
            "type":"success"
        });
        toastEvent.fire();
    },
      showCreatedToast : function() {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Success!",
            "message": "The record has been created successfully.",
            "type":"success"
        });
        toastEvent.fire();
    },
     showDeleteToast : function() {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Success!",
            "message": "The record has been deleted successfully.",
            "type":"success"
        });
        toastEvent.fire();
    },
    
     fetchfirstPicklist : function(component){
        var action = component.get("c.getPicklistvalues");
        action.setParams({
            'objectName': component.get("v.ObjectName"),
            'field_apiname': component.get("v.firsthalf"),
            'nullRequired': true // includes --None--
        });
        action.setCallback(this, function(a) {
            var state = a.getState();
            console.log('logs');
            console.log(a.getReturnValue());
            if (state === "SUCCESS"){
                component.set("v.firsthalflist", a.getReturnValue());
            } 
        });
        $A.enqueueAction(action);
    }, 
        savePlanDayMob:function(cmp,day){
        var action = cmp.get("c.savePlanDay");
        action.setParams({
            'planDay': day
            
        });
        action.setCallback(this, function(a) {
            var state = a.getState();
            console.log('logs');
            console.log(a.getReturnValue());
            cmp.set("v.isLoading",false);
            if (state === "SUCCESS"){
                var ret=a.getReturnValue();
                if(ret.isSuccess){
                    if(day['isNew']){
                        this.showCreatedToast();
                    }else{
                        this.showUpdateToast();

                    }
                    var compEvent = cmp.getEvent("Plandayrecords");
                    compEvent.fire();
                }else{
                   cmp.set("v.plandayerror",[ret.msg]);
                }
             
               
               // component.set("v.secondhalflist", a.getReturnValue());
            } else{
                
            }
        });
        $A.enqueueAction(action);
    },
    validateForm:function(day,errorList){
        if(day['First_Half__c']=='--None--' || day['Second_Half__c']=='--None--'){
              errorList.push($A.get("$Label.c.Cres_DCRFirstSecMandatory"));
        }
    }
})