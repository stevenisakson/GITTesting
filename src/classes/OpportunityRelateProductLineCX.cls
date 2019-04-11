/*
* @author : Jesfer Baculod (Cloud Sherpas)
* @date : Original - 08/19/2015
* @description : extension class for OpportunityRelateProductLine page 
                    (transition page for adding Related Product Line after creating Opportunity)
*/
public class OpportunityRelateProductLineCX {
    //class constructor
    public OpportunityRelateProductLineCX(ApexPages.StandardController stdController) {}

    //method for adding Related Product Line record on Opportunity
    public pageReference addRelatedProductLine(){
        User curUser = [Select Id, Name, Business_Unit__c From User Where Id = : UserInfo.getUserId()];

        if (ApexPages.currentPage().getParameters().get('newid') != null){
            Opportunity curOpp = [Select Id, Business_Unit__c From Opportunity Where Id = : ApexPages.currentPage().getParameters().get('newid') ];

            //Update Opportunity
            curOpp.Business_Unit__c = curUser.Business_Unit__c;     //Assign User's Business Unit
            update curOpp;

            //Insert Related Product Line 
           // Commented By Shalu Req 4.9
   /*         Related_Product_Line__c rpl = new Related_Product_Line__c(
                Opportunity__c = ApexPages.currentPage().getParameters().get('newid'),  //Assign newly created Opportunity
                Product_Line__c = ApexPages.currentPage().getParameters().get('pId')    //Assign passed Product Line ID from C360 Inline page (source)
            );
            insert rpl;*/
        }
        
        //Return back to Account 
        PageReference pref = new PageReference('/' + ApexPages.currentPage().getParameters().get('aid'));
        pref.setRedirect(true);
        return pref;  
    }
}