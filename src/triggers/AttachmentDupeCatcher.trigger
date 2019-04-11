trigger AttachmentDupeCatcher on Attachment (before insert) {
    //Fetch parent Ids
    Set<Id> parentIds = new Set<Id>();
    for( Attachment a : trigger.new ) {
        parentIds.add(a.ParentId);
    }

    //Query already existing attachments on those parent records OUTSIDE A FOR LOOP
    List<Attachment> existingAttachments = [Select Id, ParentId, Name, Body, ContentType from Attachment where ParentId in :parentIds];
    
     list<Attachment> duplist=new list<Attachment>();
    
    //Compare incoming Attachments & existing Attachments based on the content
    for( Attachment incomingAttachment : trigger.new ) {
        for( Attachment existingAttachment : existingAttachments) {
            if(  incomingAttachment .ParentId.getSobjectType() == Account.SobjectType && incomingAttachment.ParentId == existingAttachment.ParentId && incomingAttachment.name == existingAttachment.name){
               // incomingAttachment.addError(incomingAttachment.Name+' already exists.');
               duplist.add(existingAttachment);
            }
        }
    }
    
     if(duplist.size()>0)
    {
        delete duplist;
    }
    
}