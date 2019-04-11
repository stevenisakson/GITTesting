({
	doInit : function(cmp, event, helper) {
        /*Create the Visit Form Dynamically*/ 
        console.log('init Form');
        console.log(cmp.get("v.pageReference"));
        var ref=cmp.get("v.pageReference");
        
        helper.createVisitForm(cmp,cmp.get("v.pageReference"));
     
	},
    reInit : function(cmp, event, helper) {
        /*ReCreate the Visit Form Dynamically. When page is revisited*/ 
        var pageRef=cmp.get("v.pageReference");
        /*Avoid unnecessary calling of the functions when back button/cancel button is clicked*/
        if(pageRef['state']!=undefined && pageRef['state']['action']!='back'){
            
            console.log('reinit Form');
            cmp.set("v.body",[]); 
            helper.createVisitForm(cmp,cmp.get("v.pageReference"));
        }
	}
})