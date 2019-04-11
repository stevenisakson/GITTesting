public class UpdateLastModified
{

    
    public static void proccedaccounts(set<id> IDs)
    {
        Id userid=Userinfo.getUserid();
        system.debug('#################### userid'+ userid);
        list<Account> lstname=new list<Account>();
        for(Account a:[select id,name,Last_Modified_Date__c,Last_Modified_ID__c,lastmodifieddate,lastmodifiedbyid from Account where id IN:IDs])
        {
            system.debug('####################'+ a);
            // 0050j000000HhqfAAC Label.Integrationuserid is integration user id
            if(userid !=Label.Integrationuserid)
            {
                a.Last_Modified_Date__c=a.lastmodifieddate;
                a.Last_Modified_ID__c=a.lastmodifiedbyid;
                lstname.add(a);
                system.debug('#################### lstname'+ lstname);
            }
        
        
        }
        
        updation.isfutureupdate=true;
        update lstname;
    }
}