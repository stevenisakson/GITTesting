/*
    Author: Tumish Tak
    Description: To populate MobileFirst Falg and Autovalidate Flag
    Date of Creation: 6-Feb-2018
*/
public class PreDefaultValues
{

//Method to set mobile first Flag value on Account Record. Set only if Profile Id is Present in MobileFirst Custom Settings.
    public void setAccountFlagValues(List<Account> accList)
    {
        List<MobileFirstSettings__c> mobSettingList = MobileFirstSettings__c.getall().values();
        Map<Id,string> mobileSettingMap = new Map<Id,string>();
        set<Id> ownerIdSet = new set<Id>();  
        Map<Id,User> UserMap = new Map<Id,User>();
        Map<String,Id> RecordTypeMap = new Map<String,Id>();
        
        for(RecordType RecTyp : [select Id,Name from RecordType where SobjectType = 'Account'])
        {
            RecordTypeMap.put(RecTyp.Name,RecTyp.Id);
        } 
        
        for(Account acc: accList)   
        {
            ownerIdSet.add(acc.ownerId);
        }
        
        for(User usr: [Select id,ProfileId,Auto_Validate__c,Business_Unit__c,Region__c from User where Id IN:ownerIdSet])
        {
           UserMap.put(usr.id,usr); 
                       
        }
        
        for(MobileFirstSettings__c mobSetting: mobSettingList )
        {
           mobileSettingMap.put(mobSetting.ProfileId__c,mobSetting.Name); 
        }
                
        for(Account acc: accList)
        {
           
            if((UserMap.containsKey(acc.ownerId)))
            {
            
            //Set Record Owner BU on Account Level if BU is not defined while record creation
                if(String.isEmpty(acc.Business__c)){
                    acc.Business__c = (UserMap.get(acc.ownerId)).Business_Unit__c;
                }
                
            //To set mobile first Flag value on Account Record. Set only if Profile Id is Present in MobileFirst Custom Settings.       
                if(mobileSettingMap.containsKey(UserMap.get(acc.ownerId).ProfileId)){
                    acc.Mobile_First__c = true;  //Mobile First Flag is set here if conditions satisfy
                }
                
            //Set Account Owner User's Region on Account Region Field
                acc.Region__c = UserMap.get(acc.ownerId).Region__c;
            }    
           
           //To set Autovalidate Falg as per the value set on User Level for the Flag.       
            if(UserMap.get(acc.ownerid).Auto_Validate__c){
                acc.Auto_Validate__c =true;
            }
            
           //To set the RecordType of record if record is coming from DE Mobile App
            if(acc.Source_System__c == 'LM' && String.IsNotEmpty(acc.Account_Type__c)){
                acc.RecordTypeId = RecordTypeMap.get(acc.Account_Type__c + ' ' + UserMap.get(acc.ownerId).Region__c);
            }
        }
        
    }
    
    //Method to set record type on update of Account from LM.
    public void setAccountRecordType(List<Account> accList)
    {
        set<Id> ownerIdSet = new set<Id>();  
        Map<Id,User> UserMap = new Map<Id,User>();
        Map<String,Id> RecordTypeMap = new Map<String,Id>();
        
        for(RecordType RecTyp : [select Id,Name from RecordType where SobjectType = 'Account'])
        {
            RecordTypeMap.put(RecTyp.Name,RecTyp.Id);
        } 
        
        for(Account acc: accList)   
        {
            ownerIdSet.add(acc.ownerId);
        }
        
        for(User usr: [Select id,ProfileId,Auto_Validate__c,Business_Unit__c,Region__c from User where Id IN:ownerIdSet])
        {
           UserMap.put(usr.id,usr); 
                       
        }
        
        for(Account acc: accList)
        {
           
            if((UserMap.containsKey(acc.ownerId)))
            {
            
            //Set Record Owner BU on Account Level if BU is not defined while record creation
                if(String.isEmpty(acc.Business__c)){
                    acc.Business__c = (UserMap.get(acc.ownerId)).Business_Unit__c;
                }

            //Set Account Owner User's Region on Account Region Field
                acc.Region__c = UserMap.get(acc.ownerId).Region__c;
            }    
           
           //To set the RecordType of record if record is coming from DE Mobile App acc.Source_System__c == 'LM' &&
            if( String.IsNotEmpty(acc.Account_Type__c)){
                acc.RecordTypeId = RecordTypeMap.get(acc.Account_Type__c + ' ' + UserMap.get(acc.ownerId).Region__c);
            }
        }
        
    }
    
    //Method to set mobile first Flag value on Opportunity Record. Set only if Profile Id is Present in MobileFirst Custom Settings.
    public void setOpportunityFlagValues(List<Opportunity> oppList)
    {
        List<MobileFirstSettings__c> mobSettingList = MobileFirstSettings__c.getall().values();
        Map<Id,string> mobileSettingMap = new Map<Id,string>();
        set<Id> ownerIdSet = new set<Id>();  
        Map<Id,User> UserMap = new Map<Id,User>();
         
        for(Opportunity opp: oppList)   
        {
            ownerIdSet.add(opp.ownerId);
        }
        
        for(User usr: [Select id,ProfileId,Business_Unit__c from User where Id IN:ownerIdSet])
        {
           UserMap.put(usr.id,usr); 
                       
        }
        
        for(MobileFirstSettings__c mobSetting: mobSettingList )
        {
           mobileSettingMap.put(mobSetting.ProfileId__c,mobSetting.Name); 
        }
                
        for(Opportunity opp: oppList)
        {
            //To set mobile first Flag value on Opportunity Record. Set only if Profile Id is Present in MobileFirst Custom Settings.       
            if((UserMap.containsKey(opp.ownerId)))
            {
                if(mobileSettingMap.containsKey(UserMap.get(opp.ownerId).ProfileId))
                opp.Mobile_First__c = true;  //Mobile First Flag is set here if conditions satisfy
             //   opp.Business_Unit__c = (UserMap.get(opp.ownerId)).Business_Unit__c;
            }    
           
         }
        
    }
    
