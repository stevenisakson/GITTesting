/********************************************************************************************* 
* @author:      Robbie Macatbag
* @date:        6 March 2015
* @description: Controller class for RequestPDF visualforce page
* @parameters:  NA
* @revision:      
**********************************************************************************************/

public class RequestPDFController{
    public List<Account> relatedAccount {get;set;}
    public boolean showTable{get;set;}
    public boolean withAccounts{get;set;}
    //public List<Customer360__c> customerList {get;set;}// Commented By Shalu
    public boolean withContacts {get;set;}
    public List<AccountTeamMember> accountMneberList {get;set;}
    
    Map<id,User> userInfoMap = new Map<id,User>();

    public RequestPDFController(ApexPages.StandardController controller) {
        set<id> teamMemberIdSet = new set<id>();
        accountMneberList =  new List<AccountTeamMember>();
        Request__c req = (Request__c)controller.getRecord();
       // customerList = new List<Customer360__c>();
        id relatedAccountId = req.Account__c;
        system.debug('@@ rec: '+req .Account__c);
        
        if(relatedAccountId !=null){
            
            relatedAccount = [SELECT id, Name, Brand__c, RecordType.Name  FROM Account WHERE id = : relatedAccountId  ];
            withAccounts = true;
            system.debug('@@ relatedAccount['+relatedAccount.size()+']:'+relatedAccount);
            system.debug('@@ relatedAccount['+relatedAccount.size()+']:'+relatedAccount);
            
            
        }
     /* Commented By Shalu Req 4.6         
        customerList = [SELECT Name,Segment_Step_1__c,X9_Box_Step_2__c FROM Customer360__c WHERE Account__c =:relatedAccountId];
        if(customerList.size()>0){
            withContacts = true;
            
        }*/
    }
}