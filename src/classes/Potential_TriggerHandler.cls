public with sharing class Potential_TriggerHandler {
    
    public static void populateAccountId(List<Potential__c> potentialList){
        
        for(Potential__c p : potentialList){
            p.parentAccount__c = p.parentaccountFormula__c; 
        }
    }
    
    public static void doCalculationsBasedOnEstimationType(List<Potential__c> potentialList){
        
        Map<String,List<Potential__c>> calculationKey_ListOfPotentialMap = new Map<String,List<Potential__c>>();
        List<PotenCalculationOperative__c> potentialCalculationOperativeList = new List<PotenCalculationOperative__c>();
        
        for(Potential__c p : potentialList){
            if(calculationKey_ListOfPotentialMap.get(p.CalculationKey__c) != NULL)
                calculationKey_ListOfPotentialMap.get(p.CalculationKey__c).add(p);
            else
                calculationKey_ListOfPotentialMap.put(p.CalculationKey__c, new List<Potential__c>{p});
        }
        
        potentialCalculationOperativeList = [SELECT Annual_CFE__c, Annual_CFE_CON__c, Annual_Volume__c, 
                                                    CFE__c, Calculation_Key__c, Contribution__c, Name, 
                                                    Product_Function__c, Remaining_potential__c,  
                                                    Species__c,  Total__c, Total_consumption_complete_feed_MT__c, 
                                                    Type__c, TypeOfCalculation__c, Volume__c, Volume_of_our_product_MT__c,
                                                    Annual_Volume_MT__c
                                             FROM PotenCalculationOperative__c
                                             WHERE Calculation_Key__c IN: calculationKey_ListOfPotentialMap.keySet()];
        
        System.debug(LoggingLevel.Info,'\n\n\ncalculationKey_ListOfPotentialMap: '+ calculationKey_ListOfPotentialMap+'\n\n\n');
        
        for(PotenCalculationOperative__c pco : potentialCalculationOperativeList){
            for(Potential__c p : calculationKey_ListOfPotentialMap.get(pco.Calculation_Key__c)){
                
                if(p.CalculationKey__c.contains(Label.SimplePotentialEstimate) &&
                   !p.CalculationKey__c.contains('CFE')){
                    
                    System.debug(LoggingLevel.Info,'\n\n\n potential : '+p+'\n\n\n');

                    String total = getCalculationExpression(p,pco,'Total__c');
                    System.debug(LoggingLevel.Info,'\n\n\n total : '+total+'\n\n\n');
                    if(total != null){
                        Decimal d = EvaluateString.evaluate(total);
                        if( !(d == 0 && p.Total__c != 0))
                        p.Total__c = d.setScale(2);
                    }
                    
                    String volume = getCalculationExpression(p,pco,'Volume__c');
                    System.debug(LoggingLevel.Info,'\n\n\n volume : '+volume+'\n\n\n');
                    if(volume != null)
                        p.Volume__c  = EvaluateString.evaluate(volume).setScale(2);
                    
                    String contribution = getCalculationExpression(p,pco,'Contribution__c');
                    System.debug(LoggingLevel.Info,'\n\n\n contribution : '+contribution);
                    if(contribution != null)
                        p.Contribution__c = EvaluateString.evaluate(contribution).setScale(2);
                    
                }else if(p.CalculationKey__c.contains(Label.SimplePotentialEstimate_CFE)){
                    
                    String total = getCalculationExpression(p,pco,'Total__c');
                    System.debug(LoggingLevel.Info,'\n\n\n total : '+total+'\n\n\n');
                    if(total != null){
                        Decimal d = EvaluateString.evaluate(total);
                        if( !(d == 0 && p.Total__c != 0))
                            p.Total__c = d.round();

                        }
                        
                     
                    String annualVolume = getCalculationExpression(p,pco,'Annual_Volume__c');
                    System.debug(LoggingLevel.Info,'\n\n\n annualVolume : '+annualVolume);
                    if(annualVolume != null)
                        p.Annual_Volume__c = EvaluateString.evaluate(annualVolume).round();
                    
                    String annualCFECON = getCalculationExpression(p,pco,'Annual_CFE_CON__c');
                    System.debug(LoggingLevel.Info,'\n\n\n annualCFECON : '+annualCFECON);
                    if(annualCFECON != null)
                        p.Annual_CFE_CON__c = EvaluateString.evaluate(annualCFECON).round(); 
                    
                    String contribution = getCalculationExpression(p,pco,'Contribution__c');
                    System.debug(LoggingLevel.Info,'\n\n\n contribution : '+contribution);
                    if(contribution != null)
                        p.Contribution__c = EvaluateString.evaluate(contribution).round();
                    
                    
                }else if(p.CalculationKey__c.contains(Label.Cycle_Consumption) &&
                         !p.CalculationKey__c.contains('CFE')){
                    
                    String annualVolumeMT = getCalculationExpression(p,pco,'Annual_Volume_MT__c');
                    System.debug(LoggingLevel.Info,'\n\n\n annualVolumeMT : '+annualVolumeMT);
                    if(annualVolumeMT != null)
                        p.Annual_Volume_MT__c = EvaluateString.evaluate(annualVolumeMT).setScale(2); 
                    
                    
                    String total = getCalculationExpression(p,pco,'Total__c');
                    System.debug(LoggingLevel.Info,'\n\n\n total : '+total+'\n\n\n');
                    if(total != null)
                        p.Total__c = EvaluateString.evaluate(total).setScale(2);
                    
                    String volume = getCalculationExpression(p,pco,'Volume__c');
                    System.debug(LoggingLevel.Info,'\n\n\n volume : '+volume+'\n\n\n');
                    if(volume != null)
                        p.Volume__c  = EvaluateString.evaluate(volume).setScale(2);
                    
                    
                    String contribution = getCalculationExpression(p,pco,'Contribution__c');
                    System.debug(LoggingLevel.Info,'\n\n\n contribution : '+contribution);
                    if(contribution != null)
                        p.Contribution__c = EvaluateString.evaluate(contribution).setScale(2);
                    
                    
                }else if(p.CalculationKey__c.contains('Cycle Consumption - CFE')){
                    
                    String annualCFE = getCalculationExpression(p,pco,'Annual_CFE__c');
                    System.debug(LoggingLevel.Info,'\n\n\n annualCFE : '+annualCFE);
                    if(annualCFE != null)
                        p.Annual_CFE__c = EvaluateString.evaluate(annualCFE).round();
                    
                        
                    String annualVolume = getCalculationExpression(p,pco,'Annual_Volume__c');
                    System.debug(LoggingLevel.Info,'\n\n\n annualVolume : '+annualVolume);
                    if(annualVolume != null)
                        p.Annual_Volume__c = EvaluateString.evaluate(annualVolume).round();
                   
                    String total = getCalculationExpression(p,pco,'Total__c');
                    System.debug(LoggingLevel.Info,'\n\n\n total : '+total+'\n\n\n');
                    if(total != null)
                        p.Total__c = EvaluateString.evaluate(total).round();
                        
                    String annualCFECON = getCalculationExpression(p,pco,'Annual_CFE_CON__c');
                    System.debug(LoggingLevel.Info,'\n\n\n annualCFECON : '+annualCFECON);
                    if(annualCFECON != null)
                        p.Annual_CFE_CON__c = EvaluateString.evaluate(annualCFECON).round();
                    
                    String contribution = getCalculationExpression(p,pco,'Contribution__c');
                    System.debug(LoggingLevel.Info,'\n\n\n contribution : '+contribution);
                    if(contribution != null)
                        p.Contribution__c = EvaluateString.evaluate(contribution).round();
                    
                }else if(p.CalculationKey__c.contains(Label.Daily_Animal_Consumption) &&
                         !p.CalculationKey__c.contains('CFE')){
                    
                    String annualVolumeMT = getCalculationExpression(p,pco,'Annual_Volume_MT__c');
                    System.debug(LoggingLevel.Info,'\n\n\n annualVolumeMT : '+annualVolumeMT);
                    if(annualVolumeMT != null)
                        p.Annual_Volume_MT__c = EvaluateString.evaluate(annualVolumeMT).setScale(2);
                    
                    
                    String total = getCalculationExpression(p,pco,'Total__c');
                    System.debug(LoggingLevel.Info,'\n\n\n total : '+total+'\n\n\n');
                    if(total != null)
                        p.Total__c = EvaluateString.evaluate(total).setScale(2);
                    
                    String volume = getCalculationExpression(p,pco,'Volume__c');
                    System.debug(LoggingLevel.Info,'\n\n\n volume : '+volume+'\n\n\n');
                    if(volume != null)
                        p.Volume__c  = EvaluateString.evaluate(volume).setScale(2);
                    
                    
                    String contribution = getCalculationExpression(p,pco,'Contribution__c');
                    System.debug(LoggingLevel.Info,'\n\n\n contribution : '+contribution);
                    if(contribution != null)
                        p.Contribution__c = EvaluateString.evaluate(contribution).setScale(2);
                    
                    
                }else if(p.CalculationKey__c.contains(Label.DailyAnimalConsumption_CFE)){
                    
                    String annualCFE = getCalculationExpression(p,pco,'Annual_CFE__c');
                    System.debug(LoggingLevel.Info,'\n\n\n annualCFE : '+annualCFE);
                    if(annualCFE != null)
                        p.Annual_CFE__c = EvaluateString.evaluate(annualCFE).round();
                    
                        
                    String annualVolume = getCalculationExpression(p,pco,'Annual_Volume__c');
                    System.debug(LoggingLevel.Info,'\n\n\n annualVolume : '+annualVolume);
                    if(annualVolume != null)
                        p.Annual_Volume__c = EvaluateString.evaluate(annualVolume).round();
                   
                    String total = getCalculationExpression(p,pco,'Total__c');
                    System.debug(LoggingLevel.Info,'\n\n\n total : '+total+'\n\n\n');
                    if(total != null)
                        p.Total__c = EvaluateString.evaluate(total).round();
                        
                    String annualCFECON = getCalculationExpression(p,pco,'Annual_CFE_CON__c');
                    System.debug(LoggingLevel.Info,'\n\n\n annualCFECON : '+annualCFECON);
                    if(annualCFECON != null)
                        p.Annual_CFE_CON__c = EvaluateString.evaluate(annualCFECON).round(); 
                    
                    String contribution = getCalculationExpression(p,pco,'Contribution__c');
                    System.debug(LoggingLevel.Info,'\n\n\n contribution : '+contribution);
                    if(contribution != null)
                        p.Contribution__c = EvaluateString.evaluate(contribution).round();
                    
                }
            }
        }
        
    }
    
    public static String getCalculationExpression(Potential__c p,
                                                                 PotenCalculationOperative__c pco,
                                                                 String calculationFunctionApiName){
        if(pco.get(calculationFunctionApiName) != NULL){
            List<String> operators = ((String)pco.get(calculationFunctionApiName)).split(' ');
            String expression = (String)pco.get(calculationFunctionApiName);
            for(String operator : operators){
                if(operator.contains('__c')){
                    Decimal value = (Decimal)p.get(operator);
                    System.debug(LoggingLevel.Info,'\n\n\n operator : '+operator);
                    System.debug(LoggingLevel.Info,'\n\n\n value : '+value+'\n\n\n');
                    /*
                    if(value == NULL){
                        expression = null;
                        break;
                    } 
                    */
                    if(value == NULL){
                        value = 0;
                    }  
                    expression = expression.replace(operator,value.toPlainString());
                }
            }                                           
            
            System.debug(LoggingLevel.Info,'\n\n\n*****expression : '+expression+'\n\n\n');
            if(expression != NULL)      
                return expression;  
            else
                return null;                                                    
        }else 
            return null;
    }
    
    public static void RelatedPotentialDelete (list<Potential__c> potentialList)
    {
       List<String> CompetitorKeyList = new List<String>();
        for (potential__c p : potentialList)
        {
             if(p.Competitor__c == 'Cargill')
              {
                CompetitorKeyList.add(p.Competitor_Key__c);
              }
        }

        List <potential__c>  PotentialToBeDeleted = [select id, Species__c,Competitor__c, Competitor_Key__c 
                                                    from potential__c 
                                                    where Competitor_Key__c IN :CompetitorKeyList
                                                    and Competitor__c != 'Cargill'];
        
        system.debug('PotentialToBeDeleted'+PotentialToBeDeleted);

        if (!PotentialToBeDeleted.isEmpty())
        delete PotentialToBeDeleted;
   }
    
   public static Map<String,String> Calshare(list<Potential__c> potentialList)
   {
   
    Map<String,List<Potential__c>> calculationKey_ListOfPotentialMap = new Map<String,List<Potential__c>>();
    Map<String,String>  calculationKey_Message = new Map<String,String> ();
    List<Potential__c> Potential_insert = new List<Potential__c>();
    List<Potential__c> Potential_error = new List<Potential__c>();
    Set<String> calculationKey = new Set<String> ();
    List<Potential__c>  PotentialId = new List<Potential__c> ();
    Set<Id> AccountId = new Set<Id>();

        for(Potential__c p : potentialList)
        {
        calculationKey.add(p.CalculationKey__c);
        PotentialId.add(p);
        AccountId.add(p.Master_Potential__r.Account__c);
        }


        List<Potential__c> SumShare = [Select Id,Product_Function__c,Type__c,share__c,CalculationKey__c from Potential__c where CalculationKey__c =:calculationKey and Master_Potential__r.Account__c =:AccountId ];
        
        system.debug('SumShare ::::::'+SumShare );
        
      /* for(Potential__c p : SumShare ){

            if(calculationKey_ListOfPotentialMap.get(p.CalculationKey__c) != NULL)
            calculationKey_ListOfPotentialMap.get(p.CalculationKey__c).add(p);
            else
            calculationKey_ListOfPotentialMap.put(p.CalculationKey__c, new List<Potential__c>{p});
        }
        
        system.debug('calculationKey_ListOfPotentialMap:::::'+calculationKey_ListOfPotentialMap);
    
        for( String S : calculationKey_ListOfPotentialMap.keyset()){
      */  
        Decimal sum = 0;

           //for( Potential__c P : calculationKey_ListOfPotentialMap.get(S) ){
         
           for( Potential__c P : SumShare){
            
            sum = sum + P.share__c;
            system.debug('Sum::::::::'+sum);

                if( sum >100)  {
                
                    calculationKey_Message.put(P.CalculationKey__c,system.label.Calculate_ShareError );

                    for(Potential__c Pp : PotentialId)
                    {
                        if( Pp.Product_Function__c  == P.Product_Function__c && Pp.Type__c == P.Type__c ){
                        
                        Pp.addError('% share should not exceed 100 % for a product function'+'  [ ' +Pp.Product_Function__c+' - ' + Pp.Type__c + ']');

                        }
                    }
                }
                else {

                calculationKey_Message.put(P.CalculationKey__c,system.label.Calculate_ShareSuccess); 
                Potential_insert.add(P);

                system.debug('Success::::::::'+calculationKey_Message);   
                }
            }

    //    }


        try{

        upsert Potential_insert;

        }
        catch ( exception e) {
        system.debug('Exception:::::::'+e);
        } 
    system.debug('calculationKey_Message:::::'+calculationKey_Message);
    return calculationKey_Message;
            
   }
   
   public static void DuplicateRulePotential(list<Potential__c> potentialList)
    
    // Created this method to check duplicate Potential (The combination of Product Function,Type and Competitor should be unique). 
   
   {
   
    
    Set<String> DuplicateCheck= new Set<String> ();
    Map<Id,String> DupCheckcont = new Map<Id,String>();
    Map<string,Potential__c> DupMap = new Map<string,Potential__c> ();
    List<Potential__c>  PotentialId = new List<Potential__c> ();
    system.debug('potentialList::::'+potentialList);
    set<id> potId = new set<id>();
    
        for(Potential__c p : potentialList)
        {
                
         DupCheckcont.put(p.Id,p.Duplicate_Check__c);
                
        }


        Map<Id,Potential__c> DuplicateChecklist = new Map<id,Potential__c>([Select Id,Product_Function__c,Type__c,share__c,CalculationKey__c,Duplicate_Check__c from Potential__c where Duplicate_Check__c =:DupCheckcont.values()]);
        
               
       for( Potential__c Dup: DuplicateChecklist.values() )
        {
        DupMap.put(Dup.Duplicate_Check__c,Dup);
        
        }
              
         if(!DuplicateChecklist.isEmpty())
         {
             
         for(Potential__c pp: potentialList )
             {
               
                if( DupMap.containsKey(pp.Duplicate_Check__c))
                
                { 
                     
                     if(pp.id != DupMap.get(pp.Duplicate_Check__c).id)
                    
                        pp.addError('The combination of Product Function,Type and Competitor should be unique'); 
                    
                }
              
              
              
          }
         }  
      
               
    }

}