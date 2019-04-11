public class labyrinthAccountDetail{

    public Account accts{get;set;}
    public id accid;
    
    public string taid {set;get;}
    public list<task> taskList {get;set;}
    
    public string evid {set;get;}
    public list<event> evlist{set;get;}
    
    
    public string conId {set;get;}
    public list<contact> conlist{set;get;}
    
    public list<account> accoa {set;get;}
    public list<account> accoah {set;get;}
     public list<account> accattachments {set;get;}
    
    public list<attachment> attachments {set;get;}
    public string attId {set;get;}
    
    
    public list<Application_Mapping__c> maxExternalSystemsList{set;get;}
    public list<Application_Mapping__c> ddwExternalSystemsList{set;get;}
    
    
   

    public labyrinthAccountDetail(ApexPages.StandardController controller) {
       accid= ApexPages.currentPage().getParameters().get('id');
       //accts= [select Id, Name, Industry,AccountNumber,Phone from Account where Id =:ApexPages.currentPage().getParameters().get('id') limit 1];
       accts= [Select Id,Name,(select Id,Name,phone, email from Contacts Limit 1000) from Account where ID =:ApexPages.currentPage().getParameters().get('id') limit 1];
    //   maxExternalSystemsList=[Select External_Record_num__c,External_System__c,Golden_Record__c From Application_Mapping__c Where Account__c=:ApexPages.currentPage().getParameters().get('id') and External_System__c ='MAX' LIMIT 1000];
       ddwExternalSystemsList=[Select External_Record_num__c,External_System__c,Golden_Record__c From Application_Mapping__c Where Account__c=:ApexPages.currentPage().getParameters().get('id')];
       load();
       loadattachment();
     }
     
     public void load(){
        
        conlist = [Select Id,Name,phone,Email,accountid,account.name From Contact Where AccountId =:accid limit 500 ];  
        accoa=[SELECT id, (SELECT id,Subject, WhoId, whatid ,IsTask, PrimaryWhoId, ActivityDate, Status, Priority,  OwnerId,owner.name, PrimaryWho.name, what.name FROM OpenActivities ORDER BY  createddate DESC  limit 500 ) FROM Account where Id=:accid ORDER BY  LastModifiedDate DESC limit 1];
        accoah=[SELECT id, (SELECT id,Subject, WhoId, whatid ,IsTask, PrimaryWhoId, ActivityDate, Status, Priority,  OwnerId,owner.name, PrimaryWho.name, what.name   FROM ActivityHistories ORDER BY  createddate DESC limit 500) FROM Account where Id=:accid ORDER BY LastModifiedDate DESC limit 1];
        
    
    }
    
    public void loadattachment()
    {
         attachments = [SELECT Id, ParentId, Name, LastModifiedDate, BodyLength FROM Attachment WHERE ParentId=:accid limit 10];
    }
    
    public void deleteattachment(){
       
       attachments = [SELECT Id, ParentId, Name, LastModifiedDate, BodyLength FROM Attachment WHERE id=:attId];
         
       if(attachments.size() > 0 || attachments[0].Id != ''){
         delete attachments;
        }
        loadattachment(); 
        
        }

      
       public Pagereference newContactCreation(){
       
          id id=String.valueOf(accid).substring(0, 15);
          PageReference pr = new PageReference('/apex/LabyrinthContactNewpage1');
          pr.getParameters().put('accid',id);
          pr.setRedirect(true);
          return pr;
        }
    
    
     public void deletecon(){
       
        conlist= [Select Id,Name,phone,Email,accountid,account.name from contact  where id = :conId];
         System.debug('@@@@'+conlist.size());
       if(conlist.size() > 0 || conlist[0].Id != ''){
       
       delete conlist;
       
       }
       
       load();
    
       }
       
       public void deleteev(){
       
        evlist= [Select Id from event where id = :evid];
        
       if(evlist.size() > 0 || evlist[0].Id != ''){
       
       delete evlist;
       
       }
       
       load();
    
       }
       
        public void deleteta(){
       
        taskList = [Select Id from task where id = :taid];
        
       if(taskList .size() > 0 || taskList [0].Id != ''){
       
       delete taskList ;
       
       }
       
       load();
    
       }
       
       
        public PageReference editaccount()
         {
         
          PageReference pr=new PageReference('/apex/LabyrinthAccountNewPage');
           pr.getParameters().put('id',accid);
           pr.setRedirect(true);
          return pr; 
          
         }

       
       /*
       private void myMethod() {  
          Integer counter = 0;
          for ((CDH_External_System__c item : [Select CDH_External_Record_num__c,CDH_External_System__c,CDH_Golden_Record__c From CDH_External_System__c Where Accounts__c ='0015500000JMJlP' and CDH_External_System__c ='MAX'])) 
          {
            counter = counter + 1;
            // add the wrapper to the collection
            myCollection.add(new DataTableWrapper(item, counter));
          }
        }

        // inner class
        class DataTableWrapper {
        
          public Integer counter { get; set; }
          public CDH_External_System__c item { get; set;}
        
          public DataTableWrapper(CDH_External_System__c item, Integer counter) {
            this.item = item;
            this.counter = counter;
          }
        
        }*/
        
   /*     public Task[] getListTasks() {

              //taskList = 'select      whoid,subject,status,LastModifiedDate, WhatID, Description, Primary_Contact_Phone_Number__c, Primary_Contact_Email_Address__c, Call_Result__c, Last_Call_Date__c, Last_Call_Agent__c from task WHERE CreatedbyId=\''+currentUser+'\' AND (subject LIKE \'call%\' OR subject LIKE \'outbound%\') AND WhoID =\''+currentContact+'\' order by LastModifiedDate desc limit 20000'; 
              // taskList = 'select whoid,subject,status,LastModifiedDate, WhatID, Description, Primary_Contact_Phone_Number__c, Primary_Contact_Email_Address__c, Call_Result__c, Last_Call_Date__c, Last_Call_Agent__c from task WHERE CreatedbyId=\''+currentUser+'\' AND WhoID =\''+currentContact+'\' order by LastModifiedDate desc limit 20000';  
               
                taskList = 'select whoid,subject,status,LastModifiedDate, WhatID, Description,ownerid from task WHERE  WhatID =\''+accid+'\' order by LastModifiedDate desc limit 1000';  
               
            
            
                //delete duplicate property records
                     List<Task> tskList = Database.query(taskList);
                     System.debug('#########tskListInit'+tskList);
            
                      System.debug('#########tskListFinal'+tskList);
                      return tskList;     

              } */
              
         public Pagereference newTaskCreation(){
       
          id id=String.valueOf(accid).substring(0, 15);
          PageReference pr = new PageReference('/apex/LabyrinthTaskNewPage');
          pr.getParameters().put('what_id',id);
          pr.setRedirect(true);
          return pr;
        }
        
         public Pagereference newEventCreation(){
       
          id id=String.valueOf(accid).substring(0, 15);
          PageReference pr = new PageReference('/apex/LabyrinthEventNewPage');
          pr.getParameters().put('what_id',id);
          pr.setRedirect(true);
          return pr;
        }
  
  

}