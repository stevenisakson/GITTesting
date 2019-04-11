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
        
        helper.fetchPlanningMonth(cmp);
       
    },
    /*Load Plan Day record when Plan Button in the Table is clicked*/
    handleRowAction: function (cmp, event, helper) {
        var action = event.getParam('action');
        var row = event.getParam('row');
        console.log(JSON.stringify(row));
        var appEvent = $A.get("e.c:Cres_AppEvent");
       
        appEvent.setParam("data",row.Id);//send the record Id along with the Event
        appEvent.fire();
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
          cmp.set("v.planmontherror",[]);
    }
})