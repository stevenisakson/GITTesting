({
   
    /*Adding competitor record into the List if the user click + button*/
    addCompetitor:function(cmp,event,helper){
        
        var insertIndx=-1;
        var rowID=event.getParam("rowID");
       /*Finds the position for inserting the row at proper index position*/
        var arr=cmp.get("v.recordList");
        for(var i=(rowID+1);i<arr.length;i++){
            if(!arr[i]['isCompetitor']){
                insertIndx=i;
                break;
            }
        }
        console.log(insertIndx);
        var clone={};
       
        /*Copies some essential field values from Cargill record*/
        clone['product_function']=arr[rowID]['product_function'];
        clone['pftype']=arr[rowID]['pftype'];
        clone['parentRowID']=rowID;
        clone['isNew']=true;//indicate if the record is new or old
        clone['isCompetitor']=true;//indicates competitor record
        clone['competitor']='';
        clone['value_cfe']=arr[rowID]['value_cfe'];
        
        clone['cfe_incl']=arr[rowID]['cfe_incl'];
        clone['annual_cfe']=arr[rowID]['annual_cfe'];
        
        
        clone['annual_volume']=arr[rowID]['annual_volume'];
        clone['total']=arr[rowID]['total'];
        
       
        clone['cycles_yr']=arr[rowID]['cycles_yr'];
        clone['animal_cycle']=arr[rowID]['animal_cycle'];
        clone['cfe_kg_animal_cycle']=arr[rowID]['cfe_kg_animal_cycle'];
        
        
        console.log('$$clone'+clone);
        if(insertIndx!=-1){
            arr.splice(insertIndx,0,clone);
        }else{
            arr.push(clone);
        }
        
        /*Solves Array Jumbling Lightning issue in UI*/
        var cloneList=[];
        
        for(var i=0;i<arr.length;i++){
            var temp={};
            for(var j in arr[i]){
                temp[j]=arr[i][j];
                
            }
            cloneList.push(temp);
        }
        
      
        cmp.set("v.recordList",cloneList);
    },
    /*Totaling the values such as annualvolume,total,contribution,volume*/
    findtotal:function(cmp,event,helper){
        helper.totalAll(cmp,cmp.get("v.recordList"));
    }
  
    
})