/*********************************************************
      ** Author: Tumish Tak
      ** Date: 11-May-2017
      ** Description: Class contains method for updating account with the approved request line items for competitor record type
      ***********************************************************/
public class CompetitorUpdateRequest
{
    public void competitorApprove(Map<id,id> listReq)
    {
        List<RequestLineItem__c> csFields = new List<RequestLineItem__c>();
        Account updateAcc;
        String query;
        csFields = [SELECT Field_Name__c,Existing_Value__c,New_Value__c,Status__c,Account_Id__c FROM RequestLineItem__c WHERE Request__c =: listReq.keySet()];
        Set<id> idSet = new Set<Id>();
        for(Id ids: listReq.keySet()){
                idSet.add(listReq.get(ids));
           }
        
        set<String> filteredAccountFields = new set<string>();
        system.debug('@@ idSet '+ idSet);
        String BUnit = [SELECT Business__c from Account where id IN: idSet].Business__c;
        system.debug('@@ business unit ' + BUnit);
        for(CompetitorProtectedFields__c fieldName : [SELECT Field_Name__c,Field_Label__c,Name FROM CompetitorProtectedFields__c WHERE Business_Unit__c =: BUnit] ){
          filteredAccountFields.add(fieldName.Field_Name__c);
        }
        
        //construct the soql for the fields to be updated on the account
        string soql = 'select ';
        for (string fld :filteredAccountFields){
            soql += fld +',';          
        }
        soql = soql.substring(0, soql.length() - 1);        
        soql += ' from account WHERE Id IN:idSet ';
        system.debug('#####SOQL: ' + soql);
        //Map the id to its respective account for each account that is to be update based on the result of the constructed soql
        Map<id,Account> mapAcc = new Map<id,Account>();
        List<Account> accountResults = database.query(soql);
        for(Account accLoop: accountResults){
            mapAcc.put(accLoop.id, accLoop);
        }
                map<id,list<RequestLineItem__c>> AccountRequestMap = new map<id,list<RequestLineItem__c>> ();
        
        for(RequestLineItem__c rl : csFields){
            if(!AccountRequestMap.containskey(rl.Account_Id__c)){                
                list<RequestLineItem__c> temp = new list<RequestLineItem__c>();
                temp.add(rl);
                AccountRequestMap.put(rl.Account_Id__c,temp);
            } else{
                   list<RequestLineItem__c> temp = new list<RequestLineItem__c>(); 
                   temp=AccountRequestMap.get(rl.Account_Id__c);
                   temp.add(rl);
                   AccountRequestMap.put(rl.Account_Id__c,temp);
            }
        }
        List <Account> updateAccReq= new list<Account>();
        for(id rid : AccountRequestMap.keyset()){
            updateAcc = mapAcc.get(rid);
            
            for(RequestLineItem__c rli:AccountRequestMap.get(rid)){
                 if(rli.Status__c == 'Approved'){                
                    
                    Map<String, Schema.SObjectField> M  = Schema.SObjectType.Account.fields.getMap();
                    Schema.SObjectField field = M.get(rli.Field_Name__c);
                    Schema.DisplayType FldType = field.getDescribe().getType();
                    
                    system.debug('type ===== ' + rli.Field_Name__c + ' = ' + FldType + '@New Value ' + rli.New_Value__c);
                    
                    if(FldType == Schema.DisplayType.Boolean){
                        updateAcc.put(rli.Field_Name__c, Boolean.valueOf(rli.New_Value__c));                                           
                    }else{
                        if (rli.Field_Name__c == 'Account_Owner__c')
                        updateAcc.OwnerId = rli.New_Value__c;
                        //updated 9-13-2016 by Anjerico Caburnay
                        try{
                            updateAcc.put(rli.Field_Name__c, rli.New_Value__c);
                        }
                        catch(exception e){
                             updateAcc.put(rli.Field_Name__c, Decimal.valueOf(rli.New_Value__c));
                        }
                        //end of update                        
                    }                                     
                    
                    }
                }
                updateAccReq.add(updateAcc);
                system.debug('Update Account --> ' +  updateAcc);
             }
             if(!updateAccReq.isEmpty()){
                    try{
                        update updateAccReq;
                    }catch(DMLException e){                                  
                        System.debug('The following exception has occurred: ' + e.getMessage());
                    } 
             }
    }
}