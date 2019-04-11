@isTest 
public class PotentialCtrl_Test 
{
    static testMethod void testMethodPostive() 
    {
      
      Account acc =PotentialTestDataFactory.Accountcreatemethod('test654');
      
      PotentialCtrl.getAccountName(acc.id);
        Cres_Master_Potential__c cmp = PotentialTestDataFactory.Materpotentialmethod(acc.id, 'Simple Potential Estimate' ,'Pork');
      Potential__c    pot = PotentialTestDataFactory.SimplePotentialEstimatemethod( cmp.id,'Creep','Premix',100,10,10 );
     PotentialCtrl.getPotentialEstList(acc.id,'Volume');
    // PotentialCtrl.getLabelTranslationMap();
     // PotentialCtrl.savePotential(pot.name);
    }
   
    
    static testMethod void testMethodPostive_1() 
    {
      
      Account acc =PotentialTestDataFactory.Accountcreatemethod('test654');
      
      PotentialCtrl.getAccountName(acc.id);
       // Cres_Master_Potential__c cmp = PotentialTestDataFactory.Materpotentialmethod(acc.id, 'Simple Potential Estimate' ,'Pork');
     // Potential__c    pot = PotentialTestDataFactory.SimplePotentialEstimatemethod( cmp.id,'Creep','Premix',100,10,10 );
     PotentialCtrl.getPotentialEstList(acc.id,'Volume');
   
     PotentialCtrl.getUserName();
    }
     static testMethod void testMethodgetPotentialEstWrapper() 
    {
      
      Account acc =PotentialTestDataFactory.Accountcreatemethod('test654');
      
      PotentialCtrl.getAccountName(acc.id);
      Cres_Master_Potential__c cmp = PotentialTestDataFactory.Materpotentialmethod(acc.id, 'Simple Potential Estimate' ,'Pork');
      Potential__c    pot = PotentialTestDataFactory.SimplePotentialEstimatemethod( cmp.id,'Creep','Premix',100,10,10 );
      PotentialCtrl.getPotentialEstList(acc.id,'Volume');
      PotentialCtrl.getPotentialEstWrapper(cmp .id);
     // PotentialCtrl.savePotential(pot.name);
    }
    
     static testMethod void testMethodgetPotentialEstWrapper_nonCargill() 
    {
      
      Account acc =PotentialTestDataFactory.Accountcreatemethod('test654');
      
      PotentialCtrl.getAccountName(acc.id);
      Cres_Master_Potential__c cmp = PotentialTestDataFactory.Materpotentialmethod(acc.id, 'Simple Potential Estimate' ,'Pork');
     Potential__c    potc = PotentialTestDataFactory.SimplePotentialEstimatemethod( cmp.id,'Creep','Premix',100,10,10 );
      Potential__c    pot = PotentialTestDataFactory.SimplePotentialEstimatemethod_noncargill( cmp.id,'Creep','Premix',100,10,10 );
   
      //PotentialCtrl.getPotentialEstList(acc.id);
      PotentialCtrl.getPotentialEstWrapper(cmp .id);
     // PotentialCtrl.savePotential(pot.name);
    }//getProductFunction deleteRecord
    
