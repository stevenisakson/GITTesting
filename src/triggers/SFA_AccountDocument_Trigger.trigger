/*******
 * CreatedDate : 29-06-2018
 * Author : Amrish Surve
 * Description : Contains method which are used for checking/unchecking account training flags
 *******/

trigger SFA_AccountDocument_Trigger on Account_Attachments__c (before delete, after insert, after delete) {
    if(Trigger.isInsert && Trigger.isAfter){
        SFA_AccountDocument_BaxterCommunity.updateTrainingFlag(Trigger.new);// used for selecting training flags on account document level
    }
    
    if(Trigger.isDelete && Trigger.isBefore){
        SFA_AccountDocument_BaxterCommunity.resetTrainingFlag(Trigger.old);// used for selecting training flags on account document level
    }
}