({
	doInit : function(component, event, helper) {
		var opts = [];
        var action2 = component.get("c.FetchHistoricType"); // call history function
        action2.setCallback(this, function(response){
            var state=response.getState();
            if(state === "SUCCESS"){
                for(var i=0;i<response.getReturnValue().length;i++){
                    opts[i] = {"class": "optionClass", label:response.getReturnValue()[i], value:response.getReturnValue()[i]};
                }
                component.find("InputSelectDynamicType").set("v.options", opts);
            }
        })
        $A.enqueueAction(action2);
	},
    
    onChangeFunction : function(component, event, helper) {
    var result = component.find("InputSelectDynamicType").get("v.value");
    	if(result == 'Display'){
            component.set("v.displayFlag", 'true');
            component.set("v.eventFlag", 'false');
            component.set("v.prospectFlag", 'false');
            component.set("v.trainingFlag", 'false');
            component.set("v.displaydefaultFlag",'false');
        }else if(result == 'Events'){
            component.set("v.eventFlag", 'true');
            component.set("v.displayFlag", 'false');
            component.set("v.prospectFlag", 'false');
            component.set("v.trainingFlag", 'false');
            component.set("v.displaydefaultFlag",'false');
        }else if(result == 'Prospect Lists and Activities'){
            component.set("v.prospectFlag", 'true');
            component.set("v.eventFlag", 'false');
            component.set("v.displayFlag", 'false');
            component.set("v.trainingFlag", 'false');
            component.set("v.displaydefaultFlag",'false');
        }else if(result == 'For Training'){
            component.set("v.trainingFlag", 'true');
            component.set("v.displayFlag", 'false');
            component.set("v.eventFlag", 'false');
            component.set("v.prospectFlag", 'false');
            component.set("v.displaydefaultFlag",'false');
		}
	},
})