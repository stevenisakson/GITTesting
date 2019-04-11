({
    getConfiValues : function(cmp,callback) {
        var action = cmp.get("c.getAllConfigValues");
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            cmp.set("v.isLoading",false);
            if (state === "SUCCESS") {
                var retVal=response.getReturnValue();
                console.log('$$$Config');
                console.log(retVal);
                if(retVal.isSuccess){
                    cmp.set("v.firstHalfPicklist",retVal.data.firstHalf);
                    cmp.set("v.secondHalfPicklist",retVal.data.secondHalf);
                    cmp.set("v.statusHalfPicklist",retVal.data.status);
                    cmp.set("v.hasDCRUnlockAccess",retVal.data.hasDCRUnlockAccess);
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
    },
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
	 showCompleteToast : function() {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Success!",
            "message": "DCR has been completed successfully.",
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
     /*Show success message*/
      showUnlockToast : function() {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Success!",
            "message": "The DCR record has been created unlocked successfully.",
            "type":"success"
        });
        toastEvent.fire();
    },
     /*called when create button is clicked*/
    navigateToCustomerPage:function(cmp,event,dcrId,targetId){
        var pageReference = {
            type: 'standard__component',
            attributes: {
                "componentName": "c__Cres_DCRVisitFormContainer"   
            },
            state:{"btnAction":"create","dcrId":dcrId,"targetId":targetId}
        };
        
        cmp.set("v.pageReference", pageReference);
        
        var navService = cmp.find("navService");
        var pageReference = cmp.get("v.pageReference");
        event.preventDefault();
        navService.navigate(pageReference);
    },
     
    fetchDCRRecord:function(cmp,dcrId){
        var action = cmp.get("c.getDCRWrapper");
        action.setParams({"dcrId":dcrId});
        action.setCallback(this, function(response) {
            var state = response.getState();
            cmp.set("v.isLoading",false);
            if (state === "SUCCESS") {
                var retVal=response.getReturnValue();
                console.log('$$$DCR Record');
                console.log(retVal);
                if(retVal.isSuccess){
                    cmp.set("v.dcrWrapper",retVal.data);
                    
                    cmp.set("v.firstHalf",retVal.data.dcrRec.First_Half__c);
                    
                    cmp.set("v.secondHalf",retVal.data.dcrRec.Second_Half__c);
                    console.log(retVal.data.dcrRec.DCR_Locked__c);
                   /* if(retVal.data.dcrRec.DCR_Locked__c){
                       
                        cmp.set("v.mode","View");
                        cmp.set("v.isDCRLocked",true);
                       
                    }else{
                        cmp.set("v.mode","Edit");
                        cmp.set("v.isDCRLocked",false);
                      
                    }*/
                    /*if the logged in user is a Data Steward he has access to unlock*/
                    if(cmp.get("v.hasDCRUnlockAccess")==true && retVal.data.dcrRec.DCR_Locked__c==true){
                         cmp.set("v.enableUnlockbtn",true);
                    }else{
                         cmp.set("v.enableUnlockbtn",false);
                    }
                    /*Only the record owner has the access to edit the record if it is unlocked*/
                    if(retVal.data.hasEditAccess==true && retVal.data.dcrRec.DCR_Locked__c==false){
                       
                        cmp.set("v.mode","Edit");
                        cmp.set("v.isDCRLocked",false);
                    }else{
                        
                        cmp.set("v.mode","View");
                        cmp.set("v.isDCRLocked",true)
                    }
                    console.log('DCRStatus');
                    console.log(cmp.get("v.isDCRLocked"));
                   
                    
                   // cmp.set("v.mode",retVal.data.dcrRec.Second_Half__c);
                    
                }
                /*console.log('$$$DCR Record');
                console.log(retVal);
                if(retVal.isSuccess){
                    cmp.set("v.firstHalf",retVal.data.First_Half__c);
                    
                    cmp.set("v.secondHalf",retVal.data.Second_Half__c);
                    if(cmp.get("v.firstHalf")=='Customer Visit' ||  
                       cmp.get("v.firstHalf")=='Group Meeting' || cmp.get("v.secondHalf")=='Group Meeting'
                       || cmp.get("v.secondHalf")=='Customer Visit'){
                       
                        console.log('called');
                        cmp.set("v.enabledAddCustomer",true);
                        
                    }
                     this.fetchDCRCustomerRecord(cmp,dcrId);
                }*/
                
                
            }
            else if (state === "INCOMPLETE") {
                
            }
                else if (state === "ERROR") {
                    
                }
        });
        
        $A.enqueueAction(action);
    },
    fetchDCRCustomerRecord:function(cmp,dcrId){
         var action = cmp.get("c.getDCRCustomerRecord");
        action.setParams({"dcrId":dcrId});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var retVal=response.getReturnValue();
                console.log('$$$DCRCust Record');
                console.log(retVal);
                if(retVal.isSuccess){
                  cmp.set("v.dcrCustList",retVal.data);
                }
                
                
            }
            else if (state === "INCOMPLETE") {
                
            }
                else if (state === "ERROR") {
                   
                }
        });
        
        $A.enqueueAction(action);
    },
     completeDCRMob : function(cmp,dcrId,callback) {
        var action = cmp.get("c.completeDCR");
        action.setParams({"dcrId":dcrId});
        action.setCallback(this, function(response) {
            var state = response.getState();
            var retVal=response.getReturnValue();
            console.log(retVal);
            if (state === "SUCCESS") {
               
                console.log('$$$DCR Complete Status');
                console.log(retVal);
                if(retVal.isSuccess){
                   callback(true);
                   
                }
                
                
            }
          
                else if (state === "ERROR") {
                     callback(false);
                }
        });
        
        $A.enqueueAction(action);
    },
      unlockDCRMob : function(cmp,dcrId,callback) {
        var action = cmp.get("c.unlockDCR");
        action.setParams({"dcrId":dcrId});
        action.setCallback(this, function(response) {
            var state = response.getState();
            var retVal=response.getReturnValue();
            console.log(retVal);
            if (state === "SUCCESS") {
               
                console.log('$$$UnlockDCR Complete Status');
                console.log(retVal);
                if(retVal.isSuccess){
                   callback(true);
                   
                }
                
                
            }
          
                else if (state === "ERROR") {
                     callback(false);
                }
        });
        
        $A.enqueueAction(action);
    },
    validateForm:function(component,errorList){
        var fhalf=component.get("v.firstHalf");
        var shalf= component.get("v.secondHalf");
        if(fhalf=='None' || shalf=='None'){
            errorList.push($A.get("$Label.c.Cres_DCRFirstSecMandatory"));
        }
    }
})