     //Method to set mobile first Flag value on Contact Record. Set only if Profile Id is Present in MobileFirst Custom Settings.
    public void setContactFlagValues(List<Contact> conList)
    {
        List<MobileFirstSettings__c> mobSettingList = MobileFirstSettings__c.getall().values();

        Map<Id,string> mobileSettingMap = new Map<Id,string>();
        set<Id> ownerIdSet = new set<Id>();  
        Map<Id,User> UserMap = new Map<Id,User>();
         
        for(Contact con: conList)   
        {
            ownerIdSet.add(con.ownerId);
        }
        
        for(User usr: [Select id,ProfileId,Business_Unit__c from User where Id IN:ownerIdSet])
        {
           UserMap.put(usr.id,usr); 
                       
        }
        
        for(MobileFirstSettings__c mobSetting: mobSettingList )
        {
           mobileSettingMap.put(mobSetting.ProfileId__c,mobSetting.Name); 
        }
                
        for(Contact con: conList)
        {    
            Auto_Populate_Settings__c apSetting =  Auto_Populate_Settings__c.getValues(UserMap.get(con.ownerId).Business_Unit__c);
            
            //To set mobile first Flag value on Contact Record. Set only if Profile Id is Present in MobileFirst Custom Settings.       
            if((UserMap.containsKey(con.ownerId)))
            {
                if(mobileSettingMap.containsKey(UserMap.get(con.ownerId).ProfileId))
                     con.Mobile_First__c = true;  //Mobile First Flag is set here if conditions satisfy
             /*   if(apSetting.Lightning_Enabled__c)
                     con.Business_Unit__c = (UserMap.get(con.ownerId)).Business_Unit__c;*/
            }    
           
         }
        
    }

     //Method to set mobile first Flag value on Event Record. Set only if Profile Id is Present in MobileFirst Custom Settings.
    public void setEventFlagValues(List<Event> eventList)
    {
        List<MobileFirstSettings__c> mobSettingList = MobileFirstSettings__c.getall().values();
        Map<Id,string> mobileSettingMap = new Map<Id,string>();
        set<Id> ownerIdSet = new set<Id>();  
        Map<Id,User> UserMap = new Map<Id,User>();
         
        for(Event eve: eventList)   
        {
            ownerIdSet.add(eve.ownerId);
        }
        
        for(User usr: [Select id,ProfileId,Business_Unit__c from User where Id IN:ownerIdSet])
        {
           UserMap.put(usr.id,usr); 
                       
        }
        
        for(MobileFirstSettings__c mobSetting: mobSettingList )
        {
           mobileSettingMap.put(mobSetting.ProfileId__c,mobSetting.Name); 
        }
                
        for(Event eve: eventList)
        {
            system.debug('UserMap : '+UserMap);
            Auto_Populate_Settings__c apSetting =  Auto_Populate_Settings__c.getValues(String.valueOf(UserMap.get(eve.ownerId).Business_Unit__c));
            //To set mobile first Flag value on Event Record. Set only if Profile Id is Present in MobileFirst Custom Settings. 
            system.debug('UserMap.get(eve.ownerId).Business_Unit__c : '+UserMap.get(eve.ownerId).Business_Unit__c);  
            system.debug('apSetting : '+apSetting); 
            if((UserMap.containsKey(eve.ownerId)))
            {
                if(mobileSettingMap.containsKey(UserMap.get(eve.ownerId).ProfileId))
                    eve.Mobile_First__c = true;  //Mobile First Flag is set here if conditions satisfy
              /*  if(apSetting.Lightning_Enabled__c)
                    eve.Business_Unit__c = (UserMap.get(eve.ownerId)).Business_Unit__c;*/
            }    
           
         }
        
    }
    
    //Method to set mobile first Flag value on Task Record. Set only if Profile Id is Present in MobileFirst Custom Settings.
    public void setTaskFlagValues(List<Task> taskList)
    {
        List<MobileFirstSettings__c> mobSettingList = MobileFirstSettings__c.getall().values();
        Map<Id,string> mobileSettingMap = new Map<Id,string>();
        set<Id> ownerIdSet = new set<Id>();  
        Map<Id,User> UserMap = new Map<Id,User>();
         
        for(Task tsk: taskList)   
        {
            ownerIdSet.add(tsk.ownerId);
        }
        
        for(User usr: [Select id,ProfileId,Business_Unit__c from User where Id IN:ownerIdSet])
        {
           UserMap.put(usr.id,usr); 
                       
        }
        
        for(MobileFirstSettings__c mobSetting: mobSettingList )
        {
           mobileSettingMap.put(mobSetting.ProfileId__c,mobSetting.Name); 
        }
                
        for(Task tsk: taskList)
        {
            Auto_Populate_Settings__c apSetting =  Auto_Populate_Settings__c.getValues(UserMap.get(tsk.ownerId).Business_Unit__c);
            //To set mobile first Flag value on Task Record. Set only if Profile Id is Present in MobileFirst Custom Settings.       
            if((UserMap.containsKey(tsk.ownerId)))
            {
                if(mobileSettingMap.containsKey(UserMap.get(tsk.ownerId).ProfileId))
                    tsk.Mobile_First__c = true;  //Mobile First Flag is set here if conditions satisfy
               /* if(apSetting.Lightning_Enabled__c)
                    tsk.Business_Unit__c = (UserMap.get(tsk.ownerId)).Business_Unit__c;*/
            }    
           
         }
        
    }

}