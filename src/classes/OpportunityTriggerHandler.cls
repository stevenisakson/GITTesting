/*********************************************************************
Name    : SetOpportunityTeam Trigger
Date    : 28 August 2015
Description: Trigger for Opportunity object
             after insert - set opportunity Team members
History : Jed canlas - created a handler
*********************************************************************/
public class OpportunityTriggerHandler {

    public void onAfterInsert(list<Opportunity> newList){           
        List<OpportunityTeamMember> oppTeamMembersList = new List<OpportunityTeamMember>(); 
        Map< Id , Id > opportunityIdToParAccountId = new Map< Id , Id >();
        
        for(Opportunity o : newList){
            opportunityIdToParAccountId.put(o.Id,  o.AccountID );
              //opportunityIdToParAccountId.put(o.Id,  o.Account.ParentId ); // create a map between opp id and related account's parent id
        }

        Map<id, List<AccountTeamMember > > accountIdToAccountTeamMembers = new    Map<id,  List<AccountTeamMember > > ();
        for(AccountTeamMember accountTeamMember : [SELECT a.UserId,a.User.Name,a.TeamMemberRole, a.Id, a.AccountId
                                                    FROM AccountTeamMember a
                                                    WHERE a.AccountId in :opportunityIdToParAccountId.values() ]){ // changed the clause to fetch the parent account's team members
        
            List<AccountTeamMember > accountTeamMembers = (accountIdToAccountTeamMembers.get(accountTeamMember.Accountid) == null) 
                                                        ? new  List<AccountTeamMember >() 
                                                        : accountIdToAccountTeamMembers.get(accountTeamMember.Accountid);
            accountTeamMembers.add(accountTeamMember);
            accountIdToAccountTeamMembers.put(accountTeamMember.Accountid, accountTeamMembers);
        } 

        for(Opportunity o : newList) {
            Id accountId  = opportunityIdToParAccountId.get(o.Id);
            if (accountIdToAccountTeamMembers.containsKey(accountId)){
            
                for ( AccountTeamMember accountTeamMember : accountIdToAccountTeamMembers.get(accountId) )  {
                    OpportunityTeamMember opportunityTeamMember  = new OpportunityTeamMember();
                    opportunityTeamMember.UserId = accountTeamMember.UserId;
                    opportunityTeamMember.TeamMemberRole = accountTeamMember.TeamMemberRole;
                    opportunityTeamMember.OpportunityId = o.ID;
                    oppTeamMembersList.add(opportunityTeamMember);
                }
            }
        }
        insert oppTeamMembersList;
    }
    
    /*Add Logic of populating Business Unit of Opportunity from Owner's Business Unit*/
    public void onBeforeInsert(List<Opportunity> newOppList){
        populateBusinessUnit(newOppList);
    }
    
    public void populateBusinessUnit(List<Opportunity> oppList){
        Set<Id> ownerIds = new Set<Id>();
        Map<Id,User> userMap = new Map<Id,User>();
        
        for(Opportunity opportunityLoop : oppList){
            ownerIds.add(opportunityLoop.OwnerId);
        }
        
        for(User userLoop : [SELECT Id,Business_Unit__c FROM User Where Id IN :ownerIds]){
            userMap.put(userLoop.Id, userLoop);
        }
        
        for(Opportunity opportunityLoop : oppList){
            if(userMap.containsKey(opportunityLoop.OwnerId)){
                opportunityLoop.Business_Unit__c = userMap.get(opportunityLoop.OwnerId).Business_Unit__c;
            }
        }
    }
    
    public void setOpportunityCurrency(list<Opportunity> OpportunityList)
    {
        set<Id> ownerIdset = new set<Id>();
        
        for(Opportunity Opp: OpportunityList)
        {
            ownerIdset.add(Opp.OwnerId);
        }
        
        Map<string,string> ownerCurrencyMap = new Map<string,string>();
        
        for(User usr: [Select Id,DefaultCurrencyISOCode from User where Id In : ownerIdset])   
        {
           ownerCurrencyMap.put(usr.Id,usr.DefaultCurrencyISOCode);
        }
        
        for(Opportunity Opp: OpportunityList)
        {
            if(ownerCurrencyMap.containsKey(Opp.OwnerId))
            {
                Opp.CurrencyIsoCode = ownerCurrencyMap.get(Opp.OwnerId);
            }
        }  
     }
}