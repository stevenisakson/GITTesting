({
	 toggleSampleDetails1:function(component, event, helper) {
        if(component.get("v.sampleDetails1")){
            component.set("v.sampleDetails1",false);
        }else{
            component.set("v.sampleDetails1",true);
        }
	},
      toggleSampleDetails5:function(component, event, helper) {
        if(component.get("v.sampleDetails5")){
            component.set("v.sampleDetails5",false);
        }else{
            component.set("v.sampleDetails5",true);
        }
	},
      toggleSampleDetails2:function(component, event, helper) {
        if(component.get("v.sampleDetails2")){
            component.set("v.sampleDetails2",false);
        }else{
            component.set("v.sampleDetails2",true);
        }
	},
      toggleSampleDetails3:function(component, event, helper) {
        if(component.get("v.sampleDetails3")){
            component.set("v.sampleDetails3",false);
        }else{
            component.set("v.sampleDetails3",true);
        }
	},
      toggleSampleDetails4:function(component, event, helper) {
        if(component.get("v.sampleDetails4")){
            component.set("v.sampleDetails4",false);
        }else{
            component.set("v.sampleDetails4",true);
        }
	},
    dcrEdit:function(cmp,event,helper){
         console.log('$$$CustomerEdit');
         console.log(cmp.get("v.item.Id"));
         helper.navigateToCustomerEditPage(cmp,event,cmp.get("v.item.Id"),cmp.get("v.dcrId"),cmp.get("v.targetId"));
    }
  
})