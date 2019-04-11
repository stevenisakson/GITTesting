({
    doInit:function(cmp, event, helper) {
        var rec=cmp.get("v.planDay");
        var months = ["Jan", "Feb", "Mar", "April", "May", "Jun", "July","Aug","Sept","Oct","Nov","Dec"];
        
        if(rec['isNew']){
            /*Set the Mode form based on the record*/
            cmp.set("v.mode",'Edit');
        }
        if(rec.Id!=undefined){
            /*view mode when record already exist*/
            cmp.set("v.mode",'View');
            var planday=rec['Plan_Date__c'];
            var routeRecord=rec['Route__r'];
            cmp.set("v.selectedRoute",routeRecord);
            console.log(routeRecord);
            
          /*  var splitDate=planday.split("-");
            console.log(splitDate);
            var formmatedDate=new Date(splitDate[0],splitDate[1],splitDate[2]);
            console.log(formmatedDate);
            console.log(formmatedDate.getMonth()); */
           // cmp.set("v.displayDate",splitDate[2]+"-"+months[formmatedDate.getMonth()-1]);
            
        
            var dateString = rec['Plan_Date__c'];
            
            console.log('dateString');
            console.log(dateString);
            cmp.set("v.displayDate",$A.localizationService.formatDate(dateString, "MMM-DD"));


            
            
        }
      
       // helper.getPlanDay(cmp);
       // helper.fetchfirstPicklist(cmp); // fetches PickList Values of month Field
        //helper.fetchsecondPicklist(cmp); // fetches PickList Values of year Field
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
        if(confirm($A.get('$Label.c.POT_DELETE_CONFIRMATION'))){
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
        }
        /*   $A.createComponent(
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
        );*/
        
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
    
    save:function(cmp,event,helper){
        cmp.set("v.plandayerror",[]);
        var planDay=cmp.get("v.planDay");
        var plandayerror=cmp.get("v.plandayerror");
        helper.validateForm(planDay,plandayerror);
        if(plandayerror.length>0){
            cmp.set("v.plandayerror",plandayerror);
            return;
        }
        cmp.set("v.isLoading",true);
        
        if(cmp.get("v.selectedRoute.Id")!=undefined){
            planDay['Route__c']=cmp.get("v.selectedRoute.Id");
        }else{
            planDay['Route__c']=null;
        }
        planDay['Related_Planning_Month__c']=cmp.get("v.planMonthId"); 
        helper.savePlanDayMob(cmp,planDay);
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
})