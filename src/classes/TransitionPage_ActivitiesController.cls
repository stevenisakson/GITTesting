/*
* @author : Tom Quattromini, Jesfer Baculod (Cloud Sherpas)
* @date : Original - 08/03/2015, Last Modified - 09/02/2015
* @description : controller class for Activities_Transition_Page
*/
public class TransitionPage_ActivitiesController{
    private final Event evnt;
    public PageReference currentPageReference {get;set;}
    ID userId = UserInfo.getUserId();

    // The extension constructor initializes the private member variable evnt by using the getRecord method from the standard controller.
    public TransitionPage_ActivitiesController(ApexPages.StandardController stdController) {
        this.evnt = (Event)stdController.getRecord();
        currentPageReference  = ApexPages.currentPage();
    }
    
    public PageReference redirectpage(){
        PageReference redirectLink = new PageReference('/00U/e');
        set<String> paramKeys = currentPageReference.getParameters().keySet();
        User currentUser = [SELECT Id, Name,ProfileId, Business_Unit__c FROM User WHERE Id =:userId];
        
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
         if(currentUser.Id != Label.Integrationuserid)
            {
                 for(MobileFirstSettings__c mob : mobSettingList)
                {
                    if(mob.ProfileId__c == currentUser.ProfileId)
                    {
                        redirectLink.getParameters().put(os.Activity_Mobile_First_Field_Id__c,'1');            
                    }
                }
        redirectLink.getParameters().put(os.Event_Business_Unit_Field_ID__c,currentUser.Business_Unit__c);
        }
        redirectLink.setRedirect(true);
        return redirectLink;
    }
}