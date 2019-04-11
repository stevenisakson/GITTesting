({
    doInit:function(cmp,event,helper){
        if(cmp.get("v.objectAPIName")=='Route__c' ){
            cmp.set("v.IconName","custom:custom31");
        }else 
            if(cmp.get("v.objectAPIName")=='RouteCustomers' ){
                cmp.set("v.IconName","standard:account");  
            }
    },
    onfocus : function(component,event,helper){
        
        component.set("v.hasError",false);
        console.log('focuessed');
        
        $A.util.addClass(component.find("mySpinner"), "slds-show");
        var forOpen = component.find("searchRes");
        $A.util.addClass(forOpen, 'slds-is-open');
        $A.util.removeClass(forOpen, 'slds-is-close');
        // Get Default 5 Records order by createdDate DESC  
        var getInputkeyWord = component.get("v.SearchKeyWord");
        if(component.get("v.objectAPIName")!=undefined && component.get("v.objectAPIName")=='Route__c' && component.get("v.selectedParentRecordId")!=undefined
           && component.get("v.selectedParentRecordId")!=null){
            console.log('called Route');
            console.log('SearchKey');
            console.log(getInputkeyWord);
            helper.searchRoute(component,event,getInputkeyWord,component.get("v.selectedParentRecordId"));
        }
        else if(component.get("v.objectAPIName")!=undefined && component.get("v.objectAPIName")=='RouteCustomers'  && component.get("v.selectedParentRecord.Id")!=undefined
                && component.get("v.selectedParentRecord.Id")!=null){
            helper.searchRouteCustomers(component,event,getInputkeyWord,component.get("v.selectedParentRecord").Id);
            
           
        }
      
    },
    onblur : function(component,event,helper){       
        component.set("v.listOfSearchRecords", null );
        var forclose = component.find("searchRes");
        $A.util.addClass(forclose, 'slds-is-close');
        $A.util.removeClass(forclose, 'slds-is-open');
        
        if(component.get("v.selectedRecord.Id")==undefined && component.get("v.SearchKeyWord")!=undefined && component.get("v.SearchKeyWord").length>0
          &&  component.get("v.listOfSearchRecords")==null){
            component.set("v.hasError",true);
          
        }else{
            component.set("v.hasError",false);
           
        }
    },
    keyPressController : function(component, event, helper) {
        
        component.set("v.hasError",false);
        var getInputkeyWord = component.get("v.SearchKeyWord");
        
        if(component.get("v.objectAPIName")!=undefined && component.get("v.objectAPIName")=='Route__c' && component.get("v.selectedParentRecordId")!=undefined
           &&  component.get("v.selectedParentRecordId")!=null){
            
            helper.searchRoute(component,event,getInputkeyWord,component.get("v.selectedParentRecordId"));
        }
        else if(component.get("v.objectAPIName")!=undefined && component.get("v.objectAPIName")=='RouteCustomers' && component.get("v.selectedParentRecord.Id")!=undefined && component.get("v.selectedParentRecord.Id")!=null){
            helper.searchRouteCustomers(component,event,getInputkeyWord,component.get("v.selectedParentRecord").Id);
            
        }
    },
    
    // function for clear the Record Selaction 
    clear :function(component,event,heplper){
        var pillTarget = component.find("lookup-pill");
        var lookUpTarget = component.find("lookupField"); 
        
        $A.util.addClass(pillTarget, 'slds-hide');
        $A.util.removeClass(pillTarget, 'slds-show');
        
        $A.util.addClass(lookUpTarget, 'slds-show');
        $A.util.removeClass(lookUpTarget, 'slds-hide');
        
        component.set("v.SearchKeyWord",'');
        component.set("v.listOfSearchRecords", null );
        component.set("v.selectedRecord", {} );   
        
        component.set("v.hasError",false);
    },
    
    // This function call when the end User Select any record from the result list.   
    handleComponentEvent : function(component, event, helper) {
        // get the selected Promotion record from the COMPONETN event 	 
        var selectedPromotionGetFromEvent = event.getParam("recordByEvent");
        console.log('Test');
        console.log(selectedPromotionGetFromEvent.Id);
        component.set("v.selectedRecord" , selectedPromotionGetFromEvent); 
        
        var forclose = component.find("lookup-pill");
        $A.util.addClass(forclose, 'slds-show');
        $A.util.removeClass(forclose, 'slds-hide');
        
        var forclose = component.find("searchRes");
        $A.util.addClass(forclose, 'slds-is-close');
        $A.util.removeClass(forclose, 'slds-is-open');
        
        var lookUpTarget = component.find("lookupField");
        $A.util.addClass(lookUpTarget, 'slds-hide');
        $A.util.removeClass(lookUpTarget, 'slds-show');  
        
    },
   
})