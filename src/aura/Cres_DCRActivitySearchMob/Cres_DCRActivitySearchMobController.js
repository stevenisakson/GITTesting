({
    doInit: function(cmp, event, helper) {
        cmp.set("v.isLoading",true);
        helper.getConfiValues(cmp,function(ret){
            cmp.set("v.isLoading",false);
        });
    },
    /*Clear the search text when user close the lookup*/
    targetSelected : function(cmp, event, helper) {
        
        if(cmp.get("v.selectedTargetRecord.Id")==undefined){
            
            
            cmp.set("v.selectedTargetRecordId",null);
            
        }else{
            cmp.set("v.selectedTargetRecordId",cmp.get("v.selectedTargetRecord.Id"));
            if(cmp.get("v.selectedTargetRecord.Employee_Link_To__c")!=cmp.get("v.loggedinUserId")){
                cmp.set("v.disableCreatebtn",true);
            }else if(cmp.get("v.selectedTargetRecord.Employee_Link_To__c")==cmp.get("v.loggedinUserId")){
                cmp.set("v.disableCreatebtn",false);
            }
        }
    },
    /*Clear the search text when user close the lookup*/
    routeChanged:function(cmp,event,helper){
        if(cmp.get("v.selectedRoute.Id")==undefined){
            
            cmp.find("routeCustLookup").clearSearch();
        }
    },
    
    createBtnClick:function(cmp,event,helper){
        cmp.set("v.dcrerrors",[]);
        var errorList=cmp.get("v.dcrerrors");
        /*Validatons before searching*/
        helper.validateInputs(cmp,errorList);
        if(errorList.length==0){ 
            helper.validateDate(cmp,errorList);
        }
        if(errorList.length>0){
            cmp.set("v.dcrerrors",errorList);
            return;
        }
        if(errorList.length==0){
            cmp.set("v.isLoading",true);
            var dateSelected=cmp.get("v.searchDate")+' 00:00:00';
            var targetId=cmp.get("v.selectedTargetRecord.Id");
            var targetOwnerId=cmp.get("v.selectedTargetRecord.Employee_Link_To__c");
            helper.searchDCR(cmp,dateSelected,targetId,targetOwnerId,function(retValue){
                cmp.set("v.isLoading",false);
                console.log('$$$SearchResultOnCreate');
                console.log(retValue);
                if(retValue.isSuccess){
                    console.log(retValue);
                    if(retValue.data==null){
                        helper.navigateToCreationPage(cmp,event,dateSelected,targetId);
                        
                    }else{
                        
                        
                        if(cmp.get("v.hasDCRUnlockAccess")==false && retValue.data.DCR_Locked__c==true && (retValue.data.Status__c=='Open' || retValue.data.Status__c=='In Progress'
                                                                )){
                            helper.addError(errorList,$A.get("$Label.c.Cres_LockedDCRError"));
                            cmp.set("v.dcrerrors",errorList);
                        }else {
                            helper.addError(errorList,$A.get("$Label.c.Cres_DCRAlreadyExist"));
                            cmp.set("v.dcrerrors",errorList); 
                            // helper.navigateToEditPage(cmp,event,dateSelected,targetId,retValue.data);
                        }
                    }
                }else{
                     cmp.set("v.dcrerrors",retValue.msg); 
                }
            });
        }
    },
    searchDCRbtnClick:function(cmp,event,helper){
        
        cmp.set("v.dcrerrors",[]); 
        cmp.set("v.dcrerrors",[]);
        var errorList=cmp.get("v.dcrerrors");
        /*Validatons before searching*/
        helper.validateInputs(cmp,errorList);
        if(errorList.length==0){ 
            helper.validateDate(cmp,errorList);
        }
        if(errorList.length>0){
            cmp.set("v.dcrerrors",errorList);
            return;
        }
        if(errorList.length==0){
            cmp.set("v.isLoading",true);
            var dateSelected=cmp.get("v.searchDate")+' 00:00:00';
            var targetOwnerId=cmp.get("v.selectedTargetRecord.Employee_Link_To__c");
            console.log(targetOwnerId);
            var targetId=cmp.get("v.selectedTargetRecord.Id");
            console.log(dateSelected+targetId+targetOwnerId);
            helper.searchDCR(cmp,dateSelected,targetId,targetOwnerId,function(retValue){
                cmp.set("v.isLoading",false);
                console.log('$$$SearchResult');
                console.log(retValue);
                if(retValue.isSuccess){
                    console.log(retValue);
                    if(retValue.data==null){
                        
                        cmp.set("v.dcrerrors",[$A.get("$Label.c.Cres_DCRNotFound")]); 
                        console.log('Not Found');
                    }else{
                        console.log('Found');
                        console.log(retValue.data);
                        if(cmp.get("v.hasDCRUnlockAccess")==false && retValue.data.DCR_Locked__c==true && (retValue.data.Status__c=='Open' || retValue.data.Status__c=='In Progress' ||
                                                                cmp.get("v.hasDCRUnlockAccess"))){
                            helper.addError(errorList,$A.get("$Label.c.Cres_LockedDCRError"));
                            cmp.set("v.dcrerrors",errorList);
                        }else {
                            helper.navigateToEditPage(cmp,event,dateSelected,targetId,retValue.data.Id);
                        }
                    }
                    
                    
                }else{
                     cmp.set("v.dcrerrors",retValue.msg); 
                }
            });
        }
    },
    /*when cancel button is clicked*/
    clearBtnClick:function(cmp,event,helper){
        cmp.set("v.selectedTargetRecord",{});
        cmp.set("v.searchDate",'');
        cmp.set("v.dcrerrors",[]);
        cmp.set("v.disableCreatebtn",false);
    }
})