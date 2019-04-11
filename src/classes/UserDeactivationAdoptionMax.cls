public class UserDeactivationAdoptionMax
{
    public static void userDeactivate()
    {
        System.debug('Hello1');
       
        List<User> userList=[SELECT Id,Name,isActive,LastLoginDate from User]; 
        List<uf__User_Status__c> usList=[SELECT uf__User__c from uf__User_Status__c];     
        for(User userObj: userList)
        {   
                      
            Date myDate=date.today();
            Date lastLoginDate=null;
            System.debug('LastLoginDate is '+userObj.LastLoginDate);
            if(userObj.LastLoginDate!=null)
                lastLoginDate = date.newinstance(userObj.LastLoginDate.year(), userObj.LastLoginDate.month(), userObj.LastLoginDate.day());
            else
                {
                    System.debug('LastLoginDate is null');   
                    lastLoginDate = Date.parse('1/12/1990');
                }                       
            for(uf__User_Status__c us: usList)
              {
                                            
                 System.debug(lastLoginDate.daysBetween(myDate));     
                  
                      if(userObj.id==us.uf__User__c && lastLoginDate.daysBetween(myDate)>=65)
                      {
                          userObj.isActive=false;
                          update userObj;
                      }    
               }
        
         }
     }
    
}