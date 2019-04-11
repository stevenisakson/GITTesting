({
	calculateAnnualCFE:function(row,cmp){
        
        
        var annual_CFEFormula=this.getAnnualCFEFormula(cmp);
        if(annual_CFEFormula!=null){
        row['annual_cfe']=Math.round(math.eval(this.getExpression(annual_CFEFormula,row)));
        }
        
        
    },
   calculateAnnualVolume:function(row,cmp){
        
       var annual_volumeFormula=this.getAnnualVolumeFormula(cmp);
       if(annual_volumeFormula!=null){
           row['annual_volume']=Math.round(math.eval(this.getExpression(annual_volumeFormula,row)));
       }
        
        
    },
    
    calculateAnnualCFECon: function(row,cmp){
        
        
        var annual_CFEConFormula=this.getAnnualCFEConFormula(cmp);
        if(annual_CFEConFormula!=null){
        row['annual_cfe_con']=Math.round(math.eval(this.getExpression(annual_CFEConFormula,row)));
        }
        
        
    },
     calculateTotal:function(row,cmp){
        
         var totalFormula=this.getTotalFormula(cmp);
         if(totalFormula!=null){
             row['total']=Math.round(math.eval(this.getExpression(totalFormula,row)));
         }
        
      
	},
  
    calculateContribution:function(row,cmp){
       
        var contributionFormula=this.getContributionFormula(cmp);
        if(contributionFormula!=null){
            row['contribution']=Math.round(math.eval(this.getExpression(contributionFormula,row)));
        }
        
        
	},
    prepopulate:function(cmp){
	
        var autoPopList=cmp.get("v.autoPopValues");
        var calcType=cmp.get("v.calcType");
        var species=cmp.get("v.species");
        var product_function=cmp.get("v.row").product_function;
        var pftype=cmp.get("v.row").pftype;
        var row=cmp.get("v.row");
        for(var i=0;i<autoPopList.length;i++){
            var rec=autoPopList[i];
            if(rec['TypeOfCalculation__c']==calcType && rec['Species__c']==species && rec['Product_Function__c']==product_function &&  rec['Type__c']==pftype)
            {
                row['value_cfe']=rec['Value__c'];
                row['cfe_incl']=rec['inclusion_per_CFE__c'];
                row['Is_Value_MT_CFE_lock']=rec['Is_Value_MT_CFE_locked__c'];
                row['Is_CFE_Incl_lock']=rec['Is_CFE_Incl_locked__c'];
                break;
            }
        }
        cmp.set("v.row",row);
        console.log(cmp.get("v.calcType")+'--'+cmp.get("v.species"));
    },
    calcCompetitor:function(cmp,recordList){
        if(!cmp.get("v.row").isCompetitor){
          
           
            var index=cmp.get("v.index");
            var flag=0;
            console.log(index);
            for(var i=0;i<recordList.length;i++){
                var rec=recordList[i];
                if(rec.isCompetitor && rec['parentRowID']==index){
                  console.log('in');
                  flag=1;
                  
                    if(rec['annual_volume']!=null && rec['percent_of_share']!=null){
                        this.calculateAnnualCFECon(rec,cmp);
                    }else{
                        rec['annual_cfe_con']=0;
                    }
                    //this.calculateVolume(rec,rec['annual_volume_mt'],rec['percent_of_share']);
                    if(rec['total']!=null && rec['percent_of_share']!=null){
                        this.calculateContribution(rec,cmp);
                    }else{
                        rec['contribution']=0;
                    }
                    
                }
            }
         
            if(flag==1){
          
                cmp.set("v.recordList",recordList);
              
            }
      
        }
    },
    copyToCompetitor:function(cmp,recordList){
        var index=cmp.get("v.index");
        for(var i=0;i<recordList.length;i++){
            var rec=recordList[i];
           
            if(rec.isCompetitor && rec['parentRowID']==index){
                
            
                rec['value_cfe']=recordList[index]['value_cfe'];
                rec['annual_cfe']=recordList[index]['annual_cfe'];
                rec['cfe_incl']=recordList[index]['cfe_incl'];
                rec['product_function']=recordList[index]['product_function'];
                rec['pftype']=recordList[index]['pftype'];
                
                rec['annual_volume']=recordList[index]['annual_volume'];
                rec['Animals_yr']=recordList[index]['Animals_yr'];
                rec['kg_hd_day']=recordList[index]['kg_hd_day'];
                rec['Days_Fed_yr']=recordList[index]['Days_Fed_yr'];
                rec['total']=recordList[index]['total'];
                
             
                console.log(rec);
            }
        }
    },
    getTotalFormula:function(cmp){
        var calcType=cmp.get("v.calcType");
        var species=cmp.get("v.species");
        var row=cmp.get("v.row");        
        var product_function=row['product_function'];
        var pftype=row['pftype'];
        var key=calcType+' - '+species+' - '+product_function+' - '+pftype;
        var formula_map=cmp.get("v.formulaMap");
        console.log('$$$'+key);
        if(formula_map[key]!=undefined && formula_map[key]!=null){
            return formula_map[key].Total_js__c;
        }else{
            return null;
        }
    },
   
     getContributionFormula:function(cmp){
         var calcType=cmp.get("v.calcType");
         var species=cmp.get("v.species");
         var row=cmp.get("v.row");        
         var product_function=row['product_function'];
         var pftype=row['pftype'];
         var key=calcType+' - '+species+' - '+product_function+' - '+pftype;
         var formula_map=cmp.get("v.formulaMap");
         console.log('$$$'+key);
         if(formula_map[key]!=undefined && formula_map[key]!=null){
             return formula_map[key].Contribution_js__c;
         }else{
             return null;
         }
    },
    getAnnualVolumeFormula:function(cmp){
        var calcType=cmp.get("v.calcType");
        var species=cmp.get("v.species");
        var row=cmp.get("v.row");        
        var product_function=row['product_function'];
        var pftype=row['pftype'];
        var key=calcType+' - '+species+' - '+product_function+' - '+pftype;
        var formula_map=cmp.get("v.formulaMap");
        console.log('$$$'+key);
        if(formula_map[key]!=undefined && formula_map[key]!=null){
        return formula_map[key].Annual_Volume_js__c;
        }else{
            return null;
        }
    },
    getExpression:function(formula,row){
        var array=formula.split(" ");
        var expBuild='';
        for(var i=0;i<array.length;i++){
            if(row[array[i]]!=undefined && (!isNaN(row[array[i]]))){
                expBuild+=row[array[i]];
                //console.log('$$$-'+array[i]);
            }else{
                expBuild+=array[i];
            }
        }
        return expBuild;
    },

    getAnnualCFEFormula:function(cmp){
  		var calcType=cmp.get("v.calcType");
        var species=cmp.get("v.species");
        var row=cmp.get("v.row");        
        var product_function=row['product_function'];
        var pftype=row['pftype'];
        var key=calcType+' - '+species+' - '+product_function+' - '+pftype;
        var formula_map=cmp.get("v.formulaMap");
        console.log('$$$'+key);
        if(formula_map[key]!=undefined && formula_map[key]!=null){
        return formula_map[key].Annual_CFE_js__c;
        }else{
            return null;
        }
    },
    
    getAnnualCFEConFormula:function(cmp){
  		var calcType=cmp.get("v.calcType");
        var species=cmp.get("v.species");
        var row=cmp.get("v.row");        
        var product_function=row['product_function'];
        var pftype=row['pftype'];
        var key=calcType+' - '+species+' - '+product_function+' - '+pftype;
        var formula_map=cmp.get("v.formulaMap");
        console.log('$$$'+key);
        if(formula_map[key]!=undefined && formula_map[key]!=null){
        return formula_map[key].Annual_CFE_CON_js__c;
        }else{
            return null;
        }
    },
   
    
})