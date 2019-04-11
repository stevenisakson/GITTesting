({
	doinit : function(component,event) {
        var action=component.get("c.getReportInfo");
        action.setCallback(this,function(response){
             var state = response.getState();
				  if (state === "SUCCESS") {
                       var wrpObj = response.getReturnValue();
					   component.set('v.reportInfo',wrpObj.CustomReportwrapList);
                       component.set('v.wrapperList', response.getReturnValue());
                       component.set('v.sectionHeadersList',wrpObj.sectionNamewrapSet);
                   	   component.set('v.baseOrgURL',wrpObj.baseOrgURL);
                  }
        });
        $A.enqueueAction(action);
	},
})