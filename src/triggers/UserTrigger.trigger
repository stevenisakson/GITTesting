trigger UserTrigger on User__c (after insert) {
   
    
        // Define connection id
        Id networkId = ConnectionHelper.getConnectionId('Global IT');
        
        System.debug('********NETWORK ID -'+networkId);
        Set<Id> localUserSet = new Set<Id>();
        List<User__c> localUser = new List<User__c>();
        Set<Id> sharedSet = new Set<Id>();   
         
        for(User__c u : Trigger.new){
            
            ConnectionHelper.shareRecordToTarget(networkId,u.id);
        }
}