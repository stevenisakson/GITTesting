({
    getConfiValues : function(cmp,callback) {
        var action = cmp.get("c.getAllConfigValues");
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var retVal=response.getReturnValue();
                console.log('$$$ConfigOnLanding');
                console.log(retVal);
                if(retVal.isSuccess){
                    if(retVal.data.isDataSteward){
                        cmp.set("v.isDataSteward",true);
                       
                    }
                    if(retVal.data.hasDCRUnlockAccess){
                        
                        cmp.set("v.hasDCRUnlockAccess",true);
                    }
                    if(retVal.data.userId!=undefined){
                        cmp.set("v.loggedinUserId",retVal.data.userId);
                    }
                    callback(true);
                   
                }else{
                    callback(false);
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
    searchDCR:function(cmp,date,terrId,targetOwnerId,callback){
        var action=cmp.get("c.searchDCRMob");
        action.setParams({'searchDate':date,'searchTargetId':terrId,'targetOwnerId':targetOwnerId});
        action.setCallback(this,function(resp){
            cmp.set("v.isLoading",false);
            if(resp.getState()==='SUCCESS'){
                
                var retValue=resp.getReturnValue();
                callback(retValue);
               
            }
        });
        cmp.set("v.isLoading",true);
        $A.enqueueAction(action);
    },
	fetchDCRDayRecordId : function(cmp,date,terrId,routeId,custId,callback) {
		var action=cmp.get("c.getDCRRecordMob");
        action.setParams({'searchDate':date,'searchTargetId':terrId,'routeId':routeId,'custId':custId});
        action.setCallback(this,function(resp){
            cmp.set("v.isLoading",false);
            if(resp.getState()==='SUCCESS'){
                var retValue=resp.getReturnValue();
                console.log(retValue);
                if(retValue!=undefined && retValue!=null){
                    if(retValue.isSuccess){
                       
                        if(retValue.data.dcrId!=undefined){
                            cmp.set("v.dcrId",retValue.data.dcrId);
   
                        }else{
                             cmp.set("v.dcrId",null);
                        }
                        if(retValue.data.custId!=undefined){
                            cmp.set("v.dcrCustId",retValue.data.custId);
                        }else{
                            cmp.set("v.dcrCustId",null);
                        }
                        if(retValue.data.isComplete!=undefined && retValue.data.isComplete==true){
                            cmp.set("v.isDcrComplete",true);
                        }else{
                            cmp.set("v.isDcrComplete",false);
                        }
                        if(retValue.data.isLocked!=undefined && retValue.data.isLocked==true){
                            cmp.set("v.isDcrLocked",true);
                        }else{
                            cmp.set("v.isDcrLocked",false);
                        }
                        
                         callback(true);
                    }else{
                        var errorList=cmp.get("v.dcrerrors"); 
                        this.addError(errorList,retValue.msg);
                        cmp.set("v.dcrerrors",errorList);
                        callback(false);
                        console.log(retValue.msg);
                    }
                   
                }
                
            }else{
                 callback(false);
            }
        });
        cmp.set("v.isLoading",true);
        $A.enqueueAction(action);
	},
    navigateToCustomerVisit:function(cmp,event,dcrId,selectedRoute,selectedCust,custId,isDcrComplete,isDCRLocked){
        var pageReference = {
            type: 'standard__component',
            attributes: {
                "componentName": "c__Cres_DCRVisitFormContainer"   
            },
            state:{"dcrId":dcrId,"custId":custId,"selectedCust":selectedCust,"selectedRoute":selectedRoute
                   ,"isDcrComplete":isDcrComplete,"isDcrLocked":isDCRLocked}
        };
        
        cmp.set("v.pageReference", pageReference);
        
        var navService = cmp.find("navService");
        var pageReference = cmp.get("v.pageReference");
        event.preventDefault();
        navService.navigate(pageReference);
    },
    addError:function(errorList,msg){
       
        errorList.push(msg);
       
    },
    clearSearch:function(cmp){
        cmp.set("v.selectedTargetRecord",{});
        cmp.set("v.selectedRouteCustomer",{});
        cmp.set("v.selectedRoute",{});
        cmp.set("v.dcrCustId",null);
        cmp.set("v.dcrId",null);
        cmp.set("v.searchDate",null);
    },
    /*Mandatory check for the fields*/
    validateInputs:function(cmp,errorList){
        if(cmp.get("v.searchDate")==undefined || cmp.get("v.searchDate")==""
          || cmp.get("v.selectedTargetRecord.Id")==undefined){
            
            this.addError(errorList,$A.get("$Label.c.Cres_DCR_All_Mandatory"));
        }
    },
    /*Date validation.No Future Date is allowed*/
    validateDate:function(cmp,errorList){
        if(cmp.get("v.searchDate")!=undefined && cmp.get("v.searchDate")!=null && cmp.get("v.searchDate")!=""){
           var selectedDate = new Date(cmp.get("v.searchDate"));
           var today = new Date();
            if((selectedDate-today)>0){
                this.addError(errorList,$A.get("$Label.c.DCR_Error_Future_Date"));
            }
           
        }
      
    },
    /*called when create button is clicked*/
    navigateToCreationPage:function(cmp,event,dateSelected,targetId){
        var pageReference = {
            type: 'standard__component',
            attributes: {
                "componentName": "c__Cres_DCRFormContainerMob"   
            },
            state:{"btnAction":"create","dateSelected":dateSelected,"targetId":targetId}
           
        };
        
        cmp.set("v.pageReference", pageReference);
        
        var navService = cmp.find("navService");
        var pageReference = cmp.get("v.pageReference");
        event.preventDefault();
        navService.navigate(pageReference);
    },
     /*called when create button is clicked*/
    navigateToEditPage:function(cmp,event,dateSelected,targetId,dcrId){
        var pageReference = {
            type: 'standard__component',
            attributes: {
                "componentName": "c__Cres_DCRFormContainerMob"   
            },
            state:{"btnAction":"search","dateSelected":dateSelected,"targetId":targetId,"dcrId":dcrId}
           
        };
        
        cmp.set("v.pageReference", pageReference);
        
        var navService = cmp.find("navService");
        var pageReference = cmp.get("v.pageReference");
        event.preventDefault();
        navService.navigate(pageReference);
    }
})