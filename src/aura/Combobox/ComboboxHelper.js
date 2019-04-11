({
    /*Fetch Accounts that user has access with competitor record type*/
    getCompetitorList : function(cmp,searchkeyword) {
        var action=cmp.get("c.getCompetitors");
        action.setParams({'searchkeyword':searchkeyword});
        action.setCallback(this,function(resp)
                           {
                               cmp.set("v.isOpen",true);
                               var re=resp.getReturnValue();
                               var state=resp.getState();
                               cmp.set("v.isLoading",false);
                               if(state==='SUCCESS'){
                                   if(re.isSuccess){
                                       if(re.data){
                                           re.data.unshift({Name:'Unknown'}); 
                                       }
                                       cmp.set("v.resultList",re.data);
                                     
                                   }
                               }
                               console.log(re);
                           });
        $A.enqueueAction(action);
        cmp.set("v.isLoading",true);
    },
    /*Fetch all the contacts of the given Account*/
     getSalesPersonList : function(cmp,searchkeyword,accName) {
        var action=cmp.get("c.getSalesPersons");
         action.setParams({'accName':accName,'searchkeyword':searchkeyword});
        action.setCallback(this,function(resp)
                           {
                               cmp.set("v.isOpen",true);
                               var re=resp.getReturnValue();
                               var state=resp.getState();
                               cmp.set("v.isLoading",false);
                               if(state==='SUCCESS'){
                                   if(re.isSuccess){
                                       if(re.data){
                                           re.data.unshift({Name:'Unknown'}); 
                                       }
                                       cmp.set("v.resultList",re.data);
                                     
                                   }
                               }
                               console.log(re);
                           });
        $A.enqueueAction(action);
        cmp.set("v.isLoading",true);
    }
})