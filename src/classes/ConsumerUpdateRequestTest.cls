/*********************************************************************
Name:ConsumerUpdateRequestTest
Date:30 Oct 2018
Description: test Class for ConsumerUpdateRequest 
             
*********************************************************************/


@isTest
private class ConsumerUpdateRequestTest {
    
private static testMethod void consumerupdate() {
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
            
               
                Map<id,id> reqaccnt= new Map<id,id>();
            
                // Insert list of consumer custom setting fields.
                List<Consumer_Protected_Fields__c> consmrpfList = new List<Consumer_Protected_Fields__c>();
                List<RequestLineItem__c> rqltmlist = new List<RequestLineItem__c>();
            
                
                Consumer_Protected_Fields__c consmpf1 = new  Consumer_Protected_Fields__c();
                consmpf1.Name = 'Email';
                consmpf1.Field_Name__c = 'Company_Email__c';
                consmpf1.Field_Label__c ='Email';
                consmpf1.Business_Unit__c = 'CPN - India';
                consmpf1.Object__c='Account';
                consmpf1.Order__c=1;
                consmrpfList.Add(consmpf1);
                
                Consumer_Protected_Fields__c  consmpf2 = new Consumer_Protected_Fields__c();
                consmpf2.Name = 'Market Influencer';
                consmpf2.Field_Name__c = 'Market_Influencer__c';
                consmpf2.Field_Label__c ='	Market Influencer';
                consmpf2.Business_Unit__c = 'CPN - India';
                consmpf2.Object__c='Account';
                consmpf2.Order__c= 2;
                consmrpfList.Add(consmpf2);
                
                Consumer_Protected_Fields__c  consmpf3 = new Consumer_Protected_Fields__c();
                consmpf3.Name = 'Social Media Address';
                consmpf3.Field_Name__c = 'Social_Media_Address__c';
                consmpf3.Field_Label__c ='Social Media Address';
                consmpf3.Business_Unit__c = 'CPN - India';
                consmpf3.Object__c='Account';
                consmpf3.Order__c=3;
                consmrpfList.Add(consmpf3);
                
                insert consmrpfList;
                system.debug('Inserted custom setting records for consumer----:'+ consmrpfList);
            
                // Insert account
                accountInstance = TestDataBuilder.createAccount();
                accountInstance.Business__c = 'CPN - India';
               accountInstance.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Consumer CPN India').getRecordTypeId();
                //accountInstance.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(Label.Consumer_Read_Only_Record_Type).getRecordTypeId();
                accountInstance.Company_Email__c='test@gmail.com';
                accountInstance.Phone='1234567';
                accountInstance.Social_Media_Address__c='www.test.com';
                insert accountInstance;
                system.debug('Inserted Account----:'+ accountInstance);
            
                // insert related request for account update
                Request__c r1= new Request__c();
                r1.Account__c = accountInstance.Id;
                r1.Status__c = 'Submitted';
                r1.RecordTypeId = Schema.SObjectType.Request__c.getRecordTypeInfosByName().get(Label.Consumer_Update_CPN_INDIA_Record_Type).getRecordTypeId();
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
               ConsumerUpdateRequest controller = new ConsumerUpdateRequest();
               controller.consumerApprove(reqaccnt);
               Test.stopTest();
        }



}
    
    

}