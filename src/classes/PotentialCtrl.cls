/*
* Author:Sam Boban
* Desciption: Controller for lighting components PotentialCalcPanel and PotentialEstList 
* Main Functionalities are
    * 1.Displaying Master potential records,
    * 2.Deleting Master potential 
    * 3.Creating potential record and Editing 
    * 4.Deleting Potential record
*/
public class PotentialCtrl {

    /*Returns Account Name:used in Mobile App*/
    @auraEnabled
    public static String getAccountName( Id accountID){
        string request ='';
        
        Account Accrecord =[select id,name,Prospect_Validated__c,Status__c from Account where  ID =: accountID];
        
        system.debug('Accrecord :::::::::::::::'+Accrecord);
        
        request = Accrecord.name;
        system.debug('request::::::::'+request);
        
        Return request;
        
    }
     /*Wrapper for master potential and potential object*/
    public class PotentialEstWrapper{
         
        @auraenabled
        public String master_pot_id,accId;
        @auraenabled
        public String estName,species;
        @auraenabled
        public String calcType,mode,transCalcType,transSpecies;
      
      
        
        @auraenabled 
        public Decimal share_of_wallet,share_of_volume,Total_Potential,Total_Annual_Volume_MT,overridden_count,
            share_of_cfe,total_annual_cfe;
        
        @auraenabled
        public List<PotentialWrapper> potwrapper=new List<PotentialWrapper>();
        
        public PotentialEstWrapper(Id master_pot_id,String estName,String calcType,String species){
            this.master_pot_id=master_pot_id;//master potential ID
            this.estName=estName;
            this.calcType=calcType;
         
            this.species=species;
            
            share_of_wallet=0;/*Defaulting the values,else it will not be appear in wrapper*/
            Total_Potential=0;
            share_of_volume=0;
            Total_Annual_Volume_MT=0;
            
        }
        public PotentialEstWrapper(){
            share_of_wallet=0;
            Total_Potential=0;
            share_of_volume=0;
            Total_Annual_Volume_MT=0;
            
        }
  
    }
    /*Wrapper for potential alone. Referred in PotentialEstWrapper*/
    public class PotentialWrapper{

       
        @auraenabled
        public String master_pot_id,pot_id,pftype,competitor,sales_person,product_function,mode,species;
            
        @auraenabled
        public Decimal annual_volume_mt,value_mt,total,volume,percent_of_share,contribution,
            cycles_yr,animal_yr,kg_animal_cycle,animal_cycle,Animals_yr,kg_hd_day,Days_Fed_yr;
        
        /*For CFE Fields*/
        @auraenabled
        public Decimal value_cfe,cfe_incl,annual_cfe,annual_volume,annual_cfe_con,cfe_kg_animal_cycle;

        @auraenabled
        public Boolean isCompetitor,isNew,totalOverridden;
         
        public PotentialWrapper(){
            
        }
       /* public PotentialWrapper(String pot_id,String pftype,String competitor,String 
                                sales_person,String product_function,Decimal annual_volume_mt,Decimal value_mt,Decimal volume,
                                Decimal percent_of_share,Decimal contribution,Decimal total,Boolean isNew,Boolean isCompetitor){
                                  // this.accId=accId;
                                    this.master_pot_id=master_pot_id;
                                    this.pot_id=pot_id;
                                    this.pftype=pftype;
                                    this.total=total;
                                    this.competitor=competitor;
                                    this.sales_person=sales_person;
                                    this.product_function=product_function;
                                    this.annual_volume_mt=annual_volume_mt;
                                    this.value_mt=value_mt;
                                    this.volume=volume;
                                    this.percent_of_share=percent_of_share;
                                    this.contribution=contribution;
                                    this.isNew=isNew;
                                    this.isCompetitor=isCompetitor;
         }*/
        
         
        
    }
    /*returns list of Master Potential Estimations available for an account*/
    public static String STD_SUCCESS='success';
    public static String STD_NO='No Records';
    public static String SUCCESS_SAVE='Successfully Saved';
    public static String STD_EXCEPTION=System.Label.POT_STD_EXCEPTION;
    public static String EDIT_MODE='Edit';
    public static String NEW_MODE='New';
    public static String EXCEPTION_MSG='';
    public static String STD_DELETE='Record Deleted';
    public static String DUP_ERROR='DUPLICATES_DETECTED';
    public static String INSUFFICIENT_ACCESS='INSUFFICIENT_ACCESS_ON_CROSS_REFERENCE_ENTITY';
    public static String NUMBER_OUTSIDE_VALID_RANGE='NUMBER_OUTSIDE_VALID_RANGE';
   
    
    
