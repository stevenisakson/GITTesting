({
   // This method is used to display the picklist values for Filter field.
   
    getHistoryFilter:function(component, event, helper){

		var action=component.get("c.getHistoryFilters");
        action.setCallback(this,function(resp){
           var state=resp.getState();
            if(state==='SUCCESS'){
                var ret=resp.getReturnValue();
                 
                if(ret.isSuccess){
                    console.log('DisplayOption'+this.createOptionMap(ret.data));
                    component.set("v.HistoryFilter",this.createOptionMap(ret.data));
                   
                }
            }else{
                console.log('error in loading account team value');
            }
        });
        $A.enqueueAction(action);
	}, 
    
    // This method is used to display the picklist values for Competitor field.
    getCrescendoFilter:function(component, event, helper){
		console.log('Inside getCrescendoFilter');
		var action=component.get("c.getCrescendoFilter");
        action.setCallback(this,function(resp){
           var state=resp.getState();
            if(state==='SUCCESS'){
                var ret=resp.getReturnValue();
                 
                if(ret.isSuccess){
                    console.log('getCrescendoFilter'+this.createOptionMap(ret.data));
                    component.set("v.CrescendoFilter",this.createOptionMap(ret.data));
                   
                }
            }else{
                console.log('error in loading account team value');
            }
        });
        $A.enqueueAction(action);
	},
    createOptionMap:function(data){
        var options=[];
        var temp={};
        for(var i in data){
            temp={};
            temp['text']=i;
            temp['value']=data[i];
            temp['checked']=false;
            options.push(temp);
        }
        console.log('%%%%options'+options);
        return options;
    },
  // This method is used to display the list of potentail history records.
  
   getPotentials: function(component, page, recordToDisply,Field,fromDate,ToDate,Iscomp,selectedRecordId) { //,selecteduser
 	console.log('Iscomp'+Iscomp);
      // create a server side action. 
      var action = component.get("c.fetchPotential");
      // set the parameters to method 
      action.setParams({
         "pageNumber": page,
         "recordToDisply": recordToDisply,
         "historyfilter" :Field,
          "fromDate":fromDate,
          "ToDate":ToDate,
          "Iscomp":Iscomp,
          "selectedRecordId":selectedRecordId
         
      }); 
       //"selecteduser": selecteduser
      // set a call back   
      action.setCallback(this, function(a) {
         // store the response return value (wrapper class insatance)  
         var result = a.getReturnValue();
         console.log('result ---->' + JSON.stringify(result));
         // set the component attributes value with wrapper class properties.   
 		 console.log('result Potential---->' + result.Potential.Pot);
         console.log('result Potential---->' + result.Potential.PotHis);
         console.log('result PotentialHistoryDownload---->' + result.PotentialHistoryDownload);
         console.log('result PotentialHistoryDownload---->' + result.Potential.PotHis);  
		 console.log('result.CreatedDatePDF--->'+result.CreatedDatePDF);
         component.set("v.estList", result.Potential);
         component.set("v.estListHistory", result.PotentialHistoryDownload );
         console.log('Total'+ result.PotentialHistoryDownload.length);
         component.set("v.page", result.page);
         component.set("v.total", result.PotentialHistoryDownload.length);
          if(Math.ceil(result.PotentialHistoryDownload.length  / recordToDisply) == 0){
              component.set("v.pages",1);
          }else{
         component.set("v.pages", Math.ceil(result.PotentialHistoryDownload.length  / recordToDisply));
          }
         component.set("v.HeaderList", result.PotentialHistoryCusList);
 		 component.set("v.isLoading",false);
      });
      // enqueue the action 
      $A.enqueueAction(action);
      component.set("v.isLoading",true);
   },
    
   
 dovalidation : function(component, page, recordToDisply,Field,fromDate,ToDate,Iscomp,selectedRecordId) {
 
	var Fromdateval = new Date(fromDate);
	var ToDateval = new Date(ToDate); 
	var monthcorret;
	var Iscompetitor = component.find("Competitors").getSelectedOptions();
	console.log('ToDateToDate'+ToDate);
	console.log('fromDatefromDate'+fromDate);
	
	var Fromdateval = new Date(fromDate);
	var ToDateval = new Date(ToDate); 

	if( (ToDate==null || ToDate=='undefined' || ToDate.length==0 ) && (fromDate==null || fromDate=='undefined' || fromDate.length==0)){

		var today = new Date();  
		var date_one_ms = new Date();;
		var ms_in_day = 24*3600*1000; // 86400000;
		var date_60_days_later = new Date(date_one_ms - 90 * ms_in_day);
		console.log('today60'+date_60_days_later + date_60_days_later.toISOString()); 
		component.set("v.Todate", today.toISOString()); 
		component.set("v.Fromdate",date_60_days_later.toISOString());
		ToDate = today.toISOString();
		fromDate = date_60_days_later.toISOString();
	}
	
	else if((ToDate!=null || ToDate!='undefined' || ToDate.length!=0 ) && (fromDate==null || fromDate=='undefined' || fromDate.length==0))
	{
		  var date_one_ms = new Date(ToDate);;
		  var ms_in_day = 24*3600*1000; // 86400000;
		  var date_60_days_later = new Date(date_one_ms - 90 * ms_in_day);
		  console.log('Fields selected date_60_days_later'+date_60_days_later);
		  component.set("v.Fromdate",date_60_days_later.toISOString());
		  fromDate = date_60_days_later.toISOString();
		  monthcorret = 89;
	}
	else if((ToDate==null || ToDate=='undefined' || ToDate.length==0 ) && (fromDate!=null || fromDate!='undefined' || fromDate.length!=0))
	{
		var date_one_ms = new Date(fromDate);;
		var ms_in_day = 24*3600*1000; // 86400000;
		var date_60_days = new Date(date_one_ms.getTime() + 90 * ms_in_day);
		// var date_60_days =  date_one_ms.setDate(date_one_ms.getDate() + 90);
		console.log('Fields selected date_60_days'+date_60_days.toISOString());
		component.set("v.Todate",date_60_days.toISOString());
		ToDate = date_60_days.toISOString();
		monthcorret =89;
	}

		
	else if((ToDate==null || ToDate=='undefined' || ToDate.length==0 ) && (fromDate==null || fromDate=='undefined' || fromDate.length==0) ){
		var today = new Date();  

		var date_one_ms = new Date();;
		var ms_in_day = 24*3600*1000; // 86400000;
		var date_60_days_later = new Date(date_one_ms - 90 * ms_in_day);
		console.log('today60'+date_60_days_later + date_60_days_later.toISOString()); 

		component.set("v.Todate", today.toISOString()); 
		component.set("v.Fromdate",date_60_days_later.toISOString());

		Todate=today.toISOString();
		fromDate = date_60_days_later.toISOString();
		monthcorret =89;

	}
	
	else if ((ToDate!=null && ToDate!='undefined' && ToDate.length!=0 ) && (fromDate!=null && fromDate!='undefined' && fromDate.length!=0)) {
		var month =  ((Fromdateval.getTime() - ToDateval.getTime()) / 1000 / 60 / 60 / 24 )
		var monthcorret;
		console.log('Fromdateval'+Fromdateval + ToDateval + month); 
			if(month < 0)
			{
			monthcorret =month*-1 
			}
			else {
			monthcorret =month
		}
	}
		
        if(monthcorret > 90) {
            component.set("v.dateValidationError" , true);
            console.log('Test diff');
        }
        else {
             component.set("v.dateValidationError" , false);
        }
        if(monthcorret <= 90){
        if(fromDate==null && fromDate=='undefined' && fromDate.length==0){
            fromDate=null;
        }
        if(ToDate==null && ToDate=='undefined' && ToDate.length==0){
            ToDate=null;
        }
       
       
        console.log('Iscomp selected'+Iscomp);
        if(Iscomp != 'Null' && (selectedRecordId != null || selectedRecordId !='undefined' )) {
        if((Field!=null || Field!='undefined')&& (fromDate!= null || fromDate!= 'undefined' ) && (ToDate!= null || ToDate!= 'undefined'  )){ 
            
            console.log('Inside 1');
            this.getPotentials(component, page, recordToDisply,Field,fromDate,ToDate,Iscomp,selectedRecordId); 
			            
        }else if((Field!=null || Field!='undefined')&& (fromDate== null || fromDate== 'undefined' ) && (ToDate!= null || ToDate!= 'undefined') ){
              console.log('Inside 2');
           this.getPotentials(component, page, recordToDisply,Field,null,ToDate,Iscomp,selectedRecordId); 
        }
        else if((Field!=null || Field!='undefined')&& (fromDate!= null || fromDate!= 'undefined' )  && (ToDate== null || ToDate== 'undefined') ){
             console.log('Inside 3');
           this.getPotentials(component, page, recordToDisply,Field,fromDate,null,Iscomp,selectedRecordId); 
        }
		else if((Field!=null || Field!='undefined')&& (fromDate== null || fromDate== 'undefined' )  && (ToDate== null || ToDate== 'undefined')){
            console.log('Inside 4');
           this.getPotentials(component, page, recordToDisply,Field,null,null,Iscomp,selectedRecordId); 
        }
            
       else {
           console.log('Inside 5');
            this.getPotentials(component, page, recordToDisply,null,null,null,Iscomp,selectedRecordId);
            }
        }
        else if(Iscomp == 'Null' && (selectedRecordId != null || selectedRecordId !='undefined' ) ){
            if( (Field!=null || Field!='undefined' )&& (fromDate!= null ||fromDate!= 'undefined' )&& (ToDate!= null || ToDate!= 'undefined') ){ 
            
                console.log('Inside 6');
            this.getPotentials(component, page, recordToDisply,Field,fromDate,ToDate,null,selectedRecordId); 
			            
        }else if((Field!=null  || Field!='undefined' ) && (fromDate== null ||fromDate== 'undefined' ) && (ToDate!= null || ToDate!= 'undefined' )){
             console.log('Inside 7');
           this.getPotentials(component, page, recordToDisply,Field,null,ToDate,null,selectedRecordId); 
        }
        else if( (Field!=null || Field!='undefined' ) && (fromDate!= null || fromDate!= 'undefined' )&& ( ToDate== null || ToDate== 'undefined' )){
           console.log('Inside 8');
            this.getPotentials(component, page, recordToDisply,Field,fromDate,null,null,selectedRecordId); 
        }
		else if( (Field!=null  || Field!='undefined' ) && (fromDate== null || fromDate== 'undefined') && (ToDate== null || ToDate== 'undefined' )){            
            console.log('Inside 9');
            this.getPotentials(component, page, recordToDisply,Field,null,null,null,selectedRecordId); 
           console.log('Inside correct if');
        }
       else {
            console.log('Inside 10');
            this.getPotentials(component, page, recordToDisply,null,null,null,null,selectedRecordId);
            } 
        }
		else if(Iscomp != 'Null' && (selectedRecordId == null || selectedRecordId =='undefined' ) ){
            if( (Field!=null || Field!='undefined' )&& (fromDate!= null ||fromDate!= 'undefined' )&& (ToDate!= null || ToDate!= 'undefined') ){ 
            
                console.log('Inside 6');
            this.getPotentials(component, page, recordToDisply,Field,fromDate,ToDate,Iscomp,null); 
			            
        }else if((Field!=null  || Field!='undefined' ) && (fromDate== null ||fromDate== 'undefined' ) && (ToDate!= null || ToDate!= 'undefined' )){
             console.log('Inside 7');
           this.getPotentials(component, page, recordToDisply,Field,null,ToDate,Iscomp,null); 
        }
        else if( (Field!=null || Field!='undefined' ) && (fromDate!= null || fromDate!= 'undefined' )&& ( ToDate== null || ToDate== 'undefined' )){
           console.log('Inside 8');
            this.getPotentials(component, page, recordToDisply,Field,fromDate,null,Iscomp,null); 
        }
		else if( (Field!=null  || Field!='undefined' ) && (fromDate== null || fromDate== 'undefined') && (ToDate== null || ToDate== 'undefined' )){            
            console.log('Inside 9');
            this.getPotentials(component, page, recordToDisply,Field,null,null,Iscomp,null); 
           console.log('Inside correct if');
        }
       else {
            console.log('Inside 10');
            this.getPotentials(component, page, recordToDisply,null,null,null,Iscomp,null);
            } 
        }
		else {
            if( (Field!=null || Field!='undefined' )&& (fromDate!= null ||fromDate!= 'undefined' )&& (ToDate!= null || ToDate!= 'undefined') ){ 
            
                console.log('Inside 6');
            this.getPotentials(component, page, recordToDisply,Field,fromDate,ToDate,null,null); 
			            
        }else if((Field!=null  || Field!='undefined' ) && (fromDate== null ||fromDate== 'undefined' ) && (ToDate!= null || ToDate!= 'undefined' )){
             console.log('Inside 7');
           this.getPotentials(component, page, recordToDisply,Field,null,ToDate,null,null); 
        }
        else if( (Field!=null || Field!='undefined' ) && (fromDate!= null || fromDate!= 'undefined' )&& ( ToDate== null || ToDate== 'undefined' )){
           console.log('Inside 8');
            this.getPotentials(component, page, recordToDisply,Field,fromDate,null,null,null); 
        }
		else if( (Field!=null  || Field!='undefined' ) && (fromDate== null || fromDate== 'undefined') && (ToDate== null || ToDate== 'undefined' )){            
            console.log('Inside 9');
            this.getPotentials(component, page, recordToDisply,Field,null,null,null,null); 
           console.log('Inside correct if');
        }
       else {
            console.log('Inside 10');
            this.getPotentials(component, page, recordToDisply,null,null,null,null,null);
            } 
        }
      }
    },    
   
})