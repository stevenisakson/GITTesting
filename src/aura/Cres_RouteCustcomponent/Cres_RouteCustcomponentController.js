({
	doInit:function(cmp, event, helper) {
      
       helper.getroutecustomers(cmp,event,helper);
       helper.getroute(cmp,event,helper);
    },
    Adddcrcust:function(cmp,event,helper){
        
          var drcCust=cmp.get("v.routecustomerlist");
          drcCust.unshift({isNew:true});
          cmp.set("v.routecustomerlist",drcCust);
     
    },
    refresh:function(cmp, event, helper) {
       helper.getroutecustomers(cmp,event,helper);
       helper.getroute(cmp,event,helper);
    },
})