    public static String POTENTIAL_OBJECT='Potential__c';
    public static String MASTER_POTENTIAL_OBJECT='Cres_Master_Potential__c';
    public static String SPECIES_FIELD='Species__c';
    public static String species='species';
    public static String PROD_FUN_FIELD='Product_Function__c';
    
    private static Schema.DescribeSObjectResult d = Schema.SObjectType.Potential__c;
    
    private static Map<String,Schema.RecordTypeInfo> rtMapByName = d.getRecordTypeInfosByName();
    
     private static Schema.DescribeSObjectResult masterp = Schema.SObjectType.Cres_Master_Potential__c;
    
    private static Map<String,Schema.RecordTypeInfo> mrtMapByName = masterp.getRecordTypeInfosByName();
    
    /*Returns Master potential record list*/
    @auraenabled
    public static Response getPotentialEstList(Id accId,String calcCategory){
        
        /*to Provide Translations for species and Calculation Type.Key-English Value-Translated value*/
        Map<String,String> speciesTransMap=CalculateUtility.getSpeciesTransMap();
        Map<String,String> calcTypeTransMap=CalculateUtility.getEstimationTypeTransMap();
        
        System.debug('$$$'+speciesTransMap);
        String pot_Name='';
        String trans_Species;
        String trans_CalcType;
        /*Fetch Master potential Details*/
        List<Cres_Master_Potential__c> mpList=[select id,Estimation_Type__c,Species__c,Name,share_of_wallet__c,Total_Annual_Volume_MT__c,share_of_volume__c,Total_Potential__c,
                                               Overridden_Count__c,Total_Annual_CFE__c,share_of_cfe__c from Cres_Master_Potential__c
                                              where Account__c=:accId and Calculation_Category__c=:calcCategory order by createddate asc];
        List<PotentialEstWrapper> pew=new List<PotentialEstWrapper>();
        
        PotentialEstWrapper wrap;
        
        if(mpList.size()>0){
          
            for(Cres_Master_Potential__c mp:mpList){
               
                /*Translate species and calc type*/
                trans_Species=speciesTransMap.get(mp.Species__c)!=null?speciesTransMap.get(mp.Species__c):mp.Species__c;
                trans_CalcType=calcTypeTransMap.get(mp.Estimation_Type__c)!=null?calcTypeTransMap.get(mp.Estimation_Type__c):mp.Estimation_Type__c;
                
                pot_Name=trans_Species+' - '+trans_CalcType;
                System.debug('$$$'+pot_Name);
                
                wrap=new PotentialEstWrapper(mp.Id,pot_Name,mp.Estimation_Type__c,mp.Species__c);
                //share_of_volume,Total_Potential,Total_Annual_Volume_MT;
                if(mp.share_of_wallet__c!=null){
                    wrap.share_of_wallet=mp.share_of_wallet__c;
                }
                if(mp.share_of_volume__c!=null){
                     wrap.share_of_volume=mp.share_of_volume__c; 
                }
                if(mp.Total_Potential__c!=null){
                wrap.Total_Potential=mp.Total_Potential__c;
                }
                if(mp.Total_Annual_Volume_MT__c!=null){
                wrap.Total_Annual_Volume_MT=mp.Total_Annual_Volume_MT__c;
                }
                if(mp.Total_Annual_CFE__c!=null){
                    wrap.total_annual_cfe=mp.Total_Annual_CFE__c;
                }
                if(mp.share_of_cfe__c!=null){
                    wrap.share_of_cfe=mp.share_of_CFE__c;
                }else{
                    wrap.share_of_cfe=0;
                }
               
                /*Fields which indicates if any related potential records has total value overrideen.Only for S
                 Simple Potential Estimate*/
                wrap.overridden_count=mp.Overridden_Count__c;
                
                pew.add(wrap);
               // pew.add(new PotentialEstWrapper(mp.Id,mp.Name,mp.Estimation_Type__c,mp.share_of_wallet__c,mp.Species__c));
            }
        }
       
        if(pew.size()>0){
            return new Response(true,STD_SUCCESS,pew);
        }else{
            return new Response(true,STD_NO,pew);
        }
       
    }
    /*Returns Master potential and its related potential details, if Id of master potential is provided*/
    @auraenabled
    public static Response getPotentialEstWrapper(Id mpot_Id){
        System.debug('$$$'+mpot_Id);
        /*Translate species and calc type*/
        Map<String,String> speciesTransMap=CalculateUtility.getSpeciesTransMap();
        Map<String,String> calcTypeTransMap=CalculateUtility.getEstimationTypeTransMap();
        
        PotentialEstWrapper pew=new PotentialEstWrapper();
        List<PotentialWrapper> pwList=new List<PotentialWrapper>();
        
        /*Queries Master potential Details*/
        List<Cres_Master_Potential__c> mpList=[select id,toLabel(Estimation_Type__c),toLabel(Species__c),Name,share_of_wallet__c,Total_Annual_Volume_MT__c,share_of_volume__c,Total_Potential__c,Overridden_Count__c,Share_of_CFE__c from Cres_Master_Potential__c
                                               where id=:mpot_Id];
        if(mpList.size()>0){
            if(mpList[0].share_of_wallet__c!=null){
                pew.share_of_wallet=mpList[0].share_of_wallet__c;
            }else{
                pew.share_of_wallet=0;
            }
            pew.master_pot_id=mpList[0].id;
            pew.species=mpList[0].species__c;
            /*Translated values*/
            pew.transSpecies=speciesTransMap.get(mpList[0].species__c)!=null?speciesTransMap.get(mpList[0].species__c):mpList[0].species__c;
            //if value is null, this variable will not be present in wrapper,so make it 0
            if(mpList[0].share_of_volume__c!=null){
                pew.share_of_volume=mpList[0].share_of_volume__c;
            }else{
                pew.share_of_volume=0;
            }
            if(mpList[0].Share_of_CFE__c!=null){
                pew.share_of_cfe=mpList[0].Share_of_CFE__c;
            }else{
                pew.share_of_cfe=0;
            }
            pew.calcType=mpList[0].Estimation_Type__c;
            /*Translated values*/
            pew.transCalcType=calcTypeTransMap.get(mpList[0].Estimation_Type__c)!=null?calcTypeTransMap.get(mpList[0].Estimation_Type__c):mpList[0].Estimation_Type__c;
        }
        /*All potential Records which are cargill records. if isCompetitor__c=false it is Cargill record*/
        List<Potential__c> potList=getPotential(mpot_id,false);
        
        /*All potential Records which are competitor records.if isCompetitor__c=true it is competitor record*/
        List<Potential__c> competitorList=getPotential(mpot_id,true);
          
        PotentialWrapper potwrapper;
        /*Ordering both Cargill records and its related competitor records sequentially in wrapper*/
        if(potList.size()>0){
         
            for(Potential__c pot:potList){
                
                potwrapper=new PotentialWrapper();
               
                loadWrapperValues(potwrapper,pot);
                pwList.add(potwrapper);
                
                for(Potential__c potcomp:competitorList){
                    /*Finds the related competitor records using Product function and Type */
                    if(pot.Product_Function__c==potcomp.Product_Function__c && pot.Type__c==potcomp.Type__c){
                        potwrapper=new PotentialWrapper();
                      
                        loadWrapperValues(potwrapper,potcomp);
                        pwList.add(potwrapper); 
                    }
                }
            }
          
              /*String accId,String master_pot_id,String pot_id,String pftype,String competitor,String 
                                    sales_person,String product_function,Decimal annual_volume_mt,Decimal value_mt,Decimal volume,
                                    Decimal percent_of_share,Decimal contribution*/         
        }
        if(pwList.size()>0){
            pew.potwrapper=pwList;
            return new Response(true,STD_SUCCESS,pew);
        }else{
            return new Response(true,STD_NO,pew);
        }
       
    }
    /*Creating and Updating Potential records*/
    @auraenabled
    public static Response savePotential(String potentialEstStr){
        Boolean isSuccess=true;
        Savepoint sp = Database.setSavepoint();
        PotentialEstWrapper wrapper=new PotentialEstWrapper();
        List<PotentialWrapper> pwList;
        List<PotentialWrapper> potwrapperlist=new List<PotentialWrapper>();
        
        List<Potential__c> potList=new List<Potential__c>();
        String mode,species,calcType;
        
        String mpot_id,accId;
        Potential__c pot;
        try{
            /*Deserialze the JSON records to wrapper*/
            wrapper=(PotentialEstWrapper)JSON.deserialize(potentialEstStr,PotentialEstWrapper.class); 
            mode=wrapper.mode;
            species=wrapper.species;
            calcType=wrapper.calcType;
            accId=wrapper.accId;
            
            /*Fetch potential records only*/
            potwrapperlist=wrapper.potwrapper;
            /*If the user wants to create a new master potential and its potential record the mode will be NEW*/
            if(mode.equals(NEW_MODE)){
              
                Cres_Master_Potential__c mp=new Cres_Master_Potential__c(Name=species+' - '+calcType,
                                                                         Estimation_Type__c=calcType,Species__c=species,Account__c=accId);
                mp.RecordTypeId=getRecordTypeIDByDevName(System.Label.Master_Potential_RecordType,MASTER_POTENTIAL_OBJECT);
                insert mp;
            
                mpot_id=mp.Id;
            }else{
                /*if the mode is Edit assign the master potential id we need to edit*/
                 mpot_id=wrapper.master_pot_id;
            }
            System.debug('$$$Mpot'+mpot_id);
           
            /*
            * public String accId,master_pot_id,pot_id,pftype,competitor,sales_person,product_function;
            @auraenabled
            public Decimal annual_volume_mt,value_mt,total,volume,percent_of_share,contribution;
            @auraenabled
            public Decimal isCompetitor;
            */ 
            /*Loop throught the wrapper to save/update potential records*/
            for(PotentialWrapper pw:potwrapperlist){
               
                /*if the potential record is of Simple Potential Estimate*/
                if(calcType==System.Label.SimplePotentialEstimate){
                    pot=new Potential__c(Name='test',Competitor__c=pw.competitor, Product_Function__c=pw.product_function,Total__c=pw.total,
                                                           Type__c=pw.pftype,Annual_Volume_MT__c=pw.annual_volume_mt, Value_MT__c=pw.value_mt, share__c=pw.percent_of_share,
                                                           Salesperson__c=pw.sales_person);
                    
                    if(pw.isNew){
                        pot.RecordTypeId=getRecordTypeIDByDevName(System.Label.Simple_Potential_Estimate_RecordType,POTENTIAL_OBJECT);
                    }
                 }
                 /*if the potential record is of Cycle Consumption*/
                else if(calcType==System.Label.Cycle_Consumption){
                    pot=new Potential__c(Name='test',Competitor__c=pw.competitor, Product_Function__c=pw.product_function,
                                                           Type__c=pw.pftype,Value_MT__c=pw.value_mt, share__c=pw.percent_of_share,
                                                           Salesperson__c=pw.sales_person);
                    pot.Animals_cycle__c=pw.animal_cycle;
                    pot.kg_animal_cycle__c=pw.kg_animal_cycle;
                    pot.Cycles_yr__c=pw.cycles_yr;
                     /*if the potential is new assign the record type id*/
                     if(pw.isNew){
                        pot.RecordTypeId=getRecordTypeIDByDevName(System.Label.Cycle_Consumption_RecordType,POTENTIAL_OBJECT);
                    }
                }else
                    if(calcType==System.label.Daily_Animal_Consumption){
                        System.debug('$$$Inside'+calcType);
                        pot=new Potential__c(Name='test',Competitor__c=pw.competitor, Product_Function__c=pw.product_function,
                                             Type__c=pw.pftype,Value_MT__c=pw.value_mt, share__c=pw.percent_of_share,
                                             Salesperson__c=pw.sales_person);
                        pot.Animals_yr__c=pw.Animals_yr;
                        pot.Days_Fed_yr__c=pw.Days_Fed_yr;
                        pot.kg_hd_day__c= pw.kg_hd_day;
                        
                        /*if the potential is new assign the record type id*/
                        if(pw.isNew){
                            pot.RecordTypeId=getRecordTypeIDByDevName(System.Label.Daily_Animal_Consumption_RecordType,POTENTIAL_OBJECT);
                        }
                        
                    }else
                        if(calcType==System.label.SimplePotentialEstimate_CFE){
                            pot=new Potential__c(Name='test',Competitor__c=pw.competitor, Product_Function__c=pw.product_function,Annual_CFE__c=pw.annual_cfe,
                                                 Type__c=pw.pftype,CFE_incl__c=pw.cfe_incl,Value_CFE__c=pw.value_cfe, share__c=pw.percent_of_share,Total__c=pw.total,
                                                 Salesperson__c=pw.sales_person,Annual_CFE_CON__c=pw.annual_cfe_con);
                            System.debug('$$$SPE-CFE'+pot);
                            if(pw.isNew){
                                pot.RecordTypeId=getRecordTypeIDByDevName(System.Label.Simple_Potential_Estimate_CFE_RecordType,POTENTIAL_OBJECT);
                            }
                        }else
                            if(calcType==System.label.CycleConsumption_CFE){
                                pot=new Potential__c(Name='test',Competitor__c=pw.competitor, Product_Function__c=pw.product_function,
                                                     Type__c=pw.pftype,Value_cfe__c=pw.value_cfe, share__c=pw.percent_of_share,
                                                     Salesperson__c=pw.sales_person,CFE_incl__c=pw.cfe_incl);
                                pot.Animals_cycle__c=pw.animal_cycle;
                                pot.CFE_kg_animal_cycle__c=pw.cfe_kg_animal_cycle;
                                pot.Cycles_yr__c=pw.cycles_yr;
                                
                                /*if the potential is new assign the record type id*/
                                if(pw.isNew){
                                    pot.RecordTypeId=getRecordTypeIDByDevName(System.label.Cycle_Consumption_CFE_RecordType,POTENTIAL_OBJECT);
                                }
                            }else
                                if(calcType==System.label.DailyAnimalConsumption_CFE){
                                    System.debug('$$$Inside'+calcType);
                                    pot=new Potential__c(Name='test',Competitor__c=pw.competitor, Product_Function__c=pw.product_function,
                                                         Type__c=pw.pftype,Value_cfe__c=pw.value_cfe, share__c=pw.percent_of_share,CFE_incl__c=pw.cfe_incl,
                                                         Salesperson__c=pw.sales_person);
                                    pot.Animals_yr__c=pw.Animals_yr;
                                    pot.Days_Fed_yr__c=pw.Days_Fed_yr;
                                    pot.kg_hd_day__c= pw.kg_hd_day;
                                    
                                    /*if the potential is new assign the record type id*/
                                    if(pw.isNew){
                                        pot.RecordTypeId=getRecordTypeIDByDevName(System.Label.Daily_Animal_Consumption_CFE_RecordType,POTENTIAL_OBJECT);
                                    }
                        
                    }
                
                /*if the mode is Edit*/ 
                if(mode.equals(EDIT_MODE)){
                    /*In the mode is Edit some potential may be new and some may be old*/
                    if(pw.isNew){
                        /*if it is new potential, assign  master potential id to  potential*/
                       pot.Master_Potential__c=mpot_id;  
                    }else{
                        /*if it is old potential, assign its potential id to update the potential*/
                       pot.id=pw.pot_id;  
                    }
                /*if the mode is New*/    
                }else if(mode.equals(NEW_MODE)){
                    /*In mode is New,all the potential must be assigned to Master potential*/
                    pot.Master_Potential__c=mpot_id;
                    
                }
                 potList.add(pot);
               }
            if(potList.size()>0){
                System.debug('$$$$Potential'+potList);
                /*Here upsert is used because user may edit or add new potential at same time from UI*/
                upsert potList;
            }  
        }catch(DMLException e){
            System.debug('$$$'+e);
            if(e.getMessage().contains(INSUFFICIENT_ACCESS))
            {
              
                 EXCEPTION_MSG=System.Label.POT_INSUFFICIENT_ACCESS_ERROR;
            }
            else if(e.getMessage().contains(NUMBER_OUTSIDE_VALID_RANGE)){
                EXCEPTION_MSG=System.label.POT_NUMBER_OUTSIDE_VALID_RANGE;
            }
            else{
                 EXCEPTION_MSG=STD_EXCEPTION+e.getMessage();
            }
           
            Database.rollback( sp );
            isSuccess=false;
        }
        if(isSuccess){
            return new Response(isSuccess,SUCCESS_SAVE,mpot_id);
        }else
        {
            return new Response(isSuccess,EXCEPTION_MSG,null); 
        }
       
    }
  
