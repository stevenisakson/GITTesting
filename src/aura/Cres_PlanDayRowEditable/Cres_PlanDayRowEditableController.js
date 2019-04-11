({
    doInit:function(cmp, event, helper) {
        var rec=cmp.get("v.planDay");
        if(rec['isNew']){
            /*Set the Mode form based on the record*/
            cmp.set("v.mode",'Edit');
        }
        if(rec.Id!=undefined){
            /*view mode when record already exist*/
            cmp.set("v.mode",'View');
        }
    },
    clearError:function(cmp,event,helper){
        cmp.set("v.plandayerror",[]);
    },
     edit:function(cmp, event, helper) {
        /*When Edit record*/
        var mode=cmp.get("v.mode");
        if(mode=='View'){
            cmp.set("v.mode",'Edit');
        }
    },
	onError : function(component, event, helper) {
	
        var plandayerror=component.get("v.plandayerror");
        var params=event.getParams();
        console.log(JSON.stringify(params));
        if(params['output']['fieldErrors']!=undefined){
            for(var fieldName in params['output']['fieldErrors']){
                var rec=params['output']['fieldErrors'][fieldName];
                for(var i=0;i<rec.length;i++){
                    plandayerror.push(rec[i]['message']);
                }
            }
        }
        if(params['output']['errors']!=undefined){
            var rec=params['output']['errors'];
            for(var i=0;i<rec.length;i++){
                plandayerror.push(rec[i]['message']);
            }
        }
        component.set("v.plandayerror",plandayerror);
	},
    onSuccess:function(component, event, helper){
        /*When Plan Day record is saved*/
        var toastEvent = $A.get("e.force:showToast");
       
        if(component.get("v.planDay.Id")!=undefined){
            helper.showUpdateToast();
        }else{
            helper.showCreatedToast();
        }
        var compEvent = component.getEvent("Plandayrecords");
        compEvent.fire();
        
        var appEvent = $A.get("e.c:Cres_AppEvent");
        
        appEvent.setParam("data",null);
        appEvent.fire();
       
       // helper.showHide(component);
    },
    /*Add a new Plan Day record*/
    addRow : function(component, event, helper) {
        
        component.set("v.plandayerror",[]); 
        var plandaylist=component.get("v.plandaylist");
        var flag=0;
        for(var i=0;i<plandaylist.length;i++){
            var rec=plandaylist[i];
            if(rec['isNew']!=undefined && rec['isNew']==true){
                flag=1;
            }
        }
        if(flag==1){
            /*Validation error when adding multiple rows before saving the current record*/
           var plandayerror=component.get("v.plandayerror");
           
           plandayerror.push($A.get("$Label.c.Cres_Route_AddRowError"));
           component.set("v.plandayerror",plandayerror); 
        }else{
            plandaylist.unshift({isNew:true}); 
        }
       
        component.set("v.plandaylist",plandaylist);
    },
    onSubmit:function(cmp,event,helper){
        cmp.set("v.plandayerror",[]);	
     
        event.preventDefault();
        
        /*Populate fields before submission*/
        /*Populate Route ID*/
        var routeField=cmp.find("routeFieldId");
        if(routeField!=null && cmp.get("v.selectedRoute.Id")!=undefined){
              routeField.set("v.value",cmp.get("v.selectedRoute.Id"));
              
        }else{
               routeField.set("v.value",null);
        }
        /*Populate PlanMonth Id ID*/
        var lookupField=cmp.find("relatedPlanningMonth");
        if(lookupField!=undefined){
            lookupField.set("v.value",cmp.get("v.planMonthId"));
            cmp.find("planDayForm").submit();
        }
        
    },
    /*Shows up when customer symbol is clicked*/
    toggleCustomers:function(cmp,event,helper){
        if(cmp.get("v.showCustomers")){
            cmp.set("v.showCustomers",false);
        }else{
            cmp.set("v.showCustomers",true);
            var customers=cmp.find("customers");
            customers.reload();
        }
    },
    /*Delete a Plan Day record*/
    deleteRec:function(cmp,event,helper){
        var recId=cmp.get("v.planDay.Id");
        console.log(recId);
        var index=cmp.get("v.index"); 
        var recList=cmp.get("v.plandaylist");
        helper.deletePlanDay(cmp,recId,function(resp){
            if(resp){
                helper.showDeleteToast();
                recList.splice(index,1);
                cmp.set("v.plandaylist",recList);
                var compEvent = cmp.getEvent("Plandayrecords");
                compEvent.fire();
            }
        });
    },
     /*POPUP for confirmation of delete*/
    showDeletePopUp:function(cmp,event,helper){
         $A.createComponent(
            "c:DeleteConfirmModal",
             {isOpen:'true',deleteRowID:''
            },
            function(newCmp, status, errorMessage){
                //Add the new button to the body array
                if (status === "SUCCESS") {
                    var body = cmp.get("v.body");
                    body.push(newCmp);
                    cmp.set("v.body", body);
                }
                else if (status === "INCOMPLETE") {
                    console.log("No response from server or client is offline.")
                    // Show offline error
                }
                else if (status === "ERROR") {
                    console.log("Error: " + errorMessage);
                    // Show error message
                }
            }
        );
         
    },
    /*Cancel a record being edited*/
    cancel:function(cmp,event,helper){
        var recList=cmp.get("v.plandaylist");
        var mode=cmp.get("v.mode");
        var rec=cmp.get("v.planDay");
        var index=cmp.get("v.index"); 
      
        if(mode=='Edit'){
            if(rec['isNew']){
                recList.splice(index,1);/*Delete the entry from Array*/
                cmp.set("v.plandaylist",recList);
                //cmp.destroy();
            }else{  
            cmp.set("v.mode",'View');
            }
        }
    },
    onload:function(cmp,event,helper){
        /*Populate Record Edit Form*/
        var recUi = event.getParam("recordUi");
        if(recUi.record!=undefined){
            /*Set Route Value in custom Component*/
            if(recUi.record.fields['Route__r']!=undefined && recUi.record.fields['Route__r']['value']!=null){
                cmp.set("v.selectedRoute",{Name:recUi.record.fields['Route__r'].displayValue,
                                           Id:recUi.record.fields['Route__r']['value'].id})
                
            }
        }
    }
})