     static testMethod void testMethodgetProductFunction() 
    {
      
      Account acc =PotentialTestDataFactory.Accountcreatemethod('test654');
      
      PotentialCtrl.getAccountName(acc.id);
      Cres_Master_Potential__c cmp = PotentialTestDataFactory.Materpotentialmethod(acc.id, 'Simple Potential Estimate' ,'Pork');
      Potential__c    pot = PotentialTestDataFactory.SimplePotentialEstimatemethod( cmp.id,'Creep','Premix',100,10,10 );
      PotentialCtrl.getPotentialEstList(acc.id,'Volume');
      PotentialCtrl.getPotentialEstWrapper(cmp .id);
      PotentialCtrl.getProductFunction('Pork');
      PotentialCtrl.getSpecies();
      PotentialCtrl.getCalcTypes('Volume');
      PotentialCtrl.getTypes();      
      PotentialCtrl.getAutoPopValues('Simple Potential Estimate','Pork');
    }
      static testMethod void testMethodgetdeleteRecord() 
    {
      
      Account acc =PotentialTestDataFactory.Accountcreatemethod('test654');
      
      PotentialCtrl.getAccountName(acc.id);
      Cres_Master_Potential__c cmp = PotentialTestDataFactory.Materpotentialmethod(acc.id, 'Simple Potential Estimate' ,'Pork');
      Potential__c    pot = PotentialTestDataFactory.SimplePotentialEstimatemethod( cmp.id,'Creep','Premix',100,10,10 );
      //PotentialCtrl.getPotentialEstList(acc.id);
      PotentialCtrl.deleteRecord(cmp .id);
      
    }
       static testMethod void testMethodgetdpotentialEstStr() 
    {
      
      Account acc =PotentialTestDataFactory.Accountcreatemethod('test654');
      
      PotentialCtrl.getAccountName(acc.id);
      Cres_Master_Potential__c cmp = PotentialTestDataFactory.Materpotentialmethod(acc.id, 'Simple Potential Estimate' ,'Pork');
      Potential__c    pot = PotentialTestDataFactory.SimplePotentialEstimatemethod( cmp.id,'Creep','Premix',100,10,10 );
      //PotentialCtrl.getPotentialEstList(acc.id);
      PotentialCtrl.deleteRecord(cmp .id);
      
    }
 static testMethod void testMethodgetdpotensavePotential() 
    {
      // PotentialCtrl onj= new PotentialCtrl();
      Account acc =PotentialTestDataFactory.Accountcreatemethod('test654');
       //PotentialEstWrapper onj = new PotentialEstWrapper();
      PotentialCtrl.getAccountName(acc.id);
      Cres_Master_Potential__c cmp = PotentialTestDataFactory.Materpotentialmethod(acc.id, 'Simple Potential Estimate' ,'Pork');
      Potential__c    pot = PotentialTestDataFactory.SimplePotentialEstimatemethod( cmp.id,'Creep','Premix',100,10,10 );
      
       Cres_Master_Potential__c  Materpotentialcyc = PotentialTestDataFactory.Materpotentialmethod(acc.id,'Cycle Consumption','Pork' );
     //system.debug('Materpotential ::::::::::::::'+Materpotential );
    
     Potential__c childpotentialcyc = PotentialTestDataFactory.Cyclesconsummethod(Materpotentialcyc.id,'Creep','Premix',100,10,10,10,10 );
      
      Cres_Master_Potential__c  Materpotentialda = PotentialTestDataFactory.Materpotentialmethod(acc.id,'Daily Animal Consumption','Pork' );
     //system.debug('MaterpotentialDailyAnimalConsumption ::::::::::::::'+Materpotential );
    
    Potential__c childpotentialds = PotentialTestDataFactory.DailyAnimalConsumethod(Materpotentialda.id,'Creep','Premix',100,10,10,10,10 );
      
      
      
      
      PotentialCtrl.PotentialEstWrapper wrap=(PotentialCtrl.PotentialEstWrapper)PotentialCtrl.getPotentialEstWrapper(cmp.id).data;
      wrap.mode='Edit';
       string onj =  JSON.serialize(wrap);
      //system.debug();
       PotentialCtrl.savePotential(onj);
    }
    
    static testMethod void testMethodgetdpotensavePotentialCycle_Con() 
    {
      // PotentialCtrl onj= new PotentialCtrl();
      Account acc =PotentialTestDataFactory.Accountcreatemethod('test654');
       //PotentialEstWrapper onj = new PotentialEstWrapper();
      PotentialCtrl.getAccountName(acc.id);
     
      
       Cres_Master_Potential__c  Materpotentialcyc = PotentialTestDataFactory.Materpotentialmethod(acc.id,'Cycle Consumption','Pork' );
     //system.debug('Materpotential ::::::::::::::'+Materpotential );
    
     Potential__c childpotentialcyc = PotentialTestDataFactory.Cyclesconsummethod(Materpotentialcyc.id,'Creep','Premix',100,10,10,10,10 );
      
      Cres_Master_Potential__c  Materpotentialda = PotentialTestDataFactory.Materpotentialmethod(acc.id,'Daily Animal Consumption','Pork' );
     //system.debug('MaterpotentialDailyAnimalConsumption ::::::::::::::'+Materpotential );
    
    Potential__c childpotentialds = PotentialTestDataFactory.DailyAnimalConsumethod(Materpotentialda.id,'Creep','Premix',100,10,10,10,10 );
      
      
      
      
      PotentialCtrl.PotentialEstWrapper wrap=(PotentialCtrl.PotentialEstWrapper)PotentialCtrl.getPotentialEstWrapper(Materpotentialcyc.id).data;
      wrap.mode='Edit';
       string onj =  JSON.serialize(wrap);
      //system.debug();
       PotentialCtrl.savePotential(onj);
    }
    
    
    
    static testMethod void testMethodgetdpotensavePotentialDaily_Animal() 
    {
      // PotentialCtrl onj= new PotentialCtrl();
      Account acc =PotentialTestDataFactory.Accountcreatemethod('test654');
       //PotentialEstWrapper onj = new PotentialEstWrapper();
      PotentialCtrl.getAccountName(acc.id);
     
      Cres_Master_Potential__c  Materpotentialda = PotentialTestDataFactory.Materpotentialmethod(acc.id,'Daily Animal Consumption','Pork' );
     //system.debug('MaterpotentialDailyAnimalConsumption ::::::::::::::'+Materpotential );
    
    Potential__c childpotentialds = PotentialTestDataFactory.DailyAnimalConsumethod(Materpotentialda.id,'Creep','Premix',100,10,10,10,10 );
      
      
      
      
      PotentialCtrl.PotentialEstWrapper wrap=(PotentialCtrl.PotentialEstWrapper)PotentialCtrl.getPotentialEstWrapper(Materpotentialda.id).data;
      wrap.mode='Edit';
       string onj =  JSON.serialize(wrap);
      //system.debug();
       PotentialCtrl.savePotential(onj);
    }
    
