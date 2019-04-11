@isTest(SeeAllData=true)
public class PotentialTestDataFactory {

    public static Account Accountcreatemethod(string Name) {
    
    Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Consumer').getRecordTypeId();
    
    
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
       return a ;
        
    }
    public static Id insertCompetitorAccount(String Name) {
        
        Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Competitor').getRecordTypeId();
        
        
        //Account> accts = new List<Account>();        
        
        Account a = new Account();
        a.Name= Name ;
        a.Business__c='US';
        a.Prospect_Validated__c = true;
        a.RecordTypeId = devRecordTypeId ;
        a.Auto_Validate__c=true;
        //  accts.add(a);
        // }
        insert a ;
        return a.Id ;
        
    }
    public static Id insertContact(String Name,Id parentAccount) {
        
        Contact c=new Contact(LastName=Name,AccountId=parentAccount);
        insert c;
        return c.Id;
        
    }
     public static Cres_Master_Potential__c Materpotentialmethod(ID id, string EstimationType , string Species ) {
     
   
          
       Cres_Master_Potential__c  Materpotential = new Cres_Master_Potential__c ();        
        //Materpotential.Name = 'name';
        Materpotential.Estimation_Type__c =EstimationType;
        Materpotential.Species__c=Species;
        Materpotential.Account__c = id;
        
        insert Materpotential;
        
        return Materpotential;
        
    }
     public static Potential__c  SimplePotentialEstimatemethod( ID id,string ProductFunction,string Type,integer valuemt,integer AnnualVolumeMT,integer share) {
     
   
           Potential__c childpotential = new Potential__c();
            childpotential.Name='name';
            childpotential.Master_Potential__c = id;
            childpotential.Product_Function__c=ProductFunction;
            childpotential.Type__c=Type;
            childpotential.Value_MT__c=valuemt;
            childpotential.Cycles_yr__c=1;
            childpotential.Animals_cycle__c=1;
            childpotential.kg_animal_cycle__c=1;
            childpotential.Annual_Volume_MT__c=AnnualVolumeMT;
            //childpotential.Total__c= 0.1;
            childpotential.Competitor__c='Cargill';
            childpotential.share__c=2;
            //childpotential.Volume__c=0;
           // childpotential.Contribution__c=.0021;
           
        insert childpotential;
        
        return childpotential;
        
    }
    
     public static Potential__c  SimplePotentialEstimatemethod_noncargill( ID id,string ProductFunction,string Type,integer valuemt,integer AnnualVolumeMT,integer share) {
     
   
           Potential__c childpotential = new Potential__c();
            childpotential.Name='name';
            childpotential.Master_Potential__c = id;
            childpotential.Product_Function__c=ProductFunction;
            childpotential.Type__c=Type;
            childpotential.Value_MT__c=valuemt;
            childpotential.Cycles_yr__c=1;
            childpotential.Animals_cycle__c=1;
            childpotential.kg_animal_cycle__c=1;
            childpotential.Annual_Volume_MT__c=AnnualVolumeMT;
            //childpotential.Total__c= 0.1;
            childpotential.Competitor__c='xyz';
            childpotential.share__c=2;
            //childpotential.Volume__c=0;
           // childpotential.Contribution__c=.0021;
           
        insert childpotential;
        
        return childpotential;
        
    }
    
    
    
