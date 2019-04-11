({
    doInit:function(cmp, event, helper) {
        var rec=cmp.get("v.dcrcustomer");
        if(rec['isNew']){
            /*if it is new record default as Edit mode*/
            cmp.set("v.mode",'Edit');
            
        }
        if(rec.Id!=undefined){
            /*if existing record,show in View mode*/
            cmp.set("v.mode",'View');
            
        }
    },
    onload:function(cmp,event,helper){
        
        /*Prepoulate the Values when the UI is being loaded. For Account Lookup,Route Lookup 
        and Contact Field*/
        var recUi = event.getParam("recordUi");
        console.log('onload recordUI');
      
            if(recUi.record.fields['Account__r']!=undefined && recUi.record.fields['Account__r']['value']!=null){
                cmp.set("v.selectedRouteCustomer",{Name:recUi.record.fields['Account__r'].displayValue,
                                                   Id:recUi.record.fields['Account__r']['value'].id})
                
            }
            if(recUi.record.fields['Route__r']!=undefined && recUi.record.fields['Route__r']['value']!=null){
                cmp.set("v.selectedRoute",{Name:recUi.record.fields['Route__r'].displayValue,
                                           Id:recUi.record.fields['Route__r']['value'].id})
                
            }
            if(recUi.record.fields['Contact_Text__c']!=undefined){
                console.log(recUi.record.fields['Contact_Text__c']);
                cmp.set("v.selectedContactName",recUi.record.fields['Contact_Text__c'].value
                       );
                
            
        }
        /*Find how many brand reminder for each Visit Detail are added. This is to show the brand reminder row*/
        var count=0;
        if(cmp.get("v.state")=='init'){
            console.log('Init');
         
            if(recUi.record.fields["Brand_Reminder1__c"].value!=undefined){
                count=1; 
            }
            if(recUi.record.fields["Brand_Reminder2__c"].value!=undefined){
                count=2;
            }
            if(recUi.record.fields["Brand_Reminder3__c"].value!=undefined){
                count=3; 
            }
            if(recUi.record.fields["Brand_Reminder4__c"].value!=undefined){
                count=4; 
            }
            if(recUi.record.fields["Brand_Reminder5__c"].value!=undefined){
                count=5; 
            }
            
            cmp.set("v.Count",count);
            cmp.set("v.Details",false);/*Set Brand Reminder hidden by default*/
            
            
        }
        
        
    },
    edit:function(cmp, event, helper) {
        var mode=cmp.get("v.mode");
        if(mode=='View'){
            cmp.set("v.mode",'Edit');/*When the mode changes onload function will be called*/
            cmp.set("v.state",'loaded');/*to Avoid recursive execution of  onload function*/
            cmp.set("v.Details",true);/*To show the brand reminder details */
        
           
        }
    },
    /*Cancel is deleting the newly added row*/
    cancel:function(cmp,event,helper){
        
        var recList=cmp.get("v.dcrcustlist");
        var mode=cmp.get("v.mode");
        var rec=cmp.get("v.dcrcustomer");
        var index=cmp.get("v.index"); 
        cmp.set("v.Details",false);
        console.log(mode);
        console.log(rec['isNew']);
        if(mode=='Edit'){
            if(rec['isNew']){
                recList.splice(index,1);
                cmp.set("v.dcrcustlist",recList);
             
            }else{  
                cmp.set("v.mode",'View');
              
            }
        }
      
    },
    /*Unhide the brandreminder details*/
    Details :function(cmp,event,helper){
        
        /*To Show the */        
        var mode=cmp.get("v.mode");
        if(mode=='View'){
            cmp.set("v.state",'loaded');
           
            cmp.set("v.Details",true);
        }
    },
    /*Hide brand Reminder the Data*/
    HideDetails:function(cmp,event,helper){
        var mode=cmp.get("v.mode");
        if(mode=='View'){
           
            cmp.set("v.state",'loaded');
            cmp.set("v.Details",false);
        }
    },
    /*Adding a new row. By Increasing the count a new row will be unhidden*/
    addBrandReminder:function(cmp,event,helper){
        console.log(cmp.get("v.Count"));
        var c1= cmp.get("v.Count");
        if(c1<5){
        c1++;
        cmp.set("v.Count",c1);
        cmp.set("v.state",'loaded');
        cmp.set("v.Details",true);
        }
        
    },
   
   
    /*hide product remainder row when delete button is clicked*/
    hiderow:function(cmp,event,helper){
        console.log(cmp.get("v.Count"));
        
        var btn=event.getSource();
        var btnIndex=parseInt(btn.get("v.name"));
        /*When delete button is clicked shift the whole row into beginning. Then 
        hide the last row*/
        if(btnIndex>1 && btnIndex!=5){
            for(var i=btnIndex;i<5;i++){
                
                cmp.set("v.productInput"+(i),cmp.get("v.productInput"+(i+1)));
             
                cmp.set("v.productQuantity"+(i),cmp.get("v.productQuantity"+(i+1)));
               
                cmp.set("v.productDetail"+(i),cmp.get("v.productDetail"+(i+1)));
                
              
                cmp.set("v.brandReminderQuant"+(i),cmp.get("v.brandReminderQuant"+(i+1)));
              
                cmp.set("v.brandReminder"+(i),cmp.get("v.brandReminder"+(i+1)));
              
            }
            
        }
        
        
        
        
        var c1= cmp.get("v.Count");
        console.log(c1);
        /*clear the date of the row which is hidden*/
        cmp.set("v.productInput"+c1,"");
        cmp.set("v.productQuantity"+c1,null);
        cmp.set("v.productDetail"+c1,"");
        cmp.set("v.brandReminderQuant"+c1,null);
        cmp.set("v.brandReminder"+c1,"");
        
        c1=c1-1;/*decrement the count to hide the last date*/
        cmp.set("v.Count",c1);
     
        
    },
    /*Submit the Form to Save*/
    onSubmit:function(cmp,event,helper){
        cmp.set("v.dcrerrors",[]);
        console.log(event.getSource().get("v.value"));
        event.preventDefault();
        var fields = event.getParam("fields");
        fields["DCR_Day__c"] = cmp.get("v.Dcrdayid");
        fields['Route__c']=cmp.get("v.selectedRoute.Id");
        fields['Account__c']=cmp.get("v.selectedRouteCustomer.Id");
        fields['Contact_Text__c']=cmp.get("v.selectedContactName");
        console.log(JSON.stringify(fields));
        var count=cmp.get("v.Count");
        /*Clear the hidden row values*/
        for(var i=count+1;i<=5;i++){
            
            fields["Product"+i+"__c"]="";
            fields["Product_Details"+i+"__c"]="";
            fields["Product_Quantity"+i+"__c"]=null;
            
            fields["Brand_Reminder"+i+"__c"]="";
            fields["Brand_Reminder"+i+"_Quantity__c"]=null;
          
            
        }
        cmp.set("v.state",'init');
        cmp.find("dcrform").submit(fields);
    },
    
    onSuccess:function(component, event, helper){
        
        var toastEvent = $A.get("e.force:showToast");
        
        if(component.get("v.dcrcustomer.Id")!=undefined){
            helper.showUpdateToast();
        }else{
            helper.showCreatedToast();
        }
        
        var mode=component.get("v.mode");
        if(mode=='Edit'){
            component.set("v.mode",'View');
         
            component.set("v.Details",true);
        }
        var nav=component.getEvent("dcrEvent");
        nav.fire();
        
        
        
    },
    onError : function(component, event, helper) {
        
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
    
    deleteRec:function(cmp,event,helper){
        var recId=cmp.get("v.dcrcustomer.Id");
        console.log(recId);
        helper.deleteDcrCustomer(cmp,event,helper);

    },
    /*clear the data when route is deleted*/
    routeChanged:function(cmp,event,helper){
        
        if(cmp.get("v.selectedRoute.Id")==undefined || cmp.get("v.selectedRoute.Id")==null){
            cmp.set("v.selectedRouteCustomer",null);
           
            
        }
    },
    /*clear the data when Account is deleted*/
    accountChanged:function(cmp,event,helper){
        if(cmp.get("v.selectedRouteCustomer.Id")==undefined || cmp.get("v.selectedRouteCustomer.Id")==null){
            var contactCombo=cmp.find("contactCombo");
            contactCombo.clearSearch();
        }
    }
    
})