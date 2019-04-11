public class Cres_BU_PopulateHelper {

    /*Populates Business Unit of Record Owner to Contact,Opportunity,Event Records. It is a generic method*/
    public static void populateBU(List<sObject> newList){
       System.debug('$$$Before Insert-'+newList); 
       List<String> ownerIdList=new List<String>();
       String BU_API_Name;
       Boolean isTriggerSupported=false; 
        /*check if the Trigger is User in Opportunity/Contact/Event otherwise do not run the Trigger*/
        if(newList.size()>0 && newList[0].getSObjectType()==Schema.Opportunity.getSObjectType()){
            BU_API_Name='Business_Unit__c';
            isTriggerSupported=true;
        }else if(newList.size()>0 && newList[0].getSObjectType()==Schema.Contact.getSObjectType()){
            BU_API_Name='Business_Unit__c';
            isTriggerSupported=true;
        }
        else if(newList.size()>0 && newList[0].getSObjectType()==Schema.Event.getSObjectType()){
            BU_API_Name='Business_Unit__c';
            isTriggerSupported=true;
        } else if(newList.size()>0 && newList[0].getSObjectType()==Schema.Task.getSObjectType()){
            BU_API_Name='Business_Unit__c';
            isTriggerSupported=true;
        }
        else{
             /*skip the Trigger if this method is called other than mentioned object*/
             isTriggerSupported=false;
        }
            
        if(isTriggerSupported && newList.size()>0){
            for(sObject sobj:newList){
                if(sobj.get(BU_API_Name)==null){
                    /*Get record Owner*/
                    ownerIdList.add((String)sobj.get('ownerId'));
                }
                
            }
        }
        if(isTriggerSupported && ownerIdList.size()>0){
            /*Get the user map with userId and Business Unit*/
            
            Map<Id,User> userOwnerMap=new Map<Id,User>([select id,Business_Unit__c from User where id in : ownerIdList]);
           
            if(userOwnerMap.size()>0){
                for(sObject sobj:newList){
                    
                    if(userOwnerMap.get((String)sobj.get('ownerId'))!=null){
                        /*Assign the Business Unit of Owner to the record*/
                        sobj.put(BU_API_Name,userOwnerMap.get((String)sobj.get('ownerId')).Business_Unit__c);
                    }
                    
                    
                }
            }
              System.debug('$$$Before Insert-Prepopulate'+newList);   
        }
            
    }
}