     public static Potential__c  Cyclesconsummethod( ID id,string ProductFunction,string Type,integer valuemt,integer cyclesyr,integer Animalscycle,integer kganimalcycle,integer share) {
     
   
           Potential__c childpotential = new Potential__c();
            childpotential.Name='name';
            childpotential.Master_Potential__c = id;
            childpotential.Product_Function__c=ProductFunction;
            childpotential.Type__c=Type;
            childpotential.Value_MT__c=valuemt;
            childpotential.Cycles_yr__c=cyclesyr;
            childpotential.Animals_cycle__c=Animalscycle;
            //kg_animal_cycle__c
            childpotential.kg_animal_cycle__c=kganimalcycle;
           // childpotential.Annual_Volume_MT__c=AnnualVolumeMT;
            //childpotential.Total__c= 0.1;
            childpotential.Competitor__c='Cargill';
            childpotential.share__c=2;
            //childpotential.Volume__c=0;
           // childpotential.Contribution__c=.0021;
           
        insert childpotential;
        
        return childpotential;
        
    }
    public static Potential__c  DailyAnimalConsumethod( ID id,string ProductFunction,string Type,integer valuemt,integer Animalsyr,integer kghdday,integer Days_Fed,integer share) {
     
   
           Potential__c childpotential = new Potential__c();
            childpotential.Name='name';
            childpotential.Master_Potential__c = id;
            childpotential.Product_Function__c=ProductFunction;
            childpotential.Type__c=Type;
            childpotential.Value_MT__c=valuemt;
           // childpotential.Cycles_yr__c=1;
            childpotential.Animals_yr__c=Animalsyr;
            childpotential.kg_hd_day__c=kghdday;
            childpotential.Days_Fed_yr__c=Days_Fed;
            
           // childpotential.kg_animal_cycle__c=1;
           // childpotential.Annual_Volume_MT__c=AnnualVolumeMT;
            //childpotential.Total__c= 0.1;
            childpotential.Competitor__c='Cargill';
            childpotential.share__c=2;
            //childpotential.Volume__c=0;
           // childpotential.Contribution__c=.0021;
           
        insert childpotential;
        
        return childpotential;
        
    }
    
        
     public static Potential__c  SimplePotentialEstimate_CFEmethod( ID id,string ProductFunction,string Type,integer valuemt,integer Annual_CFE ,integer share,integer AnnualVolumeMT,integer CFE_incl) {
     
   
           Potential__c childpotential = new Potential__c();
            childpotential.Name='name';
            childpotential.Master_Potential__c = id;
            childpotential.Product_Function__c=ProductFunction;
            childpotential.Type__c=Type;
            
            childpotential.Value_CFE__c=valuemt;
            childpotential.Annual_CFE__c=Annual_CFE;            
            childpotential.Animals_cycle__c=1;
            childpotential.kg_animal_cycle__c=1;
            childpotential.Annual_Volume_MT__c=AnnualVolumeMT;
            //childpotential.Total__c= 0.1;
            childpotential.Competitor__c='Cargill';
            childpotential.share__c=share;
            childpotential.CFE_incl__c=CFE_incl;
           // childpotential.Contribution__c=.0021;
           
        insert childpotential;
        
        return childpotential;
        
    }
     
    
 

public static Potential__c  DailyAnimal_cfeConsumethod( ID id,string ProductFunction,string Type,integer Annual_CFE,integer alue_CFE,integer Animalscycle,integer Cycles_yr,integer share,integer CFE_kg_animal,integer CFE_incl,integer Animalsyr) {
     
   
           Potential__c childpotential = new Potential__c();
            //Potential__c childpotential = new Potential__c();
            childpotential.Name='name';
            childpotential.Master_Potential__c = id;
            childpotential.Product_Function__c=ProductFunction;
            childpotential.Type__c=Type;
            childpotential.Animals_yr__c=Animalsyr;
            childpotential.Annual_CFE__c =Annual_CFE;
            childpotential.Value_CFE__c =alue_CFE;
            childpotential.Animals_cycle__c=Animalscycle;
             childpotential.Cycles_yr__c= Cycles_yr;
            //childpotential.kg_animal_cycle__c=kganimalcycle;
           // childpotential.Annual_Volume_MT__c=AnnualVolumeMT;
            childpotential.CFE_kg_animal_cycle__c= CFE_kg_animal;
            //Total__c
            childpotential.CFE_incl__c=CFE_incl;
            
            
            childpotential.Competitor__c='Cargill';
            childpotential.share__c=2;
            //childpotential.Volume__c=0;
           // childpotential.Contribution__c=.0021;
           
        insert childpotential;
        
        return childpotential;
        
    }
    
    
   public static Potential__c  Cyclesconsummethod_CFE( ID id,string ProductFunction,string Type,integer value_CFE ,integer CFE_incl , integer Cycles_yr,integer Animalscycle,integer CFE_kg_animal,integer CAnnual_CFE ,integer share) {
     
   
           Potential__c childpotential = new Potential__c();
           
            //childpotential.Name='name';
            childpotential.Master_Potential__c = id;
           
            childpotential.Product_Function__c=ProductFunction;
            childpotential.Type__c=Type;
            
            childpotential.Value_CFE__c = value_CFE;
            childpotential.CFE_incl__c =CFE_incl;
            childpotential.Cycles_yr__c =Cycles_yr;
            childpotential.Animals_cycle__c =Animalscycle;
            childpotential.CFE_kg_animal_cycle__c =CFE_kg_animal;
            childpotential.Annual_CFE__c =CAnnual_CFE;
            childpotential.share__c=share;
            
            childpotential.Annual_CFE_CON__c=21;
            childpotential.Competitor__c='Cargill'; 
             system.debug('childpotential *****************************'+childpotential );
           
        insert childpotential;
        system.debug('childpotential&&&&&&&&&&&&&&&&&&&&&'+childpotential);
        return childpotential;
        
    }
    public static void insertPotentialFieldAccess(){
        insert new Potential_Field_Access__c(SetupOwnerId=UserInfo.getOrganizationId());
    }

   
     public static User getTestUser(Id profID, String fName, String lName, String Business){
        String orgId = UserInfo.getOrganizationId();
        String dateString = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');
       
        Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));
        String uniqueName = orgId + dateString + randomInt;
        User tuser = new User(  firstname = fName,
                                lastName = lName,
                                email = uniqueName + '@test' + orgId + '.org',
                                Username = uniqueName + '@test' + orgId + '.org',
                                EmailEncodingKey = 'ISO-8859-1',
                                Alias = uniqueName.substring(18, 23),
                                TimeZoneSidKey = 'America/Los_Angeles',
                                LocaleSidKey = 'en_US',
                                LanguageLocaleKey = 'en_US',
                                ProfileId = profId,
                                Business_Unit__c = Business);
        return tuser;
    }
    
    }