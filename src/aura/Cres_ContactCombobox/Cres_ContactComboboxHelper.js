({
  
   
    /*Fetch all the contacts of the given Account*/
     getContactList : function(cmp,searchkeyword,accId) {
        var action=cmp.get("c.fetchContactList");
        action.setParams({'accId':accId,'searchkeyword':searchkeyword});
        action.setCallback(this,function(resp)
                           {
                               cmp.set("v.isOpen",true);
                               var re=resp.getReturnValue();
                               var state=resp.getState();
                               cmp.set("v.isLoading",false);
                               if(state==='SUCCESS'){
                                  
                                       cmp.set("v.resultList",re);
                                     
                                   
                               }
                               console.log(re);
                           });
        $A.enqueueAction(action);
        cmp.set("v.isLoading",true);
    }
})