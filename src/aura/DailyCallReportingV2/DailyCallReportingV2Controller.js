({
	doInit: function(cmp, event, helper) {
		
        helper.checkDCRUnlockAccess(cmp);
        helper.getUserInfo(cmp);
    },
    
    onload:function(cmp,event,helper){
      $A.util.removeClass(cmp.find("frstHalf"), "none");
      $A.util.removeClass(cmp.find("secHalf"), "none");      
    },
   openModal: function(component, event, helper) {
      // for Display Modal,set the "isOpen" attribute to "true"
      // Check if the user has added Visit Details
      
        var firstHalf = component.find("frstHalfOutput").get("v.value");
        var secHalf = component.find("secHalfOutput").get("v.value");
      
       var searchResultDCRCustomers=component.get("v.searchResultDCRCustomers");
       if((firstHalf == 'Customer Visit' || secHalf == 'Customer Visit') && searchResultDCRCustomers!=undefined && searchResultDCRCustomers.length==0){
           
           component.set("v.dcrerrors",['Please Add Visit Details to Complete the DCR']);
       }else{
            component.set("v.isOpen", true);
       }
       
     
   },
 
   closeModal: function(component, event, helper) {
      // for Hide/Close Modal,set the "isOpen" attribute to "Fasle"  
      component.set("v.isOpen", false);
   },
   
   openSaveModal: function(component, event, helper) {
      // for Display Modal,set the "ismodalOpen" attribute to "true"
      component.set("v.ismodalOpen", true);
   },
 
   closeSaveModal: function(component, event, helper) {
      // for Hide/Close Modal,set the "ismodalOpen" attribute to "Fasle"  
      component.set("v.ismodalOpen", false);
   },

    finishClick:function(cmp,event,helper){
        console.log('finish');
        console.log(cmp.get("v.existingDCRId"));
      
        /*check if a customer is added*/
        
        helper.finishDCRRecord(cmp,cmp.get("v.existingDCRId"));
        cmp.set("v.isOpen", false);
        
       
    },
    onSubmit:function(component, event, helper) {
        component.set("v.dcrerrors",[]);
        var selectedTargetRecord=component.get("v.selectedTargetRecord");
        console.log(selectedTargetRecord.Id);
        var searchDate=component.get("v.searchDate");
        var eventFields = event.getParam("fields");
        component.set("v.isOutputfield",true);
        var fhalf=component.find("frstHalf").get("v.value");
        var shalf=component.find("secHalf").get("v.value");
        var comment=component.find("commentsId").get("v.value");
        console.log(fhalf+'--'+shalf+'--'+comment);
        
        component.set("v.firstHalfValue",fhalf);
       
        component.set("v.secondHalfValue",shalf);
   
        component.set("v.commentValue",comment);
        
       /* component.set("v.firstHalfValue",eventFields["First_Half__c"]);
       
        component.set("v.secondHalfValue",eventFields["Second_Half__c"]);
   
        component.set("v.commentValue",eventFields["Comments__c"]);
        console.log()
        */
        if(fhalf== 'Customer Visit' || shalf == 'Customer Visit'
          || fhalf == 'Group Meeting' || shalf == 'Group Meeting'){
           component.set("v.showVisitSection",true); 
            if(component.get("v.existingDCRId")!=undefined && component.get("v.existingDCRId")!=null){
                  helper.fetchDCRCustomerList(component,component.get("v.existingDCRId"));//Reload visit section
            }
         
        }
        else{
           component.set("v.showVisitSection",false);
           component.set("v.searchResultDCRCustomers",[]);
        }
        
       // event.preventDefault();
        component.find("targetFieldId").set("v.value",selectedTargetRecord.Id);
        component.find("dayFieldId").set("v.value",searchDate);
        component.set("v.ismodalOpen", false);
        component.find("dcrForm").submit();
        console.log('in submit end');
    },
        onError : function(component, event, helper) {
       // component.set("v.isOutputfield",false);
        var dcrerror=component.get("v.dcrerrors");
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
            component.set("v.dcrerrors",dcrerror);
            if(dcrerror.length>0){  
                component.set("v.isCancelDisabled",true);
                component.set("v.isEditDisabled",true);
                component.set("v.isAddCustDisabled",true);
                component.set("v.isOutputfield",false);
                console.log('After Error first half value is'+component.get("v.firstHalfValue"));
                console.log('After Error second half value is'+component.get("v.secondHalfValue"));
                console.log('After Error comment value is'+component.get("v.commentValue"));    
                console.log('Errors occured are'+dcrerror);  
                
                var firstHalf = component.get("v.firstHalfValue");
                var secHalf = component.get("v.secondHalfValue");
                var comment = component.get("v.commentValue");
                
                component.find("frstHalf").set("v.value", firstHalf);
                component.find("commentsId").set("v.value", comment);
                component.find("secHalf").set("v.value", secHalf);
            }
    },
    
    Search: function(component, event, helper) {
        component.set("v.toHideclass","slds-notify slds-notify_alert slds-theme_alert-texture slds-theme_error slds-hide")
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
                var today = new Date();
            	var tdate = today.getFullYear()+'-'+(today.getMonth()+1)+'-'+today.getDate();
            	console.log('today date is'+tdate);
            	
            	component.find("targetError").set("v.value", '');
                component.find("dayDateError").set("v.value", '');
                component.set("v.isDateDisabled",true);
                component.set("v.isTerrSelected",true);
               // component.find("terrOutputfield").set("v.value", selectedTargetRecordId.Name);
        		component.set("v.selectedTargetRecordId",selectedTargetRecordId);
            var searchSelectedDate = new Date(component.get("v.searchDate"));
            var todayDate = new Date();
            if((searchSelectedDate-todayDate)>0){
                component.set("v.isSearchDisabled",true);
                component.set("v.searchErrMsg",$A.get("$Label.c.DCR_Error_Future_Date"));
                component.set("v.toHideclass","slds-notify slds-notify_alert slds-theme_alert-texture slds-theme_error slds-show");
           }
           else{
                component.set("v.isSearchDisabled",true);
                helper.getDCRRecord(component,selectedDate,selectedTargetRecordId);
           }
        }
	     
	},
 
     unlockDCRRecordClicked: function(cmp, event, helper) {
         console.log('unlock');
		helper.unlockDCRRecord(cmp,cmp.get("v.existingDCRId"));
	},
    
    SaveActivitySection : function(component, event, helper) {
		helper.SaveActivity(component,event);
	},
    
    showSaveToast: function(component, event, helper){
    var saveStatus = component.get("v.dcrActivitySaveCheck");    
    if(saveStatus == "true" || saveStatus == true){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Success!",
                "type": "success",
                "message": "Saved Successfully"
            });
            toastEvent.fire();
        component.set("v.dcrActivitySaveCheck",false);
    	}
    },
    onFirstHalfChange: function(component, event, helper){
        
    },
    onSecondHalfChange: function(component, event, helper){
        
    },
    onStatusChange: function(component, event, helper){
        
    },
    editRouteField: function(component, event, helper){
       var routeRODiv = component.find('routeReadonlyDiv');
       $A.util.removeClass(routeRODiv, 'slds-show');
       $A.util.addClass(routeRODiv, 'slds-hide');
       var routeLookDiv = component.find('routeLookupDiv');
       $A.util.removeClass(routeLookDiv, 'slds-hide');
       $A.util.addClass(routeLookDiv, 'slds-show');
    },
    activityEditClick: function(component, event, helper){
        component.set("v.isCancelDisabled",false);
        component.set("v.isEditDisabled",true);
        component.set("v.isSaveDisabled",false);
        //Set field values in Input Mode
        component.set("v.isOutputfield",false);
        var dcrRecord = component.get("v.dcrRecord");
        var firstHalf = dcrRecord.First_Half__c;
        var secHalf = dcrRecord.Second_Half__c;
        var comment = dcrRecord.Comments__c;
        component.set("v.isAddCustDisabled",true);
        component.find("frstHalf").set("v.value", firstHalf);
        component.find("commentsId").set("v.value", comment);
        component.find("secHalf").set("v.value", secHalf);
    },
    activityCancelClik: function(component, event, helper){
        var dcrRecord = component.get("v.dcrRecord");
        component.set("v.isCancelDisabled",true);
        component.set("v.isEditDisabled",false);
        component.set("v.isSaveDisabled",true);
        
        component.set("v.isOutputfield",true);
        
        var firstHalf = dcrRecord.First_Half__c;
        var secHalf = dcrRecord.Second_Half__c;
        var comment = dcrRecord.Comments__c;
        
        component.find("frstHalfOutput").set("v.value", firstHalf);
        component.find("commentsIdOutput").set("v.value", comment);
        component.find("secHalfOutput").set("v.value", secHalf);
        if(firstHalf == 'Customer Visit' || secHalf == 'Customer Visit'
          || firstHalf == 'Group Meeting' || secHalf == 'Group Meeting'){
            component.set("v.isAddCustDisabled",false);
        }
        
    },
    dcrChange: function(component, event, helper){
        //component.set("v.ProductInstance.Type__c", selectedType.get("v.value"));
       // var setOptionValue = component.find("InputFirstHalf").get("v.value")
        var DCR = component.get("v.searchResultDCR");
        component.set("v.LOB",DCR.Line_Of_Business__c);
        component.set("v.UserType",DCR.User_Type__c);
       // component.set("v.PlannedDay",DCR.Planned_Day__r.Name);
    },
    closeExDCRError: function(component, event, helper){
       component.set("v.dcrerrors",[]); 
       component.set("v.toHideclass","slds-notify slds-notify_alert slds-theme_alert-texture slds-theme_error slds-hide")
    },
    dcrCustomerChange: function(component, event, helper){
        var visitSection = component.find('visitDetailSection');
        $A.util.removeClass(visitSection, 'slds-hide');
        $A.util.addClass(visitSection, 'slds-show');
        component.set("v.iterateVisitSec",true);
    },
    cancelSearch: function(component, event, helper){
        //Fire the refresh view event to reload page
    	//$A.get('e.force:refreshView').fire();
    	location.reload();
    },
     newDCR: function(cmp, event, helper){
       //alert("on click new"); 
      /* component.set("v.isSearchDisabled",true);
       component.set("v.isTerritoryDisabled",true);
       component.set("v.isDateDisabled",true);
       component.set("v.isNewDCRRecord",true); 
       var noDCRErrordiv = component.find('noDCRerror');
       $A.util.removeClass(noDCRErrordiv, 'slds-show');
       $A.util.addClass(noDCRErrordiv, 'slds-hide');
       var activityDiv = component.find('activityPerformedSection');
       $A.util.removeClass(activityDiv, 'slds-hide');
       $A.util.addClass(activityDiv, 'slds-show');
       component.set("v.isCreateNewDisabled",true);  */
         var btn=event.getSource();
         if(!cmp.get("v.isCreateNewDisabled")){
             var visitSection = cmp.find('activityPerformedSection');
             $A.util.removeClass(visitSection, 'slds-hide');
             $A.util.addClass(visitSection, 'slds-show');
             //display visit section header
             var visitSectionheader = cmp.find('visitSectionHeader');
             $A.util.removeClass(visitSectionheader, 'slds-hide');
             $A.util.addClass(visitSectionheader, 'slds-show');
             
             cmp.set("v.existingDCRId",null);
             cmp.set("v.isCreateNewDisabled",false);
             cmp.set("v.toHideclass","slds-notify slds-notify_alert slds-theme_alert-texture slds-theme_error slds-hide")
             
         }
      
     
    },
    handleSuccess:function(cmp,event,helper){
        console.log('****in handleSuccess enter****');
        var payload = event.getParams().response;
        console.log('****in handleSuccess****');
        console.log(JSON.stringify(payload));
        helper.showSaveToast();
		
        cmp.set("v.isCancelDisabled",true);
        cmp.set("v.isEditDisabled",false);
        cmp.set("v.isSaveDisabled",true);
        
        cmp.set("v.isOutputfield",true);
        console.log("first half success ##"+cmp.get("v.firstHalfValue"));
       // console.log("Line of business after success is ##"+cmp.find("lineOfBusiness").get("v.value"));
        
        var firstHalf = cmp.get("v.firstHalfValue");
        var secHalf = cmp.get("v.secondHalfValue");
        var comment = cmp.get("v.commentValue");
         console.log("first half success sec##"+firstHalf);
        //Update existing dcrRecord attribute values
        var dcrRecord = cmp.get("v.dcrRecord");
        cmp.set("v.isOutputfield",true);
            dcrRecord.First_Half__c = firstHalf;
            dcrRecord.Second_Half__c = secHalf;
            dcrRecord.Comments__c = comment;
           
            cmp.find("frstHalfOutput").set("v.value", firstHalf);
            cmp.find("commentsIdOutput").set("v.value", comment);
            cmp.find("secHalfOutput").set("v.value", secHalf);
        
        var showSection = cmp.get('v.showVisitSection');
        if(showSection == true){
            var activityDiv = cmp.find('visitDetailSection');
            $A.util.removeClass(activityDiv, 'slds-hide');
            $A.util.addClass(activityDiv, 'slds-show');
           
            cmp.set("v.isAddCustDisabled",false); 
            
        }
        else{
            var activityDiv = cmp.find('visitDetailSection');
            $A.util.removeClass(activityDiv, 'slds-show');
            $A.util.addClass(activityDiv, 'slds-hide'); 
        }
        
        cmp.set("v.isSearchDisabled",true);
       // cmp.set("v.isTerritoryDisabled",false);
       // cmp.set("v.isDateDisabled",false);
        cmp.set("v.isNewDCRRecord",false);
        cmp.set("v.isCreateNewDisabled",true);
        
        cmp.set("v.existingDCRId",payload['id']);
        
       // cmp.set("v.searchResultDCRCustomers",[{isNew:true}]);
        console.log(payload['id']);
       // helper.fetchDCRCustomerList(cmp,payload['id']);
       
    },
      Adddcrcust:function(cmp,event,helper){
        
         /* cmp.set("v.dcrerrors",[]); 
          var drcCust=cmp.get("v.searchResultDCRCustomers");
          drcCust.unshift({isNew:true});
          cmp.set("v.searchResultDCRCustomers",drcCust);*/
          
           var plandaylist=cmp.get("v.searchResultDCRCustomers");
        
          
          var flag=0;
          for(var i=0;i<plandaylist.length;i++){
              var rec=plandaylist[i];
              if(rec['isNew']!=undefined && rec['isNew']==true){
                  flag=1;
              }
          }
          if(flag==1){
              var plandayerror=cmp.get("v.dcrerrors");
              
              plandayerror.push($A.get("$Label.c.Cres_Route_AddRowError"));
              cmp.set("v.dcrerrors",plandayerror); 
          }else{
              
              plandaylist.unshift({isNew:true});
              cmp.set("v.searchResultDCRCustomers",plandaylist);
              cmp.set("v.state",'loaded');
          }
        
        
    }
  
    
})