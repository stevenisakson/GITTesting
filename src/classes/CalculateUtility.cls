public class CalculateUtility {

  
      /*Returns list of custom settings values which is used for auto populating value mt in UI*/
    public static List<Potential_Estimate_Form__c> getPotentialEstimateForm(String Est,String species,String BU) {
        
        List<Potential_Estimate_Form__c> EPFList = [Select Species__c,Type__c,TypeOfCalculation__c,Value__c,Product_Function__c,Is_CFE_Incl_locked__c,Is_Value_MT_CFE_locked__c ,inclusion_per_CFE__c from Potential_Estimate_Form__c where TypeOfCalculation__c =: Est and Species__c=:species and User_Business__c=: BU] ;
        
        return EPFList ;
        }
    
    /*Map of formula used to calculate in realtime */
     public static Map<String,PotenCalculationOperative__c> getFormulaMap(String Est,String species) {
        
         Map<String,PotenCalculationOperative__c> formulaMap=new Map<String,PotenCalculationOperative__c>();
         for(PotenCalculationOperative__c formula:[SELECT Id, Species__c,Total_js__c,Contribution_js__c,Volume_js__c,Potential_Check__c,Annual_Volume_mt_js__c,
                                                   Annual_Volume_js__c,Annual_CFE_CON_js__c,Annual_CFE_js__c FROM PotenCalculationOperative__c where TypeOfCalculation__c=: Est and Species__c=:species]){
             formulaMap.put(formula.Potential_Check__c,formula);
         }
        
        return formulaMap ;
        
    }
     /*Checks if the Master potential is already present with the given values for particular account*/
    public static Boolean getDuplicatecheckMasterPotential(String Type, String Species, String accId) {
        
        
        List<Cres_Master_Potential__c> MPlist = [Select Id,Estimation_Type__c,Species__c from Cres_Master_Potential__c where Estimation_Type__c =: Type and Species__c =:Species and Account__c =:accId] ;
       
        
        if( !MPlist.isempty()){
        return true;       
        }else {
        return false;
        }  
    }
     
    /*Returns species picklist values*/
    public static List<PicklistWrapper> getSpecies()
    {
        List<PicklistWrapper> picklist=new List<PicklistWrapper>();
        Map<String,String> options = new Map<String,String>();
        
        Schema.DescribeFieldResult fieldResult = Cres_Master_Potential__c.Species__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        
        for( Schema.PicklistEntry f : ple)
        {
            picklist.add(new PicklistWrapper(f.getLabel(),f.getValue()));
            
        }       
        return picklist;
    }
    /*Categories of calculation type such as Volume/CFE*/
     public static List<PicklistWrapper> getCalcCategories()
    {
        List<PicklistWrapper> picklist=new List<PicklistWrapper>();
        Map<String,String> options = new Map<String,String>();
        String pot_Access=[select Potential_Access__c from User where id=:UserInfo.getUserId()].Potential_Access__c;
        if(pot_Access!=null){
            String []pot_AccessList=pot_Access.split(';');
            if(pot_AccessList.size()>0){
                Schema.DescribeFieldResult fieldResult = Potential__c.Calculation_Category__c.getDescribe();
                List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
                
                for( Schema.PicklistEntry f : ple)
                {
                    options.put(f.getValue(),f.getLabel());
                   // picklist.add(new PicklistWrapper(f.getLabel(),f.getValue()));
                    
                } 
                for(String op:pot_AccessList){
                   picklist.add(new PicklistWrapper(options.get(op),op));   
                }
                
            }
        }
        return picklist;
    }
     /*Returns type picklist values*/
     public static List<PicklistWrapper> getTypes()
    {
      
         List<PicklistWrapper> picklist=new List<PicklistWrapper>();
        Schema.DescribeFieldResult fieldResult = Potential__c.Type__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        Map<String,String> typemap=new Map<String,String>();
        
        for( Schema.PicklistEntry f : ple)
        {
           //picklist.add(new PicklistWrapper(f.getLabel(),f.getValue()));
             typemap.put(f.getValue(),f.getLabel());
        }  
        
		list<string> values=new list<string>();
        User u = [select Id, Business_Unit__c from User where Id = :UserInfo.getUserId()];
		
		list<PotentialType__c> alltypes=[select Business__c,Type__c from PotentialType__c where Business__c =:u.Business_Unit__c] ;
		
		if(alltypes.size() != null)
		{
			for(PotentialType__c potype:alltypes)
			{
				for(String s:potype.Type__c.split(','))
				{
					picklist.add(new PicklistWrapper(typemap.get(s),s)); 
				}
				
			}
		} 
        return picklist;
    }
     /*Returns calculation type picklist values based on the user's potential access*/
    public static List<PicklistWrapper> getEstimationType(String calcType)
    {
        List<PicklistWrapper> picklist=new List<PicklistWrapper>();
        List<String> options = new List<String>();
        Map<String,List<PicklistWrapper>> estMap=new  Map<String,List<PicklistWrapper>>();
        String pot_access=[select Potential_Access__c from User where id=:UserInfo.getUserId()].Potential_Access__c;
        if(pot_access!=null){
            List<String> pot_access_list=pot_access.split(';');
            
           estMap=GetDependentOptions('Potential__c', 'Calculation_Category__c', 'TypeOfCalculation__c');
           /* for(String access:pot_access_list){
                picklist.addAll(estMap.get(calcType));
            }*/
          
        }
        return estMap.get(calcType);
      
    }
    /*Returns translations for Calculation type. key-engish,value-translated value*/
    public static Map<String,String> getEstimationTypeTransMap()
    {
        
        Map<String,String> options = new Map<String,String>();
        
        Schema.DescribeFieldResult fieldResult = Cres_Master_Potential__c.Estimation_Type__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        
        for( Schema.PicklistEntry f : ple)
        {
            options.put(f.getValue(),f.getLabel());
        }       
        return options;
    }
    /*Returns translations for Species . key-engish,value-translated value*/
    public static Map<String,String> getSpeciesTransMap()
    {
        
        Map<String,String> options = new Map<String,String>();
        
        Schema.DescribeFieldResult fieldResult = Cres_Master_Potential__c.Species__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        
        for( Schema.PicklistEntry f : ple)
        {
            options.put(f.getValue(),f.getLabel());
        }       
        return options;
    }
    /*Method for finding dependent picklist values dynamically when controlling picklist value is provided*/
    public static Map<String,List<PicklistWrapper>> GetDependentOptions(String pObjName, String pControllingFieldName, String pDependentFieldName){
        Map<String,List<PicklistWrapper>> objResults = new Map<String,List<PicklistWrapper>>();
        //get the string to sobject global map
        Map<String,Schema.SObjectType> objGlobalMap = Schema.getGlobalDescribe();
        if (!objGlobalMap.containsKey(pObjName))
            return objResults;
        //get the type being dealt with
        Schema.SObjectType pType = objGlobalMap.get(pObjName);
        Map<String, Schema.SObjectField> objFieldMap = pType.getDescribe().fields.getMap();
       
        //verify field names
        if (!objFieldMap.containsKey(pControllingFieldName) || !objFieldMap.containsKey(pDependentFieldName))
            return objResults;     
        //get the control values   
        List<Schema.PicklistEntry> ctrl_ple = objFieldMap.get(pControllingFieldName).getDescribe().getPicklistValues();
        //get the dependent values
        List<Schema.PicklistEntry> dep_ple = objFieldMap.get(pDependentFieldName).getDescribe().getPicklistValues();
        //iterate through the values and get the ones valid for the controlling field name
        TStringUtils.Bitset objBitSet = new TStringUtils.Bitset();
        //set up the results
        for(Integer pControllingIndex=0; pControllingIndex<ctrl_ple.size(); pControllingIndex++){           
            //get the pointer to the entry
            Schema.PicklistEntry ctrl_entry = ctrl_ple[pControllingIndex];
            //get the label /*Changed to Value*/
            String pControllingLabel = ctrl_entry.getValue();
            //create the entry with the label
            objResults.put(pControllingLabel,new List<PicklistWrapper>());
          
        }
        //cater for null and empty 
        objResults.put('',new List<PicklistWrapper>());
        objResults.put(null,new List<PicklistWrapper>());
        //check the dependent values
       
        for(Integer pDependentIndex=0; pDependentIndex<dep_ple.size(); pDependentIndex++){          
            //get the pointer to the dependent index
            Schema.PicklistEntry dep_entry = dep_ple[pDependentIndex];
           
            //get the valid for
            String pEntryStructure = JSON.serialize(dep_entry); 
            
            TStringUtils.TPicklistEntry objDepPLE = (TStringUtils.TPicklistEntry)JSON.deserialize(pEntryStructure, TStringUtils.TPicklistEntry.class);
           
            //if valid for is empty, skip
            if (objDepPLE.validFor==null || objDepPLE.validFor==''){

            }
            //iterate through the controlling values
            for(Integer pControllingIndex=0; pControllingIndex<ctrl_ple.size(); pControllingIndex++){    
                if (objBitSet.testBit(objDepPLE.validFor,pControllingIndex)){                   
                    //get the label/*Changed to Value*/
                    String pControllingLabel = ctrl_ple[pControllingIndex].getValue();
                 
                    objResults.get(pControllingLabel).add(new PicklistWrapper(objDepPLE.label,objDepPLE.value));
                    
                }
            }
        } 
        return objResults;
    }
   
    
    /*Wrapper for Picklist values. label for display,value for storing.
     This is useful when user needs translation. Label will be dynamically changed
     based on the user language,when value remains the same in english*/
    public class PicklistWrapper{
        @auraenabled
        public String value;
        @auraenabled
        public String label;
        public PicklistWrapper(String label,String value){
            this.label=label;
            this.value=value;
        }
    }
   

}