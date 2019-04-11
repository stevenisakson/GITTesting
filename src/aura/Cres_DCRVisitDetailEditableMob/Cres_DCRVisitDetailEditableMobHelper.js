({
    /*Show success message*/
    showUpdateToast : function() {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Success!",
            "message": "The record has been updated successfully.",
            "type":"success"
        });
        toastEvent.fire();
    },
    /*Show success message*/
    showCreatedToast : function() {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Success!",
            "message": "The record has been created successfully.",
            "type":"success"
        });
        toastEvent.fire();
    },
    /*Navigate to First Page*/
    navigateToCustomerSearch:function(cmp,event,stateObj){
        var pageReference = {
            type: 'standard__navItemPage',
            attributes: {
                "apiName": "Daily_Call_Reporting"   
            },
            state:stateObj
        };
        
        cmp.set("v.pageReference", pageReference);
        
        var navService = cmp.find("navService");
        var pageReference = cmp.get("v.pageReference");
        event.preventDefault();
        navService.navigate(pageReference);
    },
    clearError:function(cmp){
        cmp.set("v.dcrerrors",[]);
    },
    /*Navigate to First Page*/
    navigateToDCRForm:function(cmp,event,stateObj){
        var pageReference = {
            type: 'standard__component',
            attributes: {
                "componentName": "c__Cres_DCRFormContainerMob"
            },
            state:stateObj
        };
        
        cmp.set("v.pageReference", pageReference);
        
        var navService = cmp.find("navService");
        // var pageReference = cmp.get("v.pageReference");
        // event.preventDefault();
        navService.navigate(pageReference);
    },
    fetchDCRCustomer:function(cmp,dcrCustId){
        var action = cmp.get("c.getDCRCustomer");
        action.setParams({"dcrCustId":dcrCustId});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var retVal=response.getReturnValue();
                console.log('$$$DCRCustomerInfo');
                console.log(retVal);
                if(retVal.isSuccess){
                    if(retVal.data!=null){
                        cmp.set("v.selectedRoute",{Name:retVal.data.Route__r.Name,Id:retVal.data.Route__r.Id});
                        cmp.set("v.selectedRouteCustomer",{Name:retVal.data.Account__r.Name,Id:retVal.data.Account__r.Id});
                        cmp.set("v.selectedContactName",retVal.data.Contact_Text__c);
                        
                        cmp.set("v.brandReminder1",retVal.data.Brand_Reminder1__c);
                        cmp.set("v.brandReminder2",retVal.data.Brand_Reminder2__c);
                        cmp.set("v.brandReminder3",retVal.data.Brand_Reminder3__c);
                        cmp.set("v.brandReminder4",retVal.data.Brand_Reminder4__c);
                        cmp.set("v.brandReminder5",retVal.data.Brand_Reminder5__c);
                        
                        cmp.set("v.ProductDiscussed1",retVal.data.Product1__c);
                        cmp.set("v.ProductDiscussed2",retVal.data.Product2__c);
                        cmp.set("v.ProductDiscussed3",retVal.data.Product3__c);
                        cmp.set("v.ProductDiscussed4",retVal.data.Product4__c);
                        cmp.set("v.ProductDiscussed5",retVal.data.Product5__c);
                        
                        cmp.set("v.ProductSample1",retVal.data.Product_Details1__c);
                        cmp.set("v.ProductSample2",retVal.data.Product_Details2__c);
                        cmp.set("v.ProductSample3",retVal.data.Product_Details3__c);
                        cmp.set("v.ProductSample4",retVal.data.Product_Details4__c);
                        cmp.set("v.ProductSample5",retVal.data.Product_Details5__c);
                        
                        cmp.set("v.accompaniedby",retVal.data.Accompanied_By__c);
                        
                        
                        
                        
                    }
                }
             
            }
            else if (state === "INCOMPLETE") {
                
            }
                else if (state === "ERROR") {
                    callback(false);
                }
        });
        
        $A.enqueueAction(action);
    },
     getConfiValues : function(cmp,callback) {
        var action = cmp.get("c.getAllConfigValues");
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var retVal=response.getReturnValue();
                console.log('$$$Config for DCRCustomer');
                console.log(retVal);
                if(retVal.isSuccess){
                    cmp.set("v.brandReminders",retVal.data.brandReminder);
                    cmp.set("v.ProductDiscussed",retVal.data.productDiscussed);
                    cmp.set("v.ProductSample",retVal.data.ProductSample);
                    cmp.set("v.accompaniedbyList",retVal.data.accompaniedbyList);
                    
                 
                    
                    cmp.set("v.lob",retVal.data.lob);
                    callback(true);
                   
                }
                
                
            }
            else if (state === "INCOMPLETE") {
                
            }
                else if (state === "ERROR") {
                    callback(false);
                }
        });
        
        $A.enqueueAction(action);
    }
    
})