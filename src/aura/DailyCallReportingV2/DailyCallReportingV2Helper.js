({
    getDCRRecord:function(cmp,sdate,terr){
        var action = cmp.get("c.getDCRRecord");
        action.setParams({'searchDate':sdate,'searchTargetId':terr});
        action.setCallback(this, function(a) {
            var state=a.getState();
            var ret=a.getReturnValue();
            console.log(ret);
            cmp.set("v.isLoading",false);
            if(state==='SUCCESS'){
                if(ret.isPlanned == false){
                    
                        cmp.set("v.searchErrMsg",$A.get("$Label.c.Cres_DCR_Approval_Error"));
                    	cmp.set("v.toHideclass","slds-notify slds-notify_alert slds-theme_alert-texture slds-theme_error slds-show");
                        var visitSection = cmp.find('activityPerformedSection');
                        $A.util.removeClass(visitSection, 'slds-show');
                        $A.util.addClass(visitSection, 'slds-hide');
                    	//For visit section header
                    	var visitSectionheader = cmp.find('visitSectionHeader');
                        $A.util.removeClass(visitSectionheader, 'slds-show');
                        $A.util.addClass(visitSectionheader, 'slds-hide');
                    
                        var visitSection = cmp.find('visitDetailSection');
                        $A.util.removeClass(visitSection, 'slds-show');
                        $A.util.addClass(visitSection, 'slds-hide');
                   
                }
                else{
                if(ret.DCRDayRecord!=null){
                    cmp.set("v.dcrRecord",ret.DCRDayRecord);
                    console.log('inside dcr not null');
                    console.log('dcr day id'+ret.DCRDayRecord.Id);
                    cmp.set("v.existingDCRId",ret.DCRDayRecord.Id);
                    if(ret.DCRDayRecord.DCR_Locked__c){
                        console.log('inside locked');
                         cmp.set("v.isReadOnly",true);
                         cmp.set("v.isOutputfield",true);
                         cmp.set("v.isEditDisabled",true);
                         cmp.set("v.isSaveDisabled",true);
                         cmp.set("v.isCancelDisabled",true);
                         cmp.set("v.isAddCustDisabled",true);
                          var firstHalf = ret.DCRDayRecord.First_Half__c;
                          var secHalf = ret.DCRDayRecord.Second_Half__c;
                          var comment = ret.DCRDayRecord.Comments__c;
                         cmp.find("frstHalfOutput").set("v.value", firstHalf);
                         cmp.find("commentsIdOutput").set("v.value", comment);
                         cmp.find("secHalfOutput").set("v.value", secHalf);
                       	 
                    }else{
                        console.log('inside Unlocked');
                        cmp.set("v.isOutputfield",true);
                        cmp.set("v.isReadOnly",false);
                            var firstHalf = ret.DCRDayRecord.First_Half__c;
                            var secHalf = ret.DCRDayRecord.Second_Half__c;
                        	var comment = ret.DCRDayRecord.Comments__c;
                            console.log('before first'+firstHalf);
                            cmp.find("frstHalfOutput").set("v.value", ret.DCRDayRecord.First_Half__c);
                            console.log('before first1');      
                            cmp.find("commentsIdOutput").set("v.value", comment);
                       
                            cmp.find("secHalfOutput").set("v.value", secHalf);
                  			
                            cmp.set("v.isEditDisabled",false);
                            cmp.set("v.isSaveDisabled",true);
                            cmp.set("v.isCancelDisabled",true);
                        
                            /*check if the user has access to edit the record*/
                            /*Added by Sam*/
                            var rec=cmp.get("v.selectedTargetRecord");
                            var user=cmp.get("v.userInfo");
                            var hasCreateAccess=cmp.get("v.hasCreateAccess");
                            if(hasCreateAccess==false && rec!=undefined && rec.Employee_Link_To__c!=user.Id){
                                cmp.set("v.isReadOnly",true);
                            }
                            
                    }
                   
                    var visitSection = cmp.find('activityPerformedSection');
                    $A.util.removeClass(visitSection, 'slds-hide');
                    $A.util.addClass(visitSection, 'slds-show');
                    //For Visit Section Header
                    var visitSectionheader = cmp.find('visitSectionHeader');
                    $A.util.removeClass(visitSectionheader, 'slds-hide');
                    $A.util.addClass(visitSectionheader, 'slds-show');
                    
                    var firstHalf = ret.DCRDayRecord.First_Half__c;
                    var secHalf = ret.DCRDayRecord.Second_Half__c;
                  
                                       
                    console.log('first half is@@@'+firstHalf);
                    console.log('second half is@@@'+secHalf);
                    if(firstHalf == 'Customer Visit' || secHalf == 'Customer Visit'
                      || firstHalf=='Group Meeting' || secHalf=='Group Meeting'){
           				cmp.set("v.showVisitSection",true);
                        cmp.set("v.isAddCustDisabled",false);
        			}
                    else{
           				cmp.set("v.showVisitSection",false); 
                        cmp.set("v.isAddCustDisabled",true);
        			}		
                    var showSection = cmp.get('v.showVisitSection');
                    console.log('ouside if loooop'+showSection);
                    if(showSection == true){
                        console.log('In if loooop');
                        var visitSection = cmp.find('visitDetailSection');
                        $A.util.removeClass(visitSection, 'slds-hide');
                        $A.util.addClass(visitSection, 'slds-show');
                    }
                    cmp.set("v.iterateVisitSec",true);
                    //cmp.set("v.searchResultDCRCustomers",ret);
                    cmp.set("v.isCreateNewDisabled",true);
                    if(showSection == true){
                        this.fetchDCRCustomerList(cmp,ret.DCRDayRecord.Id);
                    }
                }
                else{
                    if(ret.outDatedRecord){
                                            
                        cmp.set("v.searchErrMsg",$A.get("$Label.c.Cres_LockedDCRError"));
                    	cmp.set("v.toHideclass","slds-notify slds-notify_alert slds-theme_alert-texture slds-theme_error slds-show");
                        var visitSection = cmp.find('activityPerformedSection');
                        $A.util.removeClass(visitSection, 'slds-show');
                        $A.util.addClass(visitSection, 'slds-hide');
                    	//For visit section header
                    	var visitSectionheader = cmp.find('visitSectionHeader');
                        $A.util.removeClass(visitSectionheader, 'slds-show');
                        $A.util.addClass(visitSectionheader, 'slds-hide');
                    
                        var visitSection = cmp.find('visitDetailSection');
                        $A.util.removeClass(visitSection, 'slds-show');
                        $A.util.addClass(visitSection, 'slds-hide');
                    }
                    else{
                        cmp.set("v.searchErrMsg","No Existing DCR Record Found for the Selected Combination. Please Create New DCR.");
                        cmp.set("v.toHideclass","slds-notify slds-notify_alert slds-theme_alert-texture slds-theme_error slds-show");
                        var visitSection = cmp.find('activityPerformedSection');
                        $A.util.removeClass(visitSection, 'slds-show');
                        $A.util.addClass(visitSection, 'slds-hide');
                        //For visit section header
                        var visitSectionHeader = cmp.find('visitSectionHeader');
                        $A.util.removeClass(visitSectionHeader, 'slds-show');
                        $A.util.addClass(visitSectionHeader, 'slds-hide');
                        
                        var visitSection = cmp.find('visitDetailSection');
                        $A.util.removeClass(visitSection, 'slds-show');
                        $A.util.addClass(visitSection, 'slds-hide');
                        cmp.set("v.isCreateNewDisabled",false);
                        cmp.set("v.isOutputfield",false);
                        cmp.set("v.isEditDisabled",true);
                        cmp.set("v.isSaveDisabled",false);
                        cmp.set("v.isCancelDisabled",true);
                        cmp.set("v.isAddCustDisabled",true);
                      /* cmp.find("frstHalf").set("v.value", "");
                         cmp.find("commentsId").set("v.value", "");
                         cmp.find("secHalf").set("v.value", "");*/
                    }
               }
              }
            }
        });
        cmp.set("v.isLoading",true);
        $A.enqueueAction(action);
    },
      fetchDCRCustomerList: function(cmp,dcrId) {
          var action = cmp.get("c.getDCRCustomerList");
          action.setParams({'dcrId':dcrId});
          action.setCallback(this, function(a) {
              var ret=a.getReturnValue();
              console.log(ret);
              cmp.set("v.searchResultDCRCustomers",ret);
              cmp.set("v.isLoading",false);
             
          });
          cmp.set("v.isLoading",true);
          $A.enqueueAction(action);
	},
    
    checkDCRUnlockAccess: function(cmp,dcrId) {
          var action = cmp.get("c.hasDCRUNlockAccess");
          action.setParams({'dcrId':dcrId});
          action.setCallback(this, function(a) {
              var ret=a.getReturnValue();
              console.log(ret);
              cmp.set("v.dcrUnlockAccess",ret);
              cmp.set("v.isLoading",false);
             
          });
          cmp.set("v.isLoading",true);
          $A.enqueueAction(action);
	},
     getUserInfo: function(cmp) {
          var action = cmp.get("c.getLoggedInUser");
         
          action.setCallback(this, function(a) {
              var ret=a.getReturnValue();
              console.log('$$$$');
              console.log(ret);
              cmp.set("v.userInfo",ret);
              if(ret.Profile.Name.includes('Data Steward')){
                  cmp.set("v.hasCreateAccess",true);
              }
              cmp.set("v.isLoading",false);
             
          });
          cmp.set("v.isLoading",true);
          $A.enqueueAction(action);
	},
     unlockDCRRecord: function(cmp,dcrId) {
          var action = cmp.get("c.unlockDCR");
          action.setParams({'dcrId':dcrId});
          action.setCallback(this, function(a) {
              var ret=a.getReturnValue();
              console.log(ret);
              if(ret){
                  var selectedDate = cmp.get("v.searchDate");
                  var selectedTargetRecord = cmp.get("v.selectedTargetRecord");
                  
                  var selectedTargetRecordId = selectedTargetRecord.Id;
                  this.getDCRRecord(cmp,selectedDate,selectedTargetRecordId);
                  cmp.set("v.statusValue","In Progress");
                  this.unlockSuccess();
              }
              //cmp.set("v.dcrUnlockAccess",ret);
              cmp.set("v.isLoading",false);
              
          });
          cmp.set("v.isLoading",true);
          $A.enqueueAction(action);
	},
    finishDCRRecord: function(cmp,dcrId) {
          var action = cmp.get("c.finishDCR");
          action.setParams({'dcrId':dcrId})
          action.setCallback(this, function(a) {
              var ret=a.getReturnValue();
              console.log(ret);
              if(ret){
                  this.finishSuccess();
                  cmp.set("v.statusValue","Completed");
                  var selectedDate = cmp.get("v.searchDate");
                  var selectedTargetRecord = cmp.get("v.selectedTargetRecord");

                  var selectedTargetRecordId = selectedTargetRecord.Id;
                  this.getDCRRecord(cmp,selectedDate,selectedTargetRecordId);
              }else{
                  
              }
             // cmp.set("v.dcrUnlockAccess",ret);
              cmp.set("v.isLoading",false);
             
          });
          cmp.set("v.isLoading",true);
          $A.enqueueAction(action);
	},
	
    
    SaveActivity: function(component,event){
        var action = component.get("c.saveDCRActivity");
        var firstHalf = component.find("InputFirstHalf").get("v.value");
        var secondHalf = component.find("InputSecondHalf").get("v.value");
        var status = component.find("ReadOnlyStatus").get("v.value");
        var plannedDeviation = component.get("v.plannedDeviation");
        var exstdcrId = component.get("v.existingDCRId");
        var selectedRoute = component.get("v.selectedRouteRecord");
        var selectedRouteRecordId = selectedRoute.Id;
        var selectedTargetRecord = component.get("v.selectedTargetRecord");
        var selectedTargetRecordId = selectedTargetRecord.Id;
        var selectedDate = component.get("v.searchDate");
        var newDCRrecord = component.get("v.isNewDCRRecord"); 
        action.setParams({
            "firstHalf": firstHalf,"secondHalf": secondHalf,"status": status,"plannedDeviation": plannedDeviation,"selectedRouteRecordId": selectedRouteRecordId,"selectedTargetRecordId": selectedTargetRecordId,
            "selectedDate": selectedDate,"exstDCRRecordId": exstdcrId,"newDCR": newDCRrecord
        });
        action.setCallback(this, function(response) {
        	var state = response.getState();
            if(state === "SUCCESS"){
                component.set("v.dcrActivitySaveCheck",true);
                component.set("v.setStatusValue","In Progress");
                var resultsavedDCR = response.getReturnValue();
                if(resultsavedDCR.savedDCRrecord.Route__c != '' && resultsavedDCR.savedDCRrecord.Route__c != 'undefined' && resultsavedDCR.savedDCRrecord.Route__c != null){
                   component.set("v.routeid",resultsavedDCR.savedDCRrecord.Route__c);
                   component.set("v.routeName",resultsavedDCR.savedDCRrecord.Route_No__c);                    
                }
                if(resultsavedDCR.savedDCRCustList != null && resultsavedDCR.savedDCRCustList !='' && resultsavedDCR.savedDCRCustList !='undefined'){
                    component.set("v.isNewDCRRecord",false);
                    var arr = resultsavedDCR.savedDCRCustList;
                    component.set("v.routeName",arr[0].Route_No__c);
                    component.set("v.searchResultDCRCustomers",resultsavedDCR.savedDCRCustList);
                    
                }
              }
            });
        $A.enqueueAction(action);
    },
    
    fetchRecord: function(component,event){
         var selectedTargetRecord = component.get("v.selectedTargetRecord");
         var selectedTargetRecordId = selectedTargetRecord.Id;
         var selectedDate = component.get("v.searchDate");
        if($A.util.isEmpty(selectedDate)){
            component.find("dayDateError").set("v.value", 'Please Select a Date');
            
        }
         else if($A.util.isEmpty(selectedTargetRecordId)){
            component.find("targetError").set("v.value", 'Please Select a Territory');
        }
        else{
            var action = component.get("c.fetchRecord");
            action.setParams({
    		"searchDate": selectedDate,"searchTargetId": selectedTargetRecordId
        });
		// set a call back   
        action.setCallback(this, function(response) {
        	var state = response.getState();
            if(state === "SUCCESS"){
                var resultDCRwrapRecord = response.getReturnValue();
                if(resultDCRwrapRecord.DCRDayRecord != null && resultDCRwrapRecord.DCRDayRecord != 'undefined' && resultDCRwrapRecord.DCRDayRecord != ''){
                	component.set("v.searchResultDCR",resultDCRwrapRecord.DCRDayRecord);
                    component.set("v.existingDCRId",resultDCRwrapRecord.DCRDayRecord.Id);
                    
                    
                        var activityDiv = component.find('visitDetailSection');
                        $A.util.removeClass(activityDiv, 'slds-hide');
                        $A.util.addClass(activityDiv, 'slds-show');
                   
                    if(resultDCRwrapRecord.DCRRouteRecord != null && resultDCRwrapRecord.DCRRouteRecord != '' && resultDCRwrapRecord.DCRRouteRecord != 'undefined'){
                        component.set("v.selectedRouteRecord",resultDCRwrapRecord.DCRRouteRecord);
                        component.set("v.routeName",resultDCRwrapRecord.DCRRouteRecord.Name);
                       // alert("Selected route Record is"+component.get("v.selectedRouteRecord"));
                    }
                    if(resultDCRwrapRecord.DCRDayRecord.First_Half__c != null && resultDCRwrapRecord.DCRDayRecord.First_Half__c != '' && resultDCRwrapRecord.DCRDayRecord.First_Half__c !='undefined'){
                        component.set("v.setFirstHalfValue",resultDCRwrapRecord.DCRDayRecord.First_Half__c);
        
                    }
                    if(resultDCRwrapRecord.DCRDayRecord.Second_Half__c != null && resultDCRwrapRecord.DCRDayRecord.Second_Half__c != '' && resultDCRwrapRecord.DCRDayRecord.Second_Half__c !='undefined'){
                        component.set("v.setSecondHalfValue",resultDCRwrapRecord.DCRDayRecord.Second_Half__c);
                    }
                    if(resultDCRwrapRecord.DCRDayRecord.Status__c != null && resultDCRwrapRecord.DCRDayRecord.Status__c != '' && resultDCRwrapRecord.DCRDayRecord.Status__c !='undefined'){
                        component.set("v.setStatusValue",resultDCRwrapRecord.DCRDayRecord.Status__c);
                    }
                    if(resultDCRwrapRecord.DCRDayRecord.Planned_Deviation__c != null && resultDCRwrapRecord.DCRDayRecord.Planned_Deviation__c != '' && resultDCRwrapRecord.DCRDayRecord.Planned_Deviation__c !='undefined'){
                        component.set("v.plannedDeviation",resultDCRwrapRecord.DCRDayRecord.Planned_Deviation__c);
                    }
                    if(resultDCRwrapRecord.DCRDayRecord.DCR_Locked__c != null && resultDCRwrapRecord.DCRDayRecord.DCR_Locked__c != '' && resultDCRwrapRecord.DCRDayRecord.DCR_Locked__c !='undefined'){
                        component.set("v.dcrLock",resultDCRwrapRecord.DCRDayRecord.DCR_Locked__c);
                    }
                     if(resultDCRwrapRecord.DCRDayCustomerswrapList != null && resultDCRwrapRecord.DCRDayCustomerswrapList != '' && resultDCRwrapRecord.DCRDayCustomerswrapList != 'undefined'){
                	    component.set("v.searchResultDCRCustomers",resultDCRwrapRecord.DCRDayCustomerswrapList);
                    }
                    var activityDiv = component.find('activityPerformedSection');
                       $A.util.removeClass(activityDiv, 'slds-hide');
                       $A.util.addClass(activityDiv, 'slds-show');
                    //For visit section header
                       var visitSectionHeader = component.find('visitSectionHeader');
                       $A.util.removeClass(visitSectionHeader, 'slds-hide');
                       $A.util.addClass(visitSectionHeader, 'slds-show');
                    var routereadDiv = component.find('routeReadonlyDiv');
                       $A.util.removeClass(routereadDiv, 'slds-hide');
                       $A.util.addClass(routereadDiv, 'slds-show');
                    var routeLookupdiv = component.find('routeLookupDiv');
                       $A.util.removeClass(routeLookupdiv, 'slds-show');
                       $A.util.addClass(routeLookupdiv, 'slds-hide');
                } 
                else{
                    /*  var noDCRdiv = component.find('noDCRerror');
                         $A.util.removeClass(noDCRdiv, 'slds-hide');
                    	 $A.util.addClass(noDCRdiv, 'slds-show');*/
                    component.set("v.toHideclass","slds-notify slds-notify_alert slds-theme_alert-texture slds-theme_error slds-show")
                    component.set("v.existingDCRId",null);
                    component.set("v.searchResultDCRCustomers",[]);
                    var activityDiv = component.find('activityPerformedSection');
                    $A.util.removeClass(activityDiv, 'slds-show');
                    $A.util.addClass(activityDiv, 'slds-hide');
                       //For visit section header
                       var visitSectionHeader = component.find('visitSectionHeader');
                       $A.util.removeClass(visitSectionHeader, 'slds-hide');
                       $A.util.addClass(visitSectionHeader, 'slds-show');
                    
                    var activityDiv = component.find('visitDetailSection');
                    $A.util.removeClass(activityDiv, 'slds-show');
                    $A.util.addClass(activityDiv, 'slds-hide');
                    
                    //Enable Create New Button	 
                    component.set("v.isCreateNewDisabled",false);
                    component.set("v.iterateVisitSec",false);
                    }
               
                if(resultDCRwrapRecord.PlannedDayRecord != null && resultDCRwrapRecord.PlannedDayRecord != ''&& resultDCRwrapRecord.PlannedDayRecord !='undefined'){
                    component.set("v.searchResultPlannedDay",resultDCRwrapRecord.PlannedDayRecord);
                }
                    
             }
        });
        $A.enqueueAction(action);
        }
    },
     showSaveToast: function(component, event, helper){
   // var saveStatus = component.get("v.dcrActivitySaveCheck");    
   // if(saveStatus == "true" || saveStatus == true){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Success!",
                "type": "success",
                "message": "Saved Successfully"
            });
           toastEvent.fire();
      //  component.set("v.dcrActivitySaveCheck",false);
    	
    },
      finishSuccess:function(){
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Success!",
            "type": "success",
            "message": "Successfully Submitted"
        });
        toastEvent.fire();
    },
     unlockSuccess:function(){
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Success!",
            "type": "success",
            "message": "Record Successfully Unlocked"
        });
        toastEvent.fire();
    }
})