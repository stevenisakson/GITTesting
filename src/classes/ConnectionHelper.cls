public class ConnectionHelper { 

    public static Id getConnectionId(String connectionName) {
     
        List<PartnerNetworkConnection> partnerNetConList =
           [Select id from PartnerNetworkConnection where connectionStatus = 'Accepted' and connectionName = :connectionName];
         
        System.Debug('*******PARTNERNETCONLIST'+partnerNetConList);
        if ( partnerNetConList.size() != 0 ) {
            return partnerNetConList.get(0).Id;
        }

        return null;

    }
    /* commented by ramesh
    public static Id getConnectionOwnerId(String connectionName) {
     
        List<PartnerNetworkConnection> partnerNetConList =
          [Select createdById from PartnerNetworkConnection where connectionStatus = 'Accepted' and connectionName = :connectionName];
         
        if ( partnerNetConList.size() != 0 ) {
            return partnerNetConList.get(0).createdById;
        }
         
        return null;
    }
    */
    public static void shareRecordToTarget(Id connectionId, Id localRecordId){
        
        PartnerNetworkRecordConnection recordShare = new PartnerNetworkRecordConnection();
        recordShare.ConnectionId = connectionId;
        recordShare.LocalRecordId = localRecordId;
        recordShare.SendClosedTasks = false;
        recordShare.SendOpenTasks = false;
        recordShare.SendEmails = false;
        system.debug('$$$$$connection User record='+recordShare);
        insert recordShare;
        system.debug('$$$$$connection User record after insert='+recordShare);
    }
   
}