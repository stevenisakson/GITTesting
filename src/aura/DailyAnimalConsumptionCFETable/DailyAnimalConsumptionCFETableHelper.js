({
	
	/*Method to total the values*/		
    totalAll:function(cmp,recordList){
        var totalannualvolume=0.0;
        var total=0.0;
        var totalcontribution=0.0;
        var totalvolume=0.0;
        
        for(var i=0;i<recordList.length;i++){
            if(recordList[i]['isCompetitor']==false){
                if(recordList[i]['annual_cfe']!=null){
                    totalannualvolume=totalannualvolume+ parseFloat(recordList[i]['annual_cfe']);
                }
                if(recordList[i]['total']!=null){
                  total=total+ parseFloat(recordList[i]['total']);  
                }
                if(recordList[i]['contribution']!=null){
                  totalcontribution=totalcontribution+ parseFloat(recordList[i]['contribution']);   
                }
                if(recordList[i]['annual_cfe_con']!=null){
                  totalvolume=totalvolume+ parseFloat(recordList[i]['annual_cfe_con']);     
                }
           
           
           
            }
        }
        cmp.set("v.totalannualvolume",Math.round(totalannualvolume));
        cmp.set("v.total",Math.round(total));
        cmp.set("v.totalcontribution",Math.round(totalcontribution));
        cmp.set("v.totalvolume",Math.round(totalvolume));
        
    }
            
   
})