public class RequestLineItemsOnRequest {
public List<RequestLineItem__c> reqLineItemsList{get; set;} 
public Request__c request{get; set;}

public RequestLineItemsOnRequest(ApexPages.StandardController controller) {
   String accountId = ApexPages.currentPage().getParameters().get('id');
        //System.debug('accountId: '+accountId);
		//request = [SELECT id,CreatedById,Name,Status__c FROM Request__c WHERE Id = :ApexPages.currentPage().getParameters().get('id')]; // this will return current record object(child) detail from that you can use parent Id (here Account is parent so accoutId)
       // if(request!=null){
       //    reqLineItemsList = [SELECT CreatedById,Existing_Value__c,Status__c FROM RequestLineItem__c WHERE request__c=:request.id]; 
		//}
       request = [SELECT Id,OwnerId,Status__c,(SELECT id,LastModifiedBy.Name, CreatedById,Existing_Value__c,Status__c,Team_Member__c,Account_Name__c FROM Request_Line_Items__r) FROM Request__c where id = :ApexPages.currentPage().getParameters().get('id')]; 
   } 

}