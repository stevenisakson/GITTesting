({
    
   
    /*Helper method to fetch all the Master Potential Records from Database*/
	getPotentialEstList:function(cmp,calcCategory){
        var action=cmp.get("c.getPotentialEstList");
        action.setCallback(this,function(resp)
                           {
                               var state = resp.getState();
                               console.log(resp.getReturnValue());
                               cmp.set("v.isLoading",false);
                               if (state === "SUCCESS") {
                                   
                                   console.log(resp.getReturnValue());
                                   cmp.set("v.estList",resp.getReturnValue().data)
                               }
                           }
                          );
        action.setParams({accId:cmp.get("v.recordId"),"calcCategory":calcCategory});
        $A.enqueueAction(action);
    },
     /*Helper method to delete Master Potential Records from Database*/
    deleteRecord : function(cmp,recordId) {
     
        var action = cmp.get("c.deleteRecord");
        action.setParams({Id:recordId});
        action.setCallback(this, function(response) {
              console.log(response.getReturnValue());
            if (response.getState() === "SUCCESS") {
                this.showDeleteToast(cmp,event);
                if(response.getReturnValue().isSuccess){
                    /*Refresh the Account Record Page to refresh Account Share of wallet */
                    $A.get('e.force:refreshView').fire();
                    this.getPotentialEstList(cmp);
                    cmp.set("v.isLoading",false);
                }
               
            } else {
               
            }
        });
        $A.enqueueAction(action);
       
	},
    showDeleteToast : function(component, event) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "type":"success",
            "title": $A.get("$Label.c.POT_SUCCESS"),
            "message":$A.get("$Label.c.POT_SUCCESS_DELETE")
        });
        toastEvent.fire();
    },
   
    /*Helper method to know if the account is locked or not*/
     getAccountStatus:function(cmp,accId){
        var action=cmp.get("c.isAccountLocked");
        action.setParams({'accId':accId});
        action.setCallback(this,function(resp)
                           {
                               var state = resp.getState();
                               console.log(resp.getReturnValue());
                                
                               if (state === "SUCCESS") {
                                   
                                   console.log(resp.getReturnValue());
                                   cmp.set("v.isAccountLocked",resp.getReturnValue().data)
                                 
                               }
                           }
                          );
      
        $A.enqueueAction(action);
    },
   
    
    
})