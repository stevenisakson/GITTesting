({
    handleLoad:function(cmp,event,helper){
        cmp.set("v.isLoading",false);
    },
    clearError:function(cmp,event,helper){
        /*clear the errors that is displayed*/
        cmp.set("v.planmontherror",[]);
    },
    /*Refresh the Plan Month when a plan day is added*/
    refresh:function(cmp,event,helper){
        var data=event.getParam("data");
        if(data==null){
            
            console.log('Refresh');
            cmp.set("v.isLoading",true);
            
            helper.fetchPlanningMonth(cmp);
           
        }
    }
    ,
    doInit : function(cmp, event, helper) {
        /*Load the Plan Months*/
        cmp.set("v.isLoading",true);
        
        helper.fetchPlanningMonth(cmp);
        //helper.fetchTypePicklist(cmp); // fetches PickList Values of month Field
        //helper.fetchyearPicklist(cmp); // fetches PickList Values of year Field
             
    },
   
    setAsRecordsChanged:function(cmp,event,helper){
        cmp.set("v.hasRecordsChanged",true);
    },
    addNewMonth:function(cmp,event,helper){
        /*Show the Plan Month creation Form. New Plan Month is clicked*/
        if(cmp.get("v.showMonthPlan")){
             cmp.set("v.showMonthPlan",false);
        }else{
              cmp.set("v.showMonthPlan",true);
        }
      
    },
  
    onSuccess:function(cmp,event,helper){
        cmp.set("v.showMonthPlan",false);
        var recId=cmp.get("v.recordId");
        console.log('doInit');
        helper.showToast();
        cmp.set("v.isLoading",true);
         cmp.set("v.selectedtarget.Id","")
         cmp.set("v.planmontherror",[]);
        helper.fetchPlanningMonth(cmp);
       
    },
    /*Load Plan Day record when Plan Button in the Table is clicked*/
    handleRowAction: function (cmp, event, helper) {
        var pageReference = {
            type: 'standard__component',
            attributes: {
                "componentName": "c__PlanneddaycomponentMob"   
            },
            state:{"recordId":event.getSource().get("v.value")}
        };
        cmp.set("v.pageReference", pageReference);
        
        var navService = cmp.find("navService");
        var pageReference = cmp.get("v.pageReference");
        event.preventDefault();
        navService.navigate(pageReference);
    },
    /*Capture the validation error when Plan Month is saved*/
    onError:function(cmp,event,helper){
        var planmontherror=cmp.get("v.planmontherror");
        var params=event.getParams();
        console.log(JSON.stringify(params));
        if(params['output']['fieldErrors']!=undefined){
            for(var fieldName in params['output']['fieldErrors']){
                var rec=params['output']['fieldErrors'][fieldName];
                for(var i=0;i<rec.length;i++){
                    planmontherror.push(rec[i]['message']);
                }
            }
        }
        if(params['output']['errors']!=undefined){
            var rec=params['output']['errors'];
            for(var i=0;i<rec.length;i++){
                planmontherror.push(rec[i]['message']);
            }
        }
        
        //planmontherror.push(params['output']['message']);
        cmp.set("v.planmontherror",planmontherror);
        //console.log(event.getParams());
    },
    /*Clear the previous errors when submit btn is clicked*/
    onsubmit:function(cmp,event,helper){
        event.preventDefault();
        cmp.set("v.planmontherror",[]);
        var eventFields = event.getParam("fields");
        console.log('Target id');
        console.log(cmp.get("v.selectedtarget.Id"));
        
        if(cmp.get("v.selectedtarget.Id") != null && cmp.get("v.selectedtarget.Id") != undefined){
           
            console.log('Set');
          
            eventFields['Target__c']=cmp.get("v.selectedtarget.Id");
        }
        var planmontherror=cmp.get("v.planmontherror");
        helper.validateForm(eventFields,planmontherror);
        if(planmontherror.length>0){
            cmp.set("v.planmontherror",planmontherror);
            return;	
        }
        cmp.find('mypalnmonthform').submit(eventFields);
           
    }
})