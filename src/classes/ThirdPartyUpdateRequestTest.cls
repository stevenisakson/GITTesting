/*********************************************************************
Name:ThirdPartyUpdateRequestTest
Date:25 Oct 2018
Description: test Class for ThirdPartyUpdateRequest
             
*********************************************************************/

@isTest
private class ThirdPartyUpdateRequestTest {
    
	private static testMethod void thirdpartyupdate() {
        Account accountInstance = new Account();
        Id p = TestDataBuilder.getUserProfileId(Label.System_Administrator_Profile);
        User u = TestDataBuilder.createUser(1, p);
        u.Business_Unit__c = 'CPN - India';
        u.Country_Code__c = 'IN';
        u.CAN_Business__c = 'CPN';
        u.Region__c='CPN India';
        insert u;
        
        system.debug('user details:'+ u);
        System.runAs(u) {
            
               
                Map<id, id> reqaccnt= new Map<id,id>();
            
                // Insert list of Third Party custom setting fields.
                List<Third_Party_Protected_Fields__c> pfList = new List<Third_Party_Protected_Fields__c>();
                List<RequestLineItem__c> rqltmlist = new List<RequestLineItem__c>();
            
                
                Third_Party_Protected_Fields__c pf1 = new  Third_Party_Protected_Fields__c();
                pf1.Name = 'Email';
                pf1.Field_Name__c = 'Company_Email__c';
                pf1.Field_Label__c ='Email';
                pf1.Business_Unit__c = 'CPN - India';
                pf1.Object__c='Account';
                pf1.Order__c=1;
                pfList.Add(pf1);
                
                Third_Party_Protected_Fields__c  pf2 = new Third_Party_Protected_Fields__c();
                pf2.Name = 'Account Owner';
                pf2.Field_Name__c = 'Account_Owner__c';
                pf2.Field_Label__c ='Account Owner';
                pf2.Business_Unit__c = 'CPN - India';
                pf2.Object__c='Account';
                pf2.Order__c= 2;
                pfList.Add(pf2);
                
                Third_Party_Protected_Fields__c  pf3 = new Third_Party_Protected_Fields__c();
                pf3.Name = 'Social Media Address';
                pf3.Field_Name__c = 'Social_Media_Address__c';
                pf3.Field_Label__c ='Social Media Address';
                pf3.Business_Unit__c = 'CPN - India';
                pf3.Object__c='Account';
                pf3.Order__c=3;
                pfList.Add(pf3);
                
                insert pfList;
                system.debug('Inserted custom setting records for third party----:'+ pfList);
            
                // Insert account
                accountInstance = TestDataBuilder.createAccount();
                accountInstance.Business__c = 'CPN - India';
                accountInstance.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Third Party CPN India').getRecordTypeId();
               // accountInstance.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(Label.Third_Party_Read_Only_Record_Type).getRecordTypeId();
                accountInstance.Company_Email__c='test@gmail.com';
                accountInstance.Phone='1234567';
                accountInstance.Social_Media_Address__c='www.test.com';
                insert accountInstance;
                system.debug('Inserted Account----:'+ accountInstance);
            
                // insert related request for account update
                Request__c r1= new Request__c();
                r1.Account__c = accountInstance.Id;
                r1.Status__c = 'Submitted';
                r1.RecordTypeId = Schema.SObjectType.Request__c.getRecordTypeInfosByName().get(Label.Third_Party_Update_Record_Type).getRecordTypeId();
                insert r1;
                system.debug('Inserted Request----:'+ r1);
                
                // insert Request Line Item details 
                RequestLineItem__c rl1=new RequestLineItem__c();
                rl1.Field_Name__c='Company_Email__c';
                rl1.New_Value__c='testupdated@gmail.com';
                rl1.Status__c='Approved';
                //rl1.Account_Id__c=accountInstance.id;
                rl1.Request__c=r1.id;
                rqltmlist.add(rl1);
                
                RequestLineItem__c rl2=new RequestLineItem__c();
                rl2.Field_Name__c='Social_Media_Address__c';
                rl2.New_Value__c='www.testupdated.com';
                rl2.Status__c='Declined';
                //rl1.Account_Id__c=accountInstance.id;
                rl2.Request__c=r1.id;
                rqltmlist.add(rl2);
            
                insert rqltmlist;
            
                reqaccnt.put(r1.id, accountInstance.Id);
                
               Test.startTest();
               ThirdPartyUpdateRequest controller = new ThirdPartyUpdateRequest();
               controller.thirdPartyApprove(reqaccnt);
               Test.stopTest();
        }



}




}