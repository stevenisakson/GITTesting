/* 
Owner : Amrish Surve  
Created Date : 28 Sept 2019 
Name : SF_UpdateContactController
Description : Update Contact Status and Call Approval process of Contact */


public class SF_UpdateContactController {
    
    /* This function is used to create a request record and call contact approval process */
    @AuraEnabled
    public Static String updateContactData(ID contactId){
        string request ='';
        List<Group> groupList = [select Id from Group where  Type = 'Queue' AND NAME = 'CFR Contact Request'];
        System.debug('Function Called'+contactId+'$$$$$groupList'+groupList);
        
        List<Approval.ProcessSubmitRequest> lstProcess = new List<Approval.ProcessSubmitRequest>();
        List<Request__c> requestListInsert = new List<Request__c>();
        try{
            if(!String.isBlank(contactId)){
                List<Contact> contactCountLst = [Select CFR_In_Submission__c,ID,Name From Contact where Id =:contactId and CFR_In_Submission__c = True];
                System.debug('###contactCountLst##'+contactCountLst);
                if(contactCountLst.isEmpty()){
                    request = System.Label.CFR_Contact_Request_in_Progress;
                    List<Contact> contactList = [Select ID,Request_Status__c from Contact where ID =:contactId];
                    If(!contactList.isEmpty()){
                        contactList[0].CFR_In_Submission__c	= True;
                        contactList[0].Request_Status__c = 'Submitted For Approval';
                        update contactList;
                    }
                    
                    Request__c reqObj = new Request__c();
                    reqObj.Contact__c = contactId;
                    reqObj.OwnerId = groupList[0].Id;
                    reqObj.RecordTypeId = Schema.SObjectType.Request__c.getRecordTypeInfosByName().get('CFR Contact Approval').getRecordTypeId();
                    reqObj.Status__c = 'Submitted';
                    requestListInsert.add(reqObj);
                    
                    if(!requestListInsert.isEmpty())
                        insert requestListInsert;
	
					Approval.LockResult[] lrList = Approval.lock(contactList, false);                    
                    Approval.ProcessSubmitRequest reqContact = new Approval.ProcessSubmitRequest();
                    reqContact.setComments('Automatic record lock.');
                    reqContact.setObjectId(contactId);
                    reqContact.setNextApproverIds(new Id[] {groupList[0].Id});
                    reqContact.setProcessDefinitionNameOrId(Label.CFR_Contact_Approval_Process);
                    lstProcess.add(reqContact);
                    
                    if (lstProcess.size() > 0){
                        try{
                            List<Approval.ProcessResult> lstResult = Approval.process(lstProcess);
                            System.debug('$$$$$$$$$$$$$ Approval Process Result ' + lstResult);
                        }catch (exception e){
                            System.debug('Exception occured ' + e.getMessage());
                            
                        }    
                    } 
                }else{
                    request = System.Label.CFR_Request_In_Progress;
                    System.debug('###requestListCheck inside event##'+contactCountLst);
                }
            }
        }catch(Exception e){
            System.debug('Exception Occured'+e.getMessage());
        }
        return request;
    }
    
    /* This function is used to get the CFR Contact checkbox values for each contact */
    @AuraEnabled
    public Static Boolean checkContactValues(ID contactId){
        Boolean cfrContactFlag;
        List<Contact> contactLst = [Select CFR_contact__c,Id From Contact where Id =: contactId];
        if(!contactLst.isEmpty()){
            cfrContactFlag = contactLst[0].CFR_contact__c;
        }
        return cfrContactFlag;
    }
    
}