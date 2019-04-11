({
    /*Go to landing page*/
	showLandingPage : function(component, event, helper) {
     
        component.set("v.mode","None");/*None is the default mode to show the landing page*/
        
     
	},
    /*Save method for saving potentials*/
    save:function(cmp,event,helper){
     
        /*Reset the previous error messages*/
        cmp.set('v.errorflag',false);
        cmp.set('v.errorList',[]);
        
        var wrapper=cmp.get("v.PotentialEstWrapper");
        
      
        /*Clear error indicator in each row*/
        helper.clearErrorFlag(wrapper.potwrapper);
 		
        
      
        /*Set necessary paramters for saving a potential*/
        wrapper['accId']=cmp.get("v.recordId");
        wrapper['mode']=cmp.get("v.mode");
        wrapper['calcType']=cmp.get("v.calcType");
        /*Set the master potential Record before creating/editing its potential records*/
        if(cmp.get('v.mode')=='Edit'){
            wrapper['master_pot_id']=cmp.get("v.mpot_id");
        }
        
        /*Madatory check for specific calculation types*/
        if(cmp.get("v.calcType")==$A.get("$Label.c.Daily_Animal_Consumption")){
          
            helper.mandatoryFieldsCheckForDAC(cmp,wrapper.potwrapper);
            helper.numberLengthCheckForDAC(cmp,wrapper.potwrapper);
        }else
            if(cmp.get("v.calcType")==$A.get("$Label.c.SimplePotentialEstimate")){
              
                helper.mandatoryFieldsCheckForSP(cmp,wrapper.potwrapper);
                helper.numberLengthCheckForSP(cmp,wrapper.potwrapper);
            }
            else
                if(cmp.get("v.calcType")==$A.get("$Label.c.Cycle_Consumption")){
                  
                    helper.mandatoryFieldsCheckForCC(cmp,wrapper.potwrapper);
                    helper.numberLengthCheckForCC(cmp,wrapper.potwrapper);
                }else
                    if(cmp.get("v.calcType")==$A.get("$Label.c.SimplePotentialEstimate_CFE"))
                    {
                     helper.mandatoryFieldsCheckForSPCFE(cmp,wrapper.potwrapper);    
                     helper.numberLengthCheckForSPCFE(cmp,wrapper.potwrapper);
                    }
      			else
                    if(cmp.get("v.calcType")==$A.get("$Label.c.CycleConsumption_CFE"))
                    {
                     helper.mandatoryFieldsCheckForCCCFE(cmp,wrapper.potwrapper);   
                     helper.numberLengthCheckForCCCFE(cmp,wrapper.potwrapper);  
                    }
        		else
                    if(cmp.get("v.calcType")==$A.get("$Label.c.DailyAnimalConsumption_CFE"))
                    {
                     helper.mandatoryFieldsCheckForDACCFE(cmp,wrapper.potwrapper);   
                     helper.numberLengthCheckForDACCFE(cmp,wrapper.potwrapper);  
                    }
        
        if(!cmp.get("v.errorflag")){
            /*Check if product Function and Type is unique*/
            helper.productFunctionTypeDupCheck(cmp,wrapper.potwrapper);
        }
        /*Check if the Length of the Number inputs are less than 15 for common fields*/
        
        /*Check if competitor is not Cargill*/
        helper.competitorCheck(cmp,wrapper.potwrapper);
        
        
        helper.numberLengthCheckForAll(cmp,wrapper.potwrapper);
        
        /*Further validations which should be done if duplicates are not present*/
        if(!cmp.get("v.errorflag")){
            /*Validate if sum of percent of share is <=100*/
            helper.validatePercentShare(cmp,wrapper.potwrapper);
            /*Check if any duplicate competitor is entered for a particulate product function*/
            helper.duplicateCompetitorCheck(cmp,wrapper.potwrapper);
       
           
        }   
        
        /*if no errors*/
        if(!cmp.get("v.errorflag")){
            console.log('Save Before');
            console.log(JSON.stringify(wrapper));/*Serialize to JSON before sending to server*/
            cmp.set("v.isLoading",true);//to show spinner
            helper.saveSimplePotential(cmp,JSON.stringify(wrapper));
        }else{
            /*to indicate the error fields,the changes must be set*/
            cmp.set("v.PotentialEstWrapper",wrapper);
            console.log('save error');
            console.log(wrapper.potwrapper);
        }
        
       
    },
    /*If user changes species or calculation type*/
    calcTypeORspeciesChanged:function(cmp,event,helper){
       
        cmp.set("v.isDuplicatePotential",false);
        cmp.set("v.renderTable",false);
     
        
        var est_type=cmp.find('selectEstType').get("v.value");
        var spvalue=cmp.find('selectSpecies').get("v.value");
        var transCalcType,transSpecies;
        
        var calcTypeList=cmp.get("v.calcTypeList");
        /*This is for translation of picklist values to shows in UI*/
        for(var i=0;i<calcTypeList.length;i++){
            if(calcTypeList[i]['value']==est_type){
                transCalcType=calcTypeList[i]['label'];
            }
        }
        var speciesList=cmp.get("v.speciesList");
        for(var i=0;i<speciesList.length;i++){
           
                if(speciesList[i]['value']==spvalue){
                    transSpecies=speciesList[i]['label'];
                }
            
        }
        
       
        
       
        if(spvalue!='None' && est_type!='None'){
            
            var wrapper=cmp.get("v.PotentialEstWrapper");
            
            
             /*if the user changes his selection from previously selected value*/
            if((cmp.get("v.oldspecies")!='' && cmp.get("v.oldspecies")!=spvalue && wrapper['potwrapper'].length>0) || (cmp.get("v.oldCalctype")!='' && cmp.get("v.oldCalctype")!=est_type && wrapper['potwrapper'].length>0)){
              
                /*Shows ConfirmModal to warn the user that if they change species or calc type
                the prevously entered values will be lost if they do not save*/
                $A.createComponent(
                    "c:ConfirmModal",
                    {
                    },
                    function(newCmp, status, errorMessage){
                        //Add the new button to the body array
                        if (status === "SUCCESS") {
                            var body = cmp.get("v.body");
                            body.push(newCmp);
                            cmp.set("v.body", body);
                        }
                        else if (status === "INCOMPLETE") {
                            console.log("No response from server or client is offline.")
                            // Show offline error
                        }
                            else if (status === "ERROR") {
                                console.log("Error: " + errorMessage);
                                // Show error message
                            }
                    }
                );
               
            
            }else{
                /*if the user selects to create a new potential*/
                var wrapper=cmp.get("v.PotentialEstWrapper");
                wrapper['potwrapper']=[];
                wrapper['transCalcType']=transCalcType;/*Shows the translated value in the UI*/
                wrapper['transSpecies']=transSpecies;
                cmp.set("v.PotentialEstWrapper",wrapper);
                
                /*when user selects the values first time*/
                cmp.set("v.oldspecies",spvalue);
                cmp.set("v.oldCalctype",est_type);
                
                cmp.set("v.calcType",est_type);
                cmp.set("v.species",spvalue);
                    
              
                cmp.set("v.isLoading",true);
                helper.isPotentialExist(cmp,est_type,spvalue,cmp.get("v.recordId"),function(result,success){
                    cmp.set("v.isLoading",false);
                    if(success && result==true){
                        /*If the selection is a duplicate*/
                        cmp.set("v.isDuplicatePotential",true);
                    }else if(success && result==false){
                        /*if no duplicate load the predefined values from database*/
                        cmp.loadAutoPopValues();
                        helper.loadFieldAccess(cmp,function(){
                            cmp.set("v.renderTable",true);             
                        });
                       
                    }
                });      
              
                
               
            }
            
        }
    },
    loadFieldAccess:function(cmp,event,helper){
        helper.loadFieldAccess(cmp,function(){
             cmp.set("v.renderTable",true);        
        });
    },
    /*After the user gives the confirmation from popup */
     popupconfirm:function(cmp,event,helper){
       
		var isconfirm = event.getParam("isConfirm");
		
        cmp.set("v.isDuplicatePotential",false);
        cmp.set("v.renderTable",false);
     
        
        var est_type=cmp.find('selectEstType').get("v.value");
        var spvalue=cmp.find('selectSpecies').get("v.value");
        var transCalcType,transSpecies;
        
		
		/*For translations*/
         var calcTypeList=cmp.get("v.calcTypeList");
         for(var i=0;i<calcTypeList.length;i++){
             if(calcTypeList[i]['value']==est_type){
                 transCalcType=calcTypeList[i]['label'];
             }
         }
         var speciesList=cmp.get("v.speciesList");
         for(var i=0;i<speciesList.length;i++){
             
             if(speciesList[i]['value']==spvalue){
                 transSpecies=speciesList[i]['label'];
             }
             
         }
         /*if user says yes to change the calculation type or species*/
         if (isconfirm == true) {
             
             cmp.set("v.oldspecies",spvalue);
             cmp.set("v.oldCalctype",est_type);
             
             
             var wrapper=cmp.get("v.PotentialEstWrapper");
             wrapper['transCalcType']=transCalcType;
             wrapper['transSpecies']=transSpecies;
             
             wrapper['potwrapper']=[];
             cmp.set("v.PotentialEstWrapper",wrapper);
             
             
             cmp.set("v.calcType",est_type);
             cmp.set("v.species",spvalue);
             cmp.set("v.isLoading",true);
             helper.isPotentialExist(cmp,est_type,spvalue,cmp.get("v.recordId"),function(result,success){
                 cmp.set("v.isLoading",false);
                 if(success && result==true){
                     cmp.set("v.isDuplicatePotential",true);
                 }else if(success && result==false){
                   
                     cmp.loadAutoPopValues();
                     helper.loadFieldAccess(cmp,function(){
                         cmp.set("v.renderTable",true);             
                     });
                 }
             });      
             
         }
         
         else {
             /*if the user says no,then set the previous values selected by the user*/
             cmp.find('selectSpecies').set("v.value",cmp.get("v.oldspecies"));
             cmp.find('selectEstType').set("v.value",cmp.get("v.oldCalctype"));
             cmp.set("v.renderTable",true);
         }
         
         
         
     },
    /*Aura method:called by parent component to edit potential Records*/
    loadPotentialData:function(cmp,event,helper){
       
      
       
        var param=event.getParam('arguments');
        cmp.set("v.mpot_id",param.mpot_id);
        helper.getPotential(cmp,param.mpot_id);
       
 		   
       
     
       
      
    },
    initializeParams:function(cmp,event,helper){
         /*initiliaze the data*/
         var param=event.getParam('arguments');
         
        cmp.set('v.calcType',param.calcType);
        cmp.set('v.species',param.species);
    }
    ,
    /*Adds a new product function by adding empty record into the list*/
    addProdFun:function(cmp,event,helper){
        var wrapper=cmp.get("v.PotentialEstWrapper");
        var arr=wrapper.potwrapper;
        var newrow={};
        newrow['isNew']=true;
        newrow['competitor']='Cargill';
        newrow['isCompetitor']=false;
       
        newrow['sales_person']=cmp.get('v.userName');
        arr.push(newrow);
       
        console.log(arr);
       
        /*This is solving lighnting issue in array jumbling*/
        /*Following code clones the entire list of potentials*/
        var cloneList=[];
        
        for(var i=0;i<arr.length;i++){
            var temp={};
            for(var j in arr[i]){
                temp[j]=arr[i][j];
                
            }
            cloneList.push(temp);
        }
        wrapper.potwrapper=cloneList;
        console.log(cloneList);
        
        cmp.set("v.PotentialEstWrapper",wrapper);
        
        //console.log(cmp.get("v.recordList"));
       
    },
    loadCalcTypeSpecies:function(cmp,event,helper){
        var params=event.getParam('arguments');
      
        /*Show loading spinner before loading*/
        cmp.set("v.isLoading",true);
        helper.loadSpecies(cmp);
        /*User selected category (CFE/Volume)*/
        helper.loadCalcTypes(cmp,params.calcCategory);
    },
    /*Methods that loads all necessary data from backend for potential table*/
    loadAutoPopValues:function(cmp,event,helper){
        
        cmp.set("v.isLoading",true);
        helper.getAutoPopValues(cmp);
        helper.getFormulaMap(cmp);
        helper.loadProductFunction(cmp);
        helper.loadTypes(cmp);
        helper.getUserName(cmp);
    },
    deletePotential:function(cmp,event,helper){
       
        
        var rowID=event.getParam('rowID');
        
        var wrapper=cmp.get("v.PotentialEstWrapper");
        var arr=wrapper.potwrapper;
       
        
        if(arr[rowID]['isNew']){
           
            arr.splice(rowID,1);
            
            cmp.set('v.PotentialEstWrapper',wrapper);
            helper.showDeleteToast();
        }else{
             cmp.set("v.isLoading",true);
             helper.deleteRecord(cmp,arr[rowID]['pot_id']);
          
        }
        /*Reset the previous error messages*/
        cmp.set('v.errorflag',false);
        cmp.set('v.errorList',[]);
        /*Pause the event to avoid to propogation of the Delete Event to other parent components*/
        event.pause();
       // helper.getloadAutoPopValues(cmp);
    }
    
  
})