@istest(seeAllData = true)
public Class ConnectionHelperTest {
   
    static testmethod void test_shareRecordToTarget(){
    
     Profile profileId = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1];
     User stdUserdDta = new User();
     stdUserdDta.Username='testameen1234@test.com';
     stdUserdDta.IsActive = FALSE;
     stdUserdDta.Business_Unit__c = 'CBS';
     stdUserdDta.emailencodingkey = 'UTF-8';
     stdUserdDta.localesidkey = 'en_US';
     stdUserdDta.languagelocalekey = 'en_US';
     stdUserdDta.timezonesidkey = 'America/Los_Angeles';     
     stdUserdDta.Email= 'testameen1234@test.com';     
     stdUserdDta.LastName='testc';
     stdUserdDta.Alias='tadams1';
     stdUserdDta.ProfileId= profileId.id ;  
     List<PartnerNetworkConnection> connMap=[select Id, ConnectionStatus, ConnectionName from PartnerNetworkConnection where ConnectionStatus = 'Accepted' and connectionname='ACA'];
     List<PartnerNetworkRecordConnection> lstShareRecords= new List<PartnerNetworkRecordConnection>();  
     
   for(PartnerNetworkConnection network : connMap)
   {  
    PartnerNetworkRecordConnection newrecord = new PartnerNetworkRecordConnection();
   
     newrecord.ConnectionId = network.Id;
     
     //newrecord.LocalRecordId = opp.accountid;
    
     newrecord.SendClosedTasks =false;
     newrecord.SendOpenTasks = false;
     newrecord.SendEmails = false;
    
     lstShareRecords.add(newrecord);
     }
    insert lstshareRecords;
    
    Test.StartTest();
     insert  stdUserdDta;
          
    Test.StopTest();

    }
    
}