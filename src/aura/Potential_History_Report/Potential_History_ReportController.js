({
    // This method would be displayed upon loading the page. This method shows all the potential records created between today to 30 months back data.
    

   doInit: function(component, event, helper) {
      // this function call on the component load first time     
      // get the page Number if it's not define, take 1 as default
      var page = component.get("v.page") || 1;
      // get the select option (drop-down) values. 
      var today = new Date();  
      
      var date_one_ms = new Date();;
	  var ms_in_day = 24*3600*1000; // 86400000;
      var date_60_days_later = new Date(date_one_ms - 90 * ms_in_day);
       
      console.log('today60'+date_60_days_later + date_60_days_later.toISOString()); 
       
      component.set("v.Todate", today.toISOString()); 
      component.set("v.Fromdate",date_60_days_later.toISOString());
       
      var recordToDisply = component.find("recordSize").get("v.value");
      // call the helper function   
      //helper.getPotentials(component, page, recordToDisply);
      helper.getHistoryFilter(component, event, helper);
      helper.getCrescendoFilter(component, event, helper);
       
     
   },
 
    // This method is called on click of Next and Previous button. 
   navigate: function(component, event, helper) {
	   // this function call on click on the previous page button  
	   var page = component.get("v.page") || 1;
	   // get the previous button label  
	   var direction = event.getSource().get("v.label");
	   // get the select option (drop-down) values.  
	   var recordToDisply = component.find("recordSize").get("v.value");
	   // set the current page,(using ternary operator.)  
	   page = direction === "Previous Page" ? (page - 1) : (page + 1);
	   // call the helper function
       var Field=component.find("Field").getSelectedOptions();
       var Iscompetitor = component.find("Competitors").getSelectedOptions();
       var fromDate = component.get("v.Fromdate");
       var ToDate = component.get("v.Todate");
	   var Iscomp = 'Null';
       
	   var selectedRecord = component.get("v.selectedLookUpRecord");
       var selectedRecordId = selectedRecord.Id;
       
	    if(Iscompetitor!=null && Iscompetitor!='' && Iscompetitor != 'undefined'){
        
        if(Iscompetitor== 'Cargill'){
            Iscomp = 'False';
        }
        else if(Iscompetitor == 'Competitor'){
             Iscomp = 'True';  
           }
        else {
            Iscomp = 'Null';
        }
        } 
		helper.dovalidation(component, page, recordToDisply,Field,fromDate,ToDate,Iscomp,selectedRecordId);
       
   },
 
    // This method is called on change of records per page - 10,15,20.
   onSelectChange: function(component, event, helper) {
      // this function call on the select opetion change,	 
       var page = 1
       var recordToDisply = component.find("recordSize").get("v.value");
       var Field=component.find("Field").getSelectedOptions();
       var Iscompetitor = component.find("Competitors").getSelectedOptions();
       var fromDate = component.get("v.Fromdate");
       var ToDate = component.get("v.Todate");
	   var Iscomp = 'Null';
	   var selectedRecord = component.get("v.selectedLookUpRecord");
       var selectedRecordId = selectedRecord.Id;
      
       
	   if(Iscompetitor!=null && Iscompetitor!='' && Iscompetitor != 'undefined'){
        
        if(Iscompetitor== 'Cargill'){
            Iscomp = 'False';
        }
        else if(Iscompetitor == 'Competitor'){
             Iscomp = 'True';  
           }
        else {
            Iscomp = 'Null';
        }
        } 
        
		helper.dovalidation(component, page, recordToDisply,Field,fromDate,ToDate,Iscomp,selectedRecordId);
   },
    
    // This method is called on click of search button. This will filer the records based on selection. 
    search : function(component, event, helper) {
		
	   var page = 1
       var recordToDisply = component.find("recordSize").get("v.value");
        
       var Field=component.find("Field").getSelectedOptions();
       var fromDate = component.get("v.Fromdate");
       var ToDate = component.get("v.Todate");
       var Iscompetitor = component.find("Competitors").getSelectedOptions();
       console.log('Iscompetitor'+Iscompetitor);
	   var Iscomp = 'Null';
	   var selectedRecord = component.get("v.selectedLookUpRecord");
       var selectedRecordId = selectedRecord.Id;
       console.log('Test Account Id'+selectedRecord.Id + selectedRecord.Name);
        
	    if(Iscompetitor!=null && Iscompetitor!='' && Iscompetitor != 'undefined'){
        
        if(Iscompetitor== 'Cargill'){
            Iscomp = 'False';
        }
        else if(Iscompetitor == 'Competitor'){
             Iscomp = 'True';  
           }
        else {
            Iscomp = 'Null';
        }
        } 
		helper.dovalidation(component, page, recordToDisply,Field,fromDate,ToDate,Iscomp,selectedRecordId);
   },

	// This method is called on clicking of download button.
    downloadPDF : function(cmp, event, helper) {
     	var downloadcmp=cmp.find("download");
        downloadcmp.downloadpdf();
    },
   
	
    
})