({
	
  
    calculateAnnualVolume:function(row,cmp){
        
        
        var annual_volumeFormula=this.getAnnualVolumeMTFormula(cmp);
        if(annual_volumeFormula!=null){
        row['annual_volume_mt']=math.eval(this.getExpression(annual_volumeFormula,row)).toFixed(2);
        }
        
        
    },
     calculateTotal:function(row,cmp){
        
         var totalFormula=this.getTotalFormula(cmp);
         if(totalFormula!=null){
             row['total']=math.eval(this.getExpression(totalFormula,row)).toFixed(2);
         }
        
      
	},
    calculateVolume:function(row,cmp){
      
        var volFormula=this.getVolumeFormula(cmp);
        if(volFormula!=null){
            row['volume']=math.eval(this.getExpression(volFormula,row)).toFixed(2);
        }
     
    },
    calculateContribution:function(row,cmp){
       
        var contributionFormula=this.getContributionFormula(cmp);
        if(contributionFormula!=null){
            row['contribution']=math.eval(this.getExpression(contributionFormula,row)).toFixed(2);
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
                row['value_mt']=rec['Value__c'];
                row['Is_Value_MT_CFE_lock']=rec['Is_Value_MT_CFE_locked__c'];
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
                  
                    if(rec['annual_volume_mt']!=null && rec['percent_of_share']!=null){
                        this.calculateVolume(rec,cmp);
                    }else{
                        rec['volume']=0;
                    }
                    //this.calculateVolume(rec,rec['annual_volume_mt'],rec['percent_of_share']);
                    if(rec['total']!=null && rec['percent_of_share']!=null){
                        this.calculateContribution(rec,cmp);
                    }else{
                        rec['contribution']=0;
                    }
                    // this.calculateContribution(rec,rec['total'],rec['percent_of_share']);
                    
                   
                    
                
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
                
            
                rec['value_mt']=recordList[index]['value_mt'];
                rec['annual_volume_mt']=recordList[index]['annual_volume_mt'];
                rec['product_function']=recordList[index]['product_function'];
                rec['pftype']=recordList[index]['pftype'];
                
                rec['cycles_yr']=recordList[index]['cycles_yr'];
                rec['animal_cycle']=recordList[index]['animal_cycle'];
                rec['kg_animal_cycle']=recordList[index]['kg_animal_cycle'];
                rec['total']=recordList[index]['total'];
                
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
     getVolumeFormula:function(cmp){
        var calcType=cmp.get("v.calcType");
        var species=cmp.get("v.species");
        var row=cmp.get("v.row");        
        var product_function=row['product_function'];
        var pftype=row['pftype'];
        var key=calcType+' - '+species+' - '+product_function+' - '+pftype;
        var formula_map=cmp.get("v.formulaMap");
        console.log('$$$'+key);
        if(formula_map[key]!=undefined && formula_map[key]!=null){
        return formula_map[key].volume_js__c;
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
     getAnnualVolumeMTFormula:function(cmp){
        var calcType=cmp.get("v.calcType");
        var species=cmp.get("v.species");
        var row=cmp.get("v.row");        
        var product_function=row['product_function'];
        var pftype=row['pftype'];
        var key=calcType+' - '+species+' - '+product_function+' - '+pftype;
        var formula_map=cmp.get("v.formulaMap");
        console.log('$$$'+key);
        if(formula_map[key]!=undefined && formula_map[key]!=null){
        return formula_map[key].Annual_Volume_mt_js__c;
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
    }
   
    
})