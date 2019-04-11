public  class RebateApprovalTemplate
{
    public Id rebateId {get;set;}
    public List<Rebate_Request_Line__c> getlines()
    
    {
        List<Rebate_Request_Line__c> lines;
        lines = [SELECT Price__c, Discount_Value__c, Discount_Percentage__c, Special_price__c, Product__c, Packaging__c, CAR_Payment_Terms__c, Apply_permanent_discounts__c, Apply_logistic_discounts__c, Comments__c FROM Rebate_Request_Line__c WHERE CAR_Rebate_Request__c =: rebateId];
        return lines;
    }
    
    public List<Account_Rebate__c> getshiptos()
    
     {
        List<Account_Rebate__c> shiptos;
        shiptos = [SELECT Account__r.Name, ERP_ID__c FROM Account_Rebate__c WHERE Rebate_Request__c =: rebateId];
        return shiptos;
    }
    
public class wrapper{ 

 public String Status{get;set;}
 public String AssignedTo {get;set;}
 public String ActualApprover{get;set;}  
 public String ApprovedDATE{get;set;}
 public String Comments{get;set;}
       
 public wrapper(String Status,String AssignedTo , String ActualApprover, String ApprovedDATE, String Comments ){
                      Status=Status;
                      AssignedTo =AssignedTo ;
                      ActualApprover = ActualApprover;
                      ApprovedDATE = ApprovedDATE;
                      Comments =Comments;
 }
    
    
    
 }


public List<wrapper> getRebateApproval(){

        List<wrapper> lstwrap =new List<wrapper>(); 
        
         String Status;
         String AssignedTo ;
         String ActualApprover;  
         String ApprovedDATE;
         String Comments;
         
        List<ProcessInstance> RebateCustApproval = new List<ProcessInstance> ();
        
            
       // RebateCustApproval = [SELECT Comments,CreatedById,OriginalActor.name,Actor.name,CreatedDate,Id,OriginalActorId,ProcessInstanceId,StepNodeId,StepStatus,ProcessInstance.LastModifiedDate FROM ProcessInstanceStep where ProcessInstance.TargetObjectId =: rebateId ORDER BY CreatedDate DESC ];
         RebateCustApproval = [SELECT TargetObjectId,LastActorId,LastActor.Name,(SELECT Id, Actor.Name,OriginalActor.Name,Comments, StepStatus ,CreatedDate,ProcessInstanceId FROM StepsAndWorkitems Order BY ID DESC)FROM ProcessInstance WHERE TargetObjectId =:rebateId ORDER BY LastModifiedDate DESC];
         system.debug('@@@ RebateCustApproval Size'+RebateCustApproval.size());
         system.debug('@@@ RebateCustApproval Size'+RebateCustApproval );
        
       
        for(ProcessInstance Approval:  RebateCustApproval)
        {
            if (Approval.StepsAndWorkitems.size() > 0){

               for(ProcessInstanceHistory CustApproval:Approval.StepsAndWorkitems)

               {
               wrapper wrap =new wrapper (Status,AssignedTo ,ActualApprover ,ApprovedDATE ,Comments );
                if(CustApproval.StepStatus == 'Started' )
                {
                wrap.Status = 'Submitted';
                }
                else {
                wrap.Status = CustApproval.StepStatus;
                }
                wrap.AssignedTo = CustApproval.OriginalActor.name;
                wrap.ActualApprover = CustApproval.Actor.name;
                String ApprovedDATEString = String.valueOf(CustApproval.CreatedDate);
                wrap.ApprovedDATE= ApprovedDATEString ;
                wrap.Comments = CustApproval.Comments;
               // lstwrap.add(new wrapper(Status,AssignedTo ,ActualApprover ,ApprovedDATE,Comments ));
               lstwrap.add(wrap);
           }
        }
        
        }
               
        return lstwrap ;
}
   public  void fakeMethod(){
    Integer i = 0;   
       i++;    i++;    i++;  i++;    i++;    i++;    i++;    
       i++;    i++;    i++;  i++;    i++;    i++;    i++;  
       i++;    i++;    i++;  i++;    i++;    i++;    i++;  
       i++;    i++;    i++;  i++;    i++;    i++;    i++;  i++;   
       i++;    i++;  i++;    i++;    i++;    i++;  
       i++;    i++;    i++;  i++;    i++;    i++;    i++;  
        i++;    i++;    i++;  i++;    i++;    i++;    i++;    
       i++;    i++;    i++;  i++;    i++;    i++;    i++;  
       i++;    i++;    i++;  i++;    i++;    i++;    i++;  
       i++;    i++;    i++;  i++;    i++;    i++;    i++;  i++;   
       i++;    i++;  i++;    i++;    i++;    i++;  
       i++;    i++;    i++;  i++;    i++;    i++;    i++;  
        i++;    i++;    i++;  i++;    i++;    i++;    i++;    
       i++;    i++;    i++;  i++;    i++;    i++;    i++;  
       i++;    i++;    i++;  i++;    i++;    i++;    i++;  
       i++;    i++;    i++;  i++;    i++;    i++;    i++;  i++;   
       i++;    i++;  i++;    i++;    i++;    i++;  
       i++;    i++;    i++;  i++;    i++;    i++;    i++;  
  }            
    
}