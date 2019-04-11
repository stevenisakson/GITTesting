({
     doInit: function(component, event, helper) { 
    	 var alertMessage = component.get("v.UserContext");
         //alert('alertMessage: '+alertMessage);
         var searchBoxStyle = component.find("searchRes");
         if(alertMessage == 'Theme3' || alertMessage == 'Theme2' ){ 
             //alert('Inside Classic');
             $A.util.addClass(searchBoxStyle, "searchBoxplace1");
         	 $A.util.removeClass(searchBoxStyle, "searchBoxplace2"); 
          }
         else{
              //alert('Inside Lighting');
              $A.util.addClass(searchBoxStyle,"searchBoxplace2");
         	  $A.util.removeClass(searchBoxStyle,"searchBoxplace1"); 
         }
      
     },
      onfocus : function(component,event,helper){
       $A.util.addClass(component.find("mySpinner"), "slds-show");
        var forOpen = component.find("searchRes");
            $A.util.addClass(forOpen, 'slds-is-open');
            $A.util.removeClass(forOpen, 'slds-is-close');
        // Get Default 5 Records order by createdDate DESC  
         var getInputkeyWord = '';
         helper.searchHelper(component,event,getInputkeyWord);
    },
    onblur : function(component,event,helper){       
        component.set("v.listOfSearchRecords", null );
        var forclose = component.find("searchRes");
        $A.util.addClass(forclose, 'slds-is-close');
        $A.util.removeClass(forclose, 'slds-is-open');
    },
    keyPressController : function(component, event, helper) {
       // get the search Input keyword   
         var getInputkeyWord = component.get("v.SearchKeyWord");
       
       // check if getInputKeyWord size id more then 0 then open the lookup result List and 
       // call the helper 
       // else close the lookup result List part.   
        if( getInputkeyWord.length > 0 ){
             var forOpen = component.find("searchRes");
               $A.util.addClass(forOpen, 'slds-is-open');
               $A.util.removeClass(forOpen, 'slds-is-close');
            helper.searchHelper(component,event,getInputkeyWord);
        }
        else{  
             component.set("v.listOfSearchRecords", null ); 
             var forclose = component.find("searchRes");
               $A.util.addClass(forclose, 'slds-is-close');
               $A.util.removeClass(forclose, 'slds-is-open');
          }
	},
    
  // function for clear the Record Selaction 
    clear :function(component,event,heplper){
         //$A.get('e.force:refreshView').fire();
         //alert('after refresh');
         var pillTarget = component.find("lookup-pill");
         var lookUpTarget = component.find("lookupField"); 
        
         $A.util.addClass(pillTarget, 'slds-hide');
         $A.util.removeClass(pillTarget, 'slds-show');
        
         $A.util.addClass(lookUpTarget, 'slds-show');
         $A.util.removeClass(lookUpTarget, 'slds-hide');
      
         component.set("v.SearchKeyWord",null);
         component.set("v.listOfSearchRecords", null );
         component.set("v.selectedRecord", {} );
        
         var alertMessage = component.get("v.UserContext");
         if(alertMessage == 'Theme3' || alertMessage == 'Theme2' ){
            //alert('inside classic');
            location.reload();
         }
         $A.get('e.force:refreshView').fire();
         
    },
  // This function call when the end User Select any record from the result list.   
    handleComponentEvent : function(component, event, helper) {
    // get the selected Account record from the COMPONETN event 	 
       var selectedAccountGetFromEvent = event.getParam("recordByEvent");
	   component.set("v.selectedRecord" , selectedAccountGetFromEvent); 
       //alert('selectedAccountGetFromEvent'+selectedAccountGetFromEvent.Name);
       component.set("v.showTable" , true);
       var childComponent = component.find("childCmp");
       var message = childComponent.messageMethod(selectedAccountGetFromEvent.Name, true); 
        
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
     handleHideAccountTableEvent : function(component, event) { 
        //Get the event message attribute
        var hideTable = event.getParam("hideTableAndPill");
        var showSearchText = event.getParam("showSearchText");
        //console.log('showSearchText:'+showSearchText);
        //alert('showSearchText:'+showSearchText);
        //Set the handler attributes based on event data 
        component.set("v.hideAccountTableAndPill", hideTable);
        component.set("v.showSearchText", showSearchText);
		 var pillTarget = component.find("lookup-pill");
         var lookUpTarget = component.find("lookupField"); 
        
         $A.util.addClass(pillTarget, 'slds-hide');
         $A.util.removeClass(pillTarget, 'slds-show');
        
         $A.util.addClass(lookUpTarget, 'slds-show');
         $A.util.removeClass(lookUpTarget, 'slds-hide'); 
         
         component.set("v.SearchKeyWord",null);
         component.set("v.listOfSearchRecords", null );
         component.set("v.selectedRecord", {} ); 
    } 
})