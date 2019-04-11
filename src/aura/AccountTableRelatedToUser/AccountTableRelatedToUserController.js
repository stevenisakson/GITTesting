({
    getMessage: function(component, event, helper) {
        helper.doInitHelper(component, event);
    },
 
    /* javaScript function for pagination */
    navigation: function(component, event, helper) {
        var sObjectList = component.get("v.listOfAllAccounts");
        var end = component.get("v.endPage");
        var start = component.get("v.startPage");
        var pageSize = component.get("v.pageSize");
        var whichBtn = event.getSource().get("v.name");
        // check if whichBtn value is 'next' then call 'next' helper method
        if (whichBtn == 'next') {
            component.set("v.currentPage", component.get("v.currentPage") + 1);
            helper.next(component, event, sObjectList, end, start, pageSize);
        }
        // check if whichBtn value is 'previous' then call 'previous' helper method
        else if (whichBtn == 'previous') {
            component.set("v.currentPage", component.get("v.currentPage") - 1);
            helper.previous(component, event, sObjectList, end, start, pageSize);
        }
    },
 
    selectAllCheckbox: function(component, event, helper) {
        var selectedHeaderCheck = event.getSource().get("v.value");
        var updatedAllRecords = [];
        var updatedPaginationList = [];
        var listOfAllAccounts = component.get("v.listOfAllAccounts");
        var PaginationList = component.get("v.PaginationList");
        // play a for loop on all records list 
        for (var i = 0; i < listOfAllAccounts.length; i++) {
            // check if header checkbox is 'true' then update all checkbox with true and update selected records count
            // else update all records with false and set selectedCount with 0  
            if (selectedHeaderCheck == true) {
                listOfAllAccounts[i].isChecked = true;
                component.set("v.selectedCount", listOfAllAccounts.length);
            } else {
                listOfAllAccounts[i].isChecked = false;
                component.set("v.selectedCount", 0);
            }
            updatedAllRecords.push(listOfAllAccounts[i]);
        }
        // update the checkbox for 'PaginationList' based on header checbox 
        for (var i = 0; i < PaginationList.length; i++) {
            if (selectedHeaderCheck == true) {
                PaginationList[i].isChecked = true;
            } else {
                PaginationList[i].isChecked = false;
            }
            updatedPaginationList.push(PaginationList[i]);
        }
        component.set("v.listOfAllAccounts", updatedAllRecords);
        component.set("v.PaginationList", updatedPaginationList);
    },
 
    checkboxSelect: function(component, event, helper) {
        // on each checkbox selection update the selected record count 
        var selectedRec = event.getSource().get("v.value");
        var getSelectedNumber = component.get("v.selectedCount");
        if (selectedRec == true) {
            getSelectedNumber++;
        } else {
            getSelectedNumber--;
            component.find("selectAllId").set("v.value", false);
        }
        component.set("v.selectedCount", getSelectedNumber);
        // if all checkboxes are checked then set header checkbox with true   
        if (getSelectedNumber == component.get("v.totalRecordsCount")) {
            component.find("selectAllId").set("v.value", true);
        }
    },
 
    getSelectedRecords: function(component, event, helper) {
        var selectedUsername =component.get("v.selectedUserName");
        var selectedUserId = component.get("v.selectedUserId"); 
        //alert('selectedUserId: '+selectedUserId);
        var alertMessage = component.get("v.enviromentContext");
        var allRecords = component.get("v.listOfAllAccounts");
        var selectedRecords = [];
        for (var i = 0; i < allRecords.length; i++) {
            if (allRecords[i].isChecked) {
                selectedRecords.push(allRecords[i].objAccount.Id);
            }
        }
        //alert(JSON.stringify(selectedRecords));
        var accidListJSON=JSON.stringify(selectedRecords);
        
        //To show popup starts*******************************************
         /*var action1 = component.get("c.selectedAccountIds");
         
    	 action1.setParams({
            "accIds1":accidListJSON
        });
         action1.setCallback(this, function(response1) {
            var state = response1.getState();
            //alert('state for error: '+state);
             if (state === "SUCCESS"){
             var response1 = response1.getReturnValue();
                 //alert('Response from Server: '+JSON.stringify(response1));
           for(var thisRecord in response1){
               //alert('in 1st for loop');
             for (var i = 0; i < allRecords.length; i++) {
                  //alert('in 2nd for loop');
                 if (allRecords[i].isChecked){
                    // alert('isChecked');
                    if(thisRecord === allRecords[i].objAccount.Id) {
                     //alert('Error: '+allRecords[i].objAccount.Id);
              }
            }
            } 
           }
         }
         });
        $A.enqueueAction(action1); */
        //To show popup ends*********************************************
      var responseValue;
		var action = component.get("c.createRequestRecord");
    	action.setParams({
            "accIds":accidListJSON,
            "username":selectedUsername,
            "selectedUserId":selectedUserId
    });
      action.setCallback(this, function(response) {
            var state = response.getState();
           // alert('state:'+ state);
     if (state === "SUCCESS"){
      var cmpEvent = $A.get("e.c:hideAccountTable"); 
      //Set event attribute value
      cmpEvent.setParams({"hideTableAndPill" : false, "showSearchText":true}) 
      cmpEvent.fire();
           
      if(alertMessage == 'Theme3' || alertMessage == 'Theme2' ){  
      	alert('Account team delete request sent successfully!');
       }
      else{
          var toastEvent = $A.get("e.force:showToast");
          toastEvent.setParams({
            title : 'Success',
            message: 'Account team delete request sent successfully!',
            messageTemplate: 'Record {0} created! See it {1}!',
            duration:' 5000',
            key: 'info_alt',
            type: 'success',
            mode: 'pester'
        });
        toastEvent.fire();
       } 
        var evt = $A.get("e.force:navigateToComponent");
        //console.log('evt'+evt);
        evt.setParams({
            componentDef: "c:AccountTeamDelete"
            //componentAttributes :{ }
        });
        evt.fire();
     
      }
    });
     $A.enqueueAction(action); 
   },
})