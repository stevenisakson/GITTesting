({
    /*Loads the potential Data of a master potential record*/
	 getPotential:function(cmp,mpotid){
         var action=cmp.get("c.getPotentialEstWrapper");
         action.setCallback(this,function(resp)
                            {
                                var state = resp.getState();
                                console.log(resp.getReturnValue());
                                if (state === "SUCCESS") {
                                    
                                    //  console.log(resp.getReturnValue());
                                    if(resp.getReturnValue().isSuccess){
                                       
                                        if(resp.getReturnValue().data.potwrapper){
                                            this.addRelation(resp.getReturnValue().data.potwrapper);
                                            this.lockfields(cmp,resp.getReturnValue().data.potwrapper,cmp.get("v.autoPopValues"));
                                            cmp.set("v.PotentialEstWrapper",resp.getReturnValue().data);
                                            console.log(resp.getReturnValue());
                                          
                                            
                                            /*Total the values of the Table*/
                                            if(cmp.find('spTable')){
                                            cmp.find('spTable').recalculate();
                                            console.log('check Autopopvalue');
                                            console.log(cmp.get("v.autoPopValues"));
                                            
                                          
                                            }
                                        }
                                    }
                                }
                            }
                           );
         action.setParams({'mpot_Id':mpotid});
         $A.enqueueAction(action);
    },
    
    /*Save potential records*/
     saveSimplePotential:function(cmp,potentialEstStrVal){
        var action=cmp.get("c.savePotential");
        action.setCallback(this,function(resp)
                           {
                               var state=resp.getState();
                               console.log(resp.getReturnValue());
                               var ret=resp.getReturnValue();
                               cmp.set("v.isLoading",false);
                               if(state==='SUCCESS'){
                                   
                                   if(ret.isSuccess){
                                       cmp.set("v.mpot_id",ret.data);
                                       this.getPotential(cmp,ret.data);
                                       if(cmp.get("v.mode")=="New"){
                                           
                                           this.showCreateToast();
                                       }
                                       else{
                                            this.showSuccessToast();
                                       }
                                       /*Refresh the Account Record Page to refresh Account Share of wallet */
                                       $A.get('e.force:refreshView').fire();
                                       /*Once saved,change the mode to Edit*/
                                       cmp.set("v.mode",'Edit');
                                   }else{
                                       var errorList=cmp.get('v.errorList');
                                       errorList.push(ret.msg);
                                       cmp.set("v.errorList",errorList);
                                       cmp.set("v.errorflag",true);
                                   }
                                   
                               }else
                                   if(state==='ERROR'){
                                       
                                   }
                           });
        action.setParams({potentialEstStr:potentialEstStrVal});
        $A.enqueueAction(action);
        
    },
    
    lockfields:function(cmp,recordList, customlist){
      
        console.log("lockfields");
        console.log(recordList);
        console.log(customlist);
        var calcType=cmp.get("v.calcType");
        var species=cmp.get("v.species");
        for(var i=0;i<recordList.length;i++){
            
                for(var j=0;j<customlist.length;j++){
                    if(calcType == customlist[j]['TypeOfCalculation__c'] && species == customlist[j]['Species__c'] && recordList[i]['product_function'] == customlist[j]['Product_Function__c'] && recordList[i]['pftype'] == customlist[j]['Type__c'] )
					{
						recordList[i]['Is_Value_MT_CFE_lock']=customlist[j]['Is_Value_MT_CFE_locked__c'];
                        console.log('inside');
                        console.log(customlist[j]['Is_Value_MT_CFE_locked__c']);
						recordList[i]['Is_CFE_Incl_lock']=customlist[j]['Is_CFE_Incl_locked__c'];
                        console.log(customlist[j]['Is_CFE_Incl_locked__c']);
                        
					}
					
                }
            }
        
        
        console.log('check updated values');
        console.log(recordList);
        //cmp.set("v.PotentialEstWrapper",recordList);
      //  console.log(cmp.get("v.recordList"));
        
    },
    
    /*This is to relate cargill record and competitor record */
    addRelation:function(recordList){
        var product_function,pftype,parentID;
        for(var i=0;i<recordList.length;i++){
            if(!recordList[i]['isCompetitor']){
                parentID=i;
                product_function=recordList[i]['product_function'];
                pftype=recordList[i]['pftype'];
                for(var j=i+1;j<recordList.length;j++){
                    if(recordList[j]['product_function']==product_function && recordList[j]['pftype']==pftype && recordList[j]['isCompetitor'])
                    {
                        recordList[j]['parentRowID']=parentID;
                        i++;
                    }
                }
            }
        }
    },
    /*Fetches the values for auto population for value/mt*/
    getAutoPopValues:function(cmp){
        var action=cmp.get("c.getAutoPopValues");
        action.setParams({calcType:cmp.get('v.calcType'),species:cmp.get('v.species')});
        action.setCallback(this,function(resp)
                           {
                               cmp.set("v.autoPopValues",resp.getReturnValue());
                               console.log(resp.getReturnValue()); 
                           });
        $A.enqueueAction(action);
    },
    /*Load calculation type picklist*/
    loadCalcTypes:function(cmp,calcCategory){
        var action=cmp.get("c.getCalcTypes");
        action.setParams({'calcCategory':calcCategory});
        action.setCallback(this,function(resp)
                           {
                               var state=resp.getState();
                               var retval=resp.getReturnValue();
                               console.log(retval);
                               
                               cmp.set("v.isLoading",false);
                               
                               if(state==='SUCCESS'){
                                   if(retval.isSuccess){
                                      cmp.set("v.calcTypeList",retval.data); 
                                   }
                               }else{
                                   
                               }
                           });
        $A.enqueueAction(action);
    },
     /*Load field access for the logged in user*/
    loadFieldAccess:function(cmp,callback){
        var action=cmp.get("c.getPotentialAccessFields");
      
        action.setCallback(this,function(resp)
                           {
                               var state=resp.getState();
                               var retval=resp.getReturnValue();
                               console.log('field access');
                               console.log(retval);
                               
                               cmp.set("v.isLoading",false);
                               callback();
                               if(state==='SUCCESS'){
                                   if(retval.isSuccess){
                                      cmp.set("v.fieldAccess",retval.data); 
                                       
                                   }
                               }else{
                                   
                               }
                           });
        $A.enqueueAction(action);
    },
    /*Load picklist values for species*/
    loadSpecies:function(cmp){
         var action=cmp.get("c.getSpecies");
        action.setCallback(this,function(resp)
                           {
                               var state=resp.getState();
                               var retval=resp.getReturnValue();
                               console.log(retval);
                               if(state==='SUCCESS'){
                                   if(retval.isSuccess){
                                      cmp.set("v.speciesList",retval.data); 
                                   }
                               }else{
                                   
                               }
                           });
        $A.enqueueAction(action);
    }
     /*Load picklist values for product function*/
    ,
     loadProductFunction:function(cmp){
      
         var action=cmp.get("c.getProductFunction");
         action.setParams({'species':cmp.get("v.species")});
         action.setCallback(this,function(resp)
                            {
                                var state=resp.getState();
                                var retval=resp.getReturnValue();
                                console.log('$$$');
                                console.log(retval.data);
                                if(state==='SUCCESS'){
                                    if(retval.isSuccess){
                                        if(retval.data){
                                            retval.data.unshift({label:'None',value:'None'});
                                            cmp.set("v.product_functions",retval.data); 
                                        }
                                    }
                                }else{
                                    
                                }
                            });
         $A.enqueueAction(action);
    },
    /*Loads all the picklist values for types */
    loadTypes:function(cmp){
         var action=cmp.get("c.getTypes");
         
         action.setCallback(this,function(resp)
                            {
                                var state=resp.getState();
                                var retval=resp.getReturnValue();
                                console.log(retval);
                                if(state==='SUCCESS'){
                                    if(retval.isSuccess){
                                        if(retval.data){
                                            retval.data.unshift({label:'None',value:'None'});
                                            cmp.set("v.prod_types",retval.data); 
                                        }
                                    }
                                }else{
                                    
                                }
                            });
         $A.enqueueAction(action);
    }
    /*Deletes a potential record*/
    ,
     deleteRecord : function(cmp,recordId) {
     
        var action = cmp.get("c.deleteRecord");
        action.setParams({Id:recordId});
        action.setCallback(this, function(response) {
              console.log(response.getReturnValue());
            if (response.getState() === "SUCCESS") {
                
                if(response.getReturnValue().isSuccess){
                    this.showDeleteToast();
                    console.log('Delete');
                    //var wrapper=
                    this.getPotential(cmp,cmp.get('v.PotentialEstWrapper').master_pot_id);
                    cmp.set("v.isLoading",false);
                    /*Refresh the Account Record Page to refresh Account Share of wallet */
                    $A.get('e.force:refreshView').fire();
                    
                    
                   
                }
               
            } else {
               	
            }
        });
        $A.enqueueAction(action);
       
	},
    /*Get the user name of logged in user*/
    getUserName:function(cmp){
        var action=cmp.get("c.getUserName");
       
        action.setCallback(this,function(resp)
                           {
                               var state=resp.getState();
                               var retval=resp.getReturnValue();
                               console.log(retval);
                               cmp.set("v.isLoading",false);
                               if(state==='SUCCESS'){
                                   if(retval.isSuccess){
                                        cmp.set("v.userName",retval.data); 
                                   }
                               }else{
                                   
                               }
                           });
        $A.enqueueAction(action);
    },
    /*Get formula list from database based on calc type and species*/
     getFormulaMap:function(cmp){
        var action=cmp.get("c.getFormulaMap");
        action.setParams({calcType:cmp.get('v.calcType'),species:cmp.get('v.species')});
        action.setCallback(this,function(resp)
                           {
                               var state=resp.getState();
                               var retval=resp.getReturnValue();
                               console.log(retval);
                               cmp.set("v.isLoading",false);
                               if(state==='SUCCESS'){
                                   if(retval.isSuccess){
                                        cmp.set("v.formulaMap",retval.data); 
                                   }
                               }else{
                                   
                               }
                           });
        $A.enqueueAction(action);
    }
    /*Show Success delete*/
    ,
    showDeleteToast : function(component, event, helper) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "type":"success",
            "title": $A.get("$Label.c.POT_SUCCESS"),
            "message": $A.get("$Label.c.POT_SUCCESS_DELETE")
        });
        toastEvent.fire();
    },
      showSuccessToast : function(component, event, helper) {
          var toastEvent = $A.get("e.force:showToast");
          toastEvent.setParams({
              "type":"success",
              "title": $A.get("$Label.c.POT_SUCCESS"),
              "message": $A.get("$Label.c.POT_SUCCESS_SAVE")
          });
          toastEvent.fire();
    },
    showCreateToast : function(component, event, helper) {
          var toastEvent = $A.get("e.force:showToast");
          toastEvent.setParams({
              "type":"success",
              "title": $A.get("$Label.c.POT_SUCCESS"),
              "message": $A.get("$Label.c.POT_SUCCESS_CREATE")
          });
          toastEvent.fire();
    },
    productFunctionTypeDupCheck : function(cmp,recordList) {
       // cmp.set('v.errorflag',false);
       // cmp.set('v.errorList',[]);  
    /*Validation for duplicate of product function and type combination*/
        var j=0;
        var currec;
        var errorFlag=0;
        var errorList=cmp.get('v.errorList');
        var fieldlist=[]; 
        var trans;
        var prod_fun_error='prod_fun_error';
        var pftype_error='pftype_error';
        for(var i=0;i<recordList.length;i++){
          
            if(recordList[i]['isCompetitor']==false){
                var dupVal=recordList[i]['product_function']+'-'+recordList[i]['pftype']; 
                for(j=i+1;j<recordList.length;j++){
                    if(recordList[j]['isCompetitor']==false){
                        currec=recordList[j]['product_function']+'-'+recordList[j]['pftype'];
                        trans=this.getTransProdFun(cmp,recordList[j]['product_function'])+'-'+this.getTransType(cmp,recordList[j]['pftype']);
                       
                        if(currec==dupVal){
                            errorFlag=1;
                            /*check if the field is already added in the List*/
                            if(fieldlist.indexOf(trans)==-1){
                                
                                fieldlist.push(trans);
                                /*to highlight the error field*/
                                this.addError(recordList[j],prod_fun_error);
                                this.addError(recordList[j],pftype_error);
                               
                            }
                          
                        }
                    }
                }
            }
        }
        if(errorFlag==1){
            cmp.set('v.errorflag',true);
            errorList.push($A.get("$Label.c.POT_Duplicate_Prod_Function_Type")+' ['+fieldlist.join(',')+']');
            cmp.set('v.errorList',errorList);
        }
	},
    validatePercentShare:function(cmp,recordList){
        
        var prod_fun_error='prod_fun_error';
        var pftype_error='pftype_error';
        /*Sum of percent of share for group for cargill and competitor record should be <=100*/
        var fieldlist=[]; 
        var errorList=cmp.get('v.errorList');
        var errorFlag=0;
        var sum=0;
        var currec;
        var checkedList=[];
       
        for(var i=0;i<recordList.length;i++){
            
            var dupVal=recordList[i]['product_function']+'-'+recordList[i]['pftype'];
            if(recordList[i]['isCompetitor']==false){
               
                sum=recordList[i]['percent_of_share'];
               
                for(var j=i+1;j<recordList.length;j++){
                    
                    if(recordList[j]['isCompetitor']==true){
                        currec=recordList[j]['product_function']+'-'+recordList[j]['pftype'];
                        
                        if(currec==dupVal){
                            
                            sum=sum+recordList[j]['percent_of_share'];
                            
                           
                        }
                    }
                }
                if(sum>100){
                    console.log(sum);
                    errorFlag=1;
                    /*to highlight the error field*/
                    this.addError(recordList[i],prod_fun_error);
                    this.addError(recordList[i],pftype_error);
                    fieldlist.push(this.getTransProdFun(cmp,recordList[i]['product_function'])+'-'+this.getTransType(cmp,recordList[i]['pftype']));
                }
                sum=0;
            }
            
        }
        
        if(errorFlag==1){
            errorList.push($A.get("$Label.c.POT_PERCENT_OF_SHARE_ERROR")+' ['+fieldlist.join(',')+']');
            cmp.set('v.errorflag',true);
            cmp.set('v.errorList',errorList);
        }
    },
    duplicateCompetitorCheck:function(cmp,recordList){
      
        /*Competitor should be unique for a product function*/
        var fieldlist=[]; 
        var errorList=cmp.get('v.errorList');
        var errorFlag=0;
        var sum=0;
        var trans;
        var currec;
        var error_flag_name='competitor_error';
        for(var i=0;i<recordList.length;i++){
            
            if(recordList[i]['isCompetitor']==true && recordList[i]['competitor']!='undefined'){
                var dupVal=recordList[i]['product_function']+'-'+recordList[i]['pftype']+'-'+recordList[i]['competitor'];
                
                for(var j=i+1;j<recordList.length;j++){
                    if(recordList[j]['isCompetitor']==true){
                        currec=recordList[j]['product_function']+'-'+recordList[j]['pftype']+'-'+recordList[j]['competitor'];;
                        
                        if(currec==dupVal){
                            errorFlag=1;
                            /*to highlight the error field*/
                            this.addError(recordList[j],error_flag_name);
                            trans=this.getTransProdFun(cmp,recordList[j]['product_function'])+'-'+this.getTransType(cmp,recordList[j]['pftype']);
                            if(fieldlist.indexOf(trans)==-1){
                                fieldlist.push(trans);
                            }
                        }
                    }
                }
            }
        }
      
        if(errorFlag==1){
            errorList.push($A.get("$Label.c.POT_DUPLICATE_COMPETITOR")+' ['+fieldlist.join(',')+']');
            cmp.set('v.errorflag',true);
            cmp.set('v.errorList',errorList);
        }
    },
    competitorCheck:function(cmp,recordList){
      
        var error_flag_name='competitor_error';
        /*competitor cannot be Cargill*/
        var fieldlist=[]; 
        var errorList=cmp.get('v.errorList');
        var errorFlag=0;
        var sum=0;
        var currec;
      
        
        for(var i=0;i<recordList.length;i++){
            if(recordList[i]['isCompetitor']==true){
                if(recordList[i]['competitor']!=undefined && recordList[i]['competitor']!='' && recordList[i]['competitor'].toUpperCase()=='CARGILL'){
                   
                    errorFlag=1;
                    /*to highlight the error field*/
                    this.addError(recordList[i],error_flag_name);
                 
                    fieldlist.push(this.getTransProdFun(cmp,recordList[i]['product_function'])+'-'+this.getTransType(cmp,recordList[i]['pftype']));
                }
            }
        }
      
        if(errorFlag==1){
            errorList.push($A.get("$Label.c.POT_CARGILL_COMPETITOR_ERROR")+' ['+fieldlist.join(',')+']');
            cmp.set('v.errorflag',true);
            cmp.set('v.errorList',errorList);
        }
    },
    /*Common for all calculation type.Input Number should not exceed*/
    numberLengthCheckForAll:function(cmp,recordList){
     
        var fieldlist=[]; 
        var negativeFields=[]; 
        var errorList=cmp.get('v.errorList');
        var errorFlag=0;
        var negativeNumError=0;
        
        var percent_of_share_error='percent_of_share_error';
        var value_mt_error='value_mt_error';
        
          for(var i=0;i<recordList.length;i++){
          
            if(recordList[i]['value_mt']!=undefined && recordList[i]['value_mt']!=null){
                
                var num=recordList[i]['value_mt'].toString();
                if(num.indexOf(".")==-1 && num.length>12){
                    errorFlag=1;
                    if(fieldlist.indexOf($A.get('$Label.c.POT_VALUE_MT'))==-1){
                    fieldlist.push($A.get('$Label.c.POT_VALUE_MT'));
                    
                    }
                    this.addError(recordList[i],value_mt_error);
                  
                }else if(num.length>15){
                    errorFlag=1;
                   
                    if(fieldlist.indexOf($A.get('$Label.c.POT_VALUE_MT'))==-1){
                        fieldlist.push($A.get('$Label.c.POT_VALUE_MT'));
                        
                    }
                    this.addError(recordList[i],value_mt_error);
                }
               
            }
           
            if(recordList[i]['percent_of_share']!=undefined && recordList[i]['percent_of_share']!=null){
                
                var num=recordList[i]['percent_of_share'].toString();
                var aNum=parseInt(num);
                console.log('$$$NegativeCheck');
                console.log(aNum);
                if(aNum<0){
                     negativeNumError=1;
                    if(negativeFields.indexOf($A.get('$Label.c.POT_OF_SHARE_FIELD'))){
                        negativeFields.push($A.get('$Label.c.POT_OF_SHARE_FIELD')); 
                       
                    }
                     this.addError(recordList[i],percent_of_share_error);
                }
               
            }
          
           
               
            
   
        }
        if(errorFlag==1){
            errorList.push($A.get('$Label.c.POT_NUMBER_LENGTH_ERROR')+' ['+fieldlist.join(',')+']');
            cmp.set('v.errorflag',true);
            cmp.set('v.errorList',errorList);
        }
        if(negativeNumError==1){
            errorList.push($A.get('$Label.c.POT_Number_Negative_Error')+' ['+negativeFields.join(',')+']');
            cmp.set('v.errorflag',true);
            cmp.set('v.errorList',errorList);
        }
          
    },
    /*Input Number and Calculated value should not exceed 14 digit (12-integer,2-fraction)*/
    numberLengthCheckForSP:function(cmp,recordList){
      
        var fieldlist=[]; 
        var errorList=cmp.get('v.errorList');
        var errorFlag=0;
       
        
        var product_function_error='prod_fun_error';
        var pftype_error='pftype_error';
        var competitor_error='competitor_error';
        var annual_volume_error='annual_volume_error';
        var percent_of_share_error='percent_of_share_error';
        var total_error='total_error';
        var value_mt_error='value_mt_error';
       
        console.log('length check');
       
      
        console.log('Number check'+errorFlag);
        console.log(errorFlag);
        for(var i=0;i<recordList.length;i++){
           
            
             if(recordList[i]['annual_volume_mt']!=undefined && recordList[i]['annual_volume_mt']!=null){
                
                var num=recordList[i]['annual_volume_mt'].toString();
                if(num.indexOf(".")==-1 && num.length>12){
                    errorFlag=1;
                  
                    if(fieldlist.indexOf($A.get("$Label.c.POT_ANNUAL_VOLUME_MT"))==-1){
                        fieldlist.push($A.get("$Label.c.POT_ANNUAL_VOLUME_MT"));
                    }
                    this.addError(recordList[i],annual_volume_error);
                   
                }else if(num.length>15){
                    errorFlag=1;
                    
                    if(fieldlist.indexOf($A.get("$Label.c.POT_ANNUAL_VOLUME_MT"))==-1){
                        fieldlist.push($A.get("$Label.c.POT_ANNUAL_VOLUME_MT"));
                    }
                    this.addError(recordList[i],annual_volume_error);
                  
                }
               
            }
                      
            if(recordList[i]['total']!=undefined && recordList[i]['total']!=null && (recordList[i]['annual_volume_mt']==null || recordList[i]['annual_volume_mt']==undefined)){
                
                var num=recordList[i]['total'].toString();
                if(num.indexOf(".")==-1 && num.length>12){
                    errorFlag=1;
                    
                    this.addError(recordList[i],total_error);
                    if(fieldlist.indexOf($A.get('$Label.c.POT_TOTAL'))==-1){
                        fieldlist.push($A.get('$Label.c.POT_TOTAL')); 
                    }
                   
                }else if(num.length>15){
                    errorFlag=1;
                    this.addError(recordList[i],total_error);
                    if(fieldlist.indexOf($A.get('$Label.c.POT_TOTAL'))==-1){
                        fieldlist.push($A.get('$Label.c.POT_TOTAL')); 
                    }
                 
                }
               
            }
   
        }
        if(errorFlag==1){
            errorList.push($A.get('$Label.c.POT_NUMBER_LENGTH_ERROR')+' ['+fieldlist.join(',')+']');
            cmp.set('v.errorflag',true);
            cmp.set('v.errorList',errorList);
        }
    }
    ,
     numberLengthCheckForSPCFE:function(cmp,recordList){
      
        var fieldlist=[]; 
        var errorList=cmp.get('v.errorList');
        var errorFlag=0;
       
        var annual_cfe_error='annual_cfe_error';
        var value_cfe_error='value_cfe_error';
        var cfe_incl_error='cfe_incl_error';
       
        console.log('length check');
       
      
        console.log('Number check'+errorFlag);
        console.log(errorFlag);
        for(var i=0;i<recordList.length;i++){
           
            
             if(recordList[i]['value_cfe']!=undefined && recordList[i]['value_cfe']!=null){
                
                var num=recordList[i]['value_cfe'].toString();
                if(num.indexOf(".")==-1 && num.length>12){
                    errorFlag=1;
                  
                    if(fieldlist.indexOf($A.get("$Label.c.POT_Value_CFE"))==-1){
                        fieldlist.push($A.get("$Label.c.POT_Value_CFE"));
                    }
                    this.addError(recordList[i],value_cfe_error);
                   
                }else if(num.length>15){
                    errorFlag=1;
                    
                    if(fieldlist.indexOf($A.get("$Label.c.POT_Value_CFE"))==-1){
                        fieldlist.push($A.get("$Label.c.POT_Value_CFE"));
                    }
                    this.addError(recordList[i],value_cfe_error);
                  
                }
               
            }
                      
            if(recordList[i]['cfe_incl']!=undefined && recordList[i]['cfe_incl']!=null){
                
                var num=recordList[i]['cfe_incl'].toString();
                if(num.indexOf(".")==-1 && num.length>12){
                    errorFlag=1;
                    
                    this.addError(recordList[i],cfe_incl_error);
                    if(fieldlist.indexOf($A.get('$Label.c.POT_CFE_INCL'))==-1){
                        fieldlist.push($A.get('$Label.c.POT_CFE_INCL')); 
                    }
                   
                }else if(num.length>15){
                    errorFlag=1;
                    this.addError(recordList[i],cfe_incl_error);
                    if(fieldlist.indexOf($A.get('$Label.c.POT_CFE_INCL'))==-1){
                        fieldlist.push($A.get('$Label.c.POT_CFE_INCL')); 
                    }
                 
                }
               
            }
            if(recordList[i]['annual_cfe']!=undefined && recordList[i]['annual_cfe']!=null){
                
                var num=recordList[i]['annual_cfe'].toString();
                if(num.indexOf(".")==-1 && num.length>12){
                    errorFlag=1;
                    
                    this.addError(recordList[i],annual_cfe_error);
                    if(fieldlist.indexOf($A.get('$Label.c.POT_Annual_CFE'))==-1){
                        fieldlist.push($A.get('$Label.c.POT_Annual_CFE')); 
                    }
                   
                }else if(num.length>15){
                    errorFlag=1;
                    this.addError(recordList[i],annual_cfe_error);
                    if(fieldlist.indexOf($A.get('$Label.c.POT_Annual_CFE'))==-1){
                        fieldlist.push($A.get('$Label.c.POT_Annual_CFE')); 
                    }
                 
                }
               
            }
   
        }
        if(errorFlag==1){
            errorList.push($A.get('$Label.c.POT_NUMBER_LENGTH_ERROR')+' ['+fieldlist.join(',')+']');
            cmp.set('v.errorflag',true);
            cmp.set('v.errorList',errorList);
        }
    },
    numberLengthCheckForCC:function(cmp,recordList){
    
        var fieldlist=[]; 
        var errorList=cmp.get('v.errorList');
        var errorFlag=0;
     
        var cycles_yr_error='cycles_yr_error';
        var animal_cycle_error='animal_cycle_error';
        var kg_animal_cycle_error='kg_animal_cycle_error';
        
        console.log('length check');
        
        for(var i=0;i<recordList.length;i++){
         
             if(recordList[i]['cycles_yr']!=undefined && recordList[i]['cycles_yr']!=null){
                
                var num=recordList[i]['cycles_yr'].toString();
                if(num.indexOf(".")==-1 && num.length>12){
                    errorFlag=1;
                    this.addError(recordList[i],cycles_yr_error);
                    if(fieldlist.indexOf($A.get('$Label.c.POT_CYCLES_YR'))==-1){
                        fieldlist.push($A.get('$Label.c.POT_CYCLES_YR')); 
                    }
                  
                }else if(num.length>15){
                    errorFlag=1;
                    this.addError(recordList[i],cycles_yr_error);
                    if(fieldlist.indexOf($A.get('$Label.c.POT_CYCLES_YR'))==-1){
                        fieldlist.push($A.get('$Label.c.POT_CYCLES_YR')); 
                    }
                  
                }
               
            }
           
            if(recordList[i]['animal_cycle']!=undefined && recordList[i]['animal_cycle']!=null){
                
                var num=recordList[i]['animal_cycle'].toString();
                if(num.indexOf(".")==-1 && num.length>12){
                    errorFlag=1;
                    this.addError(recordList[i],animal_cycle_error);
                    if(fieldlist.indexOf($A.get('$Label.c.POT_ANIMALS_CYCLE'))==-1){
                        fieldlist.push($A.get('$Label.c.POT_ANIMALS_CYCLE')); 
                    }
                   
                }else if(num.length>15){
                    errorFlag=1;
                    this.addError(recordList[i],animal_cycle_error);
                    if(fieldlist.indexOf($A.get('$Label.c.POT_ANIMALS_CYCLE'))==-1){
                        fieldlist.push($A.get('$Label.c.POT_ANIMALS_CYCLE')); 
                    }
                    
                }
               
            }
             if(recordList[i]['kg_animal_cycle']!=undefined && recordList[i]['kg_animal_cycle']!=null ){
                
                var num=recordList[i]['kg_animal_cycle'].toString();
                 if(num.indexOf(".")==-1 && num.length>12){
                     errorFlag=1;
                     this.addError(recordList[i],kg_animal_cycle_error);
                     if(fieldlist.indexOf($A.get('$Label.c.POT_KG_ANIMAL_CYCLE'))==-1){
                         fieldlist.push($A.get('$Label.c.POT_KG_ANIMAL_CYCLE')); 
                     }
                 
                 }else if(num.length>15){
                     errorFlag=1;
                     this.addError(recordList[i],kg_animal_cycle_error);
                     if(fieldlist.indexOf($A.get('$Label.c.POT_KG_ANIMAL_CYCLE'))==-1){
                         fieldlist.push($A.get('$Label.c.POT_KG_ANIMAL_CYCLE')); 
                     }
                    
                 }
               
            }
             
   
        }
        if(errorFlag==1){
            errorList.push($A.get('$Label.c.POT_NUMBER_LENGTH_ERROR')+' ['+fieldlist.join(',')+']');
            cmp.set('v.errorflag',true);
            cmp.set('v.errorList',errorList);
        }
    }
    ,
     numberLengthCheckForDAC:function(cmp,recordList){
    
         var fieldlist=[]; 
         var errorList=cmp.get('v.errorList');
         var errorFlag=0;
         var Animals_yr_error='animals_yr_error';
         var kg_hd_day_error='kg_hd_day_error';
         var Days_Fed_yr_error='Days_Fed_yr_error';
       
        console.log('length check');
       
        for(var i=0;i<recordList.length;i++){
           
           
             if(recordList[i]['Animals_yr']!=undefined && recordList[i]['Animals_yr']!=null){
                
                var num=recordList[i]['Animals_yr'].toString();
                if(num.indexOf(".")==-1 && num.length>12){
                    errorFlag=1;
                    this.addError(recordList[i],Animals_yr_error);
                    if(fieldlist.indexOf($A.get('$Label.c.POT_ANIMAL_YR'))==-1){
                        fieldlist.push($A.get('$Label.c.POT_ANIMAL_YR')); 
                    }
                  
                }else if(num.length>15){
                    errorFlag=1;
                    this.addError(recordList[i],Animals_yr_error);
                    if(fieldlist.indexOf($A.get('$Label.c.POT_ANIMAL_YR'))==-1){
                        fieldlist.push($A.get('$Label.c.POT_ANIMAL_YR')); 
                    }
                }
               
            }
            
            if(recordList[i]['kg_hd_day']!=undefined && recordList[i]['kg_hd_day']!=null){
                
                var num=recordList[i]['kg_hd_day'].toString();
                if(num.indexOf(".")==-1 && num.length>12){
                    errorFlag=1;
                    this.addError(recordList[i],kg_hd_day_error);
                    if(fieldlist.indexOf($A.get('$Label.c.POT_KG_HD_DAY'))==-1){
                        fieldlist.push($A.get('$Label.c.POT_KG_HD_DAY'));
                    }
                    
                }else if(num.length>15){
                    errorFlag=1;
                    this.addError(recordList[i],kg_hd_day_error);
                    if(fieldlist.indexOf($A.get('$Label.c.POT_KG_HD_DAY'))==-1){
                        fieldlist.push($A.get('$Label.c.POT_KG_HD_DAY'));
                    }
                   
                }
               
            }
             if(recordList[i]['Days_Fed_yr']!=undefined && recordList[i]['Days_Fed_yr']!=null && Days_Fed_yr_error!=1){
                
                var num=recordList[i]['Days_Fed_yr'].toString();
                if(num.indexOf(".")==-1 && num.length>12){
                    errorFlag=1;
                    this.addError(recordList[i],Days_Fed_yr_error);
                    if(fieldlist.indexOf($A.get('$Label.c.POT_DAYS_FED_YR'))){
                        fieldlist.push($A.get('$Label.c.POT_DAYS_FED_YR'));
                    }
                 
                }else if(num.length>15){
                    errorFlag=1;
                    this.addError(recordList[i],Days_Fed_yr_error);
                    if(fieldlist.indexOf($A.get('$Label.c.POT_DAYS_FED_YR'))){
                        fieldlist.push($A.get('$Label.c.POT_DAYS_FED_YR'));
                    }
                    
                }
               
            }
   
        }
        if(errorFlag==1){
            errorList.push($A.get('$Label.c.POT_NUMBER_LENGTH_ERROR')+' ['+fieldlist.join(',')+']');
            cmp.set('v.errorflag',true);
            cmp.set('v.errorList',errorList);
        }
    },
    
    numberLengthCheckForDACCFE:function(cmp,recordList){
    
         var fieldlist=[]; 
         var errorList=cmp.get('v.errorList');
         var errorFlag=0;
         var Animals_yr_error='animals_yr_error';
         var kg_hd_day_error='kg_hd_day_error';
         var Days_Fed_yr_error='Days_Fed_yr_error';
         var value_cfe_error='value_cfe_error';
         var cfe_incl_error='cfe_incl_error';
       
        console.log('length check');
       
        for(var i=0;i<recordList.length;i++){
           
           
             if(recordList[i]['Animals_yr']!=undefined && recordList[i]['Animals_yr']!=null){
                
                var num=recordList[i]['Animals_yr'].toString();
                if(num.indexOf(".")==-1 && num.length>12){
                    errorFlag=1;
                    this.addError(recordList[i],Animals_yr_error);
                    if(fieldlist.indexOf($A.get('$Label.c.POT_ANIMAL_YR'))==-1){
                        fieldlist.push($A.get('$Label.c.POT_ANIMAL_YR')); 
                    }
                  
                }else if(num.length>15){
                    errorFlag=1;
                    this.addError(recordList[i],Animals_yr_error);
                    if(fieldlist.indexOf($A.get('$Label.c.POT_ANIMAL_YR'))==-1){
                        fieldlist.push($A.get('$Label.c.POT_ANIMAL_YR')); 
                    }
                }
               
            }
            
            if(recordList[i]['kg_hd_day']!=undefined && recordList[i]['kg_hd_day']!=null){
                
                var num=recordList[i]['kg_hd_day'].toString();
                if(num.indexOf(".")==-1 && num.length>12){
                    errorFlag=1;
                    this.addError(recordList[i],kg_hd_day_error);
                    if(fieldlist.indexOf($A.get('$Label.c.POT_KG_HD_DAY'))==-1){
                        fieldlist.push($A.get('$Label.c.POT_KG_HD_DAY'));
                    }
                    
                }else if(num.length>15){
                    errorFlag=1;
                    this.addError(recordList[i],kg_hd_day_error);
                    if(fieldlist.indexOf($A.get('$Label.c.POT_KG_HD_DAY'))==-1){
                        fieldlist.push($A.get('$Label.c.POT_KG_HD_DAY'));
                    }
                   
                }
               
            }
             if(recordList[i]['Days_Fed_yr']!=undefined && recordList[i]['Days_Fed_yr']!=null){
                
                var num=recordList[i]['Days_Fed_yr'].toString();
                if(num.indexOf(".")==-1 && num.length>12){
                    errorFlag=1;
                    this.addError(recordList[i],Days_Fed_yr_error);
                    if(fieldlist.indexOf($A.get('$Label.c.POT_DAYS_FED_YR'))){
                        fieldlist.push($A.get('$Label.c.POT_DAYS_FED_YR'));
                    }
                 
                }else if(num.length>15){
                    errorFlag=1;
                    this.addError(recordList[i],Days_Fed_yr_error);
                    if(fieldlist.indexOf($A.get('$Label.c.POT_DAYS_FED_YR'))){
                        fieldlist.push($A.get('$Label.c.POT_DAYS_FED_YR'));
                    }
                    
                }
               
            }
            
            if(recordList[i]['value_cfe']!=undefined && recordList[i]['value_cfe']!=null){
                
                var num=recordList[i]['value_cfe'].toString();
                if(num.indexOf(".")==-1 && num.length>12){
                    errorFlag=1;
                    this.addError(recordList[i],value_cfe_error);
                    if(fieldlist.indexOf($A.get('$Label.c.POT_Value_CFE '))){
                        fieldlist.push($A.get('$Label.c.POT_Value_CFE '));
                    }
                 
                }else if(num.length>15){
                    errorFlag=1;
                    this.addError(recordList[i],value_cfe_error);
                    if(fieldlist.indexOf($A.get('$Label.c.POT_Value_CFE '))){
                        fieldlist.push($A.get('$Label.c.POT_Value_CFE '));
                    }
                    
                }
               
            }
            
            if(recordList[i]['cfe_incl']!=undefined && recordList[i]['cfe_incl']!=null){
                
                var num=recordList[i]['cfe_incl'].toString();
                if(num.indexOf(".")==-1 && num.length>12){
                    errorFlag=1;
                    this.addError(recordList[i],cfe_incl_error);
                    if(fieldlist.indexOf($A.get('$Label.c.POT_CFE_INCL '))){
                        fieldlist.push($A.get('$Label.c.POT_CFE_INCL '));
                    }
                 
                }else if(num.length>15){
                    errorFlag=1;
                    this.addError(recordList[i],cfe_incl_error);
                    if(fieldlist.indexOf($A.get('$Label.c.POT_CFE_INCL'))){
                        fieldlist.push($A.get('$Label.c.POT_CFE_INCL'));
                    }
                    
                }
               
            }
   
        }
        if(errorFlag==1){
            errorList.push($A.get('$Label.c.POT_NUMBER_LENGTH_ERROR')+' ['+fieldlist.join(',')+']');
            cmp.set('v.errorflag',true);
            cmp.set('v.errorList',errorList);
        }
    },
	
    mandatoryFieldsCheckForSP:function(cmp,recordList){
          /*Sum of percent of share for group for cargill and competitor record should be <=100*/
        var fieldlist=[]; 
        
        var product_function_error='prod_fun_error';
        var pftype_error='pftype_error';
        var competitor_error='competitor_error';
        var annual_volume_error='annual_volume_error';
        var percent_of_share_error='percent_of_share_error';
        var total_error='total_error';
        
        var errorList=cmp.get('v.errorList');
        var errorFlag=0;
        var sum=0;
        var currec;
        var temp={};
        for(var i=0;i<recordList.length;i++){
           
            if(recordList[i]['isCompetitor']==false){
                console.log('validation-'+recordList[i]['total']+''+recordList[i]['percent_of_share']);
                if(recordList[i]['product_function']=="None")
                {
                 
                    if(fieldlist.indexOf($A.get('$Label.c.POT_PRODUCT_FUNCTION_FIELD'))==-1){
                    fieldlist.push($A.get('$Label.c.POT_PRODUCT_FUNCTION_FIELD'));
                    }
                    errorFlag=1;
                    this.addError(recordList[i],product_function_error);
                    recordList[i]['hasError']=true;
                }
                if(recordList[i]['pftype']=='None')
                {
                  
                    if(fieldlist.indexOf($A.get('$Label.c.POT_TYPE'))==-1){
                        fieldlist.push($A.get('$Label.c.POT_TYPE')); 
                    }
                    errorFlag=1;
                    this.addError(recordList[i],pftype_error);
                    recordList[i]['hasError']=true;
                }
                
                
                 if((recordList[i]['annual_volume_mt']===undefined || recordList[i]['annual_volume_mt']===null || recordList[i]['annual_volume_mt']==='') && annual_volume_error!=1)
                {
                   // annual_volume_error=1;
                    //fieldlist.push('Annual Volume'); 
                    //errorFlag=1;
                }
                 if((recordList[i]['percent_of_share']===undefined || recordList[i]['percent_of_share']===null || recordList[i]['percent_of_share']==='' ))
                {
                    if(fieldlist.indexOf($A.get('$Label.c.POT_OF_SHARE_FIELD'))==-1){
                        fieldlist.push($A.get('$Label.c.POT_OF_SHARE_FIELD')); 
                    }
                    errorFlag=1;
                    this.addError(recordList[i],percent_of_share_error);
                    recordList[i]['hasError']=true;
                }
                 if((recordList[i]['total']===undefined || recordList[i]['total']===null || recordList[i]['total']===''))
                {
                   
                    if(fieldlist.indexOf($A.get('$Label.c.POT_TOTAL'))==-1){
                        fieldlist.push($A.get('$Label.c.POT_TOTAL')); 
                    }
                    errorFlag=1;
                    this.addError(recordList[i],total_error);
                    recordList[i]['hasError']=true;
                }
         
            }else{
                 console.log('comp'+recordList[i]['competitor']);
                if((recordList[i]['competitor']===undefined || recordList[i]['competitor']===null || recordList[i]['competitor']===''))
                {
                  
                
                    if(fieldlist.indexOf($A.get('$Label.c.POT_COMPETITOR'))==-1){
                        fieldlist.push($A.get('$Label.c.POT_COMPETITOR'));
                    }
                    errorFlag=1;
                    this.addError(recordList[i],competitor_error);
                   
                }
                 if((recordList[i]['percent_of_share']===undefined || recordList[i]['percent_of_share']===null || recordList[i]['percent_of_share']===''))
                {
                  
                    if(fieldlist.indexOf($A.get('$Label.c.POT_OF_SHARE_FIELD'))==-1){
                        fieldlist.push($A.get('$Label.c.POT_OF_SHARE_FIELD'));
                    }
                    errorFlag=1;
                    this.addError(recordList[i],percent_of_share_error);
                    recordList[i]['hasError']=true;
                }	
                
                
            }
            
        }
       
        if(errorFlag==1){
            
            errorList.push($A.get("$Label.c.POT_MANDATORY_FIELD_ERROR")+' ['+fieldlist.join(',')+']');
            cmp.set('v.errorflag',true);
            cmp.set('v.errorList',errorList);
        }
    },
      mandatoryFieldsCheckForSPCFE:function(cmp,recordList){
          /*Sum of percent of share for group for cargill and competitor record should be <=100*/
        var fieldlist=[]; 
        
        var product_function_error='prod_fun_error';
        var pftype_error='pftype_error';
        var competitor_error='competitor_error';
       
        var percent_of_share_error='percent_of_share_error';
   
        var annual_cfe_error='annual_cfe_error';
        var cfe_incl_error='cfe_incl_error';  
        var errorList=cmp.get('v.errorList');
        var errorFlag=0;
        var sum=0;
        var currec;
        var temp={};
        for(var i=0;i<recordList.length;i++){
           
            if(recordList[i]['isCompetitor']==false){
                console.log('validation-'+recordList[i]['total']+''+recordList[i]['percent_of_share']);
                if(recordList[i]['product_function']=="None")
                {
                 
                    if(fieldlist.indexOf($A.get('$Label.c.POT_PRODUCT_FUNCTION_FIELD'))==-1){
                    fieldlist.push($A.get('$Label.c.POT_PRODUCT_FUNCTION_FIELD'));
                    }
                    errorFlag=1;
                    this.addError(recordList[i],product_function_error);
                    recordList[i]['hasError']=true;
                }
                if(recordList[i]['pftype']=='None')
                {
                  
                    if(fieldlist.indexOf($A.get('$Label.c.POT_TYPE'))==-1){
                        fieldlist.push($A.get('$Label.c.POT_TYPE')); 
                    }
                    errorFlag=1;
                    this.addError(recordList[i],pftype_error);
                    recordList[i]['hasError']=true;
                }
                
                
                /* if((recordList[i]['annual_cfe']===undefined || recordList[i]['annual_cfe']===null || recordList[i]['annual_cfe']===''))
                {
                    
                   
                    if(fieldlist.indexOf($A.get('$Label.c.POT_Annual_CFE')==-1)){
                        fieldlist.push($A.get('$Label.c.POT_Annual_CFE'));
                    }
                    
                    errorFlag=1;
                    this.addError(recordList[i],annual_cfe_error);
                    recordList[i]['hasError']=true;
                }*/
                 if((recordList[i]['percent_of_share']===undefined || recordList[i]['percent_of_share']===null || recordList[i]['percent_of_share']==='' ))
                {
                    if(fieldlist.indexOf($A.get('$Label.c.POT_OF_SHARE_FIELD'))==-1){
                        fieldlist.push($A.get('$Label.c.POT_OF_SHARE_FIELD')); 
                    }
                    errorFlag=1;
                    this.addError(recordList[i],percent_of_share_error);
                    recordList[i]['hasError']=true;
                }
                if((recordList[i]['cfe_incl']===undefined || recordList[i]['cfe_incl']===null || recordList[i]['cfe_incl']==='' ))
                {
                    if(fieldlist.indexOf($A.get('$Label.c.POT_CFE_INCL'))==-1){
                        fieldlist.push($A.get('$Label.c.POT_CFE_INCL')); 
                    }
                    errorFlag=1;
                    this.addError(recordList[i],cfe_incl_error);
                    recordList[i]['hasError']=true;
                }
              
         
            }else{
                 console.log('comp'+recordList[i]['competitor']);
                if((recordList[i]['competitor']===undefined || recordList[i]['competitor']===null || recordList[i]['competitor']===''))
                {
                  
                
                    if(fieldlist.indexOf($A.get('$Label.c.POT_COMPETITOR'))==-1){
                        fieldlist.push($A.get('$Label.c.POT_COMPETITOR'));
                    }
                    errorFlag=1;
                    this.addError(recordList[i],competitor_error);
                   
                }
                 if((recordList[i]['percent_of_share']===undefined || recordList[i]['percent_of_share']===null || recordList[i]['percent_of_share']===''))
                {
                  
                    if(fieldlist.indexOf($A.get('$Label.c.POT_OF_SHARE_FIELD'))==-1){
                        fieldlist.push($A.get('$Label.c.POT_OF_SHARE_FIELD'));
                    }
                    errorFlag=1;
                    this.addError(recordList[i],percent_of_share_error);
                    recordList[i]['hasError']=true;
                }	
                
                
            }
            
        }
       
        if(errorFlag==1){
            
            errorList.push($A.get("$Label.c.POT_MANDATORY_FIELD_ERROR")+' ['+fieldlist.join(',')+']');
            cmp.set('v.errorflag',true);
            cmp.set('v.errorList',errorList);
        }
    },
	
	numberLengthCheckForCCCFE:function(cmp,recordList){
    
         var fieldlist=[]; 
         var errorList=cmp.get('v.errorList');
         var errorFlag=0;
		 
         var cfe_incl_error='cfe_incl_error';  
		 var cycles_yr_error ='cycles_yr_error';
		 var animal_cycle_error ='animal_cycle_error';
		 var cfe_kg_animal_cycle_error ='cfe_kg_animal_cycle_error';
		 var value_cfe_error='value_cfe_error';
		 
        console.log('length check');
       
        for(var i=0;i<recordList.length;i++){
           
           
             if(recordList[i]['cfe_incl']!=undefined && recordList[i]['cfe_incl']!=null){
                
                var num=recordList[i]['cfe_incl'].toString();
                if(num.indexOf(".")==-1 && num.length>12){
                    errorFlag=1;
                    this.addError(recordList[i],cfe_incl_error);
                    if(fieldlist.indexOf($A.get('$Label.c.POT_CFE_INCL'))==-1){
                        fieldlist.push($A.get('$Label.c.POT_CFE_INCL')); 
                    }
                  
                }else if(num.length>15){
                    errorFlag=1;
                    this.addError(recordList[i],cfe_incl_error);
                    if(fieldlist.indexOf($A.get('$Label.c.POT_CFE_INCL'))==-1){
                        fieldlist.push($A.get('$Label.c.POT_CFE_INCL')); 
                    }
                }
               
            }
            
            if(recordList[i]['cycles_yr']!=undefined && recordList[i]['cycles_yr']!=null){
                
                var num=recordList[i]['cycles_yr'].toString();
                if(num.indexOf(".")==-1 && num.length>12){
                    errorFlag=1;
                    this.addError(recordList[i],cycles_yr_error);
                    if(fieldlist.indexOf($A.get('$Label.c.POT_CYCLES_YR'))==-1){
                        fieldlist.push($A.get('$Label.c.POT_CYCLES_YR'));
                    }
                    
                }else if(num.length>15){
                    errorFlag=1;
                    this.addError(recordList[i],cycles_yr_error);
                    if(fieldlist.indexOf($A.get('$Label.c.POT_CYCLES_YR'))==-1){
                        fieldlist.push($A.get('$Label.c.POT_CYCLES_YR'));
                    }
                   
                }
               
            }
             if(recordList[i]['animal_cycle']!=undefined && recordList[i]['animal_cycle']!=null ){
                
                var num=recordList[i]['animal_cycle'].toString();
                if(num.indexOf(".")==-1 && num.length>12){
                    errorFlag=1;
                    this.addError(recordList[i],animal_cycle_error);
                    if(fieldlist.indexOf($A.get('$Label.c.POT_ANIMALS_CYCLE'))){
                        fieldlist.push($A.get('$Label.c.POT_ANIMALS_CYCLE'));
                    }
                 
                }else if(num.length>15){
                    errorFlag=1;
                    this.addError(recordList[i],animal_cycle_error);
                    if(fieldlist.indexOf($A.get('$Label.c.POT_ANIMALS_CYCLE'))){
                        fieldlist.push($A.get('$Label.c.POT_ANIMALS_CYCLE'));
                    }
                    
                }
               
            }
			if(recordList[i]['cfe_kg_animal_cycle']!=undefined && recordList[i]['cfe_kg_animal_cycle']!=null ){
                
                var num=recordList[i]['cfe_kg_animal_cycle'].toString();
                if(num.indexOf(".")==-1 && num.length>12){
                    errorFlag=1;
                    this.addError(recordList[i],cfe_kg_animal_cycle_error);
                    if(fieldlist.indexOf($A.get('$Label.c.POT_KG_ANIMAL_CYCLE'))){
                        fieldlist.push($A.get('$Label.c.POT_KG_ANIMAL_CYCLE'));
                    }
                 
                }else if(num.length>15){
                    errorFlag=1;
                    this.addError(recordList[i],cfe_kg_animal_cycle_error);
                    if(fieldlist.indexOf($A.get('$Label.c.POT_KG_ANIMAL_CYCLE'))){
                        fieldlist.push($A.get('$Label.c.POT_KG_ANIMAL_CYCLE'));
                    }
                    
                }
               
            }
			if(recordList[i]['value_cfe']!=undefined && recordList[i]['value_cfe']!=null ){
                
                var num=recordList[i]['value_cfe'].toString();
                if(num.indexOf(".")==-1 && num.length>12){
                    errorFlag=1;
                    this.addError(recordList[i],value_cfe_error);
                    if(fieldlist.indexOf($A.get('$Label.c.POT_Value_CFE'))){
                        fieldlist.push($A.get('$Label.c.POT_Value_CFE'));
                    }
                 
                }else if(num.length>15){
                    errorFlag=1;
                    this.addError(recordList[i],value_cfe_error);
                    if(fieldlist.indexOf($A.get('$Label.c.POT_Value_CFE'))){
                        fieldlist.push($A.get('$Label.c.POT_Value_CFE'));
                    }
                    
                }
               
            }
   
        }
        if(errorFlag==1){
            errorList.push($A.get('$Label.c.POT_NUMBER_LENGTH_ERROR')+' ['+fieldlist.join(',')+']');
            cmp.set('v.errorflag',true);
            cmp.set('v.errorList',errorList);
        }
    },
	mandatoryFieldsCheckForCCCFE:function(cmp,recordList){
          /*Sum of percent of share for group for cargill and competitor record should be <=100*/
        var fieldlist=[]; 
        
        var product_function_error='prod_fun_error';
        var pftype_error='pftype_error';
        var competitor_error='competitor_error';
       
        var percent_of_share_error='percent_of_share_error';
   
        //var annual_cfe_error='annual_cfe_error';
        var cfe_incl_error='cfe_incl_error';  
		var cycles_yr_error ='cycles_yr_error';
		var animal_cycle_error ='animal_cycle_error';
		var cfe_kg_animal_cycle_error ='cfe_kg_animal_cycle_error';

        var errorList=cmp.get('v.errorList');
        var errorFlag=0;
        var sum=0;
        var currec;
        var temp={};
        for(var i=0;i<recordList.length;i++){
           
            if(recordList[i]['isCompetitor']==false){
                console.log('validation-'+recordList[i]['total']+''+recordList[i]['percent_of_share']);
                if(recordList[i]['product_function']=="None")
                {
                 
                    if(fieldlist.indexOf($A.get('$Label.c.POT_PRODUCT_FUNCTION_FIELD'))==-1){
                    fieldlist.push($A.get('$Label.c.POT_PRODUCT_FUNCTION_FIELD'));
                    }
                    errorFlag=1;
                    this.addError(recordList[i],product_function_error);
                    recordList[i]['hasError']=true;
                }
                if(recordList[i]['pftype']=='None')
                {
                  
                    if(fieldlist.indexOf($A.get('$Label.c.POT_TYPE'))==-1){
                        fieldlist.push($A.get('$Label.c.POT_TYPE')); 
                    }
                    errorFlag=1;
                    this.addError(recordList[i],pftype_error);
                    recordList[i]['hasError']=true;
                }
                 if((recordList[i]['cfe_incl']===undefined || recordList[i]['cfe_incl']===null || recordList[i]['cfe_incl']==='' ))
                {
                    if(fieldlist.indexOf($A.get('$Label.c.POT_CFE_INCL'))==-1){
                        fieldlist.push($A.get('$Label.c.POT_CFE_INCL')); 
                    }
                    errorFlag=1;
                    this.addError(recordList[i],cfe_incl_error);
                    recordList[i]['hasError']=true;
                }
				
                
                 if((recordList[i]['cycles_yr']===undefined || recordList[i]['cycles_yr']===null || recordList[i]['cycles_yr']===''))
                {
                    
                   
                    if(fieldlist.indexOf($A.get('$Label.c.POT_CYCLES_YR')==-1)){
                        fieldlist.push($A.get('$Label.c.POT_CYCLES_YR'));
                    }
                    
                    errorFlag=1;
                    this.addError(recordList[i],cycles_yr_error);
                    recordList[i]['hasError']=true;
                }
				if((recordList[i]['animal_cycle']===undefined || recordList[i]['animal_cycle']===null || recordList[i]['animal_cycle']===''))
                {
                    
                   
                    if(fieldlist.indexOf($A.get('$Label.c.POT_ANIMALS_CYCLE')==-1)){
                        fieldlist.push($A.get('$Label.c.POT_ANIMALS_CYCLE'));
                    }
                    
                    errorFlag=1;
                    this.addError(recordList[i],animal_cycle_error);
                    recordList[i]['hasError']=true;
                }
				if((recordList[i]['cfe_kg_animal_cycle']===undefined || recordList[i]['cfe_kg_animal_cycle']===null || recordList[i]['cfe_kg_animal_cycle']===''))
                {
                    
                   
                    if(fieldlist.indexOf($A.get('$Label.c.POT_KG_ANIMAL_CYCLE')==-1)){
                        fieldlist.push($A.get('$Label.c.POT_KG_ANIMAL_CYCLE'));
                    }
                    
                    errorFlag=1;
                    this.addError(recordList[i],cfe_kg_animal_cycle_error);
                    recordList[i]['hasError']=true;
                }
				
                 if((recordList[i]['percent_of_share']===undefined || recordList[i]['percent_of_share']===null || recordList[i]['percent_of_share']==='' ))
                {
                    if(fieldlist.indexOf($A.get('$Label.c.POT_OF_SHARE_FIELD'))==-1){
                        fieldlist.push($A.get('$Label.c.POT_OF_SHARE_FIELD')); 
                    }
                    errorFlag=1;
                    this.addError(recordList[i],percent_of_share_error);
                    recordList[i]['hasError']=true;
                }
               
              
         
            }else{
                 console.log('comp'+recordList[i]['competitor']);
                if((recordList[i]['competitor']===undefined || recordList[i]['competitor']===null || recordList[i]['competitor']===''))
                {
                  
                
                    if(fieldlist.indexOf($A.get('$Label.c.POT_COMPETITOR'))==-1){
                        fieldlist.push($A.get('$Label.c.POT_COMPETITOR'));
                    }
                    errorFlag=1;
                    this.addError(recordList[i],competitor_error);
                   
                }
                 if((recordList[i]['percent_of_share']===undefined || recordList[i]['percent_of_share']===null || recordList[i]['percent_of_share']===''))
                {
                  
                    if(fieldlist.indexOf($A.get('$Label.c.POT_OF_SHARE_FIELD'))==-1){
                        fieldlist.push($A.get('$Label.c.POT_OF_SHARE_FIELD'));
                    }
                    errorFlag=1;
                    this.addError(recordList[i],percent_of_share_error);
                    recordList[i]['hasError']=true;
                }	
                
                
            }
            
        }
       
        if(errorFlag==1){
            
            errorList.push($A.get("$Label.c.POT_MANDATORY_FIELD_ERROR")+' ['+fieldlist.join(',')+']');
            cmp.set('v.errorflag',true);
            cmp.set('v.errorList',errorList);
        }
    },
    
    mandatoryFieldsCheckForDACCFE:function(cmp,recordList){
          /*Sum of percent of share for group for cargill and competitor record should be <=100*/
        var fieldlist=[]; 
        
        var product_function_error='prod_fun_error';
        var pftype_error='pftype_error';
        var competitor_error='competitor_error';
       
        var percent_of_share_error='percent_of_share_error';
   
        //var annual_cfe_error='annual_cfe_error';
        var cfe_incl_error='cfe_incl_error';  
		var Animals_yr_error ='Animals_yr_error';
		var kg_hd_day_error ='kg_hd_day_error';
		var Days_Fed_yr_error ='Days_Fed_yr_error';

        var errorList=cmp.get('v.errorList');
        var errorFlag=0;
        var sum=0;
        var currec;
        var temp={};
        for(var i=0;i<recordList.length;i++){
           
            if(recordList[i]['isCompetitor']==false){
                console.log('validation-'+recordList[i]['total']+''+recordList[i]['percent_of_share']);
                if(recordList[i]['product_function']=="None")
                {
                 
                    if(fieldlist.indexOf($A.get('$Label.c.POT_PRODUCT_FUNCTION_FIELD'))==-1){
                    fieldlist.push($A.get('$Label.c.POT_PRODUCT_FUNCTION_FIELD'));
                    }
                    errorFlag=1;
                    this.addError(recordList[i],product_function_error);
                    recordList[i]['hasError']=true;
                }
                if(recordList[i]['pftype']=='None')
                {
                  
                    if(fieldlist.indexOf($A.get('$Label.c.POT_TYPE'))==-1){
                        fieldlist.push($A.get('$Label.c.POT_TYPE')); 
                    }
                    errorFlag=1;
                    this.addError(recordList[i],pftype_error);
                    recordList[i]['hasError']=true;
                }
                 if((recordList[i]['cfe_incl']===undefined || recordList[i]['cfe_incl']===null || recordList[i]['cfe_incl']==='' ))
                {
                    if(fieldlist.indexOf($A.get('$Label.c.POT_CFE_INCL'))==-1){
                        fieldlist.push($A.get('$Label.c.POT_CFE_INCL')); 
                    }
                    errorFlag=1;
                    this.addError(recordList[i],cfe_incl_error);
                    recordList[i]['hasError']=true;
                }
				
                
                 if((recordList[i]['Animals_yr']===undefined || recordList[i]['Animals_yr']===null || recordList[i]['Animals_yr']===''))
                {
                    
                   
                    if(fieldlist.indexOf($A.get('$Label.c.POT_ANIMAL_YR')==-1)){
                        fieldlist.push($A.get('$Label.c.POT_ANIMAL_YR'));
                    }
                    
                    errorFlag=1;
                    this.addError(recordList[i],Animals_yr_error);
                    recordList[i]['hasError']=true;
                }
				if((recordList[i]['kg_hd_day']===undefined || recordList[i]['kg_hd_day']===null || recordList[i]['kg_hd_day']===''))
                {
                    
                   
                    if(fieldlist.indexOf($A.get('$Label.c.POT_KG_HD_DAY ')==-1)){
                        fieldlist.push($A.get('$Label.c.POT_KG_HD_DAY '));
                    }
                    
                    errorFlag=1;
                    this.addError(recordList[i],kg_hd_day_error);
                    recordList[i]['hasError']=true;
                }
				if((recordList[i]['Days_Fed_yr']===undefined || recordList[i]['Days_Fed_yr']===null || recordList[i]['Days_Fed_yr']===''))
                {
                    
                   
                    if(fieldlist.indexOf($A.get('$Label.c.POT_DAYS_FED_YR')==-1)){
                        fieldlist.push($A.get('$Label.c.POT_DAYS_FED_YR'));
                    }
                    
                    errorFlag=1;
                    this.addError(recordList[i],Days_Fed_yr_error);
                    recordList[i]['hasError']=true;
                }
				
                 if((recordList[i]['percent_of_share']===undefined || recordList[i]['percent_of_share']===null || recordList[i]['percent_of_share']==='' ))
                {
                    if(fieldlist.indexOf($A.get('$Label.c.POT_OF_SHARE_FIELD'))==-1){
                        fieldlist.push($A.get('$Label.c.POT_OF_SHARE_FIELD')); 
                    }
                    errorFlag=1;
                    this.addError(recordList[i],percent_of_share_error);
                    recordList[i]['hasError']=true;
                }
               
              
         
            }else{
                 console.log('comp'+recordList[i]['competitor']);
                if((recordList[i]['competitor']===undefined || recordList[i]['competitor']===null || recordList[i]['competitor']===''))
                {
                  
                
                    if(fieldlist.indexOf($A.get('$Label.c.POT_COMPETITOR'))==-1){
                        fieldlist.push($A.get('$Label.c.POT_COMPETITOR'));
                    }
                    errorFlag=1;
                    this.addError(recordList[i],competitor_error);
                   
                }
                 if((recordList[i]['percent_of_share']===undefined || recordList[i]['percent_of_share']===null || recordList[i]['percent_of_share']===''))
                {
                  
                    if(fieldlist.indexOf($A.get('$Label.c.POT_OF_SHARE_FIELD'))==-1){
                        fieldlist.push($A.get('$Label.c.POT_OF_SHARE_FIELD'));
                    }
                    errorFlag=1;
                    this.addError(recordList[i],percent_of_share_error);
                    recordList[i]['hasError']=true;
                }	
                
                
            }
            
        }
       
        if(errorFlag==1){
            
            errorList.push($A.get("$Label.c.POT_MANDATORY_FIELD_ERROR")+' ['+fieldlist.join(',')+']');
            cmp.set('v.errorflag',true);
            cmp.set('v.errorList',errorList);
        }
    },
	
    mandatoryFieldsCheckForCC:function(cmp,recordList){
          /*Sum of percent of share for group for cargill and competitor record should be <=100*/
        var fieldlist=[]; 
        
        var animal_cycle_error='animal_cycle_error';
        var cycles_yr_error='cycles_yr_error';
        var kg_animal_cycle_error='kg_animal_cycle_error';
       
       
       
        var product_function_error='prod_fun_error';
        var pftype_error='pftype_error';
        var competitor_error='competitor_error';
     
        var percent_of_share_error='percent_of_share_error';
    
        
        
        var errorList=cmp.get('v.errorList');
        var errorFlag=0;
       
        for(var i=0;i<recordList.length;i++){
           
            if(recordList[i]['isCompetitor']==false){
                
                if(recordList[i]['product_function']=="None")
                {
                    this.addError(recordList[i],product_function_error);
                    if(fieldlist.indexOf($A.get('$Label.c.POT_PRODUCT_FUNCTION_FIELD'))==-1){
                        fieldlist.push($A.get('$Label.c.POT_PRODUCT_FUNCTION_FIELD'));
                    }
                    errorFlag=1;
                   
                }
                if(recordList[i]['pftype']=='None')
                {
                    if(fieldlist.indexOf($A.get('$Label.c.POT_TYPE'))==-1){
                        fieldlist.push($A.get('$Label.c.POT_TYPE')); 
                    }
                  
                    errorFlag=1;
                   
                    this.addError(recordList[i],pftype_error);
                }
                
                
                if((recordList[i]['percent_of_share']===undefined || recordList[i]['percent_of_share']===null || recordList[i]['percent_of_share']==='' ))
                {
                    if(fieldlist.indexOf($A.get('$Label.c.POT_OF_SHARE_FIELD'))==-1){
                        fieldlist.push($A.get('$Label.c.POT_OF_SHARE_FIELD')); 
                    }
                    errorFlag=1;
                    this.addError(recordList[i],percent_of_share_error);
                   
                }
                
                
                if((recordList[i]['cycles_yr']===undefined || recordList[i]['cycles_yr']===null || recordList[i]['cycles_yr']==='' ))
                {
                    
                    if(fieldlist.indexOf($A.get('$Label.c.POT_CYCLES_YR'))==-1){
                    fieldlist.push($A.get('$Label.c.POT_CYCLES_YR')); 
                    }
                    errorFlag=1;
                    this.addError(recordList[i],cycles_yr_error);
                }
                if((recordList[i]['animal_cycle']===undefined || recordList[i]['animal_cycle']===null || recordList[i]['animal_cycle']===''))
                {
                   
                    if(fieldlist.indexOf($A.get('$Label.c.POT_ANIMALS_CYCLE'))==-1){
                    fieldlist.push($A.get('$Label.c.POT_ANIMALS_CYCLE')); 
                    }
                    this.addError(recordList[i],animal_cycle_error);
            		
                    errorFlag=1;
                }
                if((recordList[i]['kg_animal_cycle']===undefined || recordList[i]['kg_animal_cycle']===null || recordList[i]['kg_animal_cycle']===''))
                {
                   
                    if(fieldlist.indexOf($A.get('$Label.c.POT_KG_ANIMAL_CYCLE'))==-1){
                    fieldlist.push($A.get('$Label.c.POT_KG_ANIMAL_CYCLE')); 
                    }
                    this.addError(recordList[i],kg_animal_cycle_error);
                    errorFlag=1;
                    
                }
                
            }else{
                if((recordList[i]['competitor']===undefined || recordList[i]['competitor']===null || recordList[i]['competitor']===''))
                {
                    
                   
                    if(fieldlist.indexOf($A.get('$Label.c.POT_COMPETITOR'))==-1){
                        fieldlist.push($A.get('$Label.c.POT_COMPETITOR'));
                    }
                    this.addError(recordList[i],competitor_error);
                    errorFlag=1;
                   
                }
                  if((recordList[i]['percent_of_share']===undefined || recordList[i]['percent_of_share']===null || recordList[i]['percent_of_share']===''))
                {
                   
                    if(fieldlist.indexOf($A.get('$Label.c.POT_OF_SHARE_FIELD'))==-1){
                        fieldlist.push($A.get('$Label.c.POT_OF_SHARE_FIELD'));
                    }
                    errorFlag=1;
                    this.addError(recordList[i],percent_of_share_error);
                }
            }
            
            
        }
         
        if(errorFlag==1){
            
            errorList.push($A.get("$Label.c.POT_MANDATORY_FIELD_ERROR")+' ['+fieldlist.join(',')+']');
            cmp.set('v.errorflag',true);
            cmp.set('v.errorList',errorList);
        }
    },
     mandatoryFieldsCheckForDAC:function(cmp,recordList){
          /*Sum of percent of share for group for cargill and competitor record should be <=100*/
        var fieldlist=[]; 
        
        var kg_hd_day_error='kg_hd_day_error';
        var Animals_yr_error='Animals_yr_error'
        var Days_Fed_yr_error='Days_Fed_yr_error';
       
        var competitor_error='competitor_error';
       
        var product_function_error='prod_fun_error';
        var pftype_error='pftype_error';
        var competitor_error='competitor_error';
     
        var percent_of_share_error='percent_of_share_error';
    
        
        
        var errorList=cmp.get('v.errorList');
        var errorFlag=0;
        
      
        for(var i=0;i<recordList.length;i++){
           
            if(recordList[i]['isCompetitor']==false){
                
                if(recordList[i]['product_function']=="None")
                {
                   
                    if(fieldlist.indexOf($A.get('$Label.c.POT_PRODUCT_FUNCTION_FIELD'))==-1){
                    fieldlist.push($A.get('$Label.c.POT_PRODUCT_FUNCTION_FIELD'));
                    }
                    errorFlag=1;
                    this.addError(recordList[i],product_function_error);
                  
                    
                }
                if(recordList[i]['pftype']=='None')
                {
                    if(fieldlist.indexOf($A.get('$Label.c.POT_TYPE'))==-1){
                        fieldlist.push($A.get('$Label.c.POT_TYPE')); 
                    }
                    errorFlag=1;
                    this.addError(recordList[i],pftype_error);
                 
                }
                
                
                if((recordList[i]['percent_of_share']===undefined || recordList[i]['percent_of_share']===null || recordList[i]['percent_of_share']==='' ))
                {
                    if(fieldlist.indexOf($A.get('$Label.c.POT_OF_SHARE_FIELD'))==-1){
                        fieldlist.push($A.get('$Label.c.POT_OF_SHARE_FIELD')); 
                    }
                    errorFlag=1;
                    this.addError(recordList[i],percent_of_share_error);
                   
                }
                
                
                if((recordList[i]['Animals_yr']===undefined || recordList[i]['Animals_yr']===null || recordList[i]['Animals_yr']==='' ))
                {
                    if(fieldlist.indexOf($A.get('$Label.c.POT_ANIMAL_YR'))==-1){
                    fieldlist.push($A.get('$Label.c.POT_ANIMAL_YR')); 
                    }
                  
                    errorFlag=1;
                    this.addError(recordList[i],Animals_yr_error);
                }
                if((recordList[i]['kg_hd_day']===undefined || recordList[i]['kg_hd_day']===null || recordList[i]['kg_hd_day']===''))
                {
                  
                    if(fieldlist.indexOf($A.get('$Label.c.POT_KG_HD_DAY'))==-1){
                        fieldlist.push($A.get('$Label.c.POT_KG_HD_DAY')); 
                    }
                    errorFlag=1;
                    this.addError(recordList[i],kg_hd_day_error);
                }
                if((recordList[i]['Days_Fed_yr']===undefined || recordList[i]['Days_Fed_yr']===null || recordList[i]['Days_Fed_yr']===''))
                {
                   
                    if(fieldlist.indexOf($A.get('$Label.c.POT_DAYS_FED_YR'))==-1){
                    fieldlist.push($A.get('$Label.c.POT_DAYS_FED_YR'));
                    }
                    this.addError(recordList[i],Days_Fed_yr_error);
                    errorFlag=1;
                   
                }
                
            }else{
                if((recordList[i]['competitor']===undefined || recordList[i]['competitor']===null || recordList[i]['competitor']===''))
                {
                    if(fieldlist.indexOf($A.get('$Label.c.POT_COMPETITOR'))==-1){
                        fieldlist.push($A.get('$Label.c.POT_COMPETITOR'));
                    }
                    errorFlag=1;
                    this.addError(recordList[i],competitor_error);
                }
                if((recordList[i]['percent_of_share']===undefined || recordList[i]['percent_of_share']===null || recordList[i]['percent_of_share']===''))
                {   
                    if(fieldlist.indexOf($A.get('$Label.c.POT_OF_SHARE_FIELD'))==-1){
                        fieldlist.push($A.get('$Label.c.POT_OF_SHARE_FIELD'));
                    }
                    errorFlag=1;
                    this.addError(recordList[i],percent_of_share_error);
                    
                }
            }
            
            
        }
         
        if(errorFlag==1){
            
            errorList.push($A.get("$Label.c.POT_MANDATORY_FIELD_ERROR")+' ['+fieldlist.join(',')+']');
            cmp.set('v.errorflag',true);
            cmp.set('v.errorList',errorList);
        }
    }
    ,
    
    isPotentialExist:function(cmp,calcType,species,accId,callback){
        var action=cmp.get("c.getDuplicatecheckMasterPotential");
        action.setParams({'calcType':calcType,'species':species,'accId':accId});
        action.setCallback(this,function(resp){
            console.log(resp.getReturnValue());
            var res=(resp.getReturnValue())
            if(res.isSuccess){
                  callback(res.data,true);
            }else{
                console.log('unable to fetch');
                callback(res.data,false);
            }
            
        });
        $A.enqueueAction(action);
        
    }, 
  
    /*Get tranlations of the product function*/
    getTransProdFun:function(cmp,species){
        var product_functions=cmp.get("v.product_functions");
        var ret=null;
        for(var i=0;i<product_functions.length;i++){
            if(product_functions[i]['value']==species){
                ret=product_functions[i]['label'];
            }
        }
        return ret;
    },
   /*Get tranlations of the Types*/
    getTransType:function(cmp,ptype){
        var prod_types=cmp.get("v.prod_types");
        var ret=null;
        for(var i=0;i<prod_types.length;i++){
            if(prod_types[i]['value']==ptype){
                ret=prod_types[i]['label'];
            }
        }
        return ret;
    },
    clearErrorFlag:function(recordList){
        for(var i=0;i<recordList.length;i++){
            if(recordList[i]['errorFields']!=undefined){
                recordList[i]['errorFields']={};
            }
        }
        
    },
    addError:function(rec,error_field){
        if(rec['errorFields']){
            rec['errorFields'][error_field]=true;
            
        }else{
            rec['errorFields']={};
            rec['errorFields'][error_field]=true;
          
            //temp[$A.get('$Label.c.POT_PRODUCT_FUNCTION_FIELD')]=true;
            
        }
     
    }
})