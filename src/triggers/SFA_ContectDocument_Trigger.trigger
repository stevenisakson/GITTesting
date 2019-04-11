trigger SFA_ContectDocument_Trigger on ContentDocumentLink (after insert, before delete) {
    if(Trigger.isInsert && Trigger.isAfter){
        SFA_ContentDocument_BaxterCommunity.updateAttachmentName(Trigger.new);// used for updating document title into Account document custom field
    }
    
}