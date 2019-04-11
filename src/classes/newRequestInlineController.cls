/*********************************************************************
Name:        newRequestInlineController
Date:        03 AUG 16
Description: Controller for Inline VF page in Request
History:     03 AUG 16 - Regina Ligan - created controller
             09 AUG 16 - Sam Oberes - added CTRLR_doSave and getStatuses to support the page's actionfunction
             25 AUG 16 - Anjerico Caburnay - added Field Label to csFields
*********************************************************************/

public with sharing class newRequestInlineController{
    
    public Id RequestId {get;set;}
    public Id getAccountId {get; set;}
    public List<RequestLineItem__c> csFields {get; set;}
    public List<RequestLineItem__c> csFieldsTranslated {get; set;}
    List<String> fieldNames {get; set;}

    
    //Method for Saving the status of the request line item upon click of the data steward on the status picklist
    public PageReference CTRLR_doSave()
    {
        String requestLineItemId = ApexPages.currentPage().getParameters().get('requestLineItemId');
        String currentStatus = ApexPages.currentPage().getParameters().get('currentStatus');
        
        RequestLineItem__c rli = new RequestLineItem__c();
        rli.Id = Id.valueOf(requestLineItemId);
        rli.Status__c = currentStatus;
        update rli;
        
        return null;
    }
    
    //Method to get the request line items and display it in the inline page
    public newRequestInlineController(ApexPages.StandardController stdCon) {
      
        RequestId = ApexPages.currentPage().getParameters().get('Id');
        fieldNames = new List<String>{'account__c'};
        csFields = new List<RequestLineItem__c>([SELECT Id,Field_Name__c,Existing_Value__c,New_Value__c, Status__c, Request__r.Status__c,Field_Label__c,New_Value_Display__c,Existing_Value_Display__c,Account_Name__c,Action__c,Team_Member__c,Selected_Account_Id__c FROM RequestLineItem__c WHERE Request__c =: RequestId ORDER BY Id]);

        if(!test.isRunningTest())
        stdcon.addfields(fieldNames);
        Request__c req = (Request__c)stdcon.getRecord();
        getAccountId = req.account__c;

    }

    //Method to get the status from the picklist on the inline VF page
    public List<SelectOption> getStatuses()
    {
        List<SelectOption> options = new List<SelectOption>();

        Schema.DescribeFieldResult fieldResult = RequestLineItem__c.Status__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();

        for(Schema.PicklistEntry f : ple)
        {
            options.add(new SelectOption(f.getValue(), f.getLabel()));
        }
        return options;
    }
    
     //Method to get the action from the picklist on the inline VF page
    /* public List<SelectOption> getActions()
    {
        List<SelectOption> options = new List<SelectOption>();

        Schema.DescribeFieldResult fieldResult = RequestLineItem__c.Action__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();

        for(Schema.PicklistEntry f : ple)
        {
            options.add(new SelectOption(f.getValue(), f.getLabel()));
        }
        return options;
    }*/

}