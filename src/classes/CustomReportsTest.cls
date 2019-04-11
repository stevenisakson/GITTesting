/*
    @Author             : Tumish Tak (CBS Team)
    @Date Created       : 20 - June - 2018
    @Description        : Test class for CustomReports apex class
*/

@isTest
public class CustomReportsTest {

    	 @testSetup static void dataSetup() {
             	Custom_Reports__c cusSettings = new Custom_Reports__c(Name='Test Report New',Business_Unit__c='US',External_System_Report__c=true,Report_link__c='https://www.google.com/?gws_rd=ssl',Report_Name__c='Test Report',Section_Name__c='Test Report',Sequence__c=1);
             	insert cusSettings;
         }
    
    	static testMethod void testOnClick()
        {
            //Create User 
            User usr = TestDataBuilder.createUser(1, TestDataBuilder.getUserProfileId('System Administrator') );
        	insert usr;
          
            System.runAs(usr){
               CustomReports.getReportInfo(); 	
            }
        }
}