    /*Used for Auto Populating value MT Field in UI*/
    @auraenabled
    public static List<Potential_Estimate_Form__c> getAutoPopValues(String calcType,String species){
        User u=[select Business_Unit__c from User where id=:UserInfo.getUserId()];
        return CalculateUtility.getPotentialEstimateForm(calcType,species,u.Business_Unit__c);
    }    
    
    /*Used to delete master potential or potential records*/
    @auraenabled 
    public static Response deleteRecord(String Id){
        
        Database.DeleteResult rs= Database.delete(Id);
        if(rs.isSuccess())
            return new Response(true,STD_DELETE,null);
        else
            return new Response(false,STD_DELETE,null);
    }
    /*Returns picklist values of species*/
     @auraenabled 
    public static Response getSpecies(){
        
       return new Response(true,STD_SUCCESS,CalculateUtility.getSpecies());
    }
     /*Returns picklist values of Calculation Type*/
    @auraenabled 
    public static Response getCalcTypes(String calcCategory){
        
       return new Response(true,STD_SUCCESS,CalculateUtility.getEstimationType(calcCategory));
    }
     /*Returns picklist values of Product Function level Types*/
    @auraenabled 
    public static Response getTypes(){
        
        return new Response(true,STD_SUCCESS,CalculateUtility.getTypes());
    }
    /*Returns dependent values(product function) of species from potential object */
    @auraenabled 
    public static Response getProductFunction(String species){
        System.debug('$$$'+species);
        List<CalculateUtility.PicklistWrapper> product_functions=CalculateUtility.GetDependentOptions(POTENTIAL_OBJECT,SPECIES_FIELD,PROD_FUN_FIELD).get(species);
        return new Response(true,STD_SUCCESS,product_functions);
    }
    /*Returns logged in user name*/
      @auraenabled 
    public static Response getUserName(){
        
        return new Response(true,STD_SUCCESS,UserInfo.getName());
    }
    
