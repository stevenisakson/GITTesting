({
    doInit:function(cmp,event,helper){
        /*Set the values passed from the previous page*/
        console.log(cmp.get("v.pageReference"));
        var visitRef=cmp.get("v.pageReference");/*Object that contains the data from previous page*/
        console.log('receive');
        console.log(visitRef['state']);
        
        if(visitRef['state'].isDcrComplete!=undefined && visitRef['state'].isDcrComplete==true
          && visitRef['state'].isDcrLocked!=undefined && visitRef['state'].isDcrLocked==true){
            cmp.set("v.mode","View");/*Set as Readonly*/
        }
        
        if(visitRef['state'].dcrCustId!=undefined && visitRef['state'].dcrCustId!=null){
            cmp.set("v.custId",visitRef['state'].dcrCustId);
            helper.getConfiValues(cmp,function(ret){
              helper.fetchDCRCustomer(cmp,visitRef['state'].dcrCustId);   
            })
           
        }else{
            cmp.set("v.custId",null);
        }
        if(visitRef['state'].dcrId!=undefined && visitRef['state'].dcrId!=null){
            cmp.set("v.dcrId",visitRef['state'].dcrId);
        }else{
             cmp.set("v.dcrId",null);
        }
        
        if(visitRef['state'].selectedCust!=undefined){
            cmp.set("v.selectedRouteCustomer",visitRef['state'].selectedCust);
        }
        if(visitRef['state'].selectedRoute!=undefined){
            cmp.set("v.selectedRoute",visitRef['state'].selectedRoute);
        }
        if(visitRef['state']['dcrId']!=undefined && visitRef['state']['targetId']!=undefined){
            console.log('$$$Received');
            console.log(visitRef['targetId']);
            cmp.set("v.selectedTargetRecordId",visitRef['state']['targetId']);
            cmp.set("v.dcrId",visitRef['state'].dcrId);
            
           
        }
        if(visitRef['state']['btnAction']=='create'){
            helper.getConfiValues(cmp,function(ret){});
        }
     
        
    },
     onload:function(cmp,event,helper){
        
        /*Called during recordEditForm creation*/
        var recUi = event.getParam("recordUi");
      
         /*Set the Contact Name when dcr customer record is edited*/
         if(recUi.record.fields['Contact_Text__c']!=undefined){
             console.log(recUi.record.fields['Contact_Text__c']);
             cmp.set("v.selectedContactName",recUi.record.fields['Contact_Text__c'].value
                    );
             if(cmp.find("contactField")!=undefined){
                 cmp.find("contactField").setSearchKeyword();
             }
             
         }
        
        
    },
    
    saveBtnClick:function(cmp,event,helper){
        /*Saves the Form Date*/
        console.log('btnClick');
        helper.clearError(cmp);
        event.preventDefault();
        var fields = event.getParam("fields");
        console.log(fields);
        if(cmp.get("v.dcrId")!=null && cmp.get("v.dcrId")!=undefined){
            fields["DCR_Day__c"] = cmp.get("v.dcrId");
            fields['Route__c']=cmp.get("v.selectedRoute.Id");
            fields['Account__c']=cmp.get("v.selectedRouteCustomer.Id");
            fields['Contact_Text__c']=cmp.get("v.selectedContactName");
            fields['LOB__c']=cmp.get("v.lob");
           
           	fields['Accompanied_By__c']=cmp.get("v.accompaniedby");
            
            
            fields['Brand_Reminder1__c']=cmp.get("v.brandReminder1");
            fields['Brand_Reminder2__c']=cmp.get("v.brandReminder2");
            fields['Brand_Reminder3__c']=cmp.get("v.brandReminder3");
            fields['Brand_Reminder4__c']=cmp.get("v.brandReminder4");
            fields['Brand_Reminder5__c']=cmp.get("v.brandReminder5");
            
            fields['Product1__c']=cmp.get("v.ProductDiscussed1");
            fields['Product2__c']=cmp.get("v.ProductDiscussed2");
            fields['Product3__c']=cmp.get("v.ProductDiscussed3");
            fields['Product4__c']=cmp.get("v.ProductDiscussed4");
            fields['Product5__c']=cmp.get("v.ProductDiscussed5");
            
            fields['Product_Details1__c']=cmp.get("v.ProductSample1");
            fields['Product_Details2__c']=cmp.get("v.ProductSample2");
            fields['Product_Details3__c']=cmp.get("v.ProductSample3");
            fields['Product_Details4__c']=cmp.get("v.ProductSample4");
            fields['Product_Details5__c']=cmp.get("v.ProductSample5");
            
            cmp.find("dcrCustform").submit(fields);
            cmp.set("v.isLoading",true);
            
            
        }
            
        
        
    },
    onSuccess:function(cmp, event, helper){
        
        cmp.set("v.isLoading",false);
       // helper.navigateToCustomerSearch(component,event,{"action":"back"});
        if(cmp.get("v.custId")!=undefined){
            helper.showUpdateToast();
            helper.navigateToDCRForm(cmp,event,{"action":"back","dcrId":cmp.get("v.dcrId"),"targetId":cmp.get("v.selectedTargetRecordId")});
        }else{
            helper.showCreatedToast();
            helper.navigateToDCRForm(cmp,event,{"action":"back","dcrId":cmp.get("v.dcrId"),"targetId":cmp.get("v.selectedTargetRecordId")});
        }
    },
    onError : function(component, event, helper) {
        /*Read the Form Errors and Displays on the Page*/
        component.set("v.isLoading",false);
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
        
    },
    cancelBtnClick:function(cmp,event,helper){
        helper.clearError(cmp);
        /*Navigate to Previous Screen*/
         helper.navigateToDCRForm(cmp,event,{"action":"back","dcrId":cmp.get("v.dcrId"),"targetId":cmp.get("v.selectedTargetRecordId")});
        
    }
   
    	

})