/*
* @author : Jesfer Baculod (Cloud Sherpas)
* @date : Original - 09/02/2015
* @description : controller class for Opportunity_Transition_Page
*/
public class TransitionPage_OpportunityController {
    
    private final Opportunity opp;
    public PageReference currentPageReference {get;set;}
    ID userId = UserInfo.getUserId();

    // The extension constructor initializes the private member variable evnt by using the getRecord method from the standard controller.
    public TransitionPage_OpportunityController(ApexPages.StandardController stdController) {
        this.opp = (Opportunity)stdController.getRecord();
        currentPageReference  = ApexPages.currentPage();
    }
    
    public PageReference redirectpage(){
        PageReference redirectLink = new PageReference('/006/e');
        set<String> paramKeys = currentPageReference.getParameters().keySet();
        User currentUser = [SELECT Id,ProfileId, Name, Business_Unit__c FROM User WHERE Id =:userId];
        
        for(string ks: paramKeys){
            if(ks != 'sfdc.override' && ks != 'save_new'){
                redirectLink.getParameters().put(ks, currentPageReference.getParameters().get(ks));
            }
        }
        
        // auto populate fields
        redirectLink.getParameters().put('nooverride','1');
        //Get Business Unit Field ID from Override Setting Custom Setting
        Override_Settings__c os = Override_Settings__c.getOrgDefaults();
        List<MobileFirstSettings__c > mobSettingList = MobileFirstSettings__c.getall().values();
       
 /*       if(opp.AccountId <> Null)
        {
           Account acc = [Select CurrencyIsoCode
                          from Account
                          where Id =: opp.AccountId]; 
         redirectLink.getParameters().put(os.Opportunity_Currency_Field_Id__c,acc.CurrencyIsoCode);
             
        }*/
        
         if(currentUser.Id != Label.Integrationuserid)
            {
                for(MobileFirstSettings__c mob : mobSettingList)
                {
                    if(mob.ProfileId__c == currentUser.ProfileId)
                    {
                     redirectLink.getParameters().put(os.Opportunity_Mobile_First_Field_Id__c,'1');
                    }
                }
        redirectLink.getParameters().put(os.Opportunity_Business_Unit_Field_ID__c,currentUser.Business_Unit__c);
        }
        redirectLink.setRedirect(true);
        return redirectLink;
    }

}