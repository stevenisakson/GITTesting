public class ContactDetailPage_ctrl {

    public contact con {set;get;}
    String conid;
    
    public string taid {set;get;}
    public list<task> taskList {get;set;}
    
    public list<Contact> conoa {set;get;}
    public string evid {set;get;}
    public list<event> evlist{set;get;}
    
    public list<Contact> conoah {set;get;}
    
    public ContactDetailPage_ctrl(ApexPages.StandardController controller) {
    
        conid=ApexPages.currentPage().getParameters().get('id'); 
        
        load();

    }
    
    public ContactDetailPage_ctrl()
    {
        
    }
    
     public PageReference editcontact()
         {
         
          PageReference pr=new PageReference('/apex/LabyrinthContactNewpage1');
           pr.getParameters().put('id',conid);
           pr.setRedirect(true);
          return pr; 
          
         }
         
     public void load(){
        
         
        conoa=[SELECT id, (SELECT id,Subject, WhoId, whatid ,IsTask, PrimaryWhoId, ActivityDate, Status, Priority,  OwnerId, owner.name, PrimaryWho.name, what.name FROM OpenActivities Order by createddate desc limit 10) FROM Contact where Id=:conid limit 1];
        conoah=[SELECT id, (SELECT id,Subject, WhoId, whatid ,IsTask, PrimaryWhoId, ActivityDate, Status, Priority,  OwnerId,owner.name, PrimaryWho.name, what.name FROM ActivityHistories Order by createddate desc limit 10) FROM Contact where Id=:conid limit 1];
        
    
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
         
  /*       public Task[] getListTasks() {

              //taskList = 'select      whoid,subject,status,LastModifiedDate, WhatID, Description, Primary_Contact_Phone_Number__c, Primary_Contact_Email_Address__c, Call_Result__c, Last_Call_Date__c, Last_Call_Agent__c from task WHERE CreatedbyId=\''+currentUser+'\' AND (subject LIKE \'call%\' OR subject LIKE \'outbound%\') AND WhoID =\''+currentContact+'\' order by LastModifiedDate desc limit 20000'; 
              // taskList = 'select whoid,subject,status,LastModifiedDate, WhatID, Description, Primary_Contact_Phone_Number__c, Primary_Contact_Email_Address__c, Call_Result__c, Last_Call_Date__c, Last_Call_Agent__c from task WHERE CreatedbyId=\''+currentUser+'\' AND WhoID =\''+currentContact+'\' order by LastModifiedDate desc limit 20000';  
               
                taskList = 'select whoid,subject,status,LastModifiedDate, WhatID, Description,ownerid from task WHERE  WhoID =\''+conid+'\' order by LastModifiedDate desc limit 1000';  
               
            
            
                //delete duplicate property records
                     List<Task> tskList = Database.query(taskList);
                     System.debug('#########tskListInit'+tskList);
            
                      System.debug('#########tskListFinal'+tskList);
                      return tskList;     

              } */
              
         public Pagereference newTaskCreation(){
       
       //   id id=String.valueOf(conid).substring(0, 15);
          PageReference pr = new PageReference('/apex/LabyrinthTaskNewPage');
          pr.getParameters().put('who_id',conid);
          pr.setRedirect(true);
          return pr;
        }
        
        public Pagereference newEventCreation(){
       
          id id=String.valueOf(conid).substring(0, 15);
          PageReference pr = new PageReference('/apex/LabyrinthEventNewPage');
          pr.getParameters().put('who_id',id);
          pr.setRedirect(true);
          return pr;
        }

}