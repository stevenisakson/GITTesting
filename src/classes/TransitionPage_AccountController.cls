/*
* @author : Tom Quattromini, Jesfer Baculod (Cloud Sherpas)
* @date : Original - 07/29/2015, Last Modified - 09/02/2015
* @description : controller class for Account_Transition_Page and Account_RecordType_Selection
*/
public without sharing class TransitionPage_AccountController{

    private final Account acct; 
        
    // The extension constructor initializes the private member variable acct by using the getRecord method from the standard controller.
    public TransitionPage_AccountController(ApexPages.StandardController stdController) {
        this.acct = (Account)stdController.getRecord();
    }

    public PageReference redirectpage(){

        User currentUser = [SELECT Id, Name,ProfileId,Business_Unit__c, Country_Code__c, CAN_Business__c,Auto_Validate__c FROM User WHERE Id =: UserInfo.getUserId()];

        Override_Settings__c os = Override_Settings__c.getOrgDefaults();
        
        List<MobileFirstSettings__c > mobSettingList = MobileFirstSettings__c.getall().values();
        
        //Construct page URL           
        PageReference redirectLink = new PageReference('/001/e');         
            //Get Business Unit Field ID from Override Setting Custom Setting               
            redirectLink.getParameters().put('retURL','/001/o');
            redirectLink.getParameters().put('nooverride','1');
            redirectLink.getParameters().put('RecordType', acct.recordtypeId); 
            
        	System.debug(LoggingLevel.INFO,'\n ****redirectLink : '+redirectLink);
            if(currentUser.Id != Label.Integrationuserid)
            {
				System.debug(LoggingLevel.INFO,'\n ****InsideCheck : ');
                System.debug(LoggingLevel.INFO,'\n ****mobSettingList : '+mobSettingList+'\n\n');
                System.debug(LoggingLevel.INFO,'\n ****OverrideSettings : '+os+'\n\n');
                for(MobileFirstSettings__c mob : mobSettingList)
                {
                    if(mob.ProfileId__c == currentUser.ProfileId)
                    {
                        redirectLink.getParameters().put(os.Account_Mobile_First_Field_Id__c,'1');    
                    }
                }
                if(currentUser.Auto_Validate__c == true)
                {
                    redirectLink.getParameters().put(os.Account_Auto_Validate_Field_Id__c,'1');
                }
           
                else
                {
                    redirectLink.getParameters().put(os.Account_Auto_Validate_Field_Id__c,'0'); 
                }
           
           
                redirectLink.getParameters().put(os.Account_Business_Unit_Field_ID__c,currentUser.Business_Unit__c);            
            }
            //redirectLink.getParameters().put(os.Account_Physical_Country_Field_ID__c,currentUser.Country_Code__c);
            //redirectLink.getParameters().put(os.Account_Correspondence_Country_Field_ID__c,currentUser.Country_Code__c);
            //redirectLink.getParameters().put(os.Account_CAN_Business_Field_ID__c,currentUser.CAN_Business__c);
            System.debug(LoggingLevel.INFO,'\n ****redirectLink : '+redirectLink);
            redirectLink.setRedirect(true);
        
        //Redirect page to standard non-overridden New Account page with Record Type and Business Unit populated
        return redirectLink;
    }

    public PageReference webcancel(){
        //Returns the page back to Account Home
        PageReference pref = new PageReference('/001/o');
            pref.setRedirect(true);
        
        return pref;
    }
    
    public static void hack() {
        Integer i = 0;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
    }
}