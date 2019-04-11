@isTest
public class AttachmentDupeCatcher_Test {
    
    
    Static TestMethod void method1()
    {
        Test.startTest();
        // Created account record for give the parent id to attachment 
       // Account acc = new Account(Name='Test_Account', Type='Dealer', RecordType=[select Id from RecordType where name=:Label.Standard_Record_Type and SObjectType='Account' limit 1], Segment_Step_1__c='Aiden', Business__c='US', Prospect_Validated__c=false);
        Account acc = new Account(Name='Test_Account', Type='Dealer', Business__c='US', Prospect_Validated__c=false);
        
        system.debug('acc='+acc.RecordType);
        insert acc;
       
        
        //Custom object record insert
        Blob b = Blob.valueOf('test data');
        Attachment attachment = new Attachment(); 
        //objectid is id of the record in which you want to create attachment, it could be a test account etc attachment.ParentId = objectId; 
        attachment.Name = 'Test Attachment for Parent'; 
        attachment.Body = b;  
        attachment.parentId = acc.Id;

        insert(attachment);
        
        
        
        
        Test.stopTest();
    }
    Static TestMethod void method2()
    {
        Test.startTest();
        // Created account record for give the parent id to attachment 
       // Account acc = new Account(Name='Test_Account', Type='Dealer', RecordType=[select Id from RecordType where name=:Label.Standard_Record_Type and SObjectType='Account' limit 1], Segment_Step_1__c='Aiden', Business__c='US', Prospect_Validated__c=false);
        Account acc = new Account(Name='Test_Account', Type='Dealer', Business__c='US', Prospect_Validated__c=false);
        
        system.debug('acc='+acc.RecordType);
        insert acc;
       
        
        //Custom object record insert
        Blob b = Blob.valueOf('test data');
        Attachment attachment = new Attachment(); 
        //objectid is id of the record in which you want to create attachment, it could be a test account etc attachment.ParentId = objectId; 
        attachment.Name = 'Test Attachment for Parent'; 
        attachment.Body = b;  
        attachment.parentId = acc.Id;
        insert attachment;
        
      
        Attachment attachment1 = new Attachment(); 
        //objectid is id of the record in which you want to create attachment, it could be a test account etc attachment.ParentId = objectId; 
        attachment1.Name = 'Test Attachment for Parent'; 
        attachment1.Body = b;  
        attachment1.parentId = acc.Id;
        insert attachment1;
        
        List<Attachment> attachments=[select id, name from Attachment where parent.id=:acc.id];
        
            
        delete attachments;

             
        
        
        
        Test.stopTest();
    }

}