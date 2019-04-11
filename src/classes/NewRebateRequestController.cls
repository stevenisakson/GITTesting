/********************************************************************************************* 
    * @author:      Robbie Macatbag
    * @date:        20 October 2015
    * @description: Controller class for Rebate_POC visualforce page
    * @parameters:  NA
    * @revision:    23 March 2015 Robbie Macatbag:  
    * @revision:    17 May 2016 Tomasz Dusza: added 'CAR_Product_Code__c' for lookup
    **********************************************************************************************/

    public class NewRebateRequestController{
        public boolean isView {get;set;}
        public Account accountFilter {get;set;}
        public List <Account> accountList {get;set;}
        public CAR_RebateReqs__c currentRebateRequest {get;set;}
        public Rebate_Request_Line__c newRebateRequestLine {get;set;}
        public Rebate_Request_Line__c tempRebateRequestLine {get;set;}
        public List<Rebate_Request_Line__c> currentRebateRequestLineList {get;set;}
        public List<RebateRequestLineWrapper> rebateRequestLineWrapperList {get;set;}
        public integer rebateRequestIndex =0;
        public String currentIndex {get;set;}
        public String canDeleteInView {get;set;}
        public boolean displayPopup {get; set;}
        public List<accountSelectionWrapper> accountSelectionList {get;set;}
        public boolean disableLogisticDiscount{get;set;}
        public boolean withPayer {get;set;}
        public boolean isEditting {get;set;}
        public boolean isCreatingNew {get;set;}
        public boolean includePayer {get;set;}
        public boolean withRelatedRequest {get;set;}
        string errorMessage = '';
       
        
        public string selectAllChoice {get;
            // *** setter is NOT being called ***
            set {
                selectAllChoice = value;
                System.debug('@@selectAllChoice: '+value);
            }}
            
        
        List<Rebate_Request_Line__c>  deleteRebateRequestLineList = new List<Rebate_Request_Line__c>();    
        String record2clone; 
        PageReference redirectLink;
        
        Map <id,Account_Rebate__c> accountRebateMap = new Map <id,Account_Rebate__c>();
        List <Account_Rebate__c> accountRebateList = new List <Account_Rebate__c>();
        public List <Account_Rebate__c> childAccountRebateList {get;set;}
         List <Account_Rebate__c> newAccountRebateList = new List <Account_Rebate__c>();
         List <Account_Rebate__c> deleteAccountRebateList = new List <Account_Rebate__c>();
        
        
        accountSelectionWrapper tempAccountSelection = new accountSelectionWrapper();
        PageReference currentPageReference = ApexPages.currentPage();
        String accountQueryStatement ;
        id currentRebateRequestId;    
        public NewRebateRequestController(){
            
        }
        /********************************************************************************************* 
        * @author:      Robbie Macatbag
        * @date:        24 October 2015
        * @description: Constructor Method. 
        * @parameters:  NA
        * @revision:    24 March Robbie Macatbag: added conditions and new instantiation of variables.      
        * @revision:    12 May '16 Tomasz Dusza: added 'ORDER BY name' to 'accountList'
        **********************************************************************************************/
        public NewRebateRequestController(ApexPages.StandardController controller) {
            String shiptoParamValue = currentPageReference.getParameters().get('shiptoId');
            //rebateRequestIndex= 0;
            rebateRequestLineWrapperList=new List<RebateRequestLineWrapper>();
            accountFilter = new Account();
            childAccountRebateList = new List <Account_Rebate__c>();
            accountList = new List <Account> ();
            accountSelectionList = new List<accountSelectionWrapper> ();
            currentRebateRequestLineList = new List<Rebate_Request_Line__c>();
            newRebateRequestLine = new Rebate_Request_Line__c();
            currentRebateRequest = (CAR_RebateReqs__c)controller.getRecord();
            record2clone = currentPageReference.getParameters().get('Cloned');
            isView = currentPageReference.getParameters().get('isView') == '1';
            system.debug('@@record2clone:'+record2clone);
            includePayer = false;
            
           
            if(record2clone!=null){
                currentRebateRequestId = record2clone;
            }else{
                currentRebateRequestId = currentRebateRequest.id;
            }
            system.debug('@@record2clone:'+currentRebateRequestId);
            if(currentRebateRequestId==null){
                
                currentRebateRequest = new CAR_RebateReqs__c();
            }else{
                
                //Get the existing Rebate Request record.
                currentRebateRequest = [SELECT id,name,Cargill_Request_Type__c, CAR_Status__c, CAR_Account__c,Customer_Health_Actual_Margin__c, 
                    Customer_Health_Target_Margin__c, ERP_ID__c, parent__c,Comments__c,Locked__c,Valid_From__c, Inform_Supervisor__c, Second_Manager_Email__c, Valid_To__c, Needs_Manager_Approval__c, Include_Payer__c 
                    FROM CAR_RebateReqs__c 
                    WHERE id =:currentRebateRequestId];
                
                //Get Rebate Request Line records.
                currentRebateRequestLineList = [SELECT id,CAR_Amount_in_Currency__c,CAR_Credit_Limit__c,CAR_Current_Discount__c,
                    CAR_Discount_Percentage_1__c,CAR_Discount_Type__c,CAR_Find_Next_Flag__c,CAR_Item_Type__c,CAR_Payment_Terms__c,
                    Product__c,CAR_Product_Code__c,CAR_Valid_From__c,CAR_Valid_To__c,CAR_Rebate_Request__c,Discount_Percentage__c,Standard_form__c,
                    Packaging__c,Price__c,Discount_Value__c,Special_price__c,Apply_permanent_discounts__c,Apply_logistic_discounts__c,Comments__c  
                    FROM Rebate_Request_Line__c 
                    WHERE CAR_Rebate_Request__c =:currentRebateRequestId];

                //Get existing Shipping Accounts.
                accountRebateList = [SELECT id, Rebate_Request__c, Account__r.id, Account__c, ERP_ID__c FROM Account_Rebate__c 
                    WHERE Rebate_Request__c =:currentRebateRequestId ];
                for(Account_Rebate__c ac:accountRebateList){
                    accountRebateMap.put(ac.Account__r.id,ac);
                }
                
                //Get child Shipping Accounts.
                childAccountRebateList = [SELECT id, Rebate_Request__c, Rebate_Request__r.Parent__c, Rebate_Request__r.CAR_Status__c,Rebate_Request__r.CAR_Account__r.name, Rebate_Request__r.name,Rebate_Request__r.id, Account__r.id, Account__r.name,Account__c,  ERP_ID__c FROM Account_Rebate__c 
                    WHERE Rebate_Request__r.Parent__c =:currentRebateRequestId  ];
                withRelatedRequest = childAccountRebateList.size()>0;
                
                //Clean all IDs for cloning.
                if((record2clone)!=null){
                    currentRebateRequest.id=null;
                    currentRebateRequest.Locked__c=false;
                    currentRebateRequest.CAR_Status__c=Label.Rebate_Request_Draft_Status;
                    for(Rebate_Request_Line__c crrll: currentRebateRequestLineList){
                        crrll.id=null;
                        crrll.CAR_Rebate_Request__c = null;
                    }
                }
                
                for(Rebate_Request_Line__c rrll: currentRebateRequestLineList){
                    //indexedRebateRequestLineMap.put(rebateRequestIndex,rrll);
                    rebateRequestLineWrapperList.add(new RebateRequestLineWrapper(rebateRequestIndex,rrll,false));
                    rebateRequestIndex++;
                }
            }
            
            
            String referenceAccount = currentPageReference.getParameters().get(Label.Account_ID_Object); //CF00Ng0000001faDx_lkid replace with custom settings token
            system.debug('@@accountRebateMap.keySet():'+currentPageReference.getParameters());
            if(!(String.isEmpty(referenceAccount))){
                currentRebateRequest.CAR_Account__c= referenceAccount;
            }
                system.debug('@@accountRebateMap.keySet():'+accountRebateMap.keySet());


            if(accountRebateMap.keySet().size()>0||(shiptoParamValue!=null && shiptoParamValue!='null')){
                set<ID> accountIDsList = new set<id>();
                if(accountRebateMap.keySet().size()>0){
                    accountIDsList = accountRebateMap.keySet();
                }else{
                    accountIDsList.add(shiptoParamValue);
                }
                
                
                accountList = [SELECT id, name, AccountNumber,BillingStreet, BillingCity, BillingState, BillingPostalCode, BillingCountry, ERP_Id__c 
                    FROM Account 
                    WHERE id IN:accountIDsList
                    ORDER BY name ASC];
                if(accountList.size()>0 && !(accountSelectionList.size()>0)){
                    for(Account acct: accountList){
                        tempAccountSelection = new accountSelectionWrapper();
                        tempAccountSelection.acc = acct;
                        tempAccountSelection.selected = true;
                        tempAccountSelection.addressTrimed=trimAddressInfo(acct);
                        accountSelectionList.add(tempAccountSelection);
                    } 
                }
                accountSelectionList.sort();
                System.debug('$$$accountSelectionList');
            }
            withPayer = String.isEmpty(currentRebateRequest.CAR_Account__c);
            if(!withPayer){
                filterAccountList();
            }
            if(record2clone!=null){
                currentRebateRequest.id = null;
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO, 'Cloning Rebate Request: "'+currentRebateRequest.name+'"');
                ApexPages.addMessage(myMsg);
            }
        }

        /********************************************************************************************* 
        * @author:      Robbie Macatbag
        * @date:        24 October 2015
        * @description: Method that handles addition of rebate request line 
        * @parameters:  NA
        * @revision:         
        
        **********************************************************************************************/
        public void addRequestLine(){
            errorMessage ='';
            
            if((newRebateRequestLine.Product__c == null) || (newRebateRequestLine.Discount_Value__c == null && newRebateRequestLine.Discount_Percentage__c == null && newRebateRequestLine.Special_price__c == null)){
                system.debug('@@ Product__c:'+newRebateRequestLine.Product__c+' Discount_Value__c:'+newRebateRequestLine.Discount_Value__c+' Discount_Percentage__c:'+newRebateRequestLine.Discount_Percentage__c+' Special_price__c:'+newRebateRequestLine.Special_price__c);
                errorMessage='You must enter a Product and either a Discount %, Value or Special price.';
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, errorMessage);
                ApexPages.addMessage(myMsg);
                
            }else{
                closePopup();
                rebateRequestLineWrapperList.add(new RebateRequestLineWrapper(rebateRequestIndex,newRebateRequestLine,false));
                rebateRequestIndex++;
                //currentRebateRequestLineList.add();
            }
            system.debug('@@ Product__c:'+newRebateRequestLine.Product__c+' Discount_Value__c:'+newRebateRequestLine.Discount_Value__c+' Discount_Percentage__c:'+newRebateRequestLine.Discount_Percentage__c+' Special_price__c:'+newRebateRequestLine.Special_price__c);
        }
        /********************************************************************************************* 
        * @author:      Robbie Macatbag
        * @date:        20 April 2015
        * @description: Method that handles addition of rebate request line 
        * @parameters:  NA
        * @revision:         
        
        **********************************************************************************************/
        public pageReference addRequestLineView(){
            errorMessage = '';
            addRequestLine();
            
            if(errorMessage==''){
                
                return saveProgress();
                
            }else{
                return null;
            }
        }

        /********************************************************************************************* 
        * @author:      Robbie Macatbag
        * @date:        24 October 2015
        * @description: Method to close pop-up window 
        * @parameters:  NA
        * @revision:           
        
        **********************************************************************************************/
        public void closePopup() {        
            displayPopup = false;  
            isEditting = false;
            isCreatingNew = false;
           
        }     
        
        /********************************************************************************************* 
        * @author:      Robbie Macatbag
        * @date:        24 October 2015
        * @description: Method use to show pop-up window
        * @parameters:  NA
        * @revision:    25 March 2015 Robbie Macatbag: added disabledLogisticDiscount value.     
        
        **********************************************************************************************/
        public void showPopup() {
            isCreatingNew = true;
            newRebateRequestLine = new Rebate_Request_Line__c();
            newRebateRequestLine.CAR_Rebate_Request__c = currentRebateRequest.id;
            disableLogisticDiscount=false;
            displayPopup = true;    
        }
        
        /********************************************************************************************* 
        * @author:      Robbie Macatbag
        * @date:        25 October 2015
        * @description: Method for inserting the Rebate Request and Rebate Request Line records.
        * @parameters:  NA
        * @revision:    25 March 2015 Robbie Macatbag: Recoded saving process based on remodelled        
        
        **********************************************************************************************/
        public PageReference saveProgress (){
            System.debug('$$$SaveProgress');
            errorMessage = '';
            
            // replace with custom settings value '/a02/o'.
            boolean withSelectedAccount = false;
            List<CAR_RebateReqs__c> newRebateRequestList = new List<CAR_RebateReqs__c>();
            List<Rebate_Request_Line__c>  newRebateRequestLineList = new List<Rebate_Request_Line__c>();
            
            
            CAR_RebateReqs__c tempRebateRequest = new CAR_RebateReqs__c();
            Rebate_Request_Line__c tempRebateRequestLine = new Rebate_Request_Line__c();
            
            try{
                 
                 upsert currentRebateRequest;
                 redirectLink = new PageReference('/apex/RebateRequestView?id='+currentRebateRequest.Id+'&sfdc.override=1');
                }catch(DmlException  e){
                    system.debug('^^DmlException(1):'+e);
                    errorMessage += e.getDMLMessage(0);
                }catch (Exception  e){
                    system.debug('^^Exception(1):'+e);                    
                    //errorMessage += e.getMessage();
                }
           
            
            //Create/edit Rebate Request Line
            
            for(RebateRequestLineWrapper rrlw: rebateRequestLineWrapperList){
                if(rrlw.forDelete==false){
                    if(rrlw.rrlRec.CAR_Rebate_Request__c==null){
                        rrlw.rrlRec.CAR_Rebate_Request__c = currentRebateRequest.id;
                    }
                    newRebateRequestLineList.add(rrlw.rrlRec);
                
                }/*else{
                    if(rrlw.rrlRec.id!=null){
                        deleteRebateRequestLineList.add(rrlw.rrlRec);
                    }
                }*/
            }
            
            
            
            if(newRebateRequestLineList.size()>0){
                system.debug('^^newRebateRequestLineList:'+newRebateRequestLineList);
                try{
                upsert newRebateRequestLineList;
                }catch(DmlException  e){
                    system.debug('^^DmlException(1):'+e);
                    errorMessage += e.getDMLMessage(0);
                }catch (Exception  e){
                    system.debug('^^Exception(1):'+e);                    
                    //errorMessage += e.getMessage();
                }
            }
            if(deleteRebateRequestLineList.size()>0){
                try{
                    delete deleteRebateRequestLineList;
                }catch(DmlException e){
                    system.debug('^^DmlException(2):'+e);
                    errorMessage += e.getDMLMessage(0);
                }catch (Exception  e){
                    system.debug('^^Exception(2):'+e);
                    //errorMessage += e.getMessage();
                }
                
            }
            
            Account_Rebate__c tempAccountRebate = new Account_Rebate__c();
            newAccountRebateList = new List<Account_Rebate__c>();
            for(accountSelectionWrapper asw: accountSelectionList){
                if(asw.selected){
                    
                    tempAccountRebate = new Account_Rebate__c();
                    if(accountRebateMap.get(asw.acc.id)!=null){
                        Account_Rebate__c reb=accountRebateMap.get(asw.acc.id);
                        tempAccountRebate.Account__c = asw.acc.id;
                       tempAccountRebate.Rebate_Request__c = currentRebateRequest.id;
                       
                        newAccountRebateList.add(tempAccountRebate);
                        //newAccountRebateList.add(accountRebateMap.get(asw.acc.id));
                       
                    }else{
                        tempAccountRebate.Account__c = asw.acc.id;
                        tempAccountRebate.Rebate_Request__c = currentRebateRequest.id;
                        newAccountRebateList.add(tempAccountRebate);
                    }
                    withSelectedAccount=true;
                }
                else {
                tempAccountRebate = new Account_Rebate__c();
                    if(accountRebateMap.get(asw.acc.id)!=null){
                        Account_Rebate__c reb=accountRebateMap.get(asw.acc.id);
                        tempAccountRebate.Account__c = asw.acc.id;
                        tempAccountRebate.Rebate_Request__c = currentRebateRequest.id;
                       
                        deleteAccountRebateList.add(tempAccountRebate);
                        //newAccountRebateList.add(accountRebateMap.get(asw.acc.id));
                       
                    }else{
                        tempAccountRebate.Account__c = asw.acc.id;
                        tempAccountRebate.Rebate_Request__c = currentRebateRequest.id;
                        deleteAccountRebateList.add(tempAccountRebate);
                    }
                
                }
            }
            
            if(newAccountRebateList.size()>0){
                system.debug('@@newAccountRebateList['+newAccountRebateList.size()+']:'+newAccountRebateList);
                upsert newAccountRebateList;
            }
            system.debug('newAccountRebateList'+newAccountRebateList);
            //delete unrelated accounts.
            
             if(deleteAccountRebateList.size()>0){
                List<Account_Rebate__c> DeleteRebate = new List<Account_Rebate__c>();
                Set<Id> Acc = new Set<Id>();
                Set<id> Rebate = new Set<Id>();
                for(Account_Rebate__c  dar: deleteAccountRebateList){
               // DeleteRebate = [Select Id from Account_Rebate__c where  Account__c =: dar.Account__c  AND  Rebate_Request__c =:dar.Rebate_Request__c ]; 
               Acc.add(dar.Account__c  );
               
                }
                DeleteRebate = [Select Id from Account_Rebate__c where  Account__c =: Acc  AND  Rebate_Request__c =:currentRebateRequest.id ]; 
                system.debug('@@newAccountRebateList['+newAccountRebateList.size()+']:'+newAccountRebateList);
                
                delete DeleteRebate ;
            }
            
            if(errorMessage==''){
                if(record2clone!=null){
                  
                    redirectLink = new PageReference('/'+currentRebateRequest.Id);
                }else if(!String.isEmpty(currentPageReference.getParameters().get('retURL'))){
                    system.debug('@@currentRebateRequest.Id:'+currentRebateRequest.Id);
                    redirectLink = new PageReference('/'+currentRebateRequest.Id);
                }
                
                redirectLink.setRedirect(true);
                return redirectLink;
            }else{
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, errorMessage);
                    ApexPages.addMessage(myMsg);
                return null;
            }
        }
        
        /********************************************************************************************* 
        * @author:      Robbie Macatbag
        * @date:        25 October 2015
        * @description: wrapper class to determine the selected Accounts
        * @parameters:  NA
        * @revision:      
        
        **********************************************************************************************/
        public class accountSelectionWrapper implements Comparable {
        
            public Account acc {get; set;}
            public Boolean selected {get; set;}
            public String addressTrimed {get;set;}
            
            public accountSelectionWrapper(Account a) {
                acc = a;
                selected = false;
                addressTrimed = trimAddressInfo(a);
            }
            
            public accountSelectionWrapper(){}
            
            public Integer compareTo(Object obj) {
                NewRebateRequestController.accountSelectionWrapper aw = (NewRebateRequestController.accountSelectionWrapper) obj;
                return this.acc.Name.compareTo(aw.acc.Name);
            }
            
            /********************************************************************************************* 
            * @author:      Robbie Macatbag
            * @date:        30 March 2015
            * @description: method to trim address
            * @parameters:  acctinfo - Account record having the billing address
            * @revision:    
            
            **********************************************************************************************/
            public String trimAddressInfo(Account acctinfo){
                String trimedAddress = '';
                Set <String> addressStringSet = new  Set <String>();
                
                if(acctinfo!=null){
                    addressStringSet = new set<String>{acctinfo.BillingStreet, acctinfo.BillingCity, acctinfo.BillingCountry }; //acctinfo.BillingStreet, acctinfo.BillingCity, acctinfo.BillingState, acctinfo.BillingPostalCode, acctinfo.BillingCountry, BillingLatitude, BillingLongitude
                    
                    
                    for(String s: addressStringSet){
                        if((String.isNotEmpty(trimedAddress)) && (String.isNotEmpty(s))  && (s!='null')){
                            trimedAddress+=', ';
                            trimedAddress+=s;
                        }
                        else if((String.isNotEmpty(s))  && (s!='null') && (String.isNotBlank(s)) ){
                            trimedAddress+=s;
                            system.debug('##s:*'+'*');
                        }
                        
                    }
                }
                return trimedAddress;
            }
        }
        
        
        
        /********************************************************************************************* 
        * @author:      Robbie Macatbag
        * @date:        02 March 2015
        * @description: wrapper class to determine the selected Accounts
        * @parameters:  NA
        * @revision:    03/03/2015 Robbie Macatbag: added Account filter functionalities
        * @revision:    12/05/2016 Tomasz Dusza: added 'ORDER BY name' for 'customerRecordTypeList'
        **********************************************************************************************/
        public void filterAccountList(){
            id accountParentId = currentRebateRequest.CAR_Account__c;
            withPayer = String.isEmpty(currentRebateRequest.CAR_Account__c);
            String whereClause ='';
            String payerInclussionParameter = '';
            system.debug('****@@filter:'+accountFilter.name);
            system.debug('@@accountParentId:'+accountParentId);
            if(accountParentId!=null){//(!String.isEmpty(accountParentId)) || (String.isEmpty(accountParentId) && (!String.isEmpty(accountFilter.Name)))
                
                
                set<ID> customerRecordTypeIds = new set<ID>();
                set<ID> prospectRecordTypeIds = new set<ID>();
                accountQueryStatement = 'SELECT id, name,  AccountNumber, BillingStreet, BillingCity, BillingState, BillingPostalCode, BillingCountry, ERP_ID__c FROM Account ';
                boolean withFilters = false;
                list<RecordType> customerRecordTypeList = [SELECT Id,name FROM RecordType WHERE  Name LIKE 'Customer - %' ORDER BY name];
                system.debug('@@accountParentId:'+accountParentId);
                if(accountParentId == null){
                    accountFilter.name = '';
                }
                
                for(RecordType crtl: customerRecordTypeList){
                    customerRecordTypeIds.add(crtl.id);
                }
                
                list<RecordType> prospectRecordTypeList = [SELECT Id,name FROM RecordType WHERE  Name LIKE 'Prospect - %' ORDER BY name];
                for(RecordType prtl: prospectRecordTypeList){
                    prospectRecordTypeIds.add(prtl.id);
                }
                if(includePayer){
                    payerInclussionParameter = ' OR id = \''+accountParentId+'\'';
                }
                
                /*
                //if (currentRebateRequest.CAR_Account__c!=null){
                    //whereClause = ' WHERE id NOT IN :selectedAccountIds AND ((RecordTypeId IN: customerRecordTypeIds  AND ERP_Payer_id_and_Id_comparison__c = true) OR (RecordTypeId IN: prospectRecordTypeIds AND ERP_Payer_id__c != NULL AND ERP_Payer_id__c = NULL)) AND ParentId =:accountParentId ';
                // }else{
                    //whereClause = ' WHERE id NOT IN :selectedAccountIds AND ((RecordTypeId IN: customerRecordTypeIds  AND ERP_Payer_id_and_Id_comparison__c = true) OR (RecordTypeId IN: prospectRecordTypeIds AND ERP_Payer_id__c != NULL AND ERP_Payer_id__c = NULL)) ';
                //}
                */
                
                /*
                //previous where clause
                //whereClause = ' WHERE id NOT IN :selectedAccountIds AND ((RecordTypeId IN: customerRecordTypeIds  AND ERP_Payer_id_and_Id_comparison__c = true) OR (RecordTypeId IN: prospectRecordTypeIds AND ERP_Payer_id__c != NULL AND ERP_Payer_id__c = NULL)) AND ParentId =:accountParentId ';
                */
                
                
               whereClause = ' id NOT IN :selectedAccountIds AND ParentId =:accountParentId ';
                
             
               
                List<accountSelectionWrapper> tempAccountSelectionList = new List<accountSelectionWrapper>();
                tempAccountSelection = new accountSelectionWrapper();
                Set<id> selectedAccountIds = new Set<Id>();
                 system.debug('@@@selectedAccountIds'+selectedAccountIds);
               if(accountList.size()>0 && !(accountSelectionList.size()>0)){
                    for(Account acct: accountList){
                        accountSelectionList.add(new accountSelectionWrapper(acct));
                    } 
                   accountSelectionList.sort();
                }else{
                    /*if(accountFilter.Territory__c!=null){
                        whereClause+=' AND Territory__c = \''+accountFilter.Territory__c+'\' ';
                        withFilters = true;
                    }
                    */
                    system.debug('****@@filter:'+accountFilter.name);
                    if(!String.isEmpty(accountFilter.name)){
                        whereClause+=' AND name like \'%'+accountFilter.name+'%\' '; 
                        withFilters = true; 
                    }
                    
                    tempAccountSelectionList = new List<accountSelectionWrapper>();
                    
                    for(accountSelectionWrapper asl: accountSelectionList){
                        if(asl.selected==true){
                            tempAccountSelection = new accountSelectionWrapper();
                            tempAccountSelection.selected = asl.selected;
                            tempAccountSelection.acc = asl.acc;
                            selectedAccountIds.add(asl.acc.id);
                            tempAccountSelectionList.add(tempAccountSelection);
                        }
                    }
                  system.debug('@@@selectedAccountIds'+selectedAccountIds);
                    accountSelectionList = new List<accountSelectionWrapper>();
                    for(accountSelectionWrapper tasl:tempAccountSelectionList){
                        tempAccountSelection = new accountSelectionWrapper();
                        tempAccountSelection.acc = tasl.acc;
                        tempAccountSelection.selected = tasl.selected;
                        accountSelectionList.add(tempAccountSelection);
                    }
                    accountSelectionList.sort();
                    accountQueryStatement+=' WHERE ('+whereClause+')';
                    if(includePayer){
                        accountQueryStatement+= payerInclussionParameter;
                    }
                    system.debug('@@accountQueryStatement:'+accountQueryStatement);
                    system.debug('@@@ accountQueryStatement:'+accountQueryStatement);
                    accountList = Database.query(accountQueryStatement);
                    
                    system.debug('@@@ accountQueryStatement:'+accountList);
                    
                    String strurl = ApexPages.currentPage().getUrl();
                    strurl = strurl.split('apex/')[1];
                    
                    
                    if(strurl.left(16) == 'NewRebateRequest'){
                        for(Account acct: accountList){
                            accountSelectionList.add(new accountSelectionWrapper(acct));
                        }
                        system.debug('Final List'+ accountSelectionList);
                        accountSelectionList.sort();
                    }
                }
            }
        }    
        
        /********************************************************************************************* 
        * @author:      Robbie Macatbag
        * @date:        23 March 2015
        * @description: Condition handler
        * @parameters:  NA
        * @revision:    
        
        **********************************************************************************************/
        public void checkConditions(){
            //if discount populated then apply logistic field not valid, hide/read-only.
            disableLogisticDiscount = false;
            
       //     if(newRebateRequestLine.Special_price__c!=null){
       //         disableLogisticDiscount = true;
       //         newRebateRequestLine.Apply_logistic_discounts__c = false;
       //     }
            
       //     if(newRebateRequestLine.Discount_Percentage__c!=null){
       //         newRebateRequestLine.Apply_logistic_discounts__c = true;
       //         disableLogisticDiscount = true;
       //     }
            
            if(newRebateRequestLine.Discount_Percentage__c!=null){
                disableLogisticDiscount = true;
                newRebateRequestLine.Apply_logistic_discounts__c = false;
            }
            
            if(newRebateRequestLine.Special_Price__c!=null){
                newRebateRequestLine.Apply_logistic_discounts__c = true;
                disableLogisticDiscount = true;
            }
            
            
        }
        /********************************************************************************************* 
        * @author:      Robbie Macatbag
        * @date:        23 March 2015
        * @description: method to support Select all and Deselect All function
        * @parameters:  NA
        * @revision:    
        
        **********************************************************************************************/
        public void selectShipToOption(){
            boolean choice;
            if(selectAllChoice=='true'){
                choice=true;
            }else if(selectAllChoice=='false'){
                choice=false;
            }
            system.debug('@@choice:'+choice+'  !choice:'+!choice);
            
            for(accountSelectionWrapper asw: accountSelectionList){
                system.debug('@@!(asw.selected==choice):'+!(asw.selected==choice));
                if(!(asw.selected==choice)){
                    system.debug('@@asw.selected ('+asw.acc.id+') before:'+asw.selected);
                    asw.selected = choice;
                    system.debug('@@asw.selected ('+asw.acc.id+') after:'+asw.selected);system.debug('@@asw:'+asw);
                }
            }
            //return null;
        }
        
        public PageReference cancelProgress(){
            if(record2clone!=null){
                redirectLink = new PageReference('/apex/NewRebateRequest?id='+record2clone+'&isView=1');
            }else if(!String.isEmpty(currentPageReference.getParameters().get('retURL'))){
                redirectLink = new PageReference('/apex/NewRebateRequest?id='+currentRebateRequest.Id+'&isView=1');
            }else{
                redirectLink=new PageReference('/a02/o');
                
            }
            redirectLink.setRedirect(true);
            return redirectLink;
        }
        
        public pageReference cloneRecord(){
            if(currentRebateRequestId!=null){
                pageReference cloneURL = new pageReference('/apex/NewRebateRequest?Cloned='+currentRebateRequest.Id+'&retURL='+EncodingUtil.urlEncode('/'+currentRebateRequest.Id, 'UTF-8'));
                system.debug('@@redireting page1');
                cloneURL.setRedirect(true);
                return cloneURL;
            }else{
                system.debug('@@redireting page2');
                return null;
            }
        }

        public class RebateRequestLineWrapper {

            public Boolean forDelete {get; set;}
            public Rebate_Request_Line__c rrlRec {get; set;}
            public integer rrlIndex {get;set;}

            public RebateRequestLineWrapper(integer indexNum,Rebate_Request_Line__c rebateLineRec ,boolean toDelete) {
                rrlRec = rebateLineRec;
                rrlIndex = indexNum;
                forDelete = toDelete;
            }
            
            public RebateRequestLineWrapper(){}
            
        }
        
        public void DeleteRebateRequestLine(){
            List<RebateRequestLineWrapper> rebateRequestLineWrapperListTemp = new List<RebateRequestLineWrapper>();
            for(RebateRequestLineWrapper rrwlRec: rebateRequestLineWrapperList){
                if(rrwlRec.rrlIndex == Integer.valueOf(currentIndex) && rrwlRec.rrlRec.id !=null ){
                    deleteRebateRequestLineList.add(rrwlRec.rrlRec);
                    system.debug('^^deleteRebateRequestLineList:'+deleteRebateRequestLineList);
                }else if(rrwlRec.rrlIndex != Integer.valueOf(currentIndex)) {
                    rebateRequestLineWrapperListTemp.add(rrwlRec);
                }
            }
            rebateRequestLineWrapperList = rebateRequestLineWrapperListTemp;
            system.debug('^^rebateRequestLineWrapperList:'+rebateRequestLineWrapperList);
            closePopup();
        }
        public pageReference DeleteRebateRequestLineView(){
            system.debug('##currentIndex:'+currentIndex);
            system.debug('##canDeleteInView:'+canDeleteInView);
            if (canDeleteInView=='true'){
            
                errorMessage = '';

                DeleteRebateRequestLine();
                currentIndex = '';
                if(errorMessage==''){
                    return saveProgress();
                }else{
                    return null;
                }
            }
                
            canDeleteInView='false';
            return null;
        }
        
        public void EditRebateRequestLine(){
            isEditting = true;
            newRebateRequestLine = new Rebate_Request_Line__c();
            for(RebateRequestLineWrapper rrwlRec: rebateRequestLineWrapperList){
                if(rrwlRec.rrlIndex == Integer.valueOf(currentIndex) ){
                    newRebateRequestLine = rrwlRec.rrlRec;
                    break;
                }
            }
            displayPopup = true;
        }
        
        public void SaveEditedRebateRequestLine(){
            for(RebateRequestLineWrapper rrwlRec: rebateRequestLineWrapperList){
                if(rrwlRec.rrlIndex == Integer.valueOf(currentIndex) ){
                    rrwlRec.rrlRec = newRebateRequestLine;
                    break;
                }
            }
            closePopup();
        }
        
        
        /********************************************************************************************* 
        * @author:      Robbie Macatbag
        * @date:        30 March 2015
        * @description: method to trim address
        * @parameters:  acctinfo - Account record having the billing address
        * @revision:    
        
        **********************************************************************************************/
        public String trimAddressInfo(Account acctinfo){
            String trimedAddress = '';
            Set <String> addressStringSet = new  Set <String>();
            
            if(acctinfo!=null){
                addressStringSet = new set<String>{acctinfo.BillingStreet, acctinfo.BillingCity, acctinfo.BillingCountry }; //acctinfo.BillingStreet, acctinfo.BillingCity, acctinfo.BillingState, acctinfo.BillingPostalCode, acctinfo.BillingCountry, BillingLatitude, BillingLongitude
                
                
                for(String s: addressStringSet){
                    if(!(String.isEmpty(trimedAddress)) && !(String.isEmpty(s)) && s!='null'){
                        trimedAddress+=', ';
                        trimedAddress+=s;
                    }
                    else if((String.isNotEmpty(s))  && (s!='null') && (String.isNotBlank(s)) ){
                        trimedAddress+=s;
                    }
                    
                }
            }
            return trimedAddress;
        }
        
        public pageReference submitForApproval(){
            return new pagereference('/p/process/Submit?id='+currentRebateRequest.Id+'&scontrolCaching=1&sfdc.override=1'+'&saveURL='+EncodingUtil.urlEncode('/'+currentRebateRequest.Id, 'UTF-8'));
        }
        /*
        public pageReference editRebateRequestRecord(){
            pageReference redirectLink = new pagereference('/apex/NewRebateRequest?id='+currentRebateRequest.Id+'&retURL='+EncodingUtil.urlEncode(getcurrentRecordViewURL(), 'UTF-8')+'&saveURL='+EncodingUtil.urlEncode(getcurrentRecordViewURL(), 'UTF-8'));
            redirectLink.setRedirect(true);
            return redirectLink;
        } */
        
        public pageReference deleteRebateRequestRecord(){
            system.debug('@@deleting method');
            PageReference redirectLink = new PageReference('/a0X/o');
            if(currentRebateRequest.id!=null){
                List<CAR_RebateReqs__c> forDeleteRR =  [SELECT id FROM CAR_RebateReqs__c WHERE id =:currentRebateRequest.id];
                system.debug('@@deleting:'+ forDeleteRR);
                delete forDeleteRR;
            }
            redirectLink.setRedirect(true);
            system.debug('@@returning:'+redirectLink );
            return redirectLink;
        }
        
        /*
        public String getcurrentRecordViewURL(){
            String currentRecordViewURL;
            currentRecordViewURL = '/apex/NewRebateRequest?id='+currentRebateRequest.Id+'&isView=1';
            return currentRecordViewURL;
        }*/
    }