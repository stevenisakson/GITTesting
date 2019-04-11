({
    /*
	doFetchGrowthData : function(component) {
		var action = component.get('c.displayGrowthData');
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === 'SUCCESS' && component.isValid()){
                var pageSize = component.get("v.pageSize");
                component.set('v.ContactData', response.getReturnValue());
                component.set("v.totalRecords", component.get("v.ContactData").length);
                component.set("v.startPage",0);
                component.set("v.endPage",pageSize-1);
                var PaginationList = [];
                for(var i=0; i< pageSize; i++){
                    if(component.get("v.ContactData").length> i)
                        PaginationList.push(response.getReturnValue()[i]);    
                }
                component.set('v.PaginationList', PaginationList);
                component.set('v.isSending',false);
            }else{
                alert('ERROR');
            }
        });
        $A.enqueueAction(action);
	},
    */
    
    /*
     * Method will be called when use clicks on next button and performs the 
     * calculation to show the next set of records
     */
    next : function(component, event){
        var sObjectList = component.get("v.childgrowthdata");
        var end = component.get("v.endPage");
        var start = component.get("v.startPage");
        var pageSize = component.get("v.pageSize");
        var Paginationlist = [];
        var counter = 0;
        for(var i=end+1; i<end+pageSize+1; i++){
            if(sObjectList.length > i){
                Paginationlist.push(sObjectList[i]);
            }
            counter ++ ;
        }
        start = start + counter;
        end = end + counter;
        component.set("v.startPage",start);
        component.set("v.endPage",end);
        component.set('v.PaginationList', Paginationlist);
    },
    
    /*
     * Method will be called when use clicks on previous button and performs the 
     * calculation to show the previous set of records
     */
    previous : function(component, event){
        var sObjectList = component.get("v.childgrowthdata");
        var end = component.get("v.endPage");
        var start = component.get("v.startPage");
        var pageSize = component.get("v.pageSize");
        var Paginationlist = [];
        var counter = 0;
        for(var i= start-pageSize; i < start ; i++){
            if(i > -1){
                Paginationlist.push(sObjectList[i]);
                counter ++;
            }else{
                start++;
            }
        }
        start = start - counter;
        end = end - counter;
        component.set("v.startPage",start);
        component.set("v.endPage",end);
        component.set('v.PaginationList', Paginationlist);
    },
    
    
    getParentData : function( component ) {
        var action1 = component.get("c.DisplayLoginAccountName"); // gives account names details
        var action2 = component.get("c.displayParentGrowthData");// gives parent account details
        action1.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.accountName", response.getReturnValue()); // set server response in component attribute
            }
        });
        
        action2.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.parentgrowthdata", response.getReturnValue()); // set server response in component attribute
            }
        });
        
        $A.enqueueAction(action1);
        $A.enqueueAction(action2);
    },
    
    getChildData : function( component ) {
        var action2 = component.get("c.displayGrowthData");// gives parent account details
        action2.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                var pageSize = component.get("v.pageSize");
                var numRec = response.getReturnValue();
                
                component.set('v.childgrowthdata', response.getReturnValue());
                component.set("v.totalRecords", component.get("v.childgrowthdata").length);
                component.set("v.startPage",0);
                component.set("v.endPage",pageSize-1);
                var PaginationList = [];
                for(var i=0; i< pageSize; i++){
                    if(component.get("v.childgrowthdata").length> i)
                        PaginationList.push(response.getReturnValue()[i]);    
                }
                component.set('v.PaginationList', PaginationList);
                component.set('v.isSending',false);
                if(numRec){
                    if(numRec.length > 12)
                        component.set('v.paginationFlag',true);
                    else
                        component.set('v.paginationFlag',false);
                }
            }
        });
        $A.enqueueAction(action2);
    },
    
    getMaxDate : function( component ) {
        var action1 = component.get("c.fetchLatestLoadedDate"); // gives latest record loaded date
        action1.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.asofDate", response.getReturnValue()); // set server response in component attribute
            }
        });
        $A.enqueueAction(action1);
    }
})