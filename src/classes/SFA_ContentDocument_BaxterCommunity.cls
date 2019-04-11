/* 
 * Author : Amrish Surve
 * CreatedDate : 13-July-2018
 * Description : created for displaying document history in baxter community
*/
public with sharing class SFA_ContentDocument_BaxterCommunity {

    /* method which is used to update the attachment name field of Account document from content document object*/
    public static void updateAttachmentName(List<ContentDocumentLink> contentDocList){
        Set<Id> eventIdSet = new Set<Id>();
        Set<Id> AccountEventIdSet = new Set<Id>();
        Set<Id> AccountDisplayIdSet = new Set<Id>();
		Set<Id> AccountProspectIdSet = new Set<Id>();
        List<Account_Attachments__c> accDocumentList;
        List<Account> eventsUpdate = new List<Account>();
		List<Account> displayUpdate = new List<Account>();
		List<Account> prospectUpdate = new List<Account>();
        List<Account_Attachments__c> documentUpdateLst = new List<Account_Attachments__c>();
        Map<Id,Id> contentToParentIdMap = new Map<Id,Id>();
        Map<Id,String> IdToTitleMap = new Map<Id,String>();
        Map<Id,Account_Attachments__c> IdToDocumentMap = new Map<Id,Account_Attachments__c>();
        		
        if(!contentDocList.isEmpty()){
            for(ContentDocumentLink link : contentDocList){
                Id linkId = link.LinkedEntityId;
                if(String.valueOf(linkId.getsobjecttype()) == System.Label.SFA_ObjectAPIName){
                    contentToParentIdMap.put(link.ContentDocumentId,link.LinkedEntityId);
                }
            }
        }
        
        if(!contentToParentIdMap.isEmpty()){
            List<ContentDocument> documentList = [Select FileExtension,FileType,ParentId,Title,Id from ContentDocument where ID IN :contentToParentIdMap.keySet()];
            if(!documentList.isEmpty()){
                for(ContentDocument cDoc : documentList){
                    if(!String.isBlank(cDoc.FileExtension) && !String.isBlank(cDoc.Title))
                        IdToTitleMap.put(cDoc.Id, cDoc.Title + '.' +cDoc.FileExtension);
                }
            }
            
            accDocumentList = [Select Id,Name,Attachment_Name__c,Last_Upload_Date__c,Monthly_Uploaded_Date__c,Account__c,Type__c from Account_Attachments__c where ID IN :contentToParentIdMap.values()];
        }
        
        
		Date firstDayOfMonth = System.today().toStartOfMonth();
		Date lastDayOfMonth = firstDayOfMonth.addDays(Date.daysInMonth(firstDayOfMonth.year(), firstDayOfMonth.month()) - 1);
		System.debug('$$firstDayOfMonth$$'+firstDayOfMonth+'##lastDayOfMonth##'+lastDayOfMonth);
        for(ContentDocumentLink dLink : contentDocList){
            if(contentToParentIdMap.containsKey(dLink.ContentDocumentId)){
                for(Account_Attachments__c ac : accDocumentList){
                    if(ac.Id == dLink.LinkedEntityId){
						ac.Attachment_Name__c = IdToTitleMap.get(dLink.ContentDocumentId); 
                        System.debug(ac.Monthly_Uploaded_Date__c >= firstDayOfMonth && ac.Monthly_Uploaded_Date__c <= lastDayOfMonth);
						if(ac.Type__c == 'Display' && (ac.Monthly_Uploaded_Date__c >= firstDayOfMonth && ac.Monthly_Uploaded_Date__c <= lastDayOfMonth))
							AccountDisplayIdSet.add(ac.Account__c);
						if(ac.Type__c == 'Prospect Lists and Activities' && (ac.Last_Upload_Date__c >= firstDayOfMonth && ac.Last_Upload_Date__c <= lastDayOfMonth))
							AccountProspectIdSet.add(ac.Account__c);
                        if(ac.Type__c == 'Events')
                            eventIdSet.add(ac.Id);
						documentUpdateLst.add(ac);
                    }
                } 
            }
            try{
				if(!documentUpdateLst.isEmpty())
					update documentUpdateLst;
            }catch(Exception e){
                System.debug('Exception in update'+e.getMessage());
            }
			try{
				if(!AccountDisplayIdSet.isEmpty()){
					for(Account accD : [Select ID,Display_Uploaded__c from Account where ID IN :AccountDisplayIdSet]){
						accD.Display_Uploaded__c = True;
						displayUpdate.add(accD);
					}
				}
				if(!displayUpdate.isEmpty()){
					update displayUpdate;
				}
			}catch(Exception e){
				System.debug('Exception in displayUpdate'+e.getMessage());
			}
			try{
				if(!AccountProspectIdSet.isEmpty()){
					for(Account accP : [Select ID,Prospect_List_Uploaded__c from Account where ID IN :AccountProspectIdSet]){
						accP.Prospect_List_Uploaded__c = True;
						prospectUpdate.add(accP);
					}
				}
				if(!prospectUpdate.isEmpty()){
					update prospectUpdate;
				}
			}catch(Exception e){
				System.debug('Exception in prospectUpdate'+e.getMessage());
			}
            try{
                if(!eventIdSet.isEmpty()){
                    List<Account_Attachments__c> eventsLst = [Select Id, Type__c, Start_Month_Date__c, Account__c from Account_Attachments__c where ID IN :eventIdSet and Start_Month_Date__c = THIS_QUARTER];
                    if(!eventsLst.isEmpty()){
                        for(Account_Attachments__c evt : eventsLst){
                            AccountEventIdSet.add(evt.Account__c);
                        }
                    }
                    if(!AccountEventIdSet.isEmpty()){
                        for(Account accE : [Select Id,Events_Uploaded__c from Account where ID IN :AccountEventIdSet]){
                            accE.Events_Uploaded__c = true;
                            eventsUpdate.add(accE);
                        }
                    }
                    if(!eventsUpdate.isEmpty())
                        update eventsUpdate;
                }
            }catch(Exception e){
                System.debug('Exception in eventsUpdate'+e.getMessage());
            }
			
        }
    }
    
    
  
}