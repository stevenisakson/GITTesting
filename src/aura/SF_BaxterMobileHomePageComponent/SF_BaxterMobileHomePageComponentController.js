({
    
   displayCheck : function (component, event, helper){
        component.set("v.displayFlag", 'true');
        component.set("v.eventFlag", 'false');
        component.set("v.prospectFlag", 'false');
        component.set("v.trainingFlag", 'false');
        component.set("v.growthFlag", 'false');
    },
    
    eventCheck : function (component, event, helper){
        component.set("v.eventFlag", 'true');
        component.set("v.displayFlag", 'false');
        component.set("v.prospectFlag", 'false');
        component.set("v.trainingFlag", 'false');
        component.set("v.growthFlag", 'false');
    },
    
    prospectCheck :  function (component, event, helper){
        component.set("v.eventFlag", 'false');
        component.set("v.displayFlag", 'false');
        component.set("v.prospectFlag", 'true');
        component.set("v.trainingFlag", 'false');
        component.set("v.growthFlag", 'false');
    },
    
    trainingCheck :  function (component, event, helper){
        component.set("v.trainingFlag", 'true');
        component.set("v.eventFlag", 'false');
        component.set("v.displayFlag", 'false');
        component.set("v.prospectFlag", 'false');
        component.set("v.growthFlag", 'false');
    },
    
    growthCheck :  function (component, event, helper){
        component.set("v.growthFlag", 'true');
        component.set("v.eventFlag", 'false');
        component.set("v.displayFlag", 'false');
        component.set("v.prospectFlag", 'false');
        component.set("v.trainingFlag", 'false');
    },
    
    doInit : function (component, event, helper){ 
        var actionaccount = component.get("c.getAccountRecord"); //Calling Apex class controller 'getAccountRecord' method
        var actioncontact = component.get("c.getContactRecord"); //Calling Apex class controller 'getContactRecord' method
        var actionDisplay = component.get("c.checkMonthlyList"); // call display function
        var actionEvents = component.get("c.checkQuarterlyList"); // call Events function
        var actionTraining = component.get("c.checkTrainingList"); // call Training function
        var actionProspect = component.get("c.checkProspectList"); // call prospect function
        var actionGrowthTrend = component.get("c.checkGrowthMetrix"); // call growth trend
        var actionProductOffer = component.get("c.checkGrowthMetrixV1"); // updated function to set manual growth     
        
        actionDisplay.setParams({currentMonthID:null}); 
		actionEvents.setParams({currentEventID:null});
        actionTraining.setParams({currentTrainingID:null});
        actionProspect.setParams({currentProspectID:null});
        actionGrowthTrend.setParams({currentGrowthID:null});
        actionProductOffer.setParams({currentProductGrowthID:null});
        
        actionaccount.setCallback(this, function(response) {
            var state = response.getState(); //Checking response status
            var result = JSON.stringify(response.getReturnValue());
            if (component.isValid() && state === "SUCCESS")
                component.set("v.accLst", response.getReturnValue());// Adding values in Aura attribute variable.   
        });
        
        actioncontact.setCallback(this, function(response) {
            var state = response.getState(); //Checking response status
            var result = JSON.stringify(response.getReturnValue());
            if (component.isValid() && state === "SUCCESS")
                component.set("v.conLst", response.getReturnValue());  // Adding values in Aura attribute variable.   
        });
        
        actionDisplay.setCallback(this,function(a){
            var state = a.getState();
            if(state == "SUCCESS"){
                var aRespdis = a.getReturnValue();
                component.set("v.monthlypresent",aRespdis);  
            } else if(state == "ERROR"){
                alert('Error in calling server side action');
            }
        });
        
        actionEvents.setCallback(this,function(a){
            var state = a.getState();
            if(state == "SUCCESS"){
                var aRespEve = a.getReturnValue();
                component.set("v.quarterlypresent",aRespEve);  
            } else if(state == "ERROR"){
                alert('Error in calling server side action');
            }
        });
        
        actionTraining.setCallback(this,function(a){
            var state = a.getState();
            if(state == "SUCCESS"){
                var aResp = a.getReturnValue();
                component.set("v.traningpresent",aResp);  
            } else if(state == "ERROR"){
                alert('Error in calling server side action');
            }
        });
        
        actionProspect.setCallback(this,function(a){
            var state = a.getState();
            if(state == "SUCCESS"){
                var aRespPros = a.getReturnValue();
                component.set("v.prospectpresent",aRespPros);  
            } else if(state == "ERROR"){
                alert('Error in calling server side action');
            }
        });
        
        actionGrowthTrend.setCallback(this,function(a){
            var state = a.getState();
            if(state == "SUCCESS"){
                var aRespGrowthTrend = a.getReturnValue();
                component.set("v.growthpresent",aRespGrowthTrend);  
            } else if(state == "ERROR"){
                alert('Error in calling server side action');
            }
        });
        
        actionProductOffer.setCallback(this,function(a){
            var state = a.getState();
            if(state == "SUCCESS"){
                var aRespProductOffer = a.getReturnValue();
                component.set("v.productofferingpresent",aRespProductOffer);  
            } else if(state == "ERROR"){
                alert('Error in calling server side action');
            }
        });
        
        $A.enqueueAction(actionaccount);
        $A.enqueueAction(actioncontact);
        $A.enqueueAction(actionDisplay);
        $A.enqueueAction(actionEvents);
        $A.enqueueAction(actionTraining);
        $A.enqueueAction(actionProspect);
        $A.enqueueAction(actionGrowthTrend);
        $A.enqueueAction(actionProductOffer);
    },
    create : function(component, event, helper) {
        //getting the accountAttachment information
        var accountAttachment = component.get("v.accountattachment");
        var action = component.get("c.createRecord");
        
        //Setting the Apex Parameter
        action.setParams({
            monthlyattach : accountAttachment, monthSel : component.find("InputSelectDynamicMonth").get("v.value"), yearSel : component.find("InputSelectDynamicYear").get("v.value"),
            Type : $A.get("$Label.c.Cargill_Document_Type_Display")
        });
        
        //Setting the Callback
        action.setCallback(this,function(a){
            //get the response state
            var state = a.getState();
            
            //check if result is successfull
            if(state == "SUCCESS"){
                //Reset Form
                var newCandidate = {'sobjectType': 'Account_Attachments__c','Account__c': '','Start_Month_Date__c': '',
                                    'End_Month_Date__c': '','Quarterly_Start_Date__c': '','Quarterly_End_Date__c':'','Type__c':'',
                                    'Last_Upload_Date__c': '','Training_Date__c': '','Topic__c': '','of_Attendees__c': '','Attendees__c': '','Monthly_Uploaded_Date__c':''};
                //resetting the Values in the form
                component.set("v.accountattachment",newCandidate);
                var aResp = a.getReturnValue();
                component.set("v.accountattId",aResp);  
            } else if(state == "ERROR"){
                alert('Error in calling server side action');
            }
            helper.navigateToRecord(component, event, helper); 
        });
        
        //adds the server-side action to the queue        
        $A.enqueueAction(action);
    },
    
   
})