Public class NewRebateRequestShipToController{
    ID currentAccountRecordID;
    PageReference currentPageReference = ApexPages.currentPage();
    Account_Rebate__c currentAccountRecord;
    
    public NewRebateRequestShipToController(ApexPages.StandardController controller) {
        currentAccountRecord = (Account_Rebate__c)controller.getRecord();
        currentAccountRecordID = currentPageReference.getParameters().get(Label.Account_ID_Object);
    }
    
    public pageReference redirectToNewRebate(){
        pageReference newReabatePage;
        if(currentAccountRecordID!=null){
            newReabatePage = new Pagereference('/apex/NewRebateRequest?retURL=%2Fa02%2Fo&save_new=1&sfdc.override=1&shiptoId='+currentAccountRecordID);
        }else{
           //currentPageReference.getParameters().put('override',0);
 
        }
        /*
        pageReference newReabatePage = Page.NewRebateRequest;
        newReabatePage.getParameters().put('retURL', '%2F'+currentAccountRecordID);
        newReabatePage.getParameters().put('save_new', 1);
        newReabatePage.getParameters().put('sfdc.override', 1);
        newReabatePage.getParameters().put('shiptoId',currentAccountRecordID);
        */
        newReabatePage.setRedirect(true);
        return newReabatePage;
    }
    
}