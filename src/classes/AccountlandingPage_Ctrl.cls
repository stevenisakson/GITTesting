public with sharing class AccountlandingPage_Ctrl {

   
  public List<SelectOption> viewlist {get;set;}
  public String viewname{get;set;}
  public list<account> acclist{set;get;}
  
   Public Integer size{get;set;} 
   Public Integer noOfRecords{get; set;} 
   public List<SelectOption> paginationSizeOptions{get;set;}
    
   public string search {set;get;}
   
   public list<task> taskList {get;set;}
   
  
   public List<Document> documents {set;get;}
   
    
     
  public  AccountlandingPage_Ctrl ()
  {
     
      viewlist =new List<SelectOption>();
                  
      viewlist .add(new SelectOption('--None--','--None--'));
      viewlist .add(new SelectOption('All Accounts','All Accounts'));
      viewlist .add(new SelectOption('Accounts I Own','Accounts I Own'));
      viewlist .add(new SelectOption('My Team Accounts','My Team Accounts'));
      
      viewname='All Accounts';
      
        size=10;
       
        paginationSizeOptions = new List<SelectOption>();
        paginationSizeOptions.add(new SelectOption('5','5'));
        paginationSizeOptions.add(new SelectOption('10','10'));
        paginationSizeOptions.add(new SelectOption('20','20'));
        paginationSizeOptions.add(new SelectOption('50','50'));
        paginationSizeOptions.add(new SelectOption('100','100'));
        
     //   documents = [SELECT Id, FolderId, Folder.Name FROM Document  WHERE Folder.Name like 'Reference Documents English%'];
       
        documents = [SELECT Id, FolderId, Folder.Name FROM Document];
        
        loadtasklist();
       
      
  }
  
  public ApexPages.StandardSetController setCon {
        get {
        
            if(setCon == null) { 
             
            if(viewname == 'All Accounts') {  
            
             /*   Id userId = UserInfo.getUserId();
                
                List<AccountTeamMember> members = [SELECT Id,AccountId FROM AccountTeamMember WHERE UserId = :userId];
               
                Set<Id> accountIds = new Set<Id>();
                for(AccountTeamMember member : members) {
                    accountIds.add(member.AccountId);
                }
        
              //  List<Account> accounts= [SELECT Id,Name,AccountNumber,OwnerId,owner.name,Business_Uni__c,Physical_Community_Municipality__c,Physical_County_Community__c,Physical_Postal_City__c,Website_Address__c,Social_Media_Address__c FROM Account WHERE Id IN :accountIds ORDER BY NAME ASC LIMIT :blockSize OFFSET :index];
                              
                        setCon = new ApexPages.StandardSetController(Database.getQueryLocator(
                              [SELECT Id,Name,AccountNumber,OwnerId, owner.name,Business_Uni__c ,(select id ,User.name from AccountTeamMembers) FROM Account WHERE Id IN :accountIds OR OwnerId = :userId ORDER BY NAME ASC]));
                        setCon.setPageSize(size);  
                        noOfRecords = setCon.getResultSize(); */
                        
                        setCon = new ApexPages.StandardSetController(Database.getQueryLocator(
                              [SELECT Id,Name,AccountNumber,OwnerId, owner.name,Business_Uni__c,(select id ,User.name from AccountTeamMembers) FROM Account  ORDER BY NAME ASC limit 500]));
                        setCon.setPageSize(size);  
                        noOfRecords = setCon.getResultSize();
                        
                        
                    } 
                    
                if (viewname == 'Accounts I Own')
                            {
                                            
                                           Id userId = UserInfo.getUserId();
                                          // List<Account> accounts= [SELECT Id,Name,AccountNumber,OwnerId,owner.name,Business_Uni__c,Physical_Community_Municipality__c,Physical_County_Community__c,Physical_Postal_City__c,Website_Address__c,Social_Media_Address__c FROM Account WHERE OwnerId = :userId ORDER BY NAME ASC LIMIT :blockSize OFFSET :index];
                                            setCon = new ApexPages.StandardSetController(Database.getQueryLocator(
                                              [SELECT Id,Name,AccountNumber,OwnerId,owner.name,Business_Uni__c,(select id,User.name from AccountTeamMembers) FROM Account WHERE OwnerId = :userId ORDER BY NAME ASC]));
                                        setCon.setPageSize(size);  
                                        noOfRecords = setCon.getResultSize(); 
                                         
                             }
                          
                             if (viewname == 'My Team Accounts')
                            {
                                        Id userId = UserInfo.getUserId();
                                       
                                        List<AccountTeamMember> members = [SELECT Id,AccountId FROM AccountTeamMember WHERE UserId = :userId];
                                        
                                        Set<Id> accountIds = new Set<Id>();
                                        for(AccountTeamMember member : members) {
                                            accountIds.add(member.AccountId);
                                        }
                                
                                    //    List<Account> accounts= [SELECT Id,Name,AccountNumber,OwnerId,owner.name FROM Account WHERE Id IN :accountIds ORDER BY NAME ASC];
                                         setCon = new ApexPages.StandardSetController(Database.getQueryLocator(
                                              [SELECT Id,Name,AccountNumber,OwnerId,owner.name,Business_Uni__c,(select id ,User.name from AccountTeamMembers) FROM Account WHERE Id IN :accountIds ORDER BY NAME ASC]));
                                        setCon.setPageSize(size);  
                                        noOfRecords = setCon.getResultSize(); 
                                             
                              }
                              
                           
                              
                                      
            }
                          
            return setCon;
        }
        set;
    }
     
    //Changes the size of pagination
    public PageReference refreshPageSize() {
        
         if(viewname=='All Accounts' || viewname=='Accounts I Own' || viewname=='My Team Accounts')
         {
       //  size=10;
         setCon=null;
         
         } 
             if (viewname == '--None--')
                {
                  setCon = new ApexPages.StandardSetController(Database.getQueryLocator(
                          [SELECT Id,Name,AccountNumber,OwnerId,owner.name,Business_Uni__c,(select id ,User.name from AccountTeamMembers) FROM Account WHERE Id IN :null ORDER BY NAME ASC]));
                    setCon.setPageSize(size);  
                    noOfRecords = setCon.getResultSize(); 
                    
                    apexPages.addmessage(new apexpages.message(apexpages.severity.INFO, 'please select valid view '));
                         
                  }
         setCon.setPageSize(size);
         return null;
         
         
    }
 
    // Initialize setCon and return a list of record    
     
    public List<Account> getaccounts() {
         return (List<Account>) setCon.getRecords();
    }
    
   //search accounts 
   
    public void find()
 {
    
     
     if(search.length()>1)
     {
     
        setCon = new ApexPages.StandardSetController(Database.getQueryLocator(
                                              [SELECT Id,Name,AccountNumber,OwnerId,owner.name,Business_Uni__c,(select id,User.name from AccountTeamMembers) FROM Account WHERE name like :+'%'+search+'%' ORDER BY NAME ASC]));
                                        setCon.setPageSize(size);  
                                        noOfRecords = setCon.getResultSize(); 
                                       
                                       
                                        viewname='--None--';
                                        search='';
                                      
         
        if(noOfRecords == 0)
         {
           apexPages.addmessage(new apexpages.message(apexpages.severity.INFO, 'Sory, no results returned with matching '));
          }
       }
       else{
           
           apexPages.addmessage(new apexpages.message(apexpages.severity.INFO, 'Please enter at least two characters..'));
   
           } 
     
 }
 
     public void loadtasklist()
     {
         taskList=[SELECT Id, WhoId,who.name, WhatId,what.name, Subject, ActivityDate, Status, IsClosed,ownerid ,owner.name FROM Task where ownerid =:UserInfo.getUserId() and isclosed!=true];
            
     }
     
     
     
}