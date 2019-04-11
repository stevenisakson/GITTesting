({
    refreshDashboards : function(component, event, helper) {
        helper.showSpinner(component);
        var isMobile = /iPhone|iPad|iPod|Android/i.test(navigator.userAgent);
        if (isMobile) {
            component.set("v.deviceType",'false');
        } else {
          	component.set("v.deviceType",'true');
        }
        var action = component.get("c.checkMonthlyList"); // call display function
        var action1 = component.get("c.checkQuarterlyList"); // call Events function
        var action2 = component.get("c.checkTrainingList"); // call Training function
        var action3 = component.get("c.checkProspectList"); // call prospect function
        var action4 = component.get("c.checkGrowthMetrix"); // call checkGrowthMetrix function
        var action5 = component.get("c.checkGrowthMetrixV1"); // updated function to set manual growth
        action.setParams({currentMonthID:null}); 
		action1.setParams({currentEventID:null});
        action2.setParams({currentTrainingID:null});
        action3.setParams({currentProspectID:null});
        action4.setParams({currentGrowthID:null});
        action5.setParams({currentProductGrowthID:null});
        
        action.setCallback(this,function(a){
            var state = a.getState();
            if(state == "SUCCESS"){
                var aResp = a.getReturnValue();
                component.set("v.monthlypresent",aResp);  
                helper.hideSpinner(component);
            } else if(state == "ERROR"){
                alert('Error in calling server side action');
            }
        });
        
        action1.setCallback(this,function(a){
            var state = a.getState();
            if(state == "SUCCESS"){
                var aResp = a.getReturnValue();
                component.set("v.quarterlypresent",aResp);  
            } else if(state == "ERROR"){
                alert('Error in calling server side action');
            }
        });
        
        action2.setCallback(this,function(a){
            var state = a.getState();
            if(state == "SUCCESS"){
                var aResp = a.getReturnValue();
                component.set("v.traningpresent",aResp);  
            } else if(state == "ERROR"){
                alert('Error in calling server side action');
            }
        });
        
        action3.setCallback(this,function(a){
            var state = a.getState();
            if(state == "SUCCESS"){
                var aResp = a.getReturnValue();
                component.set("v.prospectpresent",aResp);  
            } else if(state == "ERROR"){
                alert('Error in calling server side action');
            }
        });
        
        
        action4.setCallback(this,function(a){
            var state = a.getState();
            if(state == "SUCCESS"){
                var aResp = a.getReturnValue();
                component.set("v.growthpresent",aResp);  
            } else if(state == "ERROR"){
                alert('Error in calling server side action');
            }
        });
        
        action5.setCallback(this,function(a){
            var state = a.getState();
            if(state == "SUCCESS"){
                var aResp = a.getReturnValue();
                component.set("v.productofferingpresent",aResp);  
            } else if(state == "ERROR"){
                alert('Error in calling server side action');
            }
        });
        
        $A.enqueueAction(action);
        $A.enqueueAction(action1);
        $A.enqueueAction(action2);
        $A.enqueueAction(action3);
        $A.enqueueAction(action4);
        $A.enqueueAction(action5);
    },
})