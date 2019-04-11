({
	fireAddCompetitor : function(cmp, event, helper) {
        var compEvent = cmp.getEvent("rowEvent");
      
        compEvent.setParam("rowID",cmp.get("v.index"))
        compEvent.fire();
	},
    annualcfeOrValueChanged:function(cmp,event,helper){
     
        if(cmp.get('v.row').product_function!='None' && cmp.get('v.row').pftype!='None'){
            var row=cmp.get("v.row");
            var recordList=cmp.get("v.recordList");
            
            
            
            if(row.cycles_yr!=null && row.animal_cycle!=null && row.cfe_kg_animal_cycle!=null){
                helper.calculateAnnualCFE(row,cmp);
                
            }else{
                  row['annual_cfe']=0;
            }
            if(row.annual_cfe!=null && row.cfe_incl!=null){
                helper.calculateAnnualVolume(row,cmp);
                
            }else{
                row['annual_volume']=0;
            }
                
            if(row.annual_volume!=null && row.value_cfe!=null){
                
                helper.calculateTotal(row,cmp);
            }else{
                row['total']=0;
            }
            if(row.annual_cfe!=null && row.percent_of_share!=null){
                helper.calculateAnnualCFECon(row,cmp);
                
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

    percent_of_shareChanged:function(cmp,event,helper){
      
        if(cmp.get('v.row').product_function!='None' && cmp.get('v.row').pftype!='None'){
            var row=cmp.get("v.row");
            
            if(row.annual_cfe!=null && row.percent_of_share!=null){
                helper.calculateAnnualCFECon(row,cmp);
                
            }else{
                row['annual_cfe_con']=0;
            }
            console.log(row.total+'--'+row.percent_of_share);
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
          /* var compEvent = cmp.getEvent("deleterow");
           compEvent.setParam("rowID",cmp.get("v.index"));
           compEvent.fire();*/
    },
   
    productfunctionOrTypeChanged:function(cmp,event,helper){
      
        if(cmp.get('v.row').product_function!='None' && cmp.get('v.row').pftype!='None'){
            
            helper.prepopulate(cmp);
            var recordList=cmp.get("v.recordList");
            var row=cmp.get("v.row");
                       if(row.cycles_yr!=null && row.animal_cycle!=null && row.cfe_kg_animal_cycle!=null){
                helper.calculateAnnualCFE(row,cmp);
                
            }else{
                  row['annual_cfe']=0;
            }
            if(row.annual_cfe!=null && row.cfe_incl!=null){
                helper.calculateAnnualVolume(row,cmp);
                
            }else{
                row['annual_volume']=0;
            }
                
            if(row.annual_volume!=null && row.value_cfe!=null){
                
                helper.calculateTotal(row,cmp);
            }else{
                row['total']=0;
            }
            if(row.annual_cfe!=null && row.percent_of_share!=null){
                helper.calculateAnnualCFECon(row,cmp);
                
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