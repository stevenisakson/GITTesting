({
	doInit : function(cmp, event, helper) {
       /*Create the Visit Form Dynamically*/ 
       console.log('init Form');
       //console.log(cmp.get("v.pageReference"),null);
       var ref=cmp.get("v.pageReference");
        
       helper.createDCRCreateForm(cmp,cmp.get("v.pageReference")); 
        /*if create btn is clicked*/
       
	},
    reInit : function(cmp, event, helper) {
        /*ReCreate the Visit Form Dynamically. When page is revisited*/ 
        var pageRef=cmp.get("v.pageReference");
        /*Avoid unnecessary calling of the functions when back button/cancel button is clicked*/
        if(pageRef['state']!=undefined){
            
            console.log('reinit DCRForm');
            cmp.set("v.body",[]); 
            console.log('DCRIDReceived');
            console.log(pageRef['state']['dcrId']);
            helper.createDCRCreateForm(cmp,cmp.get("v.pageReference"));
        }
	}
})