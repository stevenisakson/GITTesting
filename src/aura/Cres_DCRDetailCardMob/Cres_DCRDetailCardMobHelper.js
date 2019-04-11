({
	 /*called when create button is clicked*/
    navigateToCustomerEditPage:function(cmp,event,dcrCustId,dcrId,targetId){
        var pageReference = {
            type: 'standard__component',
            attributes: {
                "componentName": "c__Cres_DCRVisitFormContainer"   
            },
            state:{"btnAction":"Edit","dcrCustId":dcrCustId,"dcrId":dcrId,"targetId":targetId}
        };
        
        cmp.set("v.pageReference", pageReference);
        
        var navService = cmp.find("navService");
        var pageReference = cmp.get("v.pageReference");
        event.preventDefault();
        navService.navigate(pageReference);
    },
})