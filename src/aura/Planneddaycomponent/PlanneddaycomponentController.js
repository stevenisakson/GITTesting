({
    /*When Plan Day is successfully Submitted*/
    onSuccess:function(component,event,helper){
        
          helper.fetchplandays(component, event, helper);
          helper.getPlanningMonth(component, event, helper);
          helper.showUpdateToast();
            /*fire the Event to reload PlanMonth Section*/
            var appEvent = $A.get("e.c:Cres_AppEvent");
            
            appEvent.setParam("data",null);
            appEvent.fire();
    },
     clearError:function(cmp,event,helper){
         /*Clear the errors*/
        cmp.set("v.plandayerror",[]);
    },
    doInit: function(component, event, helper) {
        
        /*Record Id received from the Plan Month Section is used to fetch the Plan Day records*/
        var recordId=event.getParam("data");
        if(recordId!=undefined){
            console.log(recordId);
            component.set("v.recordId",recordId);
            component.set("v.isLoading",true);
            helper.getPlanningMonth(component, event, helper);/*Fetch Plan Month detail */
            helper.fetchplandays(component, event, helper);/*Fetch Plan days */
            
        }else{
            console.log('error');
        }
       
    },
    onError:function(cmp,event,helper){
      
    
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
      
        cmp.set("v.plandayerror",[]);//clear the errors
        event.preventDefault();
        cmp.find("statusField").set("v.value",'Submitted For Approval');/*Set the Status as submitted for approval*/
      
        cmp.find("planDayForm").submit();
    },
   
    /*reload the days planned,working days section when plan day is added/deleted*/
    refresh : function(component, event, helper) {
        //helper.getPlanningMonth(component, event, helper);
        console.log('refresh');
        helper.fetchplandays(component, event, helper);
        helper.getPlanningMonth(component, event, helper);
       
    },
    
})