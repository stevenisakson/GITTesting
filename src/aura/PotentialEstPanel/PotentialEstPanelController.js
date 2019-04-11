({
	doInit : function(component, event, helper) {
        /*Load the Potential Access(Potential Category) that user has such as Volume,CFE*/
        helper.loadCalcCategories(component,function(resp){
            
            var state = resp.getState();
            if (state === "SUCCESS") {
               
                console.log(resp.getReturnValue());
                if(resp.getReturnValue().data && resp.getReturnValue().data.length>0){
                    var result=resp.getReturnValue().data;
                    console.log(result);
                    /*Set the list to dropdown*/
                    component.set("v.calcCategoryList",result);
                    /*Choose the first item from the list and make it default */
                    component.set("v.calcCategory",result[0].value);
                    
                    /*Get the component by its id, id of the component and category name is same*/
                    var estList=component.find(result[0].value);
                    /*Load Master potential of the first item*/
                    estList.loadMasterPotential();
                }
                
            }
          
        });
         
	},
    
    viewChange:function(cmp,event,helper){
      
        /*when the user changes the selection from the drop down*/
        var category=cmp.find('categorySelect').get('v.value')
        console.log(category);
        cmp.set("v.calcCategory",category);
        var estList=cmp.find(category);
        /*Load the Master potential of selected Category*/
        estList.loadMasterPotential();
    },
    modeChange:function(cmp,event,helper){
        /*Handle when the mode of the application is None.
        This happens when the user clicks Back to Potential List button*/
        
        if(cmp.get("v.mode")=='None'){
         
            /*When the user comes back to the first page,retain the user selected value as selected*/
            var calcCategory = cmp.get("v.calcCategory");
            cmp.find('categorySelect').set('v.value',calcCategory);
           
            var estList=cmp.find(calcCategory);
            estList.loadMasterPotential();
           
        }
    }
        
  
})