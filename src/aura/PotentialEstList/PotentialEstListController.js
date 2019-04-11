({
    showNewPage : function(cmp, event, helper) {
        /*shows Potential Panel for Potential Creation*/
        cmp.set('v.mode','New');
        var calcPanel=cmp.find("calcpanel");/*Get the object of Potential CalcPanel*/
        
        var calcCategory = cmp.get("v.calcCategory");        
        /*Loads the picklist values for calculation type and Species
            This is aura method*/
        calcPanel.loadCalcTypeSpecies(calcCategory);
            
        
        
    },
    showInEditMode:function(cmp,event,helper){
        /*Operations to handle when a Potential is being edited.This method is executed when
        Event is fired from child component and received by this component*/
        var rowID=event.getParam('rowID');
        
        var calcType=event.getParam('data').calcType;
        var species=event.getParam('data').species;
        cmp.set("v.mode",'Edit');/*Change the mode to Edit.In this mode potentialCalc Panel will be
        visible to the user*/
        var calcPanel=cmp.find("calcpanel");
        calcPanel.set("v.renderTable",true);
        calcPanel.initializeParams(calcType,species); /*Initialize parameters in the Calc. Panel*/
        calcPanel.loadAutoPopValues();/*Load the predefined values from custom settings,objects*/
        calcPanel.loadPotentialData(rowID); /*Load the potential that is being edited*/
        calcPanel.loadFieldAccess();/*Loads Access of fields to be displayed*/
    
    },
     loadMasterPotential:function(cmp,event,helper){
         
      
         var calcCategory = cmp.get("v.calcCategory");
         /*Executed when landing page is being loaded*/
         cmp.set("v.isLoading",true);/*To show spinnner*/
         helper.getAccountStatus(cmp,cmp.get("v.recordId"));/*Checks if the account is locked or not*/
         
         helper.getPotentialEstList(cmp,calcCategory);/*Loads the Master potential Data to display in Landing page*/
         
      
       
    
    },
    deletePotential:function(cmp,event,helper){
        /*This method deletes a Master Potential Record*/
        /*Called when User confirms from PopUp*/
        var rowID = event.getParam('rowID');
        console.log('rowID' +rowID);
        var estList=cmp.get("v.estList");
        console.log('estList' +estList);
        cmp.set("v.isLoading",true);
        helper.deleteRecord(cmp,estList[rowID]['master_pot_id']);/*pass the master potential record
        id to be deleted*/
        
    }
   
   
    
    
})