    static testMethod void testMethodgetdpotensavePotentialDaily_Animal_CFE() 
    {
      // PotentialCtrl onj= new PotentialCtrl();
      Account acc =PotentialTestDataFactory.Accountcreatemethod('test654');
       //PotentialEstWrapper onj = new PotentialEstWrapper();
      PotentialCtrl.getAccountName(acc.id);
     
      Cres_Master_Potential__c  Materpotentialda = PotentialTestDataFactory.Materpotentialmethod(acc.id,'Daily Animal Consumption - CFE','Pork' );
     //system.debug('MaterpotentialDailyAnimalConsumption ::::::::::::::'+Materpotential );
    
    Potential__c childpotentialds = PotentialTestDataFactory.DailyAnimalConsumethod(Materpotentialda.id,'Creep','Premix',100,10,10,10,10 );
      
      
      
      
      PotentialCtrl.PotentialEstWrapper wrap=(PotentialCtrl.PotentialEstWrapper)PotentialCtrl.getPotentialEstWrapper(Materpotentialda.id).data;
      wrap.mode='Edit';
       string onj =  JSON.serialize(wrap);
      //system.debug();
       PotentialCtrl.savePotential(onj);
    } 
    
    static testMethod void testMethodgetdpotensavePotential_SPE_CFE() 
    {
      // PotentialCtrl onj= new PotentialCtrl();
      Account acc =PotentialTestDataFactory.Accountcreatemethod('test654');
       //PotentialEstWrapper onj = new PotentialEstWrapper();
      PotentialCtrl.getAccountName(acc.id);
     
      Cres_Master_Potential__c  Materpotentialda = PotentialTestDataFactory.Materpotentialmethod(acc.id,'Simple Potential Estimate - CFE','Pork' );
     //system.debug('MaterpotentialDailyAnimalConsumption ::::::::::::::'+Materpotential );
    
    Potential__c childpotentialds = PotentialTestDataFactory.DailyAnimalConsumethod(Materpotentialda.id,'Creep','Premix',100,10,10,10,10 );
      
      
      
      
      PotentialCtrl.PotentialEstWrapper wrap=(PotentialCtrl.PotentialEstWrapper)PotentialCtrl.getPotentialEstWrapper(Materpotentialda.id).data;
      wrap.mode='Edit';
       string onj =  JSON.serialize(wrap);
      //system.debug();
       PotentialCtrl.savePotential(onj);
    } 
    
    static testMethod void testMethodgetdpotensavePotential_CC_CFE() 
    {
      // PotentialCtrl onj= new PotentialCtrl();
      Account acc =PotentialTestDataFactory.Accountcreatemethod('test654');
       //PotentialEstWrapper onj = new PotentialEstWrapper();
      PotentialCtrl.getAccountName(acc.id);
     
      Cres_Master_Potential__c  Materpotentialda = PotentialTestDataFactory.Materpotentialmethod(acc.id,'Cycle Consumption - CFE','Pork' );
     //system.debug('MaterpotentialDailyAnimalConsumption ::::::::::::::'+Materpotential );
    
    Potential__c childpotentialds = PotentialTestDataFactory.DailyAnimalConsumethod(Materpotentialda.id,'Creep','Premix',100,10,10,10,10 );
      
      
      
      
      PotentialCtrl.PotentialEstWrapper wrap=(PotentialCtrl.PotentialEstWrapper)PotentialCtrl.getPotentialEstWrapper(Materpotentialda.id).data;
      wrap.mode='Edit';
       string onj =  JSON.serialize(wrap);
      //system.debug();
       PotentialCtrl.savePotential(onj);
    } 
    
     static testMethod void testMethodgetProductFunction1() 
    {
      
      Account acc =PotentialTestDataFactory.Accountcreatemethod('test654');
      
      PotentialCtrl.getAccountName(acc.id);
      Cres_Master_Potential__c cmp = PotentialTestDataFactory.Materpotentialmethod(acc.id, 'Simple Potential Estimate' ,'Pork');
      Potential__c    pot = PotentialTestDataFactory.SimplePotentialEstimatemethod( cmp.id,'Creep','Premix',100,10,10 );
      PotentialCtrl.getDuplicatecheckMasterPotential('Simple Potential Estimate' ,'Pork',acc.id);
      PotentialCtrl.isAccountLocked(acc.id);
      PotentialCtrl.getFormulaMap('Simple Potential Estimate' ,'Pork');
     // PotentialCtrl.getRecordTypeIDByDevName('Potential','Cres_Master_Potential__c');
      
    
      
    }
    static testMethod void testgetPotentialAccessFields() {
        PotentialTestDataFactory.insertPotentialFieldAccess();
        PotentialCtrl.getPotentialAccessFields();
    }
    static testMethod void testgetCalcCategories() {
        PotentialTestDataFactory.insertPotentialFieldAccess();
        PotentialCtrl.getCalcCategories();
    }
    


    
}