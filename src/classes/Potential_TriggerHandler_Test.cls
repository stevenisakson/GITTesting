@isTest(SeeAllData=true)
public with sharing class  Potential_TriggerHandler_Test{
    
    private static testMethod void testPotential_TriggerHandleMethod() {
           
        PotenCalculationOperative__c potencuop = new PotenCalculationOperative__c();
        
        potencuop.Name='SPE_All_All_Complete';
        //from masterpoten
        potencuop.TypeOfCalculation__c='Simple Potential Estimate';
        potencuop.Species__c='Pork';
        //from Potential
        potencuop.Product_Function__c='Creep';
        potencuop.Type__c='Premix';
        
        potencuop.Total__c='( Annual_Volume_MT__c * Value_MT__c )';
        potencuop.Contribution__c='( ( share__c * Total__c ) / 100 )';
        potencuop.Volume__c='( ( share__c * Annual_Volume_MT__c ) / 100 )';
        
        insert potencuop ;
        
       // system.debug('potencuop ::::::::::::::'+potencuop);
            
    Account account = new Account();
    Account accts = PotentialTestDataFactory.Accountcreatemethod('test123451');
   //  system.debug('accts ::::::::::::::'+accts );
    Cres_Master_Potential__c  Materpotential = PotentialTestDataFactory.Materpotentialmethod(accts.id,'Simple Potential Estimate','Pork' );
     //system.debug('Materpotential ::::::::::::::'+Materpotential );
    
    Potential__c childpotential = PotentialTestDataFactory.SimplePotentialEstimatemethod(Materpotential.id,'Creep','Premix',100,10,10 );
     //system.debug('childpotential ::::::::::::::'+childpotential );
    
    }
   
    
     
 
 
 private static testMethod void DailyAnimalConsumption_TriggerHandleMethod() {
           
    PotenCalculationOperative__c potencuop = new PotenCalculationOperative__c();
        
        potencuop.Name='SPE_All_All_Complete';
        //from masterpoten
        potencuop.TypeOfCalculation__c='Daily Animal Consumption';
        potencuop.Species__c='Pork';
        //from Potential
        potencuop.Product_Function__c='Creep';
        potencuop.Type__c='Premix';        
        potencuop.Total__c ='( Annual_Volume_MT__c * Value_MT__c )';        
        potencuop.Contribution__c='( ( share__c * Total__c ) / 100 )';      
      //  potencuop.VOLUME__C='( ( share__c * Annual_Volume_MT__c ) / 100 )';
         potencuop.ANNUAL_VOLUME_MT__C ='( ( Animals_yr__c * kg_hd_day__c * Days_Fed_yr__c ) / 1000 )';
    
        insert potencuop ;
        
        
        
          // system.debug('potencuopDailyAnimalConsumption ::::::::::::::'+potencuop);
            
    Account account = new Account();
    Account accts = PotentialTestDataFactory.Accountcreatemethod('test1234511');
      //system.debug('accts DailyAnimalConsumption::::::::::::::'+accts );
    Cres_Master_Potential__c  Materpotential = PotentialTestDataFactory.Materpotentialmethod(accts.id,'Daily Animal Consumption','Pork' );
     //system.debug('MaterpotentialDailyAnimalConsumption ::::::::::::::'+Materpotential );
    
    Potential__c childpotential = PotentialTestDataFactory.DailyAnimalConsumethod(Materpotential.id,'Creep','Premix',100,10,10,10,10 );
    // system.debug('childpotential DailyAnimalConsumption::::::::::::::'+childpotential );
    
    }
    
    
    private static testMethod void CycleConsumption_TriggerHandleMethod() {
 
        PotenCalculationOperative__c potencuop = new PotenCalculationOperative__c();
        
       // potencuop.Name='SPE_All_All_Complete';
        //from masterpoten
        potencuop.TypeOfCalculation__c='Cycle Consumption';
        potencuop.Species__c='Pork';
        //from Potential
        potencuop.Product_Function__c='Creep';
        potencuop.Type__c='Complete';
        
        potencuop.Total__c ='( Annual_Volume_MT__c * Value_MT__c )';
        
        potencuop.Contribution__c='( ( share__c * Total__c ) / 100 )';      
        potencuop.VOLUME__C='( ( share__c * Annual_Volume_MT__c ) / 100 )';
        
         potencuop.ANNUAL_VOLUME_MT__C ='( ( Cycles_yr__c * Animals_cycle__c * kg_animal_cycle__c ) / 1000 )';
    
        insert potencuop ;
          Account account = new Account();
    Account accts = PotentialTestDataFactory.Accountcreatemethod('test1234511');
      //system.debug('accts ::::::::::::::'+accts );
    Cres_Master_Potential__c  Materpotential = PotentialTestDataFactory.Materpotentialmethod(accts.id,'Cycle Consumption','Pork' );
     //system.debug('Materpotential ::::::::::::::'+Materpotential );
    
    Potential__c childpotential = PotentialTestDataFactory.Cyclesconsummethod(Materpotential.id,'Creep','Premix',100,10,10,10,10 );
     //system.debug('childpotential ::::::::::::::'+childpotential );
        
        
        
        }
        
        
        private static testMethod void testPotentialdeleteTriggerHandleMethod() {
           
        PotenCalculationOperative__c potencuop = new PotenCalculationOperative__c();
        
        potencuop.Name='SPE_All_All_Complete';
        //from masterpoten
        potencuop.TypeOfCalculation__c='Simple Potential Estimate';
        potencuop.Species__c='Pork';
        //from Potential
        potencuop.Product_Function__c='Creep';
        potencuop.Type__c='Premix';
        
        potencuop.Total__c='( Annual_Volume_MT__c * Value_MT__c )';
        potencuop.Contribution__c='( ( share__c * Total__c ) / 100 )';
        potencuop.Volume__c='( ( share__c * Annual_Volume_MT__c ) / 100 )';
        
        insert potencuop ;
        
         //system.debug('potencuop ::::::::::::::'+potencuop);
            
    Account account = new Account();
    Account accts = PotentialTestDataFactory.Accountcreatemethod('test123451');
     // system.debug('accts ::::::::::::::'+accts );
    Cres_Master_Potential__c  Materpotential = PotentialTestDataFactory.Materpotentialmethod(accts.id,'Simple Potential Estimate','Pork' );
     //system.debug('Materpotential ::::::::::::::'+Materpotential );
    
    Potential__c childpotential = PotentialTestDataFactory.SimplePotentialEstimatemethod(Materpotential.id,'Creep','Premix',100,10,10 );
     //system.debug('childpotential ::::::::::::::'+childpotential );
    delete childpotential ;    
    }
    
    
    
    
    
    private static testMethod void testPotential_CFE_TriggerHandleMethod() {
           
        PotenCalculationOperative__c potencuop = new PotenCalculationOperative__c();
        
       // potencuop.Name='SPE_All_All_Complete';
        //from masterpoten
        potencuop.TypeOfCalculation__c='Simple Potential Estimate - CFE';
        potencuop.Species__c='Pork';
        //from Potential
        potencuop.Product_Function__c='Starter';
        potencuop.Type__c='Premix';
        
        potencuop.Total__c='( Annual_CFE__c * Value_CFE__c )';
        potencuop.Contribution__c='( ( share__c * Total__c ) / 100 )';
      //  potencuop.Volume__c='( ( share__c * Annual_Volume_MT__c ) / 100 )';
         potencuop.Annual_Volume__c ='( ( Annual_CFE__c * CFE_incl__c ) / 100 )';
         potencuop.ANNUAL_CFE_CON__C ='( ( share__c * Annual_CFE__c ) / 100 )';
         
        insert potencuop ;
        
        system.debug('potencuop cfe::::::::::::::'+potencuop);
            
    Account account = new Account();
    Account accts = PotentialTestDataFactory.Accountcreatemethod('test123451');
     system.debug('accts cfe::::::::::::::'+accts );
    Cres_Master_Potential__c  Materpotential = PotentialTestDataFactory.Materpotentialmethod(accts.id,'Simple Potential Estimate - CFE','Pork' );
    system.debug('Materpotential cfe::::::::::::::'+Materpotential );
    
    Potential__c childpotential = PotentialTestDataFactory.SimplePotentialEstimate_CFEmethod(Materpotential.id,'Starter','Premix',100,10,10,10,10 );
    system.debug('childpotential cfe::::::::::::::'+childpotential );
    
    }
    
       private static testMethod void DailyAnimalConsumption_CFETriggerHandleMethod() {
           
    PotenCalculationOperative__c potencuop = new PotenCalculationOperative__c();
        
        potencuop.Name='SPE_All_All_Complete';
        //from masterpoten
        potencuop.TypeOfCalculation__c='Daily Animal Consumption - CFE';
        potencuop.Species__c='Pork';
        //from Potential
        potencuop.Product_Function__c='Creep';
        potencuop.Type__c='Premix';        
        potencuop.Total__c ='( Annual_CFE__c * Value_CFE__c )';        
        potencuop.Contribution__c='( ( share__c * Total__c ) / 100 )';      
        potencuop.ANNUAL_VOLUME__C='( ( Annual_CFE__c * CFE_incl__c ) / 100 )';    
        potencuop.ANNUAL_CFE__C ='( ( Animals_yr__c * kg_hd_day__c * Days_Fed_yr__c ) / 1000 )';
        potencuop.ANNUAL_CFE_CON__C='( ( share__c * Annual_CFE__c ) / 100 )';

        insert potencuop ;
        
        
        
          // system.debug('potencuopDailyAnimalConsumption ::::::::::::::'+potencuop);
            
    Account account = new Account();
    Account accts = PotentialTestDataFactory.Accountcreatemethod('test1234511');
      //system.debug('accts DailyAnimalConsumption::::::::::::::'+accts );
    Cres_Master_Potential__c  Materpotential = PotentialTestDataFactory.Materpotentialmethod(accts.id,'Daily Animal Consumption - CFE','Pork' );
     //system.debug('MaterpotentialDailyAnimalConsumption ::::::::::::::'+Materpotential );
    
    Potential__c childpotential = PotentialTestDataFactory.DailyAnimalConsumethod(Materpotential.id,'Creep','Premix',100,10,10,10,10 );
    // system.debug('childpotential DailyAnimalConsumption::::::::::::::'+childpotential );
    
    }
   
    
     public  static testMethod  void Accountcreatemethodwithshare() {
    
    Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Consumer').getRecordTypeId();
    Decimal sum = 0;
    
        //Account> accts = new List<Account>();        
     
            Account a = new Account();
            a.Name= 'Name' ;
            a.Business__c='US';
            a.Prospect_Validated__c = true;
            a.RecordTypeId = devRecordTypeId ;
            a.Auto_Validate__c=true;
          //  accts.add(a);
       // }
        insert a ;
        system.debug('Account **************'+a);
        
         Cres_Master_Potential__c  Materpotential = new Cres_Master_Potential__c ();        
        //Materpotential.Name = 'name';
        Materpotential.Estimation_Type__c ='Simple Potential Estimate';
        Materpotential.Species__c='Pork';
        Materpotential.Account__c = a.id;
        
        insert Materpotential;
         system.debug('Materpotential**************'+Materpotential);
         
          
       Potential__c childpotential111 = new Potential__c();
             childpotential111.parentAccount__c=a.id;
            childpotential111.Name='name';
            childpotential111.Master_Potential__c = Materpotential.id;
            childpotential111.Product_Function__c='Creep';
            childpotential111.Type__c='Premix';
            childpotential111.Value_MT__c=100;
            childpotential111.Annual_Volume_MT__c=10;
            childpotential111.share__c=40;
            childpotential111.Competitor__c='Cargill';
           
            insert childpotential111;
            
            
         
       list<Potential__c> ptlist1=new List<Potential__c>();
        
         Potential__c childpotential1 = new Potential__c();
         childpotential1.parentAccount__c=a.id;
            childpotential1.Name='name';
            childpotential1.Master_Potential__c = Materpotential.id;
            childpotential1.Product_Function__c='Creep';
            childpotential1.Type__c='Premix';
           childpotential1.Value_MT__c=100;
            childpotential1.Annual_Volume_MT__c=10;
            childpotential1.share__c=50;
            childpotential1.Competitor__c='Cargill';
            childpotential1.share__c=500;
        // insert   childpotential1;
          
       // ptlist1.add(childpotential1);
        
        Potential__c childpotential2 = new Potential__c();
            childpotential2.Master_Potential__c = Materpotential.id;
          childpotential2.Master_Potential__c = Materpotential.id;
            childpotential2.Product_Function__c='Creep';
            childpotential2.Type__c='Premix';
           childpotential2.Value_MT__c=100;
            childpotential2.Annual_Volume_MT__c=10;
            childpotential2.Competitor__c='abc';
            childpotential2.share__c=182;
       childpotential2.parentAccount__c=a.id;
         //  insert   childpotential2;
        ptlist1.add(childpotential2);
        
        
        insert ptlist1;
        
        system.debug('childpotential2**************'+childpotential2);
        
      
        
    }
    
    
 
    
}