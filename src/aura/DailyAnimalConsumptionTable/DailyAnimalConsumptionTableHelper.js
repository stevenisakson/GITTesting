({
	
	/*Method to total the values*/		
    totalAll:function(cmp,recordList){
        var totalannualvolume=0.0;
        var total=0.0;
        var totalcontribution=0.0;
        var totalvolume=0.0;
        
        for(var i=0;i<recordList.length;i++){
            if(recordList[i]['isCompetitor']==false){
                if(recordList[i]['annual_volume_mt']!=null){
                    totalannualvolume=totalannualvolume+ parseFloat(recordList[i]['annual_volume_mt']);
                }
                if(recordList[i]['total']!=null){
                  total=total+ parseFloat(recordList[i]['total']);  
                }
                if(recordList[i]['contribution']!=null){
                  totalcontribution=totalcontribution+ parseFloat(recordList[i]['contribution']);   
                }
                if(recordList[i]['volume']!=null){
                  totalvolume=totalvolume+ parseFloat(recordList[i]['volume']);     
                }
           
           
           
            }
        }
        cmp.set("v.totalannualvolume",totalannualvolume.toFixed(2));
        cmp.set("v.total",total.toFixed(2));
        cmp.set("v.totalcontribution",totalcontribution.toFixed(2));
        cmp.set("v.totalvolume",totalvolume.toFixed(2));
        
    }
            
   
})