  /*checks if the calculation type and species selected by the user is a duplicate the account. return true/false*/  
     @auraenabled  // Added by Anu
    public static Response getDuplicatecheckMasterPotential(String calcType, String species, String accId ){
        system.debug('##### Type1'+calcType);
        system.debug('##### Species1'+Species);
        system.debug('##### accId1'+accId);
        
        
       return new Response(true,STD_SUCCESS,CalculateUtility.getDuplicatecheckMasterPotential(calcType,species,accId ));
      
    }
   /*Checks if the current account in context is locked or not. return true if locked else false
   Account may be locked if it is approval process*/
    @auraenabled
    public static Response isAccountLocked(Id accId){
        
          return new Response(true,STD_SUCCESS,Approval.isLocked(accId));
      
    }
    @auraenabled
    public static Response getCalcCategories(){
        
        return new Response(true,STD_SUCCESS,CalculateUtility.getCalcCategories());
        
    }
    
    /*Returns Map of formula for speciefied for calcType and species.These fomulas are used for calculation realtime
     in the lighning component*/
    @auraenabled
    public static Response getFormulaMap(String calcType,String species){
           return new Response(true,STD_SUCCESS,CalculateUtility.getFormulaMap(calcType, species));
    }
    /*returns record type id based on the recordType developer name.*/
    static Id getRecordTypeIDByDevName(String devName,String sObjectName){
        return [select id from RecordType where sObjectType=:sObjectName and DeveloperName=:devName].Id;
    }
    
   
    private static void loadWrapperValues(PotentialWrapper potwrapper,Potential__c pot){
        
        potwrapper.pot_id=pot.Id;
        potwrapper.pftype=pot.Type__c;
        potwrapper.total=pot.Total__c;
        potwrapper.competitor=pot.competitor__c;
        potwrapper.sales_person=pot.Salesperson__c;
        potwrapper.product_function=pot.product_function__c;
        potwrapper.annual_volume_mt=pot.Annual_Volume_MT__c;
        potwrapper.value_mt=pot.Value_MT__c;
        potwrapper.volume=pot.Volume__c;
        potwrapper.percent_of_share=pot.share__c;
        potwrapper.contribution=pot.Contribution__c;
        potwrapper.isNew=false;
        potwrapper.isCompetitor=pot.isCompetitor__c;
        
        potwrapper.cycles_yr=pot.Cycles_yr__c;
        potwrapper.animal_cycle=pot.Animals_cycle__c;
        potwrapper.kg_animal_cycle=pot.kg_animal_cycle__c; 
        potwrapper.totalOverridden=pot.overridden__c;
        
        potwrapper.Animals_yr=pot.Animals_yr__c;
        potwrapper.Days_Fed_yr=pot.Days_Fed_yr__c;
        potwrapper.kg_hd_day=pot.kg_hd_day__c;
        
        potwrapper.annual_cfe=pot.Annual_CFE__c;
        potwrapper.cfe_incl=pot.CFE_incl__c;
        potwrapper.value_cfe=pot.Value_CFE__c;
        potwrapper.annual_volume=pot.Annual_Volume__c;
        potwrapper.annual_cfe_con=pot.Annual_CFE_CON__c;
        potwrapper.cfe_kg_animal_cycle=pot.CFE_kg_animal_cycle__c;
    }
    private static List<Potential__c> getPotential(Id mpot_id,Boolean isCompetitor){
        return [SELECT Id, Master_Potential__r.Estimation_Type__c,Master_Potential__r.species__c,Master_Potential__r.share_of_wallet__c,Competitor__c,isCompetitor__c, Master_Potential__c, Product_Function__c, Type__c, Annual_Volume_MT__c, Value_MT__c, Total__c, share__c, Contribution__c, 
                Animals_cycle__c,Cycles_yr__c,kg_animal_cycle__c,Salesperson__c, Volume__c,overridden__c 
                ,Animals_yr__c,kg_hd_day__c,Days_Fed_yr__c,CFE_kg_animal_cycle__c 
                ,Annual_CFE__c,CFE_incl__c,Value_CFE__c,Annual_Volume__c,Annual_CFE_CON__c FROM Potential__c
                where Master_Potential__c=:mpot_id and isCompetitor__c=:isCompetitor order by createddate asc];
    }
    /*Returns fields access information of the user*/
    @auraenabled
    public static Response getPotentialAccessFields(){
       
        Profile p=[select Name from profile where id = :userinfo.getProfileId()];
        Map<String,Boolean> fieldAccess=new Map<String,Boolean>();
        
        List<String> apiList=new List<String>();
        /*Get all the access related information by profile ID from custom settings*/
        sObject pfa=Potential_Field_Access__c.getInstance(userinfo.getProfileId());
       /*Get all the fields of the custom settings dynamically*/
        Map <String, Schema.SObjectField> fieldMap =Potential_Field_Access__c.sObjectType.getDescribe().fields.getMap();
       
        for(Schema.SObjectField sfield:fieldMap.values()){
            String apiName=sfield.getDescribe().getName();
            if(pfa!=null){
                /**/
                if(apiName!=null && pfa.get(apiName)!=null && apiName.contains('__c') && sfield.getDescribe().getType()==Schema.DisplayType.BOOLEAN){
                    System.debug('$$$'+apiName);
                    /*Get Data dynamically*/
                    fieldAccess.put(apiName,Boolean.valueof((pfa.get(apiName))));
                }else{
                    /*if no access information is available default access is true*/
                    fieldAccess.put(apiName,true);
                }
            }
            
        }
     
        return new Response(true,null,fieldAccess);
    }
 
}