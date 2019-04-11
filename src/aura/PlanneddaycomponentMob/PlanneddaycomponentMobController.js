({
    /*When Plan Day is successfully Submitted*/
    onSuccess:function(component,event,helper){
          component.set("v.isLoading",false);
          helper.showSubmitToast();
          helper.fetchplandays(component, event, helper);
          helper.getPlanningMonth(component, event, helper);
          helper.showUpdateToast();
          
    },
     clearError:function(cmp,event,helper){
         /*Clear the errors*/
        cmp.set("v.plandayerror",[]);
    },
    doInit: function(component, event, helper) {
        
        /*Record Id received from the Plan Month Section is used to fetch the Plan Day records*/
        var pageRef=component.get("v.pageReference");
        component.set("v.recordId",pageRef['state'].recordId);
        console.log(pageRef['state'].recordId);
      
        helper.getPlanningMonth(component, event, helper);/*Fetch Plan Month detail */
        helper.fetchplandays(component, event, helper);/*Fetch Plan Month detail */
        helper.getactivityPickList(component);
      
       
       
    },
    onError:function(cmp,event,helper){
      
        cmp.set("v.isLoading",false);
        var plandayerror=cmp.get("v.plandayerror");
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
        cmp.set("v.plandayerror",plandayerror);
    },
    /*When Submit button is clicked*/
    onSubmit:function(cmp,event,helper){
      
        cmp.set("v.isLoading",true);
        event.preventDefault();
        var eventFields = event.getParam("fields");
        eventFields["Status__c"] = "Submitted For Approval";
        console.log('users 1 and 2');
        console.log(cmp.get("v.selectedApp1.Id"));
        console.log(cmp.get("v.selectedApp2.Id"));
        if(cmp.get("v.selectedApp1.Id") != null && cmp.get("v.selectedApp1.Id") != undefined  ){
            eventFields["Approver_1__c"] = cmp.get("v.selectedApp1.Id");
           
        }
        if(cmp.get("v.selectedApp2.Id") != null && cmp.get("v.selectedApp2.Id") != undefined  ){
           eventFields["Approver_2__c"] = cmp.get("v.selectedApp2.Id"); 
           
        }
        cmp.find('planDayForm').submit(eventFields);
        cmp.set("v.plandayerror",[]);
     	
        
    },
   
    /*reload the days planned,working days section when plan day is added/deleted*/
    refresh : function(component, event, helper) {
        //helper.getPlanningMonth(component, event, helper);
        console.log('refresh');
        helper.fetchplandays(component, event, helper);
        helper.getPlanningMonth(component, event, helper);
       
       
    },
    reInit : function(cmp, event, helper) {
        console.log('reinit');
        if(cmp.get("v.pageReference")['state']!=undefined && cmp.get("v.pageReference")['state']['btnAction']!='back'){
             location.reload();
        }
       
    },
    onload:function(cmp,event,helper){
        console.log('load');
         var recordUi = event.getParam("recordUi");
         var record=recordUi.record;
         var fields=record['fields'];
         var monthPlan=fields['Month_Planned__c']['displayValue'];
         var yearPlan=fields['Plan_Year__c']['displayValue'];
         var territoryName=fields['Target__r']['displayValue'];
          
        if(fields['Approver_2__r']!=undefined){
            var approver2Name=fields['Approver_2__r']['displayValue'];
            var approver2Id=fields['Approver_2__c']['value'];
        }
        
        if(fields['Approver_1__r']!=undefined){
         var approver1Name=fields['Approver_1__r']['displayValue'];
         var approver1Id=fields['Approver_1__c']['value'];
        }
        
        console.log(approver2Name);
        console.log(approver2Id);
        console.log(approver1Name);
        console.log(approver1Id);
        cmp.set("v.selectedApp1",{Name:approver1Name,Id:approver1Id});
        cmp.set("v.selectedApp2",{Name:approver2Name,Id:approver2Id});
        
        
        
         cmp.set("v.planYearDisplay",yearPlan);
         cmp.set("v.planMonthDisplay",monthPlan);
         cmp.set("v.territoryDisplay",territoryName);
         
         console.log(JSON.stringify(record));
      
    },
    back:function(cmp,event,helper){
        var pageReference = {
            type: 'standard__navItemPage',
            attributes: {
                "apiName": "Route_Planning_Mobile"   
            },
            state:{btnAction:'back'}
        };
        
        cmp.set("v.pageReference", pageReference);
        
        var navService = cmp.find("navService");
        
        event.preventDefault();
        navService.navigate(pageReference);
    },
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
    
})