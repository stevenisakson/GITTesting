({
    doInitAction :function(component, event, helper){
        //console.log('calling');
       
        var action = component.get("c.getcreateRecord");
       // console.log(action);
       // console.log('calling1');
      //  alert(action);
  	//	var sPageURL = decodeURIComponent(window.location);
       // alert(sPageURL);
        action.setParams({"accountID": component.get("v.recordId")}); 
      //   console.log('calling2');
         
        action.setCallback(this,function(response){
            var state = response.getState();
        //    console.log(state);
          
            
            if(state === "SUCCESS"){
              //  console.log('success');
                var val = response.getReturnValue();
              //  console.log(val);
                //alert(val);
            //    console.log(val.Prospect_Validated__c);
               // component.set("v.checkbox",val.Prospect_Validated__c);
                component.set("v.request",response.getReturnValue());
                // $A.get('e.force:refreshView').fire();
               // requesst
                //  window.location = 'https://cargill18--preprod.cs26.my.salesforce.com/'+component.get("v.recordId") ;
                 //component.set("");
               // Component.destroy();
              //  console.log('end');
                              
                 window.setTimeout(
                    $A.getCallback(function() {
                        $A.get('e.force:refreshView').fire();
                    }), 3000
                );
                
            }
            else if(state === "ERROR"){
                 // var val = response.getReturnValue();
            //    alert('hello error');
               //  component.set("v.checkbox",'false');
            }
            
        });
        
         $A.enqueueAction(action);
    },
    closeModel : function(component, event, helper) {
		//component.set("v.isOpen", false);
		   // component.destroy();
		    $A.get("e.force:closeQuickAction").fire();
	}
    
   })