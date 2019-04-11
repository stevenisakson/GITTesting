({
	onload : function(component, event, helper) {
		
	},
    saveBtnClick:function(component, event, helper) {
		
	},
    unlockDCRBtn:function(cmp, event, helper) {
        cmp.set("v.isLoading",true);
        helper.unlockDCRMob(cmp,cmp.get("v.dcrId"),function(ret){
              cmp.set("v.isLoading",false);
            if(ret){
                helper.showUnlockToast();
                helper.fetchDCRRecord(cmp,cmp.get("v.dcrId"));
            }
        });
	},
    completeBtnClick:function(cmp, event, helper) {
        if(cmp.get("v.dcrWrapper.hasCustomerActivity")==false || (cmp.get("v.dcrWrapper.hasCustomerActivity")==true && cmp.get("v.dcrWrapper.dcrCustRec").length>0)){
            cmp.set("v.isLoading",true);
            helper.completeDCRMob(cmp,cmp.get("v.dcrId"),function(ret){
                if(ret){
                    cmp.set("v.isLoading",false);
                    helper.showCompleteToast();
                    helper.fetchDCRRecord(cmp,cmp.get("v.dcrId"));
                }
            });
        }else if(cmp.get("v.dcrWrapper.hasCustomerActivity")==true && cmp.get("v.dcrWrapper.dcrCustRec").length==0){
             cmp.set("v.dcrerror",['Please Add at least one customer to Complete the DCR']);
        }
	},
   
    onSuccess:function(component, event, helper) {
        component.set("v.isLoading",false);
        var payload = event.getParams().response;
        console.log(payload.id);
        if(component.set("v.dcrId")==undefined){
             helper.showCreatedToast();
             helper.fetchDCRRecord(component,payload.id);
        }else{
            helper.showUpdateToast();
            helper.fetchDCRRecord(component,component.get("v.dcrId"));
        }
       /* if(component.get("v.firstHalf")=='Customer Visit' ||  
           component.get("v.firstHalf")=='Group Meeting' || component.get("v.secondHalf")=='Group Meeting'
          || component.get("v.secondHalf")=='Customer Visit'){
            
            component.set("v.enabledAddCustomer",true);
        }*/
        
        component.set("v.dcrId",payload.id);
    },
    onError:function(component, event, helper) {
        component.set("v.isLoading",false);
        var dcrerror=component.get("v.dcrerror");
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
        component.set("v.dcrerror",dcrerror);
    },
    doInit:function(cmp,event,helper){
        var pref=cmp.get("v.pageReference");
        if(pref['state']!=undefined && pref['state']['dcrId']){
            cmp.set("v.dcrId",pref['state']['dcrId']);
            cmp.set("v.isLoading",true);
            helper.getConfiValues(cmp,function(ret){
                helper.fetchDCRRecord(cmp,pref['state']['dcrId']);
            });
            /*When user tries to create dcr by clicking create button*/
          
        }
       
        
        cmp.set("v.selectedTargetRecordId",pref['state']['targetId']);
        console.log('$$$Received');
        
        console.log(pref['state']['targetId']);
        
        cmp.set("v.isLoading",true);
        helper.getConfiValues(cmp,function(ret){
            cmp.set("v.isLoading",false);
        });
        
        cmp.set("v.dcrDate",pref['state']['dateSelected']);
        var dcrDate=cmp.get("v.dcrDate");
        
        
        //var dcrDisplayDate=dcrDate.split(" ")[0];
        //cmp.set("v.dcrDisplayDate",dcrDisplayDate);
        
        
        
      
        
    },
    onSubmit:function(component,event,helper){
        
        component.set("v.dcrerror",[]);
        /*override submit,add required fields to the form*/
        event.preventDefault();
        
        var dcrerror=component.get("v.dcrerror");
        
        helper.validateForm(component,dcrerror);
        if(dcrerror.length>0){
            component.set("v.dcrerror",dcrerror);
            return;
        }

        component.set("v.isLoading",true);
        var fields = event.getParam("fields");
        fields["First_Half__c"] = component.get("v.firstHalf");
        fields["Second_Half__c"] = component.get("v.secondHalf");
        fields["Target__c"]=component.get("v.selectedTargetRecordId");
        fields['Day__c']=component.get("v.dcrDate");
        var form=component.find("dcrForm");
        form.submit(fields);
      
    },
    /*Navigate to Customer Creation/Editing Page*/
    customerBtnClicked:function(cmp,event,helper){
        
        helper.navigateToCustomerPage(cmp,event,cmp.get("v.dcrId"),cmp.get("v.selectedTargetRecordId"));
    },
    backToSearch:function(cmp,event,helper){
        var pageReference = {
            type: 'standard__navItemPage',
            attributes: {
                "apiName": "Daily_Call_Reporting"   
            },
           
        };
        
        cmp.set("v.pageReference", pageReference);
        
        var navService = cmp.find("navService");
       
        event.preventDefault();
        navService.navigate(pageReference);
    }
})