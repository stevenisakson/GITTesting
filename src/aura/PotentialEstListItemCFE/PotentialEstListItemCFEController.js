({
    /*Fires a Edit Event to the parent for editing the potential record*/
	editpotential : function(cmp, event, helper) {
		var event = cmp.getEvent("potential_edit");
       /*pass the paramters for editing the selected potentials. Record Id and Calculation Type and Species to be edited*/
        event.setParam('rowID',cmp.get("v.est_item").master_pot_id);
        event.setParam('data',{calcType:cmp.get("v.est_item").calcType,species:cmp.get("v.est_item").species});
        event.fire();
	},
    /*Show delete confirmation pop up when user clicks delete button*/
    deletepotential:function(cmp){
        
        $A.createComponent(
            "c:DeleteConfirmModal",
            {isOpen:'true',deleteRowID:cmp.get("v.index")
            },
            function(newCmp, status, errorMessage){
                //Add the new button to the body array
                if (status === "SUCCESS") {
                    var body = cmp.get("v.body");
                    body.push(newCmp);
                    cmp.set("v.body", body);
                }
                else if (status === "INCOMPLETE") {
                    console.log("No response from server or client is offline.")
                    // Show offline error
                }
                else if (status === "ERROR") {
                    console.log("Error: " + errorMessage);
                    // Show error message
                }
            }
        );
    }
})