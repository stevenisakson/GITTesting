global class UserTriggerHandler {
    private boolean m_isExecuting = false;
    private integer BatchSize = 0;
    
    Set<Id> sUIdToRemoveFromAccounts;
    Set<Id> sUIdToAddToAccounts;
    
    public UserTriggerHandler(boolean isExecuting, integer size){
        m_isExecuting = isExecuting;
        BatchSize = size;

    }
       
 //Method to insert/update standard user info into custom object "User"  when new user created or user info updated. 
 public void insertStandardUserintoUserObj (List<User> NewListUsers,List<User>oldListUsers,Map<id,User>oldUserMap,Map<id,User>NewUserMap,boolean isInsert, boolean isUpdate)      
 {
    List<User> userList = new List<User>();
    List<User__c> userObjList = new List<User__c>();
    List<User__c> oldUserObjList = new List<User__c>();
    List<User__c> UserObjLists = new List<User__c>();
    set<id>uIds = new set<id>();
    set<id> oldIds = new set<id>();
    
    system.debug('#####@@userList='+NewListUsers);
    if(isInsert)
    {
        if(NewListUsers.size()>0)
        {
            for(User u :NewListUsers)
            {
               uIds.add(u.id);
               system.debug('####uIds ='+uIds);
               
               userObjList.add(new User__c(Name=u.Username,Email__c=u.Email,License_Type__c=u.License_Type__c,First_Name__c=u.FirstName,Active__c =u.IsActive,
                                           Last_Name__c=u.LastName,Profile_Name__c=u.Profile.Name,userid__c=u.id,SAML_Federation_ID__c =u.FederationIdentifier));
               system.debug('####userObjList='+userObjList); 
            }
            
            if(userObjList.size()>0)
            {
                try{
                    insert userObjList; 
                    system.debug('####Insert userObjList='+userObjList);
                  }catch (System.Dmlexception e)  
                  {
                    system.debug (e); 
                  }
            }
        }
    }
    
    if(isUpdate && E2ERecursiveHandler.isRecursive == false)
    {
        for(User u :NewListUsers)
        {
          oldIds.add(u.id);
          system.debug('#### pass update user ids='+oldIds);           
        }
        if(oldIds.size()>0)
        {            
            updateStandardUserInfointoUserObj(oldIds); 
            system.debug('####updateStandardUserInfointoUserObj');
            
        }
    }  
 }
    
  @future
  public static void updateStandardUserInfointoUserObj(set<id> userIds)
  {
  List<User__c> oldUserObjList = new List<User__c>();
        List<User__c> UserObjLists = new List<User__c>();
        set<User__c> UserObjSet= new set<User__c>();
        Map<id,User__c> UpdateUserMap = new Map<id,User__c>();
        
        Map<id,User>NewUserMap = new Map<id,User>([select id,Username,Email,License_Type__c,FirstName,LastName,Profile.Name,FederationIdentifier,IsActive from User where id IN:userIds]);
        
        Map<id,User__c> userMap = new Map<id,User__c>([select id,Name,Email__c,License_Type__c,First_Name__c,Last_Name__c,Profile_Name__c,userid__c,SAML_Federation_ID__c,Active__c  from User__c where userid__c =:NewUserMap.keyset()]);
        
            for(User__c u1 :userMap.values())
            {
                for(User u2 :NewUserMap.values())
                {
                    if(u2.id == u1.userid__c)
                    {
                        u1.Name = u2.UserName;
                        system.debug('####userMap.get(id).Name='+u1.Name);
                        u1.First_Name__c=u2.FirstName;
                        u1.Last_Name__c=u2.LastName;
                        u1.Email__c =u2.email;
                        u1.License_Type__c =u2.License_Type__c;
                        u1.SAML_Federation_ID__c =u2.FederationIdentifier;
                        u1.Profile_Name__c=u2.Profile.Name;
                        u1.Active__c =u2.IsActive;
                        UserObjLists.add(u1);
                        system.debug('####UserObjLists='+UserObjLists);
                    }
                }
            }
              
        if(UserObjLists.size()>0)
        {
          update UserObjLists;
          system.debug('#####update user List='+UserObjLists);  
        }              
  }
}