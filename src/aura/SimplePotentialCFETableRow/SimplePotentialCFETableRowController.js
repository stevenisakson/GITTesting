({
    /*Fires by table row for adding a new row*/
	fireAddCompetitor : function(cmp, event, helper) {
        
        var compEvent = cmp.getEvent("rowEvent");
      
        compEvent.setParam("rowID",cmp.get("v.index"))
        compEvent.fire();
	},
    /*Called when annualVolume or Value is changed*/
    annualcfeOrValueChanged:function(cmp,event,helper){

        
        if(cmp.get('v.row').product_function!='None' && cmp.get('v.row').pftype!='None'){
            
            
            var row=cmp.get("v.row");        
            
            
            var index=cmp.get("v.index");
            var recordList=cmp.get("v.recordList");
            if(row.annual_cfe!=null && row.cfe_incl!=null){
                helper.calculateAnnualVolume(cmp,row);
            }else{
                row["annual_volume"]=0;
            }
            /*Finds total*/
            if(row.annual_cfe!=null && row.value_cfe!=null){
                
                helper.calculateTotal(row,cmp);
                
            }else{
                row['total']=0;
            }
            if(row.annual_cfe!=null && row.percent_of_share!=null){
                
                helper.calculateAnnualCFE(row,cmp);
            }else{
                row['annual_cfe_con']=0;
            }
            if(row.total!=null && row.percent_of_share!=null){
                
                helper.calculateContribution(row,cmp);
            }else{
                row['contribution']=0;
            }
            cmp.set("v.row",row);
            /*Values of the Cargill record should be same as competitor record
            this method copies the values to competitor records*/
            helper.copyToCompetitor(cmp,recordList);
            /*Do the same calculation for competitor*/
            helper.calcCompetitor(cmp,recordList);
            /*recalculate the total value*/
            var compEvent = cmp.getEvent("recalculation");
            compEvent.fire();
        }
    },

    percent_of_shareChanged:function(cmp,event,helper){
        
        if(cmp.get('v.row').product_function!='None' && cmp.get('v.row').pftype!='None'){
            var index=cmp.get("v.index");
            
            var row=cmp.get("v.row");
            if(row.annual_cfe!=null && row.percent_of_share!=null){
                
                helper.calculateAnnualCFE(row,cmp);
            }else{
                row['annual_cfe_con']=0;
            }
            if(row.total!=null && row.percent_of_share!=null){
                
                helper.calculateContribution(row,cmp);
            }else{
                row['contribution']=0;
            }
            cmp.set("v.row",row);
            
            if(!cmp.get("v.row").isCompetitor){
                var compEvent = cmp.getEvent("recalculation");
                compEvent.fire();
            }
        }
       
    },
    /*POPUP for confirmation of delete*/
    removePotential:function(cmp,event,helper){
         $A.createComponent(
            "c:DeleteConfirmModal",
             {isOpen:'true',deleteRowID:cmp.get("v.index")
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
    totalChanged:function(cmp,event,helper){
      
        if(cmp.get('v.row').product_function!='None' && cmp.get('v.row').pftype!='None'){
            
            var recordList=cmp.get("v.recordList");
            
            
            var row=cmp.get("v.row");
            /*Override*/
            row['annual_cfe']=null;
            if(row.annual_cfe!=null && row.cfe_incl!=null){
                helper.calculateAnnualVolume(cmp,row);
            }else{
                row["annual_volume"]=0;
            }
            
            if(row.annual_cfe!=null && row.percent_of_share!=null){
                
                helper.calculateAnnualCFE(row,cmp);
            }else{
                row['annual_cfe_con']=0;
            }
            if(row.total!=null && row.percent_of_share!=null){
                
                helper.calculateContribution(row,cmp);
            }else{
                row['contribution']=0;
            }
            cmp.set("v.row",row);
            
            
            
            helper.copyToCompetitor(cmp,recordList);
            helper.calcCompetitor(cmp,recordList);
            var compEvent = cmp.getEvent("recalculation");
            compEvent.fire();
            
        }
       
    },
    productfunctionOrTypeChanged:function(cmp,event,helper){
      
        if(cmp.get('v.row').product_function!='None' && cmp.get('v.row').pftype!='None'){
          
           var recordList=cmp.get("v.recordList");
          	
            helper.prepopulate(cmp);
             var row=cmp.get("v.row");
            if(row.annual_cfe!=null && row.cfe_incl!=null){
                helper.calculateAnnualVolume(cmp,row);
            }
            /*Finds total*/
            if(row.annual_volume!=null && row.value_cfe!=null){
                
                helper.calculateTotal(row,cmp);
                
            }else{
                row['total']=0;
            }
            if(row.annual_cfe!=null && row.percent_of_share!=null){
                
                helper.calculateAnnualCFE(row,cmp);
            }else{
                row['annual_cfe_con']=0;
            }
            if(row.total!=null && row.percent_of_share!=null){
                
                helper.calculateContribution(row,cmp);
            }else{
                row['contribution']=0;
            }
            cmp.set("v.row",row);
           
            
            
            helper.copyToCompetitor(cmp,recordList);
            helper.calcCompetitor(cmp,recordList);
            var compEvent = cmp.getEvent("recalculation");
            compEvent.fire();
           
        }
    }    
})