trigger SFA_ContentDocument_DeleteTrigger on ContentDocument (before delete) {

    if(Trigger.isDelete && Trigger.isBefore){
        SFA_ContentDocument_DeleteHandler.resetAccountFlags(Trigger.